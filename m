Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2GJPsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:48:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:7361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab2GJPsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:48:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175579207"
Date: Tue, 10 Jul 2012 23:47:35 +0800
From: wfg@linux.intel.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: ftrace_ops_list_func() triggered WARNING: at kernel/lockdep.c:3506
Message-ID: <20120710154735.GA6398@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Steven,

I can produce this in 3.5.0-rc6 as well as in 3.2.
Basically it's the rcu_dereference_raw(ftrace_ops_list) call that triggered the
__rcu_dereference_check()/lock_is_held()/check_flags() warning.

[    3.500806] Testing dynamic ftrace: PASSED
[    3.910268] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 36) (2 2 4 1 164) [    4.000026] ------------[ cut here ]--
----------
[    4.000026] WARNING: at /c/wfg/linux/kernel/lockdep.c:3506 check_flags+0x140/0x177()
[    4.000026] Hardware name: Bochs

[    4.000026] Modules linked in:
[    4.000026] 
[    4.000026] Pid: 0, comm: swapper/0 Not tainted 3.5.0-rc6-bisect #48
[    4.000026] Call Trace:
[    4.000026]  <IRQ>  [<ffffffff81045250>] warn_slowpath_common+0x83/0x9c
[    4.000026]  [<ffffffff81045283>] warn_slowpath_null+0x1a/0x1c
[    4.000026]  [<ffffffff81099306>] check_flags+0x140/0x177
[    4.000026]  [<ffffffff8109a503>] lock_is_held+0x3c/0xa7
[    4.000026]  [<ffffffff81324901>] ? sub_preempt_count+0x7/0xe0
[    4.000026]  [<ffffffff8104e529>] ? __local_bh_enable+0xda/0x18f
[    4.000026]  [<ffffffff810d0a03>] ftrace_ops_list_func+0xae/0xf2
[    4.000026]  [<ffffffff81326d16>] ftrace_call+0x5/0x2b
[    4.000026]  [<ffffffff81324906>] ? sub_preempt_count+0xc/0xe0
[    4.000026]  [<ffffffff8104e529>] __local_bh_enable+0xda/0x18f
[    4.000026]  [<ffffffff8104e5f1>] _local_bh_enable+0x13/0x15
[    4.000026]  [<ffffffff8104ed7f>] irq_enter+0x4f/0x74
[    4.000026]  [<ffffffff81031ec9>] smp_apic_timer_interrupt+0x3e/0x98
[    4.000026]  [<ffffffff81327aef>] apic_timer_interrupt+0x6f/0x80
[    4.000026]  <EOI>  [<ffffffff810c4c85>] ? rcu_is_cpu_idle+0x67/0x78
[    4.000026]  [<ffffffff81038cc0>] ? native_safe_halt+0x6/0x8
[    4.000026]  [<ffffffff81099b2e>] ? trace_hardirqs_on+0xd/0xf
[    4.000026]  [<ffffffff8102215e>] default_idle+0x127/0x2cd
[    4.000026]  [<ffffffff810232a3>] cpu_idle+0x11d/0x1e7
[    4.000026]  [<ffffffff812fd3ac>] rest_init+0x130/0x137
[    4.000026]  [<ffffffff812fd27c>] ? csum_partial_copy_generic+0x16c/0x16c
[    4.000026]  [<ffffffff815a6baa>] start_kernel+0x3c8/0x3d5
[    4.000026]  [<ffffffff815a65ea>] ? repair_env_string+0x5a/0x5a
[    4.000026]  [<ffffffff815a62d6>] x86_64_start_reservations+0xb1/0xb5
[    4.000026]  [<ffffffff815a63d8>] x86_64_start_kernel+0xfe/0x10b

Thanks,
Fengguang

--J/dobhs11T7y2rNN
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=dmesg-kvm-waimea-2292-2012-07-10-10-51-49
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset=0A[    0.000000] Initializ=
ing cgroup subsys cpu=0A[    0.000000] Linux version 3.5.0-rc5+ (kbuild@snb=
) (gcc version 4.7.0 (Debian 4.7.0-11) ) #91 SMP PREEMPT Tue Jul 10 10:49:5=
4 CST 2012=0A[    0.000000] Command line: rcutorture.rcutorture_runnable=3D=
0 trinity=3D10m tree=3Dregulator:for-next auth_hashtable_size=3D10 sunrpc.a=
uth_hashtable_size=3D10 log_buf_len=3D8M ignore_loglevel debug sched_debug =
apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10 hung_task_panic=
=3D1 softlockup_panic=3D1 unknown_nmi_panic=3D1 nmi_watchdog=3Dpanic,lapic =
 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  roo=
t=3D/dev/ram0 rw link=3Dvmlinuz-2012-07-10-10-51-20-usb-regulator.for-next-=
2bd2b1a-d1ef065-x86_64-randconfig-usb3-1-waimea BOOT_IMAGE=3Dkernel-tests/k=
ernels/x86_64-randconfig-usb3/d1ef065d43476fd0e245cad2ef1d226e7cb6324b/vmli=
nuz-3.5.0-rc5+=0A[    0.000000] KERNEL supported cpus:=0A[    0.000000] CPU=
: vendor_id 'GenuineIntel' unknown, using generic init.=0A[    0.000000] CP=
U: Your system may be unstable.=0A[    0.000000] e820: BIOS-provided physic=
al RAM map:=0A[    0.000000] debug: ignoring loglevel setting.=0A[    0.000=
000] NX (Execute Disable) protection: active=0A[    0.000000] DMI 2.4 prese=
nt.=0A[    0.000000] e820: last_pfn =3D 0xfffd max_arch_pfn =3D 0x400000000=
=0A[    0.000000] MTRR default type: write-back=0A[    0.000000] MTRR fixed=
 ranges enabled:=0A[    0.000000]   00000-9FFFF write-back=0A[    0.000000]=
   A0000-BFFFF uncachable=0A[    0.000000]   C0000-FFFFF write-protect=0A[ =
   0.000000] MTRR variable ranges enabled:=0A[    0.000000]   0 base 00E000=
0000 mask FFE0000000 uncachable=0A[    0.000000]   1 disabled=0A[    0.0000=
00]   2 disabled=0A[    0.000000]   3 disabled=0A[    0.000000]   4 disable=
d=0A[    0.000000]   5 disabled=0A[    0.000000]   6 disabled=0A[    0.0000=
00]   7 disabled=0A[    0.000000] Scan for SMP in [mem 0x00000000-0x000003f=
f]=0A[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]=0A[    0.00=
0000] Scan for SMP in [mem 0x000f0000-0x000fffff]=0A[    0.000000] found SM=
P MP-table at [mem 0x000f8860-0x000f886f] mapped at [ffff8800000f8860]=0A[ =
   0.000000]   mpc: f8870-f898c=0A[    0.000000] initial memory mapped: [me=
m 0x00000000-0x1fffffff]=0A[    0.000000] Base memory trampoline at [ffff88=
0000099000] 99000 size 24576=0A[    0.000000] init_memory_mapping: [mem 0x0=
0000000-0x0fffcfff]=0A[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M=
=0A[    0.000000]  [mem 0x0fe00000-0x0fffcfff] page 4k=0A[    0.000000] ker=
nel direct mapping tables up to 0xfffcfff @ [mem 0x0e854000-0x0e8d5fff]=0A[=
    0.000000] log_buf_len: 8388608=0A[    0.000000] early log buf free: 127=
860(97%)=0A[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]=0A[    0.000=
000] ACPI: Local APIC address 0xfee00000=0A[    0.000000] mapped APIC to ff=
ffffffff5fb000 (        fee00000)=0A[    0.000000] kvm-clock: cpu 0, msr 0:=
15a7f41, boot clock=0A[    0.000000]  [ffffea0000000000-ffffea00003fffff] P=
MD -> [ffff88000d400000-ffff88000d7fffff] on node 0=0A[    0.000000] Zone r=
anges:=0A[    0.000000] Movable zone start for each node=0A[    0.000000] E=
arly memory node ranges=0A[    0.000000]   node   0: [mem 0x00010000-0x0009=
efff]=0A[    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]=0A[    0.000=
000] On node 0 totalpages: 65420=0A[    0.000000]   DMA32 zone: 896 pages u=
sed for memmap=0A[    0.000000]   DMA32 zone: 6 pages reserved=0A[    0.000=
000]   DMA32 zone: 64518 pages, LIFO batch:15=0A[    0.000000] ACPI: Local =
APIC address 0xfee00000=0A[    0.000000] mapped APIC to ffffffffff5fb000 ( =
       fee00000)=0A[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00]=
 enabled)=0A[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enable=
d)=0A[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])=
=0A[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI=
 0-23=0A[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl =
dfl)=0A[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2=
, APIC INT 02=0A[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_ir=
q 5 high level)=0A[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05=
, APIC ID 2, APIC INT 05=0A[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq =
9 global_irq 9 high level)=0A[    0.000000] Int: type 0, pol 1, trig 3, bus=
 00, IRQ 09, APIC ID 2, APIC INT 09=0A[    0.000000] ACPI: INT_SRC_OVR (bus=
 0 bus_irq 10 global_irq 10 high level)=0A[    0.000000] Int: type 0, pol 1=
, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a=0A[    0.000000] ACPI: INT=
_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)=0A[    0.000000] Int: =
type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b=0A[    0.0000=
00] ACPI: IRQ0 used by override.=0A[    0.000000] Int: type 0, pol 0, trig =
0, bus 00, IRQ 01, APIC ID 2, APIC INT 01=0A[    0.000000] ACPI: IRQ2 used =
by override.=0A[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, A=
PIC ID 2, APIC INT 03=0A[    0.000000] Int: type 0, pol 0, trig 0, bus 00, =
IRQ 04, APIC ID 2, APIC INT 04=0A[    0.000000] ACPI: IRQ5 used by override=
=2E=0A[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2,=
 APIC INT 06=0A[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, A=
PIC ID 2, APIC INT 07=0A[    0.000000] Int: type 0, pol 0, trig 0, bus 00, =
IRQ 08, APIC ID 2, APIC INT 08=0A[    0.000000] ACPI: IRQ9 used by override=
=2E=0A[    0.000000] ACPI: IRQ10 used by override.=0A[    0.000000] ACPI: I=
RQ11 used by override.=0A[    0.000000] Int: type 0, pol 0, trig 0, bus 00,=
 IRQ 0c, APIC ID 2, APIC INT 0c=0A[    0.000000] Int: type 0, pol 0, trig 0=
, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d=0A[    0.000000] Int: type 0, pol =
0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e=0A[    0.000000] Int: typ=
e 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f=0A[    0.000000]=
 Using ACPI (MADT) for SMP configuration information=0A[    0.000000] ACPI:=
 HPET id: 0x8086a201 base: 0xfed00000=0A[    0.000000] SMP: Allowing 2 CPUs=
, 0 hotplug CPUs=0A[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec000=
00)=0A[    0.000000] nr_irqs_gsi: 40=0A[    0.000000] e820: [mem 0x10000000=
-0xfffbbfff] available for PCI devices=0A[    0.000000] Booting paravirtual=
ized kernel on KVM=0A[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits=
:8 nr_cpu_ids:2 nr_node_ids:1=0A[    0.000000] PERCPU: Embedded 27 pages/cp=
u @ffff88000de00000 s81152 r8192 d21248 u1048576=0A[    0.000000] kvm-clock=
: cpu 0, msr 0:de12f41, primary cpu clock=0A[    0.000000] Built 1 zonelist=
s in Zone order, mobility grouping on.  Total pages: 64518=0A[    0.000000]=
 Kernel command line: rcutorture.rcutorture_runnable=3D0 trinity=3D10m tree=
=3Dregulator:for-next auth_hashtable_size=3D10 sunrpc.auth_hashtable_size=
=3D10 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynam=
ic_printk sysrq_always_enabled panic=3D10 hung_task_panic=3D1 softlockup_pa=
nic=3D1 unknown_nmi_panic=3D1 nmi_watchdog=3Dpanic,lapic  prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw l=
ink=3Dvmlinuz-2012-07-10-10-51-20-usb-regulator.for-next-2bd2b1a-d1ef065-x8=
6_64-randconfig-usb3-1-waimea BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-rand=
config-usb3/d1ef065d43476fd0e245cad2ef1d226e7cb6324b/vmlinuz-3.5.0-rc5+=0A[=
    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)=0A[    0.=
000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)=0A[=
    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes=
)=0A[    0.000000] __ex_table already sorted, skipping sort=0A[    0.000000=
] Memory: 209732k/262132k available (3243k kernel code, 452k absent, 51948k=
 reserved, 2464k data, 720k init)=0A[    0.000000] Preemptible hierarchical=
 RCU implementation.=0A[    0.000000] 	RCU debugfs-based tracing is enabled=
=2E=0A[    0.000000] 	Hierarchical RCU autobalancing is disabled.=0A[    0.=
000000] 	RCU lockdep checking is enabled.=0A[    0.000000] NR_IRQS:4352 nr_=
irqs:512 16=0A[    0.000000] console [ttyS0] enabled=0A[    0.000000] Lock =
dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar=0A[    =
0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8=0A[    0.000000] ... MAX_LOCK_DEPT=
H:          48=0A[    0.000000] ... MAX_LOCKDEP_KEYS:        8191=0A[    0.=
000000] ... CLASSHASH_SIZE:          4096=0A[    0.000000] ... MAX_LOCKDEP_=
ENTRIES:     16384=0A[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768=0A[ =
   0.000000] ... CHAINHASH_SIZE:          16384=0A[    0.000000]  memory us=
ed by lock dependency info: 5855 kB=0A[    0.000000]  per task-struct memor=
y footprint: 1920 bytes=0A[    0.000000] ------------------------=0A[    0.=
000000] | Locking API testsuite:=0A[    0.000000] -------------------------=
---------------------------------------------------=0A[    0.000000]       =
                           | spin |wlock |rlock |mutex | wsem | rsem |=0A[ =
   0.000000]   ------------------------------------------------------------=
--------------=0A[    0.000000]                      A-A deadlock:  ok  |  =
ok  |  ok  |  ok  |  ok  |  ok  |=0A[    0.000000]                  A-B-B-A=
 deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |=0A[    0.000000]      =
        A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |=0A[=
    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  =
|  ok  |  ok  |=0A[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  | =
 ok  |  ok  |  ok  |  ok  |  ok  |=0A[    0.000000]          A-B-C-D-B-D-D-=
A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |=0A[    0.000000]     =
     A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |=0A=
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |=0A[    0.000000]                   initialize held:  ok  |=
  ok  |  ok  |  ok  |  ok  |  ok  |=0A[    0.000000]                  bad u=
nlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |=0A[    0.000000]   -=
-------------------------------------------------------------------------=
=0A[    0.000000]               recursive read-lock:             |  ok  |  =
           |  ok  |=0A[    0.000000]            recursive read-lock #2:    =
         |  ok  |             |  ok  |=0A[    0.000000]             mixed r=
ead-write-lock:             |  ok  |             |  ok  |=0A[    0.000000] =
            mixed write-read-lock:             |  ok  |             |  ok  =
|=0A[    0.000000]   ------------------------------------------------------=
--------------------=0A[    0.000000]      hard-irqs-on + irq-safe-A/12:  o=
k  |  ok  |  ok  |=0A[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok =
 |  ok  |  ok  |=0A[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |=
  ok  |  ok  |=0A[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  =
ok  |  ok  |=0A[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  =
ok  |  ok  |=0A[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  =
ok  |  ok  |=0A[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok=
  |  ok  |=0A[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  =
|  ok  |=0A[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  | =
 ok  |=0A[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  o=
k  |=0A[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok =
 |=0A[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |=
=0A[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |=
=0A[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |=
=0A[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |=
=0A[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |=
=0A[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |=
=0A[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |=
=0A[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |=
=0A[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |=
=0A[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |=
=0A[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |=
=0A[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |=
=0A[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |=
=0A[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |=
=0A[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |=
=0A[    0.000000]       hard-irq read-recursion/123:  ok  |=0A[    0.000000=
]       soft-irq read-recursion/123:  ok  |=0A[    0.000000]       hard-irq=
 read-recursion/132:  ok  |=0A[    0.000000]       soft-irq read-recursion/=
132:  ok  |=0A[    0.000000]       hard-irq read-recursion/213:  ok  |=0A[ =
   0.000000]       soft-irq read-recursion/213:  ok  |=0A[    0.000000]    =
   hard-irq read-recursion/231:  ok  |=0A[    0.000000]       soft-irq read=
-recursion/231:  ok  |=0A[    0.000000]       hard-irq read-recursion/312: =
 ok  |=0A[    0.000000]       soft-irq read-recursion/312:  ok  |=0A[    0.=
000000]       hard-irq read-recursion/321:  ok  |=0A[    0.000000]       so=
ft-irq read-recursion/321:  ok  |=0A[    0.000000] ------------------------=
-------------------------------=0A[    0.000000] Good, all 218 testcases pa=
ssed! |=0A[    0.000000] ---------------------------------=0A[    0.000000]=
 hpet clockevent registered=0A[    0.000000] Detected 3299.986 MHz processo=
r.=0A[    0.000000] Marking TSC unstable due to TSCs unsynchronized=0A[    =
0.010000] Calibrating delay loop (skipped) preset value.. 6599.97 BogoMIPS =
(lpj=3D32999860)=0A[    0.010000] pid_max: default: 32768 minimum: 301=0A[ =
   0.010000] Security Framework initialized=0A[    0.010000] AppArmor: AppA=
rmor initialized=0A[    0.010000] Mount-cache hash table entries: 256=0A[  =
  0.010000] Initializing cgroup subsys debug=0A[    0.010063] Initializing =
cgroup subsys cpuacct=0A[    0.010921] Initializing cgroup subsys freezer=
=0A[    0.011763] Initializing cgroup subsys blkio=0A[    0.012815] mce: CP=
U supports 10 MCE banks=0A[    0.013574] MCE: unknown CPU type - not enabli=
ng MCE support.=0A[    0.018202] ACPI: Core revision 20120320=0A[    0.0527=
10] ftrace: allocating 12637 entries in 50 pages=0A[    0.060382] Getting V=
ERSION: 50014=0A[    0.061036] Getting VERSION: 50014=0A[    0.061698] Gett=
ing ID: 0=0A[    0.062167] Getting ID: ff000000=0A[    0.062821] Getting LV=
T0: 8700=0A[    0.070017] Getting LVT1: 8400=0A[    0.070590] enabled ExtIN=
T on CPU#0=0A[    0.072095] ENABLING IO-APIC IRQs=0A[    0.072696] init IO_=
APIC IRQs=0A[    0.073259]  apic 2 pin 0 not connected=0A[    0.074022] IOA=
PIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)=0A[=
    0.075467] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Act=
ive:0 Dest:1)=0A[    0.076965] IOAPIC[0]: Set routing entry (2-3 -> 0x33 ->=
 IRQ 3 Mode:0 Active:0 Dest:1)=0A[    0.078421] IOAPIC[0]: Set routing entr=
y (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)=0A[    0.080043] IOAPIC[0]:=
 Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)=0A[    0.0=
81488] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 D=
est:1)=0A[    0.083003] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 =
Mode:0 Active:0 Dest:1)=0A[    0.084437] IOAPIC[0]: Set routing entry (2-8 =
-> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)=0A[    0.085943] IOAPIC[0]: Set ro=
uting entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)=0A[    0.087408] =
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1=
)=0A[    0.088940] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mod=
e:1 Active:0 Dest:1)=0A[    0.090033] IOAPIC[0]: Set routing entry (2-12 ->=
 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)=0A[    0.091573] IOAPIC[0]: Set rou=
ting entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)=0A[    0.093039]=
 IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:=
1)=0A[    0.094576] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mo=
de:0 Active:0 Dest:1)=0A[    0.096022]  apic 2 pin 16 not connected=0A[    =
0.096766]  apic 2 pin 17 not connected=0A[    0.097559]  apic 2 pin 18 not =
connected=0A[    0.098262]  apic 2 pin 19 not connected=0A[    0.100010]  a=
pic 2 pin 20 not connected=0A[    0.100749]  apic 2 pin 21 not connected=0A=
[    0.101510]  apic 2 pin 22 not connected=0A[    0.102209]  apic 2 pin 23=
 not connected=0A[    0.103086] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 a=
pic2=3D-1 pin2=3D-1=0A[    0.104770] CPU0: GenuineIntel Common KVM processo=
r stepping 01=0A[    0.106530] Using local APIC timer interrupts.=0A[    0.=
106530] calibrating APIC timer ...=0A[    0.110000] ... lapic delta =3D 624=
9214=0A[    0.110000] ..... delta 6249214=0A[    0.110000] ..... mult: 2684=
01697=0A[    0.110000] ..... calibration result: 9998742=0A[    0.110000] .=
=2E... CPU clock speed is 3299.5681 MHz.=0A[    0.110000] ..... host bus cl=
ock speed is 999.8742 MHz.=0A[    0.110000] ... verify APIC timer=0A[    0.=
226783] ... jiffies delta =3D 10=0A[    0.227706] ... jiffies result ok=0A[=
    0.228636] Performance Events: =0A[    0.302114] Testing tracer nop: =0A=
[    0.303268] PASSED=0A[    0.340179] lockdep: fixing up alternatives.=0A[=
    0.342068] Booting Node   0, Processors  #1 Ok.=0A[    0.010000] kvm-clo=
ck: cpu 1, msr 0:df12f41, secondary cpu clock=0A[    0.010000] masked ExtIN=
T on CPU#1=0A[    0.356049] Brought up 2 CPUs=0A[    0.356583] Total of 2 p=
rocessors activated (13199.94 BogoMIPS).=0A[    0.359416] device: 'platform=
': device_add=0A[    0.360085] PM: Adding info for No Bus:platform=0A[    0=
=2E361181] bus: 'platform': registered=0A[    0.362118] bus: 'cpu': registe=
red=0A[    0.362730] device: 'cpu': device_add=0A[    0.363492] PM: Adding =
info for No Bus:cpu=0A[    0.364655] device class 'regulator': registering=
=0A[    0.365949] Registering platform device 'reg-dummy'. Parent at platfo=
rm=0A[    0.367095] device: 'reg-dummy': device_add=0A[    0.367862] bus: '=
platform': add device reg-dummy=0A[    0.368766] PM: Adding info for platfo=
rm:reg-dummy=0A[    0.369664] bus: 'platform': add driver reg-dummy=0A[    =
0.370083] bus: 'platform': driver_probe_device: matched device reg-dummy wi=
th driver reg-dummy=0A[    0.371840] bus: 'platform': really_probe: probing=
 driver reg-dummy with device reg-dummy=0A[    0.373496] device: 'regulator=
=2E0': device_add=0A[    0.374611] PM: Adding info for No Bus:regulator.0=
=0A[    0.375653] dummy: =0A[    0.376171] driver: 'reg-dummy': driver_boun=
d: bound to device 'reg-dummy'=0A[    0.377406] bus: 'platform': really_pro=
be: bound device reg-dummy to driver reg-dummy=0A[    0.380006] NET: Regist=
ered protocol family 16=0A[    0.381013] device class 'bdi': registering=0A=
[    0.382054] device class 'pci_bus': registering=0A[    0.383042] bus: 'p=
ci': registered=0A[    0.383648] device: 'rapidio': device_add=0A[    0.384=
408] PM: Adding info for No Bus:rapidio=0A[    0.385321] bus: 'rapidio': re=
gistered=0A[    0.386018] device class 'tty': registering=0A[    0.480525] =
ACPI: bus type pci registered=0A[    0.481768] PCI: Using configuration typ=
e 1 for base access=0A[    0.483250] device: 'cpu0': device_add=0A[    0.48=
4218] bus: 'cpu': add device cpu0=0A[    0.485238] PM: Adding info for cpu:=
cpu0=0A[    0.486383] device: 'cpu1': device_add=0A[    0.487356] bus: 'cpu=
': add device cpu1=0A[    0.488396] PM: Adding info for cpu:cpu1=0A[    0.4=
89469] mtrr: your CPUs had inconsistent variable MTRR settings=0A[    0.490=
010] mtrr: your CPUs had inconsistent MTRRdefType settings=0A[    0.491571]=
 mtrr: probably your BIOS does not setup all CPUs.=0A[    0.492982] mtrr: c=
orrected configuration.=0A[    0.504270] device: 'default': device_add=0A[ =
   0.505606] PM: Adding info for No Bus:default=0A[    0.507749] bio: creat=
e slab <bio-0> at 0=0A[    0.508944] device class 'block': registering=0A[ =
   0.510866] ACPI: Added _OSI(Module Device)=0A[    0.512095] ACPI: Added _=
OSI(Processor Device)=0A[    0.513191] ACPI: Added _OSI(3.0 _SCP Extensions=
)=0A[    0.514362] ACPI: Added _OSI(Processor Aggregator Device)=0A[    0.5=
18846] ACPI: EC: Look up EC in DSDT=0A[    0.606943] ACPI: Interpreter enab=
led=0A[    0.607619] ACPI: (supports S0 S3 S5)=0A[    0.608669] ACPI: Using=
 IOAPIC for interrupt routing=0A[    0.609720] bus: 'acpi': registered=0A[ =
   0.610290] bus: 'acpi': add driver power=0A[    0.611354] device: 'LNXSYS=
TM:00': device_add=0A[    0.612180] bus: 'acpi': add device LNXSYSTM:00=0A[=
    0.613028] PM: Adding info for acpi:LNXSYSTM:00=0A[    0.614184] device:=
 'LNXCPU:00': device_add=0A[    0.614955] bus: 'acpi': add device LNXCPU:00=
=0A[    0.615792] PM: Adding info for acpi:LNXCPU:00=0A[    0.616880] devic=
e: 'LNXCPU:01': device_add=0A[    0.617634] bus: 'acpi': add device LNXCPU:=
01=0A[    0.618472] PM: Adding info for acpi:LNXCPU:01=0A[    0.620404] dev=
ice: 'device:00': device_add=0A[    0.621203] bus: 'acpi': add device devic=
e:00=0A[    0.622137] PM: Adding info for acpi:device:00=0A[    0.623783] d=
evice: 'PNP0A03:00': device_add=0A[    0.624574] bus: 'acpi': add device PN=
P0A03:00=0A[    0.625418] PM: Adding info for acpi:PNP0A03:00=0A[    0.6271=
46] device: 'device:01': device_add=0A[    0.627902] bus: 'acpi': add devic=
e device:01=0A[    0.628749] PM: Adding info for acpi:device:01=0A[    0.63=
0916] device: 'device:02': device_add=0A[    0.631785] bus: 'acpi': add dev=
ice device:02=0A[    0.632620] PM: Adding info for acpi:device:02=0A[    0.=
634314] device: 'device:03': device_add=0A[    0.635097] bus: 'acpi': add d=
evice device:03=0A[    0.635912] PM: Adding info for acpi:device:03=0A[    =
0.637613] device: 'device:04': device_add=0A[    0.638396] bus: 'acpi': add=
 device device:04=0A[    0.639235] PM: Adding info for acpi:device:04=0A[  =
  0.640907] device: 'device:05': device_add=0A[    0.641788] bus: 'acpi': a=
dd device device:05=0A[    0.642620] PM: Adding info for acpi:device:05=0A[=
    0.644312] device: 'device:06': device_add=0A[    0.645092] bus: 'acpi':=
 add device device:06=0A[    0.645900] PM: Adding info for acpi:device:06=
=0A[    0.647587] device: 'device:07': device_add=0A[    0.648370] bus: 'ac=
pi': add device device:07=0A[    0.649202] PM: Adding info for acpi:device:=
07=0A[    0.650977] device: 'device:08': device_add=0A[    0.651869] bus: '=
acpi': add device device:08=0A[    0.652702] PM: Adding info for acpi:devic=
e:08=0A[    0.654385] device: 'device:09': device_add=0A[    0.655165] bus:=
 'acpi': add device device:09=0A[    0.655984] PM: Adding info for acpi:dev=
ice:09=0A[    0.657680] device: 'device:0a': device_add=0A[    0.658470] bu=
s: 'acpi': add device device:0a=0A[    0.659311] PM: Adding info for acpi:d=
evice:0a=0A[    0.660893] device: 'device:0b': device_add=0A[    0.661789] =
bus: 'acpi': add device device:0b=0A[    0.662619] PM: Adding info for acpi=
:device:0b=0A[    0.664317] device: 'device:0c': device_add=0A[    0.665093=
] bus: 'acpi': add device device:0c=0A[    0.665909] PM: Adding info for ac=
pi:device:0c=0A[    0.667603] device: 'device:0d': device_add=0A[    0.6683=
71] bus: 'acpi': add device device:0d=0A[    0.669205] PM: Adding info for =
acpi:device:0d=0A[    0.671049] device: 'device:0e': device_add=0A[    0.67=
1995] bus: 'acpi': add device device:0e=0A[    0.672813] PM: Adding info fo=
r acpi:device:0e=0A[    0.674504] device: 'device:0f': device_add=0A[    0.=
675285] bus: 'acpi': add device device:0f=0A[    0.676129] PM: Adding info =
for acpi:device:0f=0A[    0.677833] device: 'device:10': device_add=0A[    =
0.678618] bus: 'acpi': add device device:10=0A[    0.679457] PM: Adding inf=
o for acpi:device:10=0A[    0.680931] device: 'device:11': device_add=0A[  =
  0.681848] bus: 'acpi': add device device:11=0A[    0.682674] PM: Adding i=
nfo for acpi:device:11=0A[    0.684372] device: 'device:12': device_add=0A[=
    0.685152] bus: 'acpi': add device device:12=0A[    0.686000] PM: Adding=
 info for acpi:device:12=0A[    0.687660] device: 'device:13': device_add=
=0A[    0.688437] bus: 'acpi': add device device:13=0A[    0.689275] PM: Ad=
ding info for acpi:device:13=0A[    0.691108] device: 'device:14': device_a=
dd=0A[    0.691968] bus: 'acpi': add device device:14=0A[    0.692801] PM: =
Adding info for acpi:device:14=0A[    0.694470] device: 'device:15': device=
_add=0A[    0.695240] bus: 'acpi': add device device:15=0A[    0.696086] PM=
: Adding info for acpi:device:15=0A[    0.697781] device: 'device:16': devi=
ce_add=0A[    0.698542] bus: 'acpi': add device device:16=0A[    0.699375] =
PM: Adding info for acpi:device:16=0A[    0.700978] device: 'device:17': de=
vice_add=0A[    0.701813] bus: 'acpi': add device device:17=0A[    0.702649=
] PM: Adding info for acpi:device:17=0A[    0.704316] device: 'device:18': =
device_add=0A[    0.705087] bus: 'acpi': add device device:18=0A[    0.7059=
28] PM: Adding info for acpi:device:18=0A[    0.707611] device: 'device:19'=
: device_add=0A[    0.708364] bus: 'acpi': add device device:19=0A[    0.70=
9195] PM: Adding info for acpi:device:19=0A[    0.711097] device: 'device:1=
a': device_add=0A[    0.711934] bus: 'acpi': add device device:1a=0A[    0.=
712768] PM: Adding info for acpi:device:1a=0A[    0.714441] device: 'device=
:1b': device_add=0A[    0.715227] bus: 'acpi': add device device:1b=0A[    =
0.716085] PM: Adding info for acpi:device:1b=0A[    0.717781] device: 'devi=
ce:1c': device_add=0A[    0.718566] bus: 'acpi': add device device:1c=0A[  =
  0.719387] PM: Adding info for acpi:device:1c=0A[    0.720989] device: 'de=
vice:1d': device_add=0A[    0.721774] bus: 'acpi': add device device:1d=0A[=
    0.722610] PM: Adding info for acpi:device:1d=0A[    0.724310] device: '=
device:1e': device_add=0A[    0.725083] bus: 'acpi': add device device:1e=
=0A[    0.725917] PM: Adding info for acpi:device:1e=0A[    0.727619] devic=
e: 'device:1f': device_add=0A[    0.728401] bus: 'acpi': add device device:=
1f=0A[    0.729223] PM: Adding info for acpi:device:1f=0A[    0.731607] dev=
ice: 'device:20': device_add=0A[    0.732387] bus: 'acpi': add device devic=
e:20=0A[    0.733202] PM: Adding info for acpi:device:20=0A[    0.734776] d=
evice: 'device:21': device_add=0A[    0.735562] bus: 'acpi': add device dev=
ice:21=0A[    0.736405] PM: Adding info for acpi:device:21=0A[    0.737982]=
 device: 'PNP0B00:00': device_add=0A[    0.738782] bus: 'acpi': add device =
PNP0B00:00=0A[    0.740079] PM: Adding info for acpi:PNP0B00:00=0A[    0.74=
2137] device: 'PNP0303:00': device_add=0A[    0.742939] bus: 'acpi': add de=
vice PNP0303:00=0A[    0.743792] PM: Adding info for acpi:PNP0303:00=0A[   =
 0.745808] device: 'PNP0F13:00': device_add=0A[    0.746577] bus: 'acpi': a=
dd device PNP0F13:00=0A[    0.747430] PM: Adding info for acpi:PNP0F13:00=
=0A[    0.749432] device: 'PNP0700:00': device_add=0A[    0.750172] bus: 'a=
cpi': add device PNP0700:00=0A[    0.751116] PM: Adding info for acpi:PNP07=
00:00=0A[    0.755246] device: 'PNP0400:00': device_add=0A[    0.756035] bu=
s: 'acpi': add device PNP0400:00=0A[    0.756887] PM: Adding info for acpi:=
PNP0400:00=0A[    0.760641] device: 'PNP0501:00': device_add=0A[    0.76148=
0] bus: 'acpi': add device PNP0501:00=0A[    0.762399] PM: Adding info for =
acpi:PNP0501:00=0A[    0.764792] device: 'device:22': device_add=0A[    0.7=
65577] bus: 'acpi': add device device:22=0A[    0.766422] PM: Adding info f=
or acpi:device:22=0A[    0.768477] device: 'PNP0103:00': device_add=0A[    =
0.769279] bus: 'acpi': add device PNP0103:00=0A[    0.770222] PM: Adding in=
fo for acpi:PNP0103:00=0A[    0.773474] device: 'PNP0C0F:00': device_add=0A=
[    0.774272] bus: 'acpi': add device PNP0C0F:00=0A[    0.775126] PM: Addi=
ng info for acpi:PNP0C0F:00=0A[    0.777988] device: 'PNP0C0F:01': device_a=
dd=0A[    0.778763] bus: 'acpi': add device PNP0C0F:01=0A[    0.779610] PM:=
 Adding info for acpi:PNP0C0F:01=0A[    0.782191] device: 'PNP0C0F:02': dev=
ice_add=0A[    0.782985] bus: 'acpi': add device PNP0C0F:02=0A[    0.783839=
] PM: Adding info for acpi:PNP0C0F:02=0A[    0.786740] device: 'PNP0C0F:03'=
: device_add=0A[    0.787517] bus: 'acpi': add device PNP0C0F:03=0A[    0.7=
88371] PM: Adding info for acpi:PNP0C0F:03=0A[    0.790660] device: 'device=
:23': device_add=0A[    0.791554] bus: 'acpi': add device device:23=0A[    =
0.792450] PM: Adding info for acpi:device:23=0A[    0.793358] device: 'LNXP=
WRBN:00': device_add=0A[    0.794159] bus: 'acpi': add device LNXPWRBN:00=
=0A[    0.794983] PM: Adding info for acpi:LNXPWRBN:00=0A[    0.796198] bus=
: 'acpi': add driver ec=0A[    0.797067] PCI: Ignoring host bridge windows =
=66rom ACPI; if necessary, use "pci=3Duse_crs" and report a bug=0A[    0.79=
8684] bus: 'acpi': add driver pci_root=0A[    0.799458] bus: 'acpi': driver=
_probe_device: matched device PNP0A03:00 with driver pci_root=0A[    0.8000=
05] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:=
00=0A[    0.801686] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])=
=0A[    0.802929] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf=
7] (ignored)=0A[    0.804230] pci_root PNP0A03:00: host bridge window [io  =
0x0d00-0xffff] (ignored)=0A[    0.805506] pci_root PNP0A03:00: host bridge =
window [mem 0x000a0000-0x000bffff] (ignored)=0A[    0.806896] pci_root PNP0=
A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)=0A[    0.8=
08313] PCI: root bus 00: using default resources=0A[    0.810298] device: '=
pci0000:00': device_add=0A[    0.811229] PM: Adding info for No Bus:pci0000=
:00=0A[    0.812255] device: '0000:00': device_add=0A[    0.813221] PM: Add=
ing info for No Bus:0000:00=0A[    0.814099] PCI host bridge to bus 0000:00=
=0A[    0.814811] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]=0A=
[    0.815874] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]=0A[    0.817111] pci_bus 0000:00: scanning bus=0A[    0.817893] pci 00=
00:00:00.0: [8086:1237] type 00 class 0x060000=0A[    0.818951] pci 0000:00=
:00.0: calling quirk_mmio_always_on+0x0/0xa=0A[    0.820466] pci 0000:00:01=
=2E0: [8086:7000] type 00 class 0x060100=0A[    0.822350] pci 0000:00:01.1:=
 [8086:7010] type 00 class 0x010180=0A[    0.823805] pci 0000:00:01.1: reg =
20: [io  0xc000-0xc00f]=0A[    0.825138] pci 0000:00:01.3: [8086:7113] type=
 00 class 0x068000=0A[    0.826751] pci 0000:00:01.3: calling quirk_piix4_a=
cpi+0x0/0x154=0A[    0.827864] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f]=
 claimed by PIIX4 ACPI=0A[    0.829218] pci 0000:00:01.3: quirk: [io  0xb10=
0-0xb10f] claimed by PIIX4 SMB=0A[    0.830104] pci 0000:00:01.3: calling p=
ci_fixup_piix4_acpi+0x0/0x10=0A[    0.831581] pci 0000:00:02.0: [1013:00b8]=
 type 00 class 0x030000=0A[    0.836689] pci 0000:00:02.0: reg 10: [mem 0xf=
0000000-0xf1ffffff pref]=0A[    0.841462] pci 0000:00:02.0: reg 14: [mem 0x=
f2000000-0xf2000fff]=0A[    0.858705] pci 0000:00:02.0: reg 30: [mem 0xf201=
0000-0xf201ffff pref]=0A[    0.860433] pci 0000:00:03.0: [8086:100e] type 0=
0 class 0x020000=0A[    0.862800] pci 0000:00:03.0: reg 10: [mem 0xf2020000=
-0xf203ffff]=0A[    0.865020] pci 0000:00:03.0: reg 14: [io  0xc040-0xc07f]=
=0A[    0.871265] pci 0000:00:03.0: reg 30: [mem 0xf2040000-0xf2047fff pref=
]=0A[    0.873437] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000=0A[=
    0.875121] pci 0000:00:04.0: reg 10: [io  0xc080-0xc0bf]=0A[    0.876584=
] pci 0000:00:04.0: reg 14: [mem 0xf2048000-0xf2048fff]=0A[    0.880268] pc=
i 0000:00:05.0: [1af4:1001] type 00 class 0x010000=0A[    0.882148] pci 000=
0:00:05.0: reg 10: [io  0xc0c0-0xc0ff]=0A[    0.883729] pci 0000:00:05.0: r=
eg 14: [mem 0xf2049000-0xf2049fff]=0A[    0.886404] pci 0000:00:06.0: [1af4=
:1001] type 00 class 0x010000=0A[    0.888107] pci 0000:00:06.0: reg 10: [i=
o  0xc100-0xc13f]=0A[    0.889565] pci 0000:00:06.0: reg 14: [mem 0xf204a00=
0-0xf204afff]=0A[    0.891267] pci 0000:00:07.0: [1af4:1001] type 00 class =
0x010000=0A[    0.892982] pci 0000:00:07.0: reg 10: [io  0xc140-0xc17f]=0A[=
    0.894453] pci 0000:00:07.0: reg 14: [mem 0xf204b000-0xf204bfff]=0A[    =
0.897149] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000=0A[    0.898=
844] pci 0000:00:08.0: reg 10: [io  0xc180-0xc1bf]=0A[    0.900180] pci 000=
0:00:08.0: reg 14: [mem 0xf204c000-0xf204cfff]=0A[    0.902903] pci 0000:00=
:09.0: [1af4:1001] type 00 class 0x010000=0A[    0.904588] pci 0000:00:09.0=
: reg 10: [io  0xc1c0-0xc1ff]=0A[    0.906052] pci 0000:00:09.0: reg 14: [m=
em 0xf204d000-0xf204dfff]=0A[    0.910147] pci 0000:00:0a.0: [8086:25ab] ty=
pe 00 class 0x088000=0A[    0.911897] pci 0000:00:0a.0: reg 10: [mem 0xf204=
e000-0xf204e00f]=0A[    0.914381] pci_bus 0000:00: fixups for bus=0A[    0.=
915214] pci_bus 0000:00: bus scan returning with max=3D00=0A[    0.916274] =
pci_bus 0000:00: on NUMA node 0=0A[    0.917191] ACPI: PCI Interrupt Routin=
g Table [\_SB_.PCI0._PRT]=0A[    0.944166]  pci0000:00: Unable to request _=
OSC control (_OSC support mask: 0x18)=0A[    0.945505] device: '0000:00:00.=
0': device_add=0A[    0.964352] bus: 'pci': add device 0000:00:00.0=0A[    =
0.965437] PM: Adding info for pci:0000:00:00.0=0A[    0.966374] device: '00=
00:00:01.0': device_add=0A[    0.984786] bus: 'pci': add device 0000:00:01.=
0=0A[    0.985857] PM: Adding info for pci:0000:00:01.0=0A[    0.986713] de=
vice: '0000:00:01.1': device_add=0A[    1.005181] bus: 'pci': add device 00=
00:00:01.1=0A[    1.006243] PM: Adding info for pci:0000:00:01.1=0A[    1.0=
07110] device: '0000:00:01.3': device_add=0A[    1.025574] bus: 'pci': add =
device 0000:00:01.3=0A[    1.026656] PM: Adding info for pci:0000:00:01.3=
=0A[    1.027519] device: '0000:00:02.0': device_add=0A[    1.045977] bus: =
'pci': add device 0000:00:02.0=0A[    1.047109] PM: Adding info for pci:000=
0:00:02.0=0A[    1.047967] device: '0000:00:03.0': device_add=0A[    1.0665=
46] bus: 'pci': add device 0000:00:03.0=0A[    1.067625] PM: Adding info fo=
r pci:0000:00:03.0=0A[    1.068485] device: '0000:00:04.0': device_add=0A[ =
   1.086893] bus: 'pci': add device 0000:00:04.0=0A[    1.087971] PM: Addin=
g info for pci:0000:00:04.0=0A[    1.088843] device: '0000:00:05.0': device=
_add=0A[    1.107316] bus: 'pci': add device 0000:00:05.0=0A[    1.108393] =
PM: Adding info for pci:0000:00:05.0=0A[    1.109250] device: '0000:00:06.0=
': device_add=0A[    1.127821] bus: 'pci': add device 0000:00:06.0=0A[    1=
=2E128898] PM: Adding info for pci:0000:00:06.0=0A[    1.129763] device: '0=
000:00:07.0': device_add=0A[    1.148221] bus: 'pci': add device 0000:00:07=
=2E0=0A[    1.149339] PM: Adding info for pci:0000:00:07.0=0A[    1.150059]=
 device: '0000:00:08.0': device_add=0A[    1.168644] bus: 'pci': add device=
 0000:00:08.0=0A[    1.169709] PM: Adding info for pci:0000:00:08.0=0A[    =
1.170055] device: '0000:00:09.0': device_add=0A[    1.189030] bus: 'pci': a=
dd device 0000:00:09.0=0A[    1.190331] PM: Adding info for pci:0000:00:09.=
0=0A[    1.191211] device: '0000:00:0a.0': device_add=0A[    1.209779] bus:=
 'pci': add device 0000:00:0a.0=0A[    1.210282] PM: Adding info for pci:00=
00:00:0a.0=0A[    1.211228] driver: 'PNP0A03:00': driver_bound: bound to de=
vice 'pci_root'=0A[    1.212479] bus: 'acpi': really_probe: bound device PN=
P0A03:00 to driver pci_root=0A[    1.213904] bus: 'acpi': add driver pci_li=
nk=0A[    1.214708] bus: 'acpi': driver_probe_device: matched device PNP0C0=
F:00 with driver pci_link=0A[    1.216148] bus: 'acpi': really_probe: probi=
ng driver pci_link with device PNP0C0F:00=0A[    1.218907] ACPI: PCI Interr=
upt Link [LNKA] (IRQs 5 *10 11)=0A[    1.221015] driver: 'PNP0C0F:00': driv=
er_bound: bound to device 'pci_link'=0A[    1.222294] bus: 'acpi': really_p=
robe: bound device PNP0C0F:00 to driver pci_link=0A[    1.223576] bus: 'acp=
i': driver_probe_device: matched device PNP0C0F:01 with driver pci_link=0A[=
    1.225016] bus: 'acpi': really_probe: probing driver pci_link with devic=
e PNP0C0F:01=0A[    1.227593] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 1=
1)=0A[    1.229029] driver: 'PNP0C0F:01': driver_bound: bound to device 'pc=
i_link'=0A[    1.230007] bus: 'acpi': really_probe: bound device PNP0C0F:01=
 to driver pci_link=0A[    1.231391] bus: 'acpi': driver_probe_device: matc=
hed device PNP0C0F:02 with driver pci_link=0A[    1.232830] bus: 'acpi': re=
ally_probe: probing driver pci_link with device PNP0C0F:02=0A[    1.235414]=
 ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)=0A[    1.236838] driver: '=
PNP0C0F:02': driver_bound: bound to device 'pci_link'=0A[    1.238018] bus:=
 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link=0A[    1.=
239295] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with dr=
iver pci_link=0A[    1.240229] bus: 'acpi': really_probe: probing driver pc=
i_link with device PNP0C0F:03=0A[    1.243053] ACPI: PCI Interrupt Link [LN=
KD] (IRQs 5 10 *11)=0A[    1.244597] driver: 'PNP0C0F:03': driver_bound: bo=
und to device 'pci_link'=0A[    1.245894] bus: 'acpi': really_probe: bound =
device PNP0C0F:03 to driver pci_link=0A[    1.247424] bus: 'pnp': registere=
d=0A[    1.248237] bus: 'xen': registered=0A[    1.250027] device class 'mi=
sc': registering=0A[    1.251051] device: 'vga_arbiter': device_add=0A[    =
1.252237] PM: Adding info for No Bus:vga_arbiter=0A[    1.253310] vgaarb: d=
evice added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone=
=0A[    1.254762] vgaarb: loaded=0A[    1.255248] vgaarb: bridge control po=
ssible 0000:00:02.0=0A[    1.256306] bus: 'serio': registered=0A[    1.2569=
48] device class 'input': registering=0A[    1.257777] device class 'rtc': =
registering=0A[    1.258585] device class 'power_supply': registering=0A[  =
  1.259507] device class 'watchdog': registering=0A[    1.260164] device cl=
ass 'devfreq': registering=0A[    1.261104] PCI: Using ACPI for IRQ routing=
=0A[    1.261891] PCI: pci_cache_line_size set to 64 bytes=0A[    1.262831]=
 pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=3D0,=
 p=3D0)=0A[    1.264243] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 fla=
gs 0x110] (d=3D0, p=3D0)=0A[    1.265559] pci 0000:00:01.1: BAR 2: reservin=
g [io  0x0170-0x0177 flags 0x110] (d=3D0, p=3D0)=0A[    1.266951] pci 0000:=
00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=3D0, p=3D0)=0A[    1.=
268252] pci 0000:00:01.1: BAR 4: reserving [io  0xc000-0xc00f flags 0x40101=
] (d=3D0, p=3D0)=0A[    1.270056] pci 0000:00:02.0: BAR 0: reserving [mem 0=
xf0000000-0xf1ffffff flags 0x42208] (d=3D0, p=3D0)=0A[    1.271752] pci 000=
0:00:02.0: BAR 1: reserving [mem 0xf2000000-0xf2000fff flags 0x40200] (d=3D=
0, p=3D0)=0A[    1.273450] pci 0000:00:03.0: BAR 0: reserving [mem 0xf20200=
00-0xf203ffff flags 0x40200] (d=3D0, p=3D0)=0A[    1.275023] pci 0000:00:03=
=2E0: BAR 1: reserving [io  0xc040-0xc07f flags 0x40101] (d=3D0, p=3D0)=0A[=
    1.276464] pci 0000:00:04.0: BAR 0: reserving [io  0xc080-0xc0bf flags 0=
x40101] (d=3D0, p=3D0)=0A[    1.277911] pci 0000:00:04.0: BAR 1: reserving =
[mem 0xf2048000-0xf2048fff flags 0x40200] (d=3D0, p=3D0)=0A[    1.279461] p=
ci 0000:00:05.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags 0x40101] (d=3D0,=
 p=3D0)=0A[    1.280068] pci 0000:00:05.0: BAR 1: reserving [mem 0xf2049000=
-0xf2049fff flags 0x40200] (d=3D0, p=3D0)=0A[    1.281722] pci 0000:00:06.0=
: BAR 0: reserving [io  0xc100-0xc13f flags 0x40101] (d=3D0, p=3D0)=0A[    =
1.283166] pci 0000:00:06.0: BAR 1: reserving [mem 0xf204a000-0xf204afff fla=
gs 0x40200] (d=3D0, p=3D0)=0A[    1.284721] pci 0000:00:07.0: BAR 0: reserv=
ing [io  0xc140-0xc17f flags 0x40101] (d=3D0, p=3D0)=0A[    1.286151] pci 0=
000:00:07.0: BAR 1: reserving [mem 0xf204b000-0xf204bfff flags 0x40200] (d=
=3D0, p=3D0)=0A[    1.287714] pci 0000:00:08.0: BAR 0: reserving [io  0xc18=
0-0xc1bf flags 0x40101] (d=3D0, p=3D0)=0A[    1.290007] pci 0000:00:08.0: B=
AR 1: reserving [mem 0xf204c000-0xf204cfff flags 0x40200] (d=3D0, p=3D0)=0A=
[    1.291652] pci 0000:00:09.0: BAR 0: reserving [io  0xc1c0-0xc1ff flags =
0x40101] (d=3D0, p=3D0)=0A[    1.293088] pci 0000:00:09.0: BAR 1: reserving=
 [mem 0xf204d000-0xf204dfff flags 0x40200] (d=3D0, p=3D0)=0A[    1.294640] =
pci 0000:00:0a.0: BAR 0: reserving [mem 0xf204e000-0xf204e00f flags 0x40200=
] (d=3D0, p=3D0)=0A[    1.296489] e820: reserve RAM buffer [mem 0x0009f400-=
0x0009ffff]=0A[    1.297565] e820: reserve RAM buffer [mem 0x0fffd000-0x0ff=
fffff]=0A[    1.298623] device class 'net': registering=0A[    1.300121] de=
vice: 'lo': device_add=0A[    1.301448] PM: Adding info for No Bus:lo=0A[  =
  1.340650] HPET: 3 timers in total, 0 timers will be used for per-cpu time=
r=0A[    1.376046] Switching to clocksource kvm-clock=0A[    1.377337] Warn=
ing: could not register annotated branches stats=0A[    1.446481] AppArmor:=
 AppArmor Filesystem Enabled=0A[    1.447488] bus: 'pnp': add driver system=
=0A[    1.448303] pnp: PnP ACPI init=0A[    1.448896] device: 'pnp0': devic=
e_add=0A[    1.449587] PM: Adding info for No Bus:pnp0=0A[    1.450352] ACP=
I: bus type pnp registered=0A[    1.451292] pnp 00:00: [bus 00-ff]=0A[    1=
=2E451930] pnp 00:00: [io  0x0cf8-0x0cff]=0A[    1.452648] pnp 00:00: [io  =
0x0000-0x0cf7 window]=0A[    1.453483] pnp 00:00: [io  0x0d00-0xffff window=
]=0A[    1.454457] pnp 00:00: [mem 0x000a0000-0x000bffff window]=0A[    1.4=
55400] pnp 00:00: [mem 0xe0000000-0xfebfffff window]=0A[    1.456367] devic=
e: '00:00': device_add=0A[    1.457149] bus: 'pnp': add device 00:00=0A[   =
 1.457953] PM: Adding info for pnp:00:00=0A[    1.458792] pnp 00:00: Plug a=
nd Play ACPI device, IDs PNP0a03 (active)=0A[    1.461385] pnp 00:01: [io  =
0x0070-0x0071]=0A[    1.462153] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -=
> IRQ 8 Mode:0 Active:0 Dest:3)=0A[    1.463522] pnp 00:01: [irq 8]=0A[    =
1.464108] pnp 00:01: [io  0x0072-0x0077]=0A[    1.464940] device: '00:01': =
device_add=0A[    1.465747] bus: 'pnp': add device 00:01=0A[    1.466555] P=
M: Adding info for pnp:00:01=0A[    1.467363] pnp 00:01: Plug and Play ACPI=
 device, IDs PNP0b00 (active)=0A[    1.469276] pnp 00:02: [io  0x0060]=0A[ =
   1.469928] pnp 00:02: [io  0x0064]=0A[    1.470573] IOAPIC[0]: Set routin=
g entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)=0A[    1.472009] pnp =
00:02: [irq 1]=0A[    1.472568] device: '00:02': device_add=0A[    1.473381=
] bus: 'pnp': add device 00:02=0A[    1.474215] PM: Adding info for pnp:00:=
02=0A[    1.475023] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (acti=
ve)=0A[    1.476921] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 M=
ode:0 Active:0 Dest:3)=0A[    1.478348] pnp 00:03: [irq 12]=0A[    1.478934=
] device: '00:03': device_add=0A[    1.479735] bus: 'pnp': add device 00:03=
=0A[    1.480587] PM: Adding info for pnp:00:03=0A[    1.481343] pnp 00:03:=
 Plug and Play ACPI device, IDs PNP0f13 (active)=0A[    1.483195] pnp 00:04=
: [io  0x03f2-0x03f5]=0A[    1.483978] pnp 00:04: [io  0x03f7]=0A[    1.484=
682] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Des=
t:3)=0A[    1.486087] pnp 00:04: [irq 6]=0A[    1.486625] pnp 00:04: [dma 2=
]=0A[    1.487194] device: '00:04': device_add=0A[    1.488055] bus: 'pnp':=
 add device 00:04=0A[    1.488849] PM: Adding info for pnp:00:04=0A[    1.4=
89593] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)=0A[    1.=
491988] pnp 00:05: [io  0x0378-0x037f]=0A[    1.492692] IOAPIC[0]: Set rout=
ing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)=0A[    1.494118] pn=
p 00:05: [irq 7]=0A[    1.494743] device: '00:05': device_add=0A[    1.4955=
46] bus: 'pnp': add device 00:05=0A[    1.496372] PM: Adding info for pnp:0=
0:05=0A[    1.497213] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (ac=
tive)=0A[    1.499626] pnp 00:06: [io  0x03f8-0x03ff]=0A[    1.500399] IOAP=
IC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)=0A[ =
   1.501819] pnp 00:06: [irq 4]=0A[    1.502370] device: '00:06': device_ad=
d=0A[    1.503233] bus: 'pnp': add device 00:06=0A[    1.504084] PM: Adding=
 info for pnp:00:06=0A[    1.504946] pnp 00:06: Plug and Play ACPI device, =
IDs PNP0501 (active)=0A[    1.507625] pnp 00:07: [mem 0xfed00000-0xfed003ff=
]=0A[    1.508565] device: '00:07': device_add=0A[    1.509436] bus: 'pnp':=
 add device 00:07=0A[    1.510625] PM: Adding info for pnp:00:07=0A[    1.5=
11715] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)=0A[    1.=
516429] pnp: PnP ACPI: found 8 devices=0A[    1.517185] ACPI: ACPI bus type=
 pnp unregistered=0A[    1.518136] device class 'mem': registering=0A[    1=
=2E519021] device: 'mem': device_add=0A[    1.519886] PM: Adding info for N=
o Bus:mem=0A[    1.520729] device: 'kmem': device_add=0A[    1.521555] PM: =
Adding info for No Bus:kmem=0A[    1.522606] device: 'null': device_add=0A[=
    1.523744] PM: Adding info for No Bus:null=0A[    1.525025] device: 'por=
t': device_add=0A[    1.526114] PM: Adding info for No Bus:port=0A[    1.52=
6969] device: 'zero': device_add=0A[    1.527741] PM: Adding info for No Bu=
s:zero=0A[    1.528577] device: 'full': device_add=0A[    1.529407] PM: Add=
ing info for No Bus:full=0A[    1.530330] device: 'random': device_add=0A[ =
   1.531167] PM: Adding info for No Bus:random=0A[    1.531998] device: 'ur=
andom': device_add=0A[    1.532839] PM: Adding info for No Bus:urandom=0A[ =
   1.533659] device: 'kmsg': device_add=0A[    1.534545] PM: Adding info fo=
r No Bus:kmsg=0A[    1.535390] device: 'tty': device_add=0A[    1.536331] P=
M: Adding info for No Bus:tty=0A[    1.537218] device: 'console': device_ad=
d=0A[    1.538090] PM: Adding info for No Bus:console=0A[    1.539258] pci_=
bus 0000:00: resource 4 [io  0x0000-0xffff]=0A[    1.540299] pci_bus 0000:0=
0: resource 5 [mem 0x00000000-0xffffffffff]=0A[    1.541501] NET: Registere=
d protocol family 1=0A[    1.542352] pci 0000:00:00.0: calling quirk_natoma=
+0x0/0x2b=0A[    1.543375] pci 0000:00:00.0: Limiting direct PCI/PCI transf=
ers=0A[    1.544606] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x=
80=0A[    1.545856] pci 0000:00:01.0: PIIX3: Enabling Passive Release=0A[  =
  1.546961] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x2e=0A[    1=
=2E548087] pci 0000:00:01.0: Activating ISA DMA hang workarounds=0A[    1.5=
49257] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xa9=0A[    1.550430] =
pci 0000:00:02.0: Boot video device=0A[    1.551304] pci 0000:00:03.0: call=
ing quirk_e100_interrupt+0x0/0x153=0A[    1.552644] PCI: CLS 0 bytes, defau=
lt 64=0A[    1.554007] Unpacking initramfs...=0A[    3.115695] Freeing init=
rd memory: 23656k freed=0A[    3.121545] Registering platform device 'pcspk=
r'. Parent at platform=0A[    3.122669] device: 'pcspkr': device_add=0A[   =
 3.123406] bus: 'platform': add device pcspkr=0A[    3.124340] PM: Adding i=
nfo for platform:pcspkr=0A[    3.125868] bus: 'clocksource': registered=0A[=
    3.126639] device: 'clocksource': device_add=0A[    3.127499] PM: Adding=
 info for No Bus:clocksource=0A[    3.128386] device: 'clocksource0': devic=
e_add=0A[    3.129255] bus: 'clocksource': add device clocksource0=0A[    3=
=2E130345] PM: Adding info for clocksource:clocksource0=0A[    3.131403] bu=
s: 'platform': add driver alarmtimer=0A[    3.132422] Registering platform =
device 'alarmtimer'. Parent at platform=0A[    3.133657] device: 'alarmtime=
r': device_add=0A[    3.134640] bus: 'platform': add device alarmtimer=0A[ =
   3.135634] PM: Adding info for platform:alarmtimer=0A[    3.136563] bus: =
'platform': driver_probe_device: matched device alarmtimer with driver alar=
mtimer=0A[    3.138241] bus: 'platform': really_probe: probing driver alarm=
timer with device alarmtimer=0A[    3.139839] driver: 'alarmtimer': driver_=
bound: bound to device 'alarmtimer'=0A[    3.141167] bus: 'platform': reall=
y_probe: bound device alarmtimer to driver alarmtimer=0A[    3.142852] bus:=
 'rttest': registered=0A[    3.143548] device: 'rttest': device_add=0A[    =
3.144472] PM: Adding info for No Bus:rttest=0A[    3.145499] device: 'rttes=
t0': device_add=0A[    3.146289] bus: 'rttest': add device rttest0=0A[    3=
=2E147167] PM: Adding info for rttest:rttest0=0A[    3.148258] device: 'rtt=
est1': device_add=0A[    3.149009] bus: 'rttest': add device rttest1=0A[   =
 3.149873] PM: Adding info for rttest:rttest1=0A[    3.151675] device: 'rtt=
est2': device_add=0A[    3.152428] bus: 'rttest': add device rttest2=0A[   =
 3.153240] PM: Adding info for rttest:rttest2=0A[    3.154373] device: 'rtt=
est3': device_add=0A[    3.155187] bus: 'rttest': add device rttest3=0A[   =
 3.156129] PM: Adding info for rttest:rttest3=0A[    3.157211] device: 'rtt=
est4': device_add=0A[    3.157969] bus: 'rttest': add device rttest4=0A[   =
 3.158788] PM: Adding info for rttest:rttest4=0A[    3.159799] device: 'rtt=
est5': device_add=0A[    3.160566] bus: 'rttest': add device rttest5=0A[   =
 3.161416] PM: Adding info for rttest:rttest5=0A[    3.162432] device: 'rtt=
est6': device_add=0A[    3.163188] bus: 'rttest': add device rttest6=0A[   =
 3.164140] PM: Adding info for rttest:rttest6=0A[    3.165297] device: 'rtt=
est7': device_add=0A[    3.166041] bus: 'rttest': add device rttest7=0A[   =
 3.166895] PM: Adding info for rttest:rttest7=0A[    3.167722] Initializing=
 RT-Tester: OK=0A[    3.168419] audit: initializing netlink socket (disable=
d)=0A[    3.169456] type=3D2000 audit(1341888701.160:1): initialized=0A[   =
 3.176836] Kprobe smoke test started=0A[    3.410257] Kprobe smoke test pas=
sed successfully=0A[    3.530099] Testing tracer function: PASSED=0A[    3.=
851158] Testing dynamic ftrace: PASSED=0A[    4.270243] Testing dynamic ftr=
ace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 36) (2 2 4 1 144) [    4.36003=
7] irq event stamp: 64122=0A[    4.360043] ------------[ cut here ]--------=
----=0A[    4.360043] WARNING: at /c/kernel-tests/usb/kernel/lockdep.c:3506=
 check_flags+0x140/0x177()=0A[    4.360043] Hardware name: Bochs=0A[    4.3=
60043] Modules linked in:=0A[    4.360043] =0A[    4.360043] Pid: 0, comm: =
swapper/1 Not tainted 3.5.0-rc5+ #91=0A[    4.360043] Call Trace:=0A[    4.=
360043]  <IRQ> =0A[    4.360043] =0A[    4.360043]  [<ffffffff81045250>] wa=
rn_slowpath_common+0x83/0x9c=0A[    4.360043] =0A[    4.360043]  [<ffffffff=
81045283>] warn_slowpath_null+0x1a/0x1c=0A[    4.360043] =0A[    4.360043] =
 [<ffffffff81099312>] check_flags+0x140/0x177=0A[    4.360043] =0A[    4.36=
0043]  [<ffffffff8109a528>] lock_is_held+0x3c/0xa7=0A[    4.360043] =0A[   =
 4.360043]  [<ffffffff81324ec1>] ? sub_preempt_count+0x7/0xe0=0A[    4.3600=
43] =0A[    4.360043]  [<ffffffff8104e529>] ? __local_bh_enable+0xda/0x18f=
=0A[    4.360043] =0A[    4.360043]  [<ffffffff810d0a5f>] ftrace_ops_list_f=
unc+0xae/0xf2=0A[    4.360043] =0A[    4.360043]  [<ffffffff813272d6>] ftra=
ce_call+0x5/0x2b=0A[    4.360043] =0A[    4.360043]  [<ffffffff81324ec6>] ?=
 sub_preempt_count+0xc/0xe0=0A[    4.360043] =0A[    4.360043]  [<ffffffff8=
104e529>] __local_bh_enable+0xda/0x18f=0A[    4.360043] =0A[    4.360043]  =
[<ffffffff8104e5f1>] _local_bh_enable+0x13/0x15=0A[    4.360043] =0A[    4.=
360043]  [<ffffffff8104ed7f>] irq_enter+0x4f/0x74=0A[    4.360043] =0A[    =
4.360043]  [<ffffffff81031ec9>] smp_apic_timer_interrupt+0x3e/0x98=0A[    4=
=2E360043] =0A[    4.360043]  [<ffffffff813280af>] apic_timer_interrupt+0x6=
f/0x80=0A[    4.360043]  <EOI> =0A[    4.360043] =0A[    4.360043]  [<fffff=
fff810c4ce1>] ? rcu_is_cpu_idle+0x67/0x78=0A[    4.360043] =0A[    4.360043=
]  [<ffffffff81038cc0>] ? native_safe_halt+0x6/0x8=0A[    4.360043] =0A[   =
 4.360043]  [<ffffffff81099b53>] ? trace_hardirqs_on+0xd/0xf=0A[    4.36004=
3] =0A[    4.360043]  [<ffffffff8102215e>] default_idle+0x127/0x2cd=0A[    =
4.360043] =0A[    4.360043]  [<ffffffff810232a3>] cpu_idle+0x11d/0x1e7=0A[ =
   4.360043] =0A[    4.360043]  [<ffffffff8130ddb9>] start_secondary+0x4a4/=
0x4b3=0A[    4.360043] ---[ end trace 5a5d197966b56a2e ]---=0A[    4.360043=
] irq event stamp: 13992=0A[    4.360043] hardirqs last  enabled at (13989)=
: =0A[    4.360043] [<ffffffff81022159>] default_idle+0x122/0x2cd=0A[    4.=
360043] hardirqs last disabled at (13990): =0A[    4.360043] [<ffffffff8132=
80aa>] apic_timer_interrupt+0x6a/0x80=0A[    4.360043] softirqs last  enabl=
ed at (13992): =0A[    4.360043] [<ffffffff8104e5f1>] _local_bh_enable+0x13=
/0x15=0A[    4.360043] softirqs last disabled at (13991): =0A[    4.360043]=
 [<ffffffff8104ed73>] irq_enter+0x43/0x74=0A=0A[    4.360037] hardirqs last=
  enabled at (64119): =0A[    4.360037] [<ffffffff81022159>] default_idle+0=
x122/0x2cd=0A[    4.360037] hardirqs last disabled at (64120): [<ffffffff81=
3280aa>] apic_timer_interrupt+0x6a/0x80=0A[    4.360037] softirqs last  ena=
bled at (64122): [<ffffffff8104e5f1>] _local_bh_enable+0x13/0x15=0A[    4.3=
60037] softirqs last disabled at (64121): [<ffffffff8104ed73>] irq_enter+0x=
43/0x74=0A[    4.490360] PASSED=0A[    4.490738] Testing dynamic ftrace ops=
 #2: (1 0 1 13 0) (1 1 2 109 0) (2 1 3 1 22) (2 2 4 107 126) PASSED=0A[    =
4.900060] Testing tracer irqsoff: PASSED=0A[    5.510065] Testing tracer br=
anch: PASSED=0A[    5.860555] bus: 'event_source': registered=0A[    5.8616=
59] device: 'breakpoint': device_add=0A[    5.862800] bus: 'event_source': =
add device breakpoint=0A[    5.864177] PM: Adding info for event_source:bre=
akpoint=0A[    5.865396] device: 'tracepoint': device_add=0A[    5.866242] =
bus: 'event_source': add device tracepoint=0A[    5.867307] PM: Adding info=
 for event_source:tracepoint=0A[    5.868401] device: 'software': device_ad=
d=0A[    5.869224] bus: 'event_source': add device software=0A[    5.870269=
] PM: Adding info for event_source:software=0A[    5.871719] HugeTLB regist=
ered 2 MB page size, pre-allocated 0 pages=0A[    5.874710] VFS: Disk quota=
s dquot_6.5.2=0A[    5.875956] Dquot-cache hash table entries: 512 (order 0=
, 4096 bytes)=0A[    5.878125] msgmni has been set to 455=0A[    5.880508] =
device class 'bsg': registering=0A[    5.881712] Block layer SCSI generic (=
bsg) driver version 0.4 loaded (major 252)=0A[    5.883607] io scheduler no=
op registered (default)=0A[    5.884987] start plist test=0A[    5.889667] =
end plist test=0A[    5.890476] list_sort_test: start testing list_sort()=
=0A[    5.904354] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1=0A[    5.9056=
49] crc32: self tests passed, processed 225944 bytes in 2274588 nsec=0A[   =
 5.909928] crc32c: CRC_LE_BITS =3D 1=0A[    5.911019] crc32c: self tests pa=
ssed, processed 225944 bytes in 1263970 nsec=0A[    5.912826] bus: 'pci': a=
dd driver langwell_gpio=0A[    5.914291] bus: 'platform': add driver wp_gpi=
o=0A[    5.915836] bus: 'acpi': add driver hardware_error_device=0A[    5.9=
17389] GHES: HEST is not enabled!=0A[    5.918351] bus: 'pci': add driver x=
en-platform-pci=0A[    5.919909] device: 'ptyp0': device_add=0A[    5.92143=
3] PM: Adding info for No Bus:ptyp0=0A[    5.922585] device: 'ptyp1': devic=
e_add=0A[    5.923848] PM: Adding info for No Bus:ptyp1=0A[    5.925103] de=
vice: 'ptyp2': device_add=0A[    5.926241] PM: Adding info for No Bus:ptyp2=
=0A[    5.927421] device: 'ptyp3': device_add=0A[    5.928643] PM: Adding i=
nfo for No Bus:ptyp3=0A[    5.929953] device: 'ptyp4': device_add=0A[    5.=
931205] PM: Adding info for No Bus:ptyp4=0A[    5.932361] device: 'ptyp5': =
device_add=0A[    5.933574] PM: Adding info for No Bus:ptyp5=0A[    5.93495=
1] device: 'ptyp6': device_add=0A[    5.936142] PM: Adding info for No Bus:=
ptyp6=0A[    5.937361] device: 'ptyp7': device_add=0A[    5.938552] PM: Add=
ing info for No Bus:ptyp7=0A[    5.939728] device: 'ptyp8': device_add=0A[ =
   5.940987] PM: Adding info for No Bus:ptyp8=0A[    5.942190] device: 'pty=
p9': device_add=0A[    5.943368] PM: Adding info for No Bus:ptyp9=0A[    5.=
944728] device: 'ptypa': device_add=0A[    5.946097] PM: Adding info for No=
 Bus:ptypa=0A[    5.947303] device: 'ptypb': device_add=0A[    5.948463] PM=
: Adding info for No Bus:ptypb=0A[    5.949681] device: 'ptypc': device_add=
=0A[    5.950923] PM: Adding info for No Bus:ptypc=0A[    5.952033] device:=
 'ptypd': device_add=0A[    5.952866] PM: Adding info for No Bus:ptypd=0A[ =
   5.953690] device: 'ptype': device_add=0A[    5.954656] PM: Adding info f=
or No Bus:ptype=0A[    5.955525] device: 'ptypf': device_add=0A[    5.95641=
4] PM: Adding info for No Bus:ptypf=0A[    5.957294] device: 'ptyq0': devic=
e_add=0A[    5.958158] PM: Adding info for No Bus:ptyq0=0A[    5.959097] de=
vice: 'ptyq1': device_add=0A[    5.959991] PM: Adding info for No Bus:ptyq1=
=0A[    5.960911] device: 'ptyq2': device_add=0A[    5.961783] PM: Adding i=
nfo for No Bus:ptyq2=0A[    5.962673] device: 'ptyq3': device_add=0A[    5.=
963506] PM: Adding info for No Bus:ptyq3=0A[    5.964568] device: 'ptyq4': =
device_add=0A[    5.965435] PM: Adding info for No Bus:ptyq4=0A[    5.96632=
4] device: 'ptyq5': device_add=0A[    5.967166] PM: Adding info for No Bus:=
ptyq5=0A[    5.968062] device: 'ptyq6': device_add=0A[    5.968951] PM: Add=
ing info for No Bus:ptyq6=0A[    5.969853] device: 'ptyq7': device_add=0A[ =
   5.970746] PM: Adding info for No Bus:ptyq7=0A[    5.971625] device: 'pty=
q8': device_add=0A[    5.972474] PM: Adding info for No Bus:ptyq8=0A[    5.=
973355] device: 'ptyq9': device_add=0A[    5.974218] PM: Adding info for No=
 Bus:ptyq9=0A[    5.975162] device: 'ptyqa': device_add=0A[    5.976170] PM=
: Adding info for No Bus:ptyqa=0A[    5.977061] device: 'ptyqb': device_add=
=0A[    5.977928] PM: Adding info for No Bus:ptyqb=0A[    5.978817] device:=
 'ptyqc': device_add=0A[    5.979679] PM: Adding info for No Bus:ptyqc=0A[ =
   5.980622] device: 'ptyqd': device_add=0A[    5.981490] PM: Adding info f=
or No Bus:ptyqd=0A[    5.982368] device: 'ptyqe': device_add=0A[    5.98320=
5] PM: Adding info for No Bus:ptyqe=0A[    5.984129] device: 'ptyqf': devic=
e_add=0A[    5.985071] PM: Adding info for No Bus:ptyqf=0A[    5.985975] de=
vice: 'ptyr0': device_add=0A[    5.986860] PM: Adding info for No Bus:ptyr0=
=0A[    5.987735] device: 'ptyr1': device_add=0A[    5.988618] PM: Adding i=
nfo for No Bus:ptyr1=0A[    5.989482] device: 'ptyr2': device_add=0A[    5.=
990397] PM: Adding info for No Bus:ptyr2=0A[    5.991310] device: 'ptyr3': =
device_add=0A[    5.992179] PM: Adding info for No Bus:ptyr3=0A[    5.99308=
0] device: 'ptyr4': device_add=0A[    5.993985] PM: Adding info for No Bus:=
ptyr4=0A[    5.995115] device: 'ptyr5': device_add=0A[    5.996153] PM: Add=
ing info for No Bus:ptyr5=0A[    5.997173] device: 'ptyr6': device_add=0A[ =
   5.998121] PM: Adding info for No Bus:ptyr6=0A[    5.999206] device: 'pty=
r7': device_add=0A[    6.000327] PM: Adding info for No Bus:ptyr7=0A[    6.=
001353] device: 'ptyr8': device_add=0A[    6.002316] PM: Adding info for No=
 Bus:ptyr8=0A[    6.003358] device: 'ptyr9': device_add=0A[    6.004531] PM=
: Adding info for No Bus:ptyr9=0A[    6.005692] device: 'ptyra': device_add=
=0A[    6.006735] PM: Adding info for No Bus:ptyra=0A[    6.007715] device:=
 'ptyrb': device_add=0A[    6.008856] PM: Adding info for No Bus:ptyrb=0A[ =
   6.009978] device: 'ptyrc': device_add=0A[    6.010984] PM: Adding info f=
or No Bus:ptyrc=0A[    6.011988] device: 'ptyrd': device_add=0A[    6.01311=
9] PM: Adding info for No Bus:ptyrd=0A[    6.014063] device: 'ptyre': devic=
e_add=0A[    6.014981] PM: Adding info for No Bus:ptyre=0A[    6.015838] de=
vice: 'ptyrf': device_add=0A[    6.016632] PM: Adding info for No Bus:ptyrf=
=0A[    6.017486] device: 'ptys0': device_add=0A[    6.018288] PM: Adding i=
nfo for No Bus:ptys0=0A[    6.019100] device: 'ptys1': device_add=0A[    6.=
019902] PM: Adding info for No Bus:ptys1=0A[    6.020775] device: 'ptys2': =
device_add=0A[    6.021557] PM: Adding info for No Bus:ptys2=0A[    6.02238=
3] device: 'ptys3': device_add=0A[    6.023193] PM: Adding info for No Bus:=
ptys3=0A[    6.024043] device: 'ptys4': device_add=0A[    6.025010] PM: Add=
ing info for No Bus:ptys4=0A[    6.025903] device: 'ptys5': device_add=0A[ =
   6.026743] PM: Adding info for No Bus:ptys5=0A[    6.027621] device: 'pty=
s6': device_add=0A[    6.028444] PM: Adding info for No Bus:ptys6=0A[    6.=
029302] device: 'ptys7': device_add=0A[    6.030200] PM: Adding info for No=
 Bus:ptys7=0A[    6.031137] device: 'ptys8': device_add=0A[    6.032051] PM=
: Adding info for No Bus:ptys8=0A[    6.032956] device: 'ptys9': device_add=
=0A[    6.033866] PM: Adding info for No Bus:ptys9=0A[    6.034880] device:=
 'ptysa': device_add=0A[    6.035799] PM: Adding info for No Bus:ptysa=0A[ =
   6.036714] device: 'ptysb': device_add=0A[    6.037584] PM: Adding info f=
or No Bus:ptysb=0A[    6.038495] device: 'ptysc': device_add=0A[    6.03935=
7] PM: Adding info for No Bus:ptysc=0A[    6.040254] device: 'ptysd': devic=
e_add=0A[    6.041147] PM: Adding info for No Bus:ptysd=0A[    6.042077] de=
vice: 'ptyse': device_add=0A[    6.042947] PM: Adding info for No Bus:ptyse=
=0A[    6.043865] device: 'ptysf': device_add=0A[    6.044886] PM: Adding i=
nfo for No Bus:ptysf=0A[    6.045729] device: 'ptyt0': device_add=0A[    6.=
046623] PM: Adding info for No Bus:ptyt0=0A[    6.047543] device: 'ptyt1': =
device_add=0A[    6.048394] PM: Adding info for No Bus:ptyt1=0A[    6.04927=
4] device: 'ptyt2': device_add=0A[    6.050175] PM: Adding info for No Bus:=
ptyt2=0A[    6.051096] device: 'ptyt3': device_add=0A[    6.051995] PM: Add=
ing info for No Bus:ptyt3=0A[    6.052888] device: 'ptyt4': device_add=0A[ =
   6.053920] PM: Adding info for No Bus:ptyt4=0A[    6.054890] device: 'pty=
t5': device_add=0A[    6.055779] PM: Adding info for No Bus:ptyt5=0A[    6.=
056633] device: 'ptyt6': device_add=0A[    6.057493] PM: Adding info for No=
 Bus:ptyt6=0A[    6.058391] device: 'ptyt7': device_add=0A[    6.059271] PM=
: Adding info for No Bus:ptyt7=0A[    6.060244] device: 'ptyt8': device_add=
=0A[    6.061151] PM: Adding info for No Bus:ptyt8=0A[    6.062033] device:=
 'ptyt9': device_add=0A[    6.062933] PM: Adding info for No Bus:ptyt9=0A[ =
   6.063869] device: 'ptyta': device_add=0A[    6.064870] PM: Adding info f=
or No Bus:ptyta=0A[    6.065809] device: 'ptytb': device_add=0A[    6.06671=
2] PM: Adding info for No Bus:ptytb=0A[    6.067568] device: 'ptytc': devic=
e_add=0A[    6.068418] PM: Adding info for No Bus:ptytc=0A[    6.069307] de=
vice: 'ptytd': device_add=0A[    6.070166] PM: Adding info for No Bus:ptytd=
=0A[    6.071033] device: 'ptyte': device_add=0A[    6.071886] PM: Adding i=
nfo for No Bus:ptyte=0A[    6.072705] device: 'ptytf': device_add=0A[    6.=
073515] PM: Adding info for No Bus:ptytf=0A[    6.074423] device: 'ptyu0': =
device_add=0A[    6.075247] PM: Adding info for No Bus:ptyu0=0A[    6.07606=
1] device: 'ptyu1': device_add=0A[    6.076859] PM: Adding info for No Bus:=
ptyu1=0A[    6.077641] device: 'ptyu2': device_add=0A[    6.078432] PM: Add=
ing info for No Bus:ptyu2=0A[    6.079260] device: 'ptyu3': device_add=0A[ =
   6.080077] PM: Adding info for No Bus:ptyu3=0A[    6.080890] device: 'pty=
u4': device_add=0A[    6.081670] PM: Adding info for No Bus:ptyu4=0A[    6.=
082468] device: 'ptyu5': device_add=0A[    6.083265] PM: Adding info for No=
 Bus:ptyu5=0A[    6.084110] device: 'ptyu6': device_add=0A[    6.085001] PM=
: Adding info for No Bus:ptyu6=0A[    6.085809] device: 'ptyu7': device_add=
=0A[    6.086586] PM: Adding info for No Bus:ptyu7=0A[    6.087382] device:=
 'ptyu8': device_add=0A[    6.088165] PM: Adding info for No Bus:ptyu8=0A[ =
   6.088987] device: 'ptyu9': device_add=0A[    6.089777] PM: Adding info f=
or No Bus:ptyu9=0A[    6.090614] device: 'ptyua': device_add=0A[    6.09141=
1] PM: Adding info for No Bus:ptyua=0A[    6.092210] device: 'ptyub': devic=
e_add=0A[    6.093007] PM: Adding info for No Bus:ptyub=0A[    6.093853] de=
vice: 'ptyuc': device_add=0A[    6.094698] PM: Adding info for No Bus:ptyuc=
=0A[    6.095518] device: 'ptyud': device_add=0A[    6.096367] PM: Adding i=
nfo for No Bus:ptyud=0A[    6.097166] device: 'ptyue': device_add=0A[    6.=
097966] PM: Adding info for No Bus:ptyue=0A[    6.098796] device: 'ptyuf': =
device_add=0A[    6.099574] PM: Adding info for No Bus:ptyuf=0A[    6.10039=
3] device: 'ptyv0': device_add=0A[    6.101185] PM: Adding info for No Bus:=
ptyv0=0A[    6.101983] device: 'ptyv1': device_add=0A[    6.102778] PM: Add=
ing info for No Bus:ptyv1=0A[    6.103582] device: 'ptyv2': device_add=0A[ =
   6.104439] PM: Adding info for No Bus:ptyv2=0A[    6.105263] device: 'pty=
v3': device_add=0A[    6.106056] PM: Adding info for No Bus:ptyv3=0A[    6.=
106857] device: 'ptyv4': device_add=0A[    6.107629] PM: Adding info for No=
 Bus:ptyv4=0A[    6.108453] device: 'ptyv5': device_add=0A[    6.109249] PM=
: Adding info for No Bus:ptyv5=0A[    6.110081] device: 'ptyv6': device_add=
=0A[    6.110878] PM: Adding info for No Bus:ptyv6=0A[    6.111663] device:=
 'ptyv7': device_add=0A[    6.112453] PM: Adding info for No Bus:ptyv7=0A[ =
   6.113270] device: 'ptyv8': device_add=0A[    6.114080] PM: Adding info f=
or No Bus:ptyv8=0A[    6.115037] device: 'ptyv9': device_add=0A[    6.11590=
6] PM: Adding info for No Bus:ptyv9=0A[    6.116719] device: 'ptyva': devic=
e_add=0A[    6.117570] PM: Adding info for No Bus:ptyva=0A[    6.118430] de=
vice: 'ptyvb': device_add=0A[    6.119279] PM: Adding info for No Bus:ptyvb=
=0A[    6.120185] device: 'ptyvc': device_add=0A[    6.121045] PM: Adding i=
nfo for No Bus:ptyvc=0A[    6.121893] device: 'ptyvd': device_add=0A[    6.=
122699] PM: Adding info for No Bus:ptyvd=0A[    6.123576] device: 'ptyve': =
device_add=0A[    6.124476] PM: Adding info for No Bus:ptyve=0A[    6.12534=
1] device: 'ptyvf': device_add=0A[    6.126258] PM: Adding info for No Bus:=
ptyvf=0A[    6.127113] device: 'ptyw0': device_add=0A[    6.127957] PM: Add=
ing info for No Bus:ptyw0=0A[    6.128830] device: 'ptyw1': device_add=0A[ =
   6.129637] PM: Adding info for No Bus:ptyw1=0A[    6.130533] device: 'pty=
w2': device_add=0A[    6.131369] PM: Adding info for No Bus:ptyw2=0A[    6.=
132221] device: 'ptyw3': device_add=0A[    6.133067] PM: Adding info for No=
 Bus:ptyw3=0A[    6.133966] device: 'ptyw4': device_add=0A[    6.134897] PM=
: Adding info for No Bus:ptyw4=0A[    6.135795] device: 'ptyw5': device_add=
=0A[    6.136631] PM: Adding info for No Bus:ptyw5=0A[    6.137473] device:=
 'ptyw6': device_add=0A[    6.138308] PM: Adding info for No Bus:ptyw6=0A[ =
   6.139141] device: 'ptyw7': device_add=0A[    6.139938] PM: Adding info f=
or No Bus:ptyw7=0A[    6.140806] device: 'ptyw8': device_add=0A[    6.14159=
8] PM: Adding info for No Bus:ptyw8=0A[    6.142411] device: 'ptyw9': devic=
e_add=0A[    6.143217] PM: Adding info for No Bus:ptyw9=0A[    6.144077] de=
vice: 'ptywa': device_add=0A[    6.144972] PM: Adding info for No Bus:ptywa=
=0A[    6.145802] device: 'ptywb': device_add=0A[    6.146590] PM: Adding i=
nfo for No Bus:ptywb=0A[    6.147407] device: 'ptywc': device_add=0A[    6.=
148214] PM: Adding info for No Bus:ptywc=0A[    6.149046] device: 'ptywd': =
device_add=0A[    6.149848] PM: Adding info for No Bus:ptywd=0A[    6.15066=
5] device: 'ptywe': device_add=0A[    6.151476] PM: Adding info for No Bus:=
ptywe=0A[    6.152273] device: 'ptywf': device_add=0A[    6.153063] PM: Add=
ing info for No Bus:ptywf=0A[    6.153906] device: 'ptyx0': device_add=0A[ =
   6.154806] PM: Adding info for No Bus:ptyx0=0A[    6.155662] device: 'pty=
x1': device_add=0A[    6.156489] PM: Adding info for No Bus:ptyx1=0A[    6.=
157301] device: 'ptyx2': device_add=0A[    6.158095] PM: Adding info for No=
 Bus:ptyx2=0A[    6.158937] device: 'ptyx3': device_add=0A[    6.159721] PM=
: Adding info for No Bus:ptyx3=0A[    6.160574] device: 'ptyx4': device_add=
=0A[    6.161379] PM: Adding info for No Bus:ptyx4=0A[    6.162182] device:=
 'ptyx5': device_add=0A[    6.162979] PM: Adding info for No Bus:ptyx5=0A[ =
   6.163829] device: 'ptyx6': device_add=0A[    6.164721] PM: Adding info f=
or No Bus:ptyx6=0A[    6.165525] device: 'ptyx7': device_add=0A[    6.16633=
3] PM: Adding info for No Bus:ptyx7=0A[    6.167269] device: 'ptyx8': devic=
e_add=0A[    6.168077] PM: Adding info for No Bus:ptyx8=0A[    6.168962] de=
vice: 'ptyx9': device_add=0A[    6.169771] PM: Adding info for No Bus:ptyx9=
=0A[    6.170631] device: 'ptyxa': device_add=0A[    6.171444] PM: Adding i=
nfo for No Bus:ptyxa=0A[    6.172293] device: 'ptyxb': device_add=0A[    6.=
173090] PM: Adding info for No Bus:ptyxb=0A[    6.173993] device: 'ptyxc': =
device_add=0A[    6.174881] PM: Adding info for No Bus:ptyxc=0A[    6.17571=
5] device: 'ptyxd': device_add=0A[    6.176515] PM: Adding info for No Bus:=
ptyxd=0A[    6.177372] device: 'ptyxe': device_add=0A[    6.178179] PM: Add=
ing info for No Bus:ptyxe=0A[    6.179051] device: 'ptyxf': device_add=0A[ =
   6.179845] PM: Adding info for No Bus:ptyxf=0A[    6.180698] device: 'pty=
y0': device_add=0A[    6.181511] PM: Adding info for No Bus:ptyy0=0A[    6.=
182314] device: 'ptyy1': device_add=0A[    6.183152] PM: Adding info for No=
 Bus:ptyy1=0A[    6.184049] device: 'ptyy2': device_add=0A[    6.184945] PM=
: Adding info for No Bus:ptyy2=0A[    6.185824] device: 'ptyy3': device_add=
=0A[    6.186604] PM: Adding info for No Bus:ptyy3=0A[    6.187449] device:=
 'ptyy4': device_add=0A[    6.188252] PM: Adding info for No Bus:ptyy4=0A[ =
   6.189126] device: 'ptyy5': device_add=0A[    6.189919] PM: Adding info f=
or No Bus:ptyy5=0A[    6.190789] device: 'ptyy6': device_add=0A[    6.19156=
7] PM: Adding info for No Bus:ptyy6=0A[    6.192431] device: 'ptyy7': devic=
e_add=0A[    6.193232] PM: Adding info for No Bus:ptyy7=0A[    6.194129] de=
vice: 'ptyy8': device_add=0A[    6.195015] PM: Adding info for No Bus:ptyy8=
=0A[    6.195857] device: 'ptyy9': device_add=0A[    6.196640] PM: Adding i=
nfo for No Bus:ptyy9=0A[    6.197489] device: 'ptyya': device_add=0A[    6.=
198301] PM: Adding info for No Bus:ptyya=0A[    6.199255] device: 'ptyyb': =
device_add=0A[    6.200176] PM: Adding info for No Bus:ptyyb=0A[    6.20100=
5] device: 'ptyyc': device_add=0A[    6.201830] PM: Adding info for No Bus:=
ptyyc=0A[    6.202650] device: 'ptyyd': device_add=0A[    6.203456] PM: Add=
ing info for No Bus:ptyyd=0A[    6.204437] device: 'ptyye': device_add=0A[ =
   6.205325] PM: Adding info for No Bus:ptyye=0A[    6.206203] device: 'pty=
yf': device_add=0A[    6.207079] PM: Adding info for No Bus:ptyyf=0A[    6.=
207968] device: 'ptyz0': device_add=0A[    6.208918] PM: Adding info for No=
 Bus:ptyz0=0A[    6.209733] device: 'ptyz1': device_add=0A[    6.210632] PM=
: Adding info for No Bus:ptyz1=0A[    6.211487] device: 'ptyz2': device_add=
=0A[    6.212363] PM: Adding info for No Bus:ptyz2=0A[    6.213249] device:=
 'ptyz3': device_add=0A[    6.214150] PM: Adding info for No Bus:ptyz3=0A[ =
   6.215043] device: 'ptyz4': device_add=0A[    6.216033] PM: Adding info f=
or No Bus:ptyz4=0A[    6.216946] device: 'ptyz5': device_add=0A[    6.21781=
6] PM: Adding info for No Bus:ptyz5=0A[    6.218645] device: 'ptyz6': devic=
e_add=0A[    6.219526] PM: Adding info for No Bus:ptyz6=0A[    6.220400] de=
vice: 'ptyz7': device_add=0A[    6.221224] PM: Adding info for No Bus:ptyz7=
=0A[    6.222098] device: 'ptyz8': device_add=0A[    6.222914] PM: Adding i=
nfo for No Bus:ptyz8=0A[    6.223819] device: 'ptyz9': device_add=0A[    6.=
224778] PM: Adding info for No Bus:ptyz9=0A[    6.225674] device: 'ptyza': =
device_add=0A[    6.226550] PM: Adding info for No Bus:ptyza=0A[    6.22736=
1] device: 'ptyzb': device_add=0A[    6.228228] PM: Adding info for No Bus:=
ptyzb=0A[    6.229112] device: 'ptyzc': device_add=0A[    6.229972] PM: Add=
ing info for No Bus:ptyzc=0A[    6.230909] device: 'ptyzd': device_add=0A[ =
   6.231789] PM: Adding info for No Bus:ptyzd=0A[    6.232583] device: 'pty=
ze': device_add=0A[    6.233528] PM: Adding info for No Bus:ptyze=0A[    6.=
234405] device: 'ptyzf': device_add=0A[    6.235307] PM: Adding info for No=
 Bus:ptyzf=0A[    6.236192] device: 'ptya0': device_add=0A[    6.237079] PM=
: Adding info for No Bus:ptya0=0A[    6.237964] device: 'ptya1': device_add=
=0A[    6.238843] PM: Adding info for No Bus:ptya1=0A[    6.239643] device:=
 'ptya2': device_add=0A[    6.240471] PM: Adding info for No Bus:ptya2=0A[ =
   6.241348] device: 'ptya3': device_add=0A[    6.242266] PM: Adding info f=
or No Bus:ptya3=0A[    6.243120] device: 'ptya4': device_add=0A[    6.24402=
5] PM: Adding info for No Bus:ptya4=0A[    6.245007] device: 'ptya5': devic=
e_add=0A[    6.245980] PM: Adding info for No Bus:ptya5=0A[    6.246879] de=
vice: 'ptya6': device_add=0A[    6.247811] PM: Adding info for No Bus:ptya6=
=0A[    6.248739] device: 'ptya7': device_add=0A[    6.249657] PM: Adding i=
nfo for No Bus:ptya7=0A[    6.250614] device: 'ptya8': device_add=0A[    6.=
251550] PM: Adding info for No Bus:ptya8=0A[    6.252426] device: 'ptya9': =
device_add=0A[    6.253443] PM: Adding info for No Bus:ptya9=0A[    6.25438=
3] device: 'ptyaa': device_add=0A[    6.255344] PM: Adding info for No Bus:=
ptyaa=0A[    6.256221] device: 'ptyab': device_add=0A[    6.257150] PM: Add=
ing info for No Bus:ptyab=0A[    6.258116] device: 'ptyac': device_add=0A[ =
   6.259053] PM: Adding info for No Bus:ptyac=0A[    6.259914] device: 'pty=
ad': device_add=0A[    6.260885] PM: Adding info for No Bus:ptyad=0A[    6.=
261717] device: 'ptyae': device_add=0A[    6.262633] PM: Adding info for No=
 Bus:ptyae=0A[    6.263597] device: 'ptyaf': device_add=0A[    6.264598] PM=
: Adding info for No Bus:ptyaf=0A[    6.265449] device: 'ptyb0': device_add=
=0A[    6.266370] PM: Adding info for No Bus:ptyb0=0A[    6.267314] device:=
 'ptyb1': device_add=0A[    6.268210] PM: Adding info for No Bus:ptyb1=0A[ =
   6.269142] device: 'ptyb2': device_add=0A[    6.270100] PM: Adding info f=
or No Bus:ptyb2=0A[    6.271040] device: 'ptyb3': device_add=0A[    6.27196=
3] PM: Adding info for No Bus:ptyb3=0A[    6.272816] device: 'ptyb4': devic=
e_add=0A[    6.273712] PM: Adding info for No Bus:ptyb4=0A[    6.274805] de=
vice: 'ptyb5': device_add=0A[    6.275792] PM: Adding info for No Bus:ptyb5=
=0A[    6.276730] device: 'ptyb6': device_add=0A[    6.277653] PM: Adding i=
nfo for No Bus:ptyb6=0A[    6.278498] device: 'ptyb7': device_add=0A[    6.=
279492] PM: Adding info for No Bus:ptyb7=0A[    6.280422] device: 'ptyb8': =
device_add=0A[    6.281282] PM: Adding info for No Bus:ptyb8=0A[    6.28211=
6] device: 'ptyb9': device_add=0A[    6.283052] PM: Adding info for No Bus:=
ptyb9=0A[    6.284008] device: 'ptyba': device_add=0A[    6.285047] PM: Add=
ing info for No Bus:ptyba=0A[    6.285932] device: 'ptybb': device_add=0A[ =
   6.286868] PM: Adding info for No Bus:ptybb=0A[    6.287809] device: 'pty=
bc': device_add=0A[    6.288709] PM: Adding info for No Bus:ptybc=0A[    6.=
289611] device: 'ptybd': device_add=0A[    6.290921] PM: Adding info for No=
 Bus:ptybd=0A[    6.291822] device: 'ptybe': device_add=0A[    6.292849] PM=
: Adding info for No Bus:ptybe=0A[    6.293696] device: 'ptybf': device_add=
=0A[    6.294703] PM: Adding info for No Bus:ptybf=0A[    6.295598] device:=
 'ptyc0': device_add=0A[    6.296513] PM: Adding info for No Bus:ptyc0=0A[ =
   6.297384] device: 'ptyc1': device_add=0A[    6.298406] PM: Adding info f=
or No Bus:ptyc1=0A[    6.299267] device: 'ptyc2': device_add=0A[    6.30019=
0] PM: Adding info for No Bus:ptyc2=0A[    6.301096] device: 'ptyc3': devic=
e_add=0A[    6.302030] PM: Adding info for No Bus:ptyc3=0A[    6.303005] de=
vice: 'ptyc4': device_add=0A[    6.303959] PM: Adding info for No Bus:ptyc4=
=0A[    6.304932] device: 'ptyc5': device_add=0A[    6.305911] PM: Adding i=
nfo for No Bus:ptyc5=0A[    6.306855] device: 'ptyc6': device_add=0A[    6.=
307772] PM: Adding info for No Bus:ptyc6=0A[    6.308687] device: 'ptyc7': =
device_add=0A[    6.309620] PM: Adding info for No Bus:ptyc7=0A[    6.31060=
2] device: 'ptyc8': device_add=0A[    6.311432] PM: Adding info for No Bus:=
ptyc8=0A[    6.312352] device: 'ptyc9': device_add=0A[    6.313355] PM: Add=
ing info for No Bus:ptyc9=0A[    6.314322] device: 'ptyca': device_add=0A[ =
   6.315303] PM: Adding info for No Bus:ptyca=0A[    6.316179] device: 'pty=
cb': device_add=0A[    6.317103] PM: Adding info for No Bus:ptycb=0A[    6.=
318031] device: 'ptycc': device_add=0A[    6.318962] PM: Adding info for No=
 Bus:ptycc=0A[    6.319849] device: 'ptycd': device_add=0A[    6.320809] PM=
: Adding info for No Bus:ptycd=0A[    6.321735] device: 'ptyce': device_add=
=0A[    6.322657] PM: Adding info for No Bus:ptyce=0A[    6.323555] device:=
 'ptycf': device_add=0A[    6.324566] PM: Adding info for No Bus:ptycf=0A[ =
   6.325531] device: 'ptyd0': device_add=0A[    6.326454] PM: Adding info f=
or No Bus:ptyd0=0A[    6.327319] device: 'ptyd1': device_add=0A[    6.32822=
7] PM: Adding info for No Bus:ptyd1=0A[    6.329159] device: 'ptyd2': devic=
e_add=0A[    6.330101] PM: Adding info for No Bus:ptyd2=0A[    6.331082] de=
vice: 'ptyd3': device_add=0A[    6.332019] PM: Adding info for No Bus:ptyd3=
=0A[    6.332883] device: 'ptyd4': device_add=0A[    6.333902] PM: Adding i=
nfo for No Bus:ptyd4=0A[    6.334836] device: 'ptyd5': device_add=0A[    6.=
335814] PM: Adding info for No Bus:ptyd5=0A[    6.336726] device: 'ptyd6': =
device_add=0A[    6.337652] PM: Adding info for No Bus:ptyd6=0A[    6.33858=
6] device: 'ptyd7': device_add=0A[    6.339485] PM: Adding info for No Bus:=
ptyd7=0A[    6.340390] device: 'ptyd8': device_add=0A[    6.341212] PM: Add=
ing info for No Bus:ptyd8=0A[    6.342085] device: 'ptyd9': device_add=0A[ =
   6.342929] PM: Adding info for No Bus:ptyd9=0A[    6.343797] device: 'pty=
da': device_add=0A[    6.344950] PM: Adding info for No Bus:ptyda=0A[    6.=
345829] device: 'ptydb': device_add=0A[    6.346781] PM: Adding info for No=
 Bus:ptydb=0A[    6.347604] device: 'ptydc': device_add=0A[    6.348494] PM=
: Adding info for No Bus:ptydc=0A[    6.349343] device: 'ptydd': device_add=
=0A[    6.350244] PM: Adding info for No Bus:ptydd=0A[    6.351128] device:=
 'ptyde': device_add=0A[    6.352002] PM: Adding info for No Bus:ptyde=0A[ =
   6.352834] device: 'ptydf': device_add=0A[    6.353687] PM: Adding info f=
or No Bus:ptydf=0A[    6.354703] device: 'ptye0': device_add=0A[    6.35563=
6] PM: Adding info for No Bus:ptye0=0A[    6.356540] device: 'ptye1': devic=
e_add=0A[    6.357446] PM: Adding info for No Bus:ptye1=0A[    6.358424] de=
vice: 'ptye2': device_add=0A[    6.359353] PM: Adding info for No Bus:ptye2=
=0A[    6.360271] device: 'ptye3': device_add=0A[    6.361203] PM: Adding i=
nfo for No Bus:ptye3=0A[    6.362060] device: 'ptye4': device_add=0A[    6.=
362907] PM: Adding info for No Bus:ptye4=0A[    6.363837] device: 'ptye5': =
device_add=0A[    6.364915] PM: Adding info for No Bus:ptye5=0A[    6.36590=
7] device: 'ptye6': device_add=0A[    6.366837] PM: Adding info for No Bus:=
ptye6=0A[    6.367656] device: 'ptye7': device_add=0A[    6.368580] PM: Add=
ing info for No Bus:ptye7=0A[    6.369556] device: 'ptye8': device_add=0A[ =
   6.370526] PM: Adding info for No Bus:ptye8=0A[    6.371438] device: 'pty=
e9': device_add=0A[    6.372367] PM: Adding info for No Bus:ptye9=0A[    6.=
373228] device: 'ptyea': device_add=0A[    6.374254] PM: Adding info for No=
 Bus:ptyea=0A[    6.375199] device: 'ptyeb': device_add=0A[    6.376132] PM=
: Adding info for No Bus:ptyeb=0A[    6.377038] device: 'ptyec': device_add=
=0A[    6.377916] PM: Adding info for No Bus:ptyec=0A[    6.378803] device:=
 'ptyed': device_add=0A[    6.379656] PM: Adding info for No Bus:ptyed=0A[ =
   6.380536] device: 'ptyee': device_add=0A[    6.381346] PM: Adding info f=
or No Bus:ptyee=0A[    6.382159] device: 'ptyef': device_add=0A[    6.38311=
4] PM: Adding info for No Bus:ptyef=0A[    6.384063] device: 'ttyp0': devic=
e_add=0A[    6.385075] PM: Adding info for No Bus:ttyp0=0A[    6.385916] de=
vice: 'ttyp1': device_add=0A[    6.386799] PM: Adding info for No Bus:ttyp1=
=0A[    6.387662] device: 'ttyp2': device_add=0A[    6.388548] PM: Adding i=
nfo for No Bus:ttyp2=0A[    6.389358] device: 'ttyp3': device_add=0A[    6.=
390292] PM: Adding info for No Bus:ttyp3=0A[    6.391183] device: 'ttyp4': =
device_add=0A[    6.392047] PM: Adding info for No Bus:ttyp4=0A[    6.39292=
8] device: 'ttyp5': device_add=0A[    6.393820] PM: Adding info for No Bus:=
ttyp5=0A[    6.394686] device: 'ttyp6': device_add=0A[    6.395676] PM: Add=
ing info for No Bus:ttyp6=0A[    6.396521] device: 'ttyp7': device_add=0A[ =
   6.397384] PM: Adding info for No Bus:ttyp7=0A[    6.398228] device: 'tty=
p8': device_add=0A[    6.399104] PM: Adding info for No Bus:ttyp8=0A[    6.=
399981] device: 'ttyp9': device_add=0A[    6.400936] PM: Adding info for No=
 Bus:ttyp9=0A[    6.401734] device: 'ttypa': device_add=0A[    6.402596] PM=
: Adding info for No Bus:ttypa=0A[    6.403476] device: 'ttypb': device_add=
=0A[    6.404532] PM: Adding info for No Bus:ttypb=0A[    6.405776] device:=
 'ttypc': device_add=0A[    6.407034] PM: Adding info for No Bus:ttypc=0A[ =
   6.408320] device: 'ttypd': device_add=0A[    6.409584] PM: Adding info f=
or No Bus:ttypd=0A[    6.410792] device: 'ttype': device_add=0A[    6.41206=
1] PM: Adding info for No Bus:ttype=0A[    6.413330] device: 'ttypf': devic=
e_add=0A[    6.414720] PM: Adding info for No Bus:ttypf=0A[    6.416011] de=
vice: 'ttyq0': device_add=0A[    6.417307] PM: Adding info for No Bus:ttyq0=
=0A[    6.418489] device: 'ttyq1': device_add=0A[    6.419907] PM: Adding i=
nfo for No Bus:ttyq1=0A[    6.421152] device: 'ttyq2': device_add=0A[    6.=
422368] PM: Adding info for No Bus:ttyq2=0A[    6.423476] device: 'ttyq3': =
device_add=0A[    6.425032] PM: Adding info for No Bus:ttyq3=0A[    6.42633=
0] device: 'ttyq4': device_add=0A[    6.427649] PM: Adding info for No Bus:=
ttyq4=0A[    6.428858] device: 'ttyq5': device_add=0A[    6.430113] PM: Add=
ing info for No Bus:ttyq5=0A[    6.430971] device: 'ttyq6': device_add=0A[ =
   6.431859] PM: Adding info for No Bus:ttyq6=0A[    6.432725] device: 'tty=
q7': device_add=0A[    6.433609] PM: Adding info for No Bus:ttyq7=0A[    6.=
434532] device: 'ttyq8': device_add=0A[    6.435440] PM: Adding info for No=
 Bus:ttyq8=0A[    6.436335] device: 'ttyq9': device_add=0A[    6.437209] PM=
: Adding info for No Bus:ttyq9=0A[    6.438055] device: 'ttyqa': device_add=
=0A[    6.438936] PM: Adding info for No Bus:ttyqa=0A[    6.439825] device:=
 'ttyqb': device_add=0A[    6.440779] PM: Adding info for No Bus:ttyqb=0A[ =
   6.441571] device: 'ttyqc': device_add=0A[    6.442511] PM: Adding info f=
or No Bus:ttyqc=0A[    6.443392] device: 'ttyqd': device_add=0A[    6.44428=
6] PM: Adding info for No Bus:ttyqd=0A[    6.445429] device: 'ttyqe': devic=
e_add=0A[    6.446734] PM: Adding info for No Bus:ttyqe=0A[    6.448040] de=
vice: 'ttyqf': device_add=0A[    6.449256] PM: Adding info for No Bus:ttyqf=
=0A[    6.450552] device: 'ttyr0': device_add=0A[    6.451871] PM: Adding i=
nfo for No Bus:ttyr0=0A[    6.452957] device: 'ttyr1': device_add=0A[    6.=
453985] PM: Adding info for No Bus:ttyr1=0A[    6.454901] device: 'ttyr2': =
device_add=0A[    6.455834] PM: Adding info for No Bus:ttyr2=0A[    6.45666=
3] device: 'ttyr3': device_add=0A[    6.457535] PM: Adding info for No Bus:=
ttyr3=0A[    6.458429] device: 'ttyr4': device_add=0A[    6.459360] PM: Add=
ing info for No Bus:ttyr4=0A[    6.460218] device: 'ttyr5': device_add=0A[ =
   6.461018] PM: Adding info for No Bus:ttyr5=0A[    6.461911] device: 'tty=
r6': device_add=0A[    6.462788] PM: Adding info for No Bus:ttyr6=0A[    6.=
463669] device: 'ttyr7': device_add=0A[    6.464663] PM: Adding info for No=
 Bus:ttyr7=0A[    6.465549] device: 'ttyr8': device_add=0A[    6.466424] PM=
: Adding info for No Bus:ttyr8=0A[    6.467233] device: 'ttyr9': device_add=
=0A[    6.468180] PM: Adding info for No Bus:ttyr9=0A[    6.468990] device:=
 'ttyra': device_add=0A[    6.469900] PM: Adding info for No Bus:ttyra=0A[ =
   6.470744] device: 'ttyrb': device_add=0A[    6.471628] PM: Adding info f=
or No Bus:ttyrb=0A[    6.472523] device: 'ttyrc': device_add=0A[    6.47340=
7] PM: Adding info for No Bus:ttyrc=0A[    6.474295] device: 'ttyrd': devic=
e_add=0A[    6.475255] PM: Adding info for No Bus:ttyrd=0A[    6.476161] de=
vice: 'ttyre': device_add=0A[    6.477031] PM: Adding info for No Bus:ttyre=
=0A[    6.477883] device: 'ttyrf': device_add=0A[    6.478744] PM: Adding i=
nfo for No Bus:ttyrf=0A[    6.479627] device: 'ttys0': device_add=0A[    6.=
480580] PM: Adding info for No Bus:ttys0=0A[    6.481399] device: 'ttys1': =
device_add=0A[    6.482267] PM: Adding info for No Bus:ttys1=0A[    6.48308=
0] device: 'ttys2': device_add=0A[    6.483964] PM: Adding info for No Bus:=
ttys2=0A[    6.484962] device: 'ttys3': device_add=0A[    6.485965] PM: Add=
ing info for No Bus:ttys3=0A[    6.486880] device: 'ttys4': device_add=0A[ =
   6.487814] PM: Adding info for No Bus:ttys4=0A[    6.488738] device: 'tty=
s5': device_add=0A[    6.489684] PM: Adding info for No Bus:ttys5=0A[    6.=
490583] device: 'ttys6': device_add=0A[    6.491544] PM: Adding info for No=
 Bus:ttys6=0A[    6.492476] device: 'ttys7': device_add=0A[    6.493398] PM=
: Adding info for No Bus:ttys7=0A[    6.494406] device: 'ttys8': device_add=
=0A[    6.495408] PM: Adding info for No Bus:ttys8=0A[    6.496277] device:=
 'ttys9': device_add=0A[    6.497334] PM: Adding info for No Bus:ttys9=0A[ =
   6.498183] device: 'ttysa': device_add=0A[    6.499100] PM: Adding info f=
or No Bus:ttysa=0A[    6.500038] device: 'ttysb': device_add=0A[    6.50098=
6] PM: Adding info for No Bus:ttysb=0A[    6.501936] device: 'ttysc': devic=
e_add=0A[    6.502915] PM: Adding info for No Bus:ttysc=0A[    6.503802] de=
vice: 'ttysd': device_add=0A[    6.504832] PM: Adding info for No Bus:ttysd=
=0A[    6.505900] device: 'ttyse': device_add=0A[    6.506807] PM: Adding i=
nfo for No Bus:ttyse=0A[    6.507642] device: 'ttysf': device_add=0A[    6.=
508608] PM: Adding info for No Bus:ttysf=0A[    6.509518] device: 'ttyt0': =
device_add=0A[    6.510384] PM: Adding info for No Bus:ttyt0=0A[    6.51120=
9] device: 'ttyt1': device_add=0A[    6.512020] PM: Adding info for No Bus:=
ttyt1=0A[    6.512944] device: 'ttyt2': device_add=0A[    6.513934] PM: Add=
ing info for No Bus:ttyt2=0A[    6.514924] device: 'ttyt3': device_add=0A[ =
   6.515866] PM: Adding info for No Bus:ttyt3=0A[    6.516655] device: 'tty=
t4': device_add=0A[    6.517546] PM: Adding info for No Bus:ttyt4=0A[    6.=
518463] device: 'ttyt5': device_add=0A[    6.519399] PM: Adding info for No=
 Bus:ttyt5=0A[    6.520330] device: 'ttyt6': device_add=0A[    6.521243] PM=
: Adding info for No Bus:ttyt6=0A[    6.522091] device: 'ttyt7': device_add=
=0A[    6.523064] PM: Adding info for No Bus:ttyt7=0A[    6.523937] device:=
 'ttyt8': device_add=0A[    6.524966] PM: Adding info for No Bus:ttyt8=0A[ =
   6.525843] device: 'ttyt9': device_add=0A[    6.526703] PM: Adding info f=
or No Bus:ttyt9=0A[    6.527606] device: 'ttyta': device_add=0A[    6.52851=
0] PM: Adding info for No Bus:ttyta=0A[    6.529343] device: 'ttytb': devic=
e_add=0A[    6.530310] PM: Adding info for No Bus:ttytb=0A[    6.531144] de=
vice: 'ttytc': device_add=0A[    6.531968] PM: Adding info for No Bus:ttytc=
=0A[    6.532900] device: 'ttytd': device_add=0A[    6.533814] PM: Adding i=
nfo for No Bus:ttytd=0A[    6.534818] device: 'ttyte': device_add=0A[    6.=
535720] PM: Adding info for No Bus:ttyte=0A[    6.536544] device: 'ttytf': =
device_add=0A[    6.537427] PM: Adding info for No Bus:ttytf=0A[    6.53833=
1] device: 'ttyu0': device_add=0A[    6.539210] PM: Adding info for No Bus:=
ttyu0=0A[    6.540098] device: 'ttyu1': device_add=0A[    6.541043] PM: Add=
ing info for No Bus:ttyu1=0A[    6.541945] device: 'ttyu2': device_add=0A[ =
   6.542835] PM: Adding info for No Bus:ttyu2=0A[    6.543628] device: 'tty=
u3': device_add=0A[    6.544596] PM: Adding info for No Bus:ttyu3=0A[    6.=
545513] device: 'ttyu4': device_add=0A[    6.546493] PM: Adding info for No=
 Bus:ttyu4=0A[    6.547404] device: 'ttyu5': device_add=0A[    6.548294] PM=
: Adding info for No Bus:ttyu5=0A[    6.549111] device: 'ttyu6': device_add=
=0A[    6.550119] PM: Adding info for No Bus:ttyu6=0A[    6.550947] device:=
 'ttyu7': device_add=0A[    6.552087] PM: Adding info for No Bus:ttyu7=0A[ =
   6.552953] device: 'ttyu8': device_add=0A[    6.553793] PM: Adding info f=
or No Bus:ttyu8=0A[    6.554722] device: 'ttyu9': device_add=0A[    6.55559=
8] PM: Adding info for No Bus:ttyu9=0A[    6.556451] device: 'ttyua': devic=
e_add=0A[    6.557386] PM: Adding info for No Bus:ttyua=0A[    6.558278] de=
vice: 'ttyub': device_add=0A[    6.559161] PM: Adding info for No Bus:ttyub=
=0A[    6.559981] device: 'ttyuc': device_add=0A[    6.560866] PM: Adding i=
nfo for No Bus:ttyuc=0A[    6.561742] device: 'ttyud': device_add=0A[    6.=
562663] PM: Adding info for No Bus:ttyud=0A[    6.563518] device: 'ttyue': =
device_add=0A[    6.564476] PM: Adding info for No Bus:ttyue=0A[    6.56536=
8] device: 'ttyuf': device_add=0A[    6.566247] PM: Adding info for No Bus:=
ttyuf=0A[    6.567059] device: 'ttyv0': device_add=0A[    6.567968] PM: Add=
ing info for No Bus:ttyv0=0A[    6.568862] device: 'ttyv1': device_add=0A[ =
   6.569716] PM: Adding info for No Bus:ttyv1=0A[    6.570643] device: 'tty=
v2': device_add=0A[    6.571448] PM: Adding info for No Bus:ttyv2=0A[    6.=
572252] device: 'ttyv3': device_add=0A[    6.573251] PM: Adding info for No=
 Bus:ttyv3=0A[    6.574094] device: 'ttyv4': device_add=0A[    6.575037] PM=
: Adding info for No Bus:ttyv4=0A[    6.575950] device: 'ttyv5': device_add=
=0A[    6.576838] PM: Adding info for No Bus:ttyv5=0A[    6.577700] device:=
 'ttyv6': device_add=0A[    6.578621] PM: Adding info for No Bus:ttyv6=0A[ =
   6.579430] device: 'ttyv7': device_add=0A[    6.580314] PM: Adding info f=
or No Bus:ttyv7=0A[    6.581209] device: 'ttyv8': device_add=0A[    6.58208=
2] PM: Adding info for No Bus:ttyv8=0A[    6.582925] device: 'ttyv9': devic=
e_add=0A[    6.583862] PM: Adding info for No Bus:ttyv9=0A[    6.584845] de=
vice: 'ttyva': device_add=0A[    6.585707] PM: Adding info for No Bus:ttyva=
=0A[    6.586519] device: 'ttyvb': device_add=0A[    6.587384] PM: Adding i=
nfo for No Bus:ttyvb=0A[    6.588271] device: 'ttyvc': device_add=0A[    6.=
589179] PM: Adding info for No Bus:ttyvc=0A[    6.590114] device: 'ttyvd': =
device_add=0A[    6.590918] PM: Adding info for No Bus:ttyvd=0A[    6.59171=
3] device: 'ttyve': device_add=0A[    6.592509] PM: Adding info for No Bus:=
ttyve=0A[    6.593464] device: 'ttyvf': device_add=0A[    6.594453] PM: Add=
ing info for No Bus:ttyvf=0A[    6.595301] device: 'ttyw0': device_add=0A[ =
   6.596178] PM: Adding info for No Bus:ttyw0=0A[    6.597062] device: 'tty=
w1': device_add=0A[    6.597937] PM: Adding info for No Bus:ttyw1=0A[    6.=
598727] device: 'ttyw2': device_add=0A[    6.599640] PM: Adding info for No=
 Bus:ttyw2=0A[    6.600558] device: 'ttyw3': device_add=0A[    6.601426] PM=
: Adding info for No Bus:ttyw3=0A[    6.602307] device: 'ttyw4': device_add=
=0A[    6.603186] PM: Adding info for No Bus:ttyw4=0A[    6.604103] device:=
 'ttyw5': device_add=0A[    6.605420] PM: Adding info for No Bus:ttyw5=0A[ =
   6.606385] device: 'ttyw6': device_add=0A[    6.607261] PM: Adding info f=
or No Bus:ttyw6=0A[    6.608131] device: 'ttyw7': device_add=0A[    6.60911=
9] PM: Adding info for No Bus:ttyw7=0A[    6.610047] device: 'ttyw8': devic=
e_add=0A[    6.611001] PM: Adding info for No Bus:ttyw8=0A[    6.611815] de=
vice: 'ttyw9': device_add=0A[    6.612663] PM: Adding info for No Bus:ttyw9=
=0A[    6.613551] device: 'ttywa': device_add=0A[    6.614607] PM: Adding i=
nfo for No Bus:ttywa=0A[    6.615481] device: 'ttywb': device_add=0A[    6.=
616412] PM: Adding info for No Bus:ttywb=0A[    6.617302] device: 'ttywc': =
device_add=0A[    6.618210] PM: Adding info for No Bus:ttywc=0A[    6.61902=
3] device: 'ttywd': device_add=0A[    6.619899] PM: Adding info for No Bus:=
ttywd=0A[    6.620790] device: 'ttywe': device_add=0A[    6.621608] PM: Add=
ing info for No Bus:ttywe=0A[    6.622575] device: 'ttywf': device_add=0A[ =
   6.623459] PM: Adding info for No Bus:ttywf=0A[    6.624444] device: 'tty=
x0': device_add=0A[    6.625342] PM: Adding info for No Bus:ttyx0=0A[    6.=
626236] device: 'ttyx1': device_add=0A[    6.627160] PM: Adding info for No=
 Bus:ttyx1=0A[    6.628072] device: 'ttyx2': device_add=0A[    6.628960] PM=
: Adding info for No Bus:ttyx2=0A[    6.629770] device: 'ttyx3': device_add=
=0A[    6.630733] PM: Adding info for No Bus:ttyx3=0A[    6.631572] device:=
 'ttyx4': device_add=0A[    6.632489] PM: Adding info for No Bus:ttyx4=0A[ =
   6.633344] device: 'ttyx5': device_add=0A[    6.634353] PM: Adding info f=
or No Bus:ttyx5=0A[    6.635364] device: 'ttyx6': device_add=0A[    6.63637=
6] PM: Adding info for No Bus:ttyx6=0A[    6.637198] device: 'ttyx7': devic=
e_add=0A[    6.638135] PM: Adding info for No Bus:ttyx7=0A[    6.639076] de=
vice: 'ttyx8': device_add=0A[    6.640000] PM: Adding info for No Bus:ttyx8=
=0A[    6.640917] device: 'ttyx9': device_add=0A[    6.641697] PM: Adding i=
nfo for No Bus:ttyx9=0A[    6.642490] device: 'ttyxa': device_add=0A[    6.=
643476] PM: Adding info for No Bus:ttyxa=0A[    6.644434] device: 'ttyxb': =
device_add=0A[    6.645339] PM: Adding info for No Bus:ttyxb=0A[    6.64627=
7] device: 'ttyxc': device_add=0A[    6.647162] PM: Adding info for No Bus:=
ttyxc=0A[    6.648041] device: 'ttyxd': device_add=0A[    6.648974] PM: Add=
ing info for No Bus:ttyxd=0A[    6.649865] device: 'ttyxe': device_add=0A[ =
   6.650808] PM: Adding info for No Bus:ttyxe=0A[    6.651602] device: 'tty=
xf': device_add=0A[    6.652474] PM: Adding info for No Bus:ttyxf=0A[    6.=
653376] device: 'ttyy0': device_add=0A[    6.654481] PM: Adding info for No=
 Bus:ttyy0=0A[    6.655397] device: 'ttyy1': device_add=0A[    6.656277] PM=
: Adding info for No Bus:ttyy1=0A[    6.657082] device: 'ttyy2': device_add=
=0A[    6.658054] PM: Adding info for No Bus:ttyy2=0A[    6.658873] device:=
 'ttyy3': device_add=0A[    6.659785] PM: Adding info for No Bus:ttyy3=0A[ =
   6.660624] device: 'ttyy4': device_add=0A[    6.661460] PM: Adding info f=
or No Bus:ttyy4=0A[    6.662305] device: 'ttyy5': device_add=0A[    6.66326=
7] PM: Adding info for No Bus:ttyy5=0A[    6.664199] device: 'ttyy6': devic=
e_add=0A[    6.665229] PM: Adding info for No Bus:ttyy6=0A[    6.666287] de=
vice: 'ttyy7': device_add=0A[    6.667159] PM: Adding info for No Bus:ttyy7=
=0A[    6.668062] device: 'ttyy8': device_add=0A[    6.668973] PM: Adding i=
nfo for No Bus:ttyy8=0A[    6.669920] device: 'ttyy9': device_add=0A[    6.=
670893] PM: Adding info for No Bus:ttyy9=0A[    6.671682] device: 'ttyya': =
device_add=0A[    6.672546] PM: Adding info for No Bus:ttyya=0A[    6.67344=
5] device: 'ttyyb': device_add=0A[    6.674498] PM: Adding info for No Bus:=
ttyyb=0A[    6.675400] device: 'ttyyc': device_add=0A[    6.676329] PM: Add=
ing info for No Bus:ttyyc=0A[    6.677155] device: 'ttyyd': device_add=0A[ =
   6.678144] PM: Adding info for No Bus:ttyyd=0A[    6.678960] device: 'tty=
ye': device_add=0A[    6.679836] PM: Adding info for No Bus:ttyye=0A[    6.=
680795] device: 'ttyyf': device_add=0A[    6.681619] PM: Adding info for No=
 Bus:ttyyf=0A[    6.682582] device: 'ttyz0': device_add=0A[    6.683465] PM=
: Adding info for No Bus:ttyz0=0A[    6.684453] device: 'ttyz1': device_add=
=0A[    6.685353] PM: Adding info for No Bus:ttyz1=0A[    6.686241] device:=
 'ttyz2': device_add=0A[    6.687163] PM: Adding info for No Bus:ttyz2=0A[ =
   6.688044] device: 'ttyz3': device_add=0A[    6.688934] PM: Adding info f=
or No Bus:ttyz3=0A[    6.689828] device: 'ttyz4': device_add=0A[    6.69072=
2] PM: Adding info for No Bus:ttyz4=0A[    6.691565] device: 'ttyz5': devic=
e_add=0A[    6.692491] PM: Adding info for No Bus:ttyz5=0A[    6.693397] de=
vice: 'ttyz6': device_add=0A[    6.694453] PM: Adding info for No Bus:ttyz6=
=0A[    6.695406] device: 'ttyz7': device_add=0A[    6.696414] PM: Adding i=
nfo for No Bus:ttyz7=0A[    6.697226] device: 'ttyz8': device_add=0A[    6.=
698249] PM: Adding info for No Bus:ttyz8=0A[    6.699111] device: 'ttyz9': =
device_add=0A[    6.700044] PM: Adding info for No Bus:ttyz9=0A[    6.70094=
2] device: 'ttyza': device_add=0A[    6.701831] PM: Adding info for No Bus:=
ttyza=0A[    6.702726] device: 'ttyzb': device_add=0A[    6.703804] PM: Add=
ing info for No Bus:ttyzb=0A[    6.704856] device: 'ttyzc': device_add=0A[ =
   6.706244] PM: Adding info for No Bus:ttyzc=0A[    6.707396] device: 'tty=
zd': device_add=0A[    6.708314] PM: Adding info for No Bus:ttyzd=0A[    6.=
709197] device: 'ttyze': device_add=0A[    6.710289] PM: Adding info for No=
 Bus:ttyze=0A[    6.711166] device: 'ttyzf': device_add=0A[    6.711989] PM=
: Adding info for No Bus:ttyzf=0A[    6.712919] device: 'ttya0': device_add=
=0A[    6.713880] PM: Adding info for No Bus:ttya0=0A[    6.714990] device:=
 'ttya1': device_add=0A[    6.715919] PM: Adding info for No Bus:ttya1=0A[ =
   6.716828] device: 'ttya2': device_add=0A[    6.717717] PM: Adding info f=
or No Bus:ttya2=0A[    6.718555] device: 'ttya3': device_add=0A[    6.71951=
7] PM: Adding info for No Bus:ttya3=0A[    6.720375] device: 'ttya4': devic=
e_add=0A[    6.721371] PM: Adding info for No Bus:ttya4=0A[    6.722247] de=
vice: 'ttya5': device_add=0A[    6.723151] PM: Adding info for No Bus:ttya5=
=0A[    6.724209] device: 'ttya6': device_add=0A[    6.725234] PM: Adding i=
nfo for No Bus:ttya6=0A[    6.726220] device: 'ttya7': device_add=0A[    6.=
727156] PM: Adding info for No Bus:ttya7=0A[    6.728093] device: 'ttya8': =
device_add=0A[    6.729044] PM: Adding info for No Bus:ttya8=0A[    6.72991=
8] device: 'ttya9': device_add=0A[    6.730920] PM: Adding info for No Bus:=
ttya9=0A[    6.731742] device: 'ttyaa': device_add=0A[    6.732588] PM: Add=
ing info for No Bus:ttyaa=0A[    6.733414] device: 'ttyab': device_add=0A[ =
   6.734572] PM: Adding info for No Bus:ttyab=0A[    6.735497] device: 'tty=
ac': device_add=0A[    6.736380] PM: Adding info for No Bus:ttyac=0A[    6.=
737250] device: 'ttyad': device_add=0A[    6.738214] PM: Adding info for No=
 Bus:ttyad=0A[    6.739121] device: 'ttyae': device_add=0A[    6.740056] PM=
: Adding info for No Bus:ttyae=0A[    6.740928] device: 'ttyaf': device_add=
=0A[    6.741828] PM: Adding info for No Bus:ttyaf=0A[    6.742711] device:=
 'ttyb0': device_add=0A[    6.743641] PM: Adding info for No Bus:ttyb0=0A[ =
   6.744812] device: 'ttyb1': device_add=0A[    6.745693] PM: Adding info f=
or No Bus:ttyb1=0A[    6.746509] device: 'ttyb2': device_add=0A[    6.74749=
9] PM: Adding info for No Bus:ttyb2=0A[    6.748349] device: 'ttyb3': devic=
e_add=0A[    6.749276] PM: Adding info for No Bus:ttyb3=0A[    6.750158] de=
vice: 'ttyb4': device_add=0A[    6.751022] PM: Adding info for No Bus:ttyb4=
=0A[    6.751957] device: 'ttyb5': device_add=0A[    6.752859] PM: Adding i=
nfo for No Bus:ttyb5=0A[    6.753675] device: 'ttyb6': device_add=0A[    6.=
754893] PM: Adding info for No Bus:ttyb6=0A[    6.756025] device: 'ttyb7': =
device_add=0A[    6.756917] PM: Adding info for No Bus:ttyb7=0A[    6.75780=
2] device: 'ttyb8': device_add=0A[    6.758821] PM: Adding info for No Bus:=
ttyb8=0A[    6.759722] device: 'ttyb9': device_add=0A[    6.760738] PM: Add=
ing info for No Bus:ttyb9=0A[    6.761604] device: 'ttyba': device_add=0A[ =
   6.762500] PM: Adding info for No Bus:ttyba=0A[    6.763418] device: 'tty=
bb': device_add=0A[    6.764502] PM: Adding info for No Bus:ttybb=0A[    6.=
765440] device: 'ttybc': device_add=0A[    6.766387] PM: Adding info for No=
 Bus:ttybc=0A[    6.767239] device: 'ttybd': device_add=0A[    6.768236] PM=
: Adding info for No Bus:ttybd=0A[    6.769073] device: 'ttybe': device_add=
=0A[    6.769967] PM: Adding info for No Bus:ttybe=0A[    6.770908] device:=
 'ttybf': device_add=0A[    6.771730] PM: Adding info for No Bus:ttybf=0A[ =
   6.772591] device: 'ttyc0': device_add=0A[    6.773484] PM: Adding info f=
or No Bus:ttyc0=0A[    6.774609] device: 'ttyc1': device_add=0A[    6.77552=
6] PM: Adding info for No Bus:ttyc1=0A[    6.776347] device: 'ttyc2': devic=
e_add=0A[    6.777266] PM: Adding info for No Bus:ttyc2=0A[    6.778189] de=
vice: 'ttyc3': device_add=0A[    6.779066] PM: Adding info for No Bus:ttyc3=
=0A[    6.779960] device: 'ttyc4': device_add=0A[    6.780895] PM: Adding i=
nfo for No Bus:ttyc4=0A[    6.781716] device: 'ttyc5': device_add=0A[    6.=
782720] PM: Adding info for No Bus:ttyc5=0A[    6.783556] device: 'ttyc6': =
device_add=0A[    6.784641] PM: Adding info for No Bus:ttyc6=0A[    6.78561=
8] device: 'ttyc7': device_add=0A[    6.786591] PM: Adding info for No Bus:=
ttyc7=0A[    6.787521] device: 'ttyc8': device_add=0A[    6.788491] PM: Add=
ing info for No Bus:ttyc8=0A[    6.789340] device: 'ttyc9': device_add=0A[ =
   6.790201] PM: Adding info for No Bus:ttyc9=0A[    6.791036] device: 'tty=
ca': device_add=0A[    6.791998] PM: Adding info for No Bus:ttyca=0A[    6.=
792861] device: 'ttycb': device_add=0A[    6.793835] PM: Adding info for No=
 Bus:ttycb=0A[    6.794939] device: 'ttycc': device_add=0A[    6.795827] PM=
: Adding info for No Bus:ttycc=0A[    6.796647] device: 'ttycd': device_add=
=0A[    6.797526] PM: Adding info for No Bus:ttycd=0A[    6.798437] device:=
 'ttyce': device_add=0A[    6.799375] PM: Adding info for No Bus:ttyce=0A[ =
   6.800307] device: 'ttycf': device_add=0A[    6.801196] PM: Adding info f=
or No Bus:ttycf=0A[    6.802028] device: 'ttyd0': device_add=0A[    6.80319=
9] PM: Adding info for No Bus:ttyd0=0A[    6.804170] device: 'ttyd1': devic=
e_add=0A[    6.805144] PM: Adding info for No Bus:ttyd1=0A[    6.805993] de=
vice: 'ttyd2': device_add=0A[    6.806885] PM: Adding info for No Bus:ttyd2=
=0A[    6.807676] device: 'ttyd3': device_add=0A[    6.808625] PM: Adding i=
nfo for No Bus:ttyd3=0A[    6.809440] device: 'ttyd4': device_add=0A[    6.=
810382] PM: Adding info for No Bus:ttyd4=0A[    6.811196] device: 'ttyd5': =
device_add=0A[    6.812144] PM: Adding info for No Bus:ttyd5=0A[    6.81304=
6] device: 'ttyd6': device_add=0A[    6.814025] PM: Adding info for No Bus:=
ttyd6=0A[    6.815015] device: 'ttyd7': device_add=0A[    6.816128] PM: Add=
ing info for No Bus:ttyd7=0A[    6.817038] device: 'ttyd8': device_add=0A[ =
   6.817921] PM: Adding info for No Bus:ttyd8=0A[    6.818818] device: 'tty=
d9': device_add=0A[    6.819716] PM: Adding info for No Bus:ttyd9=0A[    6.=
820643] device: 'ttyda': device_add=0A[    6.821584] PM: Adding info for No=
 Bus:ttyda=0A[    6.822419] device: 'ttydb': device_add=0A[    6.823670] PM=
: Adding info for No Bus:ttydb=0A[    6.825012] device: 'ttydc': device_add=
=0A[    6.826349] PM: Adding info for No Bus:ttydc=0A[    6.827638] device:=
 'ttydd': device_add=0A[    6.829032] PM: Adding info for No Bus:ttydd=0A[ =
   6.830264] device: 'ttyde': device_add=0A[    6.831415] PM: Adding info f=
or No Bus:ttyde=0A[    6.832552] device: 'ttydf': device_add=0A[    6.83373=
6] PM: Adding info for No Bus:ttydf=0A[    6.835276] device: 'ttye0': devic=
e_add=0A[    6.836641] PM: Adding info for No Bus:ttye0=0A[    6.837833] de=
vice: 'ttye1': device_add=0A[    6.839076] PM: Adding info for No Bus:ttye1=
=0A[    6.840412] device: 'ttye2': device_add=0A[    6.841705] PM: Adding i=
nfo for No Bus:ttye2=0A[    6.843013] device: 'ttye3': device_add=0A[    6.=
844454] PM: Adding info for No Bus:ttye3=0A[    6.845854] device: 'ttye4': =
device_add=0A[    6.846897] PM: Adding info for No Bus:ttye4=0A[    6.84770=
4] device: 'ttye5': device_add=0A[    6.848644] PM: Adding info for No Bus:=
ttye5=0A[    6.849558] device: 'ttye6': device_add=0A[    6.850518] PM: Add=
ing info for No Bus:ttye6=0A[    6.851352] device: 'ttye7': device_add=0A[ =
   6.852245] PM: Adding info for No Bus:ttye7=0A[    6.853158] device: 'tty=
e8': device_add=0A[    6.854093] PM: Adding info for No Bus:ttye8=0A[    6.=
855095] device: 'ttye9': device_add=0A[    6.856045] PM: Adding info for No=
 Bus:ttye9=0A[    6.856885] device: 'ttyea': device_add=0A[    6.857774] PM=
: Adding info for No Bus:ttyea=0A[    6.858659] device: 'ttyeb': device_add=
=0A[    6.859551] PM: Adding info for No Bus:ttyeb=0A[    6.860484] device:=
 'ttyec': device_add=0A[    6.861433] PM: Adding info for No Bus:ttyec=0A[ =
   6.862256] device: 'ttyed': device_add=0A[    6.863226] PM: Adding info f=
or No Bus:ttyed=0A[    6.864093] device: 'ttyee': device_add=0A[    6.86509=
6] PM: Adding info for No Bus:ttyee=0A[    6.865969] device: 'ttyef': devic=
e_add=0A[    6.866909] PM: Adding info for No Bus:ttyef=0A[    6.867944] de=
vice: 'ptmx': device_add=0A[    6.868817] PM: Adding info for No Bus:ptmx=
=0A[    6.869583] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled=
=0A[    6.870803] Registering platform device 'serial8250'. Parent at platf=
orm=0A[    6.871978] device: 'serial8250': device_add=0A[    6.872747] bus:=
 'platform': add device serial8250=0A[    6.873656] PM: Adding info for pla=
tform:serial8250=0A=FF[    7.170439] serial8250: ttyS0 at I/O 0x3f8 (irq =
=3D 4) is a 16550A=0A[    7.172010] device: 'ttyS0': device_add=0A[    7.17=
3924] PM: Adding info for No Bus:ttyS0=0A[    7.175545] device: 'ttyS1': de=
vice_add=0A[    7.176966] PM: Adding info for No Bus:ttyS1=0A[    7.178494]=
 device: 'ttyS2': device_add=0A[    7.179838] PM: Adding info for No Bus:tt=
yS2=0A[    7.181515] device: 'ttyS3': device_add=0A[    7.182829] PM: Addin=
g info for No Bus:ttyS3=0A[    7.184191] bus: 'platform': add driver serial=
8250=0A[    7.185460] bus: 'platform': driver_probe_device: matched device =
serial8250 with driver serial8250=0A[    7.187658] bus: 'platform': really_=
probe: probing driver serial8250 with device serial8250=0A[    7.189988] dr=
iver: 'serial8250': driver_bound: bound to device 'serial8250'=0A[    7.191=
815] bus: 'platform': really_probe: bound device serial8250 to driver seria=
l8250=0A[    7.193980] bus: 'pnp': add driver tpm_tis=0A[    7.195435] bus:=
 'pnp': add driver i8042 kbd=0A[    7.196358] bus: 'pnp': driver_probe_devi=
ce: matched device 00:02 with driver i8042 kbd=0A[    7.197825] bus: 'pnp':=
 really_probe: probing driver i8042 kbd with device 00:02=0A[    7.199314] =
driver: '00:02': driver_bound: bound to device 'i8042 kbd'=0A[    7.200689]=
 bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd=0A[    7.=
202471] bus: 'pnp': add driver i8042 aux=0A[    7.203645] bus: 'pnp': drive=
r_probe_device: matched device 00:03 with driver i8042 aux=0A[    7.205807]=
 bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03=0A[  =
  7.208014] driver: '00:03': driver_bound: bound to device 'i8042 aux'=0A[ =
   7.209591] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 a=
ux=0A[    7.211453] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] a=
t 0x60,0x64 irq 1,12=0A[    7.213449] Registering platform device 'i8042'. =
Parent at platform=0A[    7.215290] device: 'i8042': device_add=0A[    7.21=
6254] bus: 'platform': add device i8042=0A[    7.217155] PM: Adding info fo=
r platform:i8042=0A[    7.218199] bus: 'platform': add driver i8042=0A[    =
7.219327] bus: 'platform': driver_probe_device: matched device i8042 with d=
river i8042=0A[    7.220915] bus: 'platform': really_probe: probing driver =
i8042 with device i8042=0A[    7.223547] serio: i8042 KBD port at 0x60,0x64=
 irq 1=0A[    7.224816] device: 'serio0': device_add=0A[    7.225880] bus: =
'serio': add device serio0=0A[    7.226858] PM: Adding info for serio:serio=
0=0A[    7.227720] serio: i8042 AUX port at 0x60,0x64 irq 12=0A[    7.22871=
2] device: 'serio1': device_add=0A[    7.229635] bus: 'serio': add device s=
erio1=0A[    7.230631] PM: Adding info for serio:serio1=0A[    7.231522] dr=
iver: 'i8042': driver_bound: bound to device 'i8042'=0A[    7.232696] bus: =
'platform': really_probe: bound device i8042 to driver i8042=0A[    7.23419=
5] bus: 'serio': add driver atkbd=0A[    7.235317] bus: 'serio': driver_pro=
be_device: matched device serio0 with driver atkbd=0A[    7.236950] bus: 's=
erio': really_probe: probing driver atkbd with device serio0=0A[    7.23889=
0] device: 'input0': device_add=0A[    7.240446] PM: Adding info for No Bus=
:input0=0A[    7.241468] input: AT Translated Set 2 keyboard as /devices/pl=
atform/i8042/serio0/input/input0=0A[    7.243086] driver: 'serio0': driver_=
bound: bound to device 'atkbd'=0A[    7.244377] bus: 'serio': really_probe:=
 bound device serio0 to driver atkbd=0A[    7.245741] bus: 'serio': driver_=
probe_device: matched device serio1 with driver atkbd=0A[    7.247196] bus:=
 'serio': really_probe: probing driver atkbd with device serio1=0A[    7.24=
8840] atkbd: probe of serio1 rejects match -19=0A[    7.249781] cpuidle: us=
ing governor ladder=0A[    7.251038] =0A[    7.251038] printing PIC content=
s=0A[    7.251957] ... PIC  IMR: ffff=0A[    7.252531] ... PIC  IRR: 1013=
=0A[    7.253115] ... PIC  ISR: 0000=0A[    7.253718] ... PIC ELCR: 0c00=0A=
[    7.254432] printing local APIC contents on CPU#0/0:=0A[    7.255702] ..=
=2E APIC ID:      00000000 (0)=0A[    7.256731] ... APIC VERSION: 00050014=
=0A[    7.257679] ... APIC TASKPRI: 00000000 (00)=0A[    7.258720] ... APIC=
 PROCPRI: 00000000=0A[    7.259659] ... APIC LDR: 01000000=0A[    7.260035]=
 ... APIC DFR: ffffffff=0A[    7.260035] ... APIC SPIV: 000001ff=0A[    7.2=
60035] ... APIC ISR field:=0A[    7.260035] 0000000000000000000000000000000=
000000000000000000000000000000000=0A[    7.260035] ... APIC TMR field:=0A[ =
   7.260035] 00000000000000000000000000000000000000000000000000000000000000=
00=0A[    7.260035] ... APIC IRR field:=0A[    7.260035] 000000000000000000=
0000000000000000000000000000000000000000008000=0A[    7.260035] ... APIC ES=
R: 00000000=0A[    7.260035] ... APIC ICR: 000008fd=0A[    7.260035] ... AP=
IC ICR2: 02000000=0A[    7.260035] ... APIC LVTT: 000000ef=0A[    7.260035]=
 ... APIC LVTPC: 00010000=0A[    7.260035] ... APIC LVT0: 00010700=0A[    7=
=2E260035] ... APIC LVT1: 00000400=0A[    7.260035] ... APIC LVTERR: 000000=
fe=0A[    7.260035] ... APIC TMICT: 00097fc1=0A[    7.260035] ... APIC TMCC=
T: 00000000=0A[    7.260035] ... APIC TDCR: 00000003=0A[    7.260035] =0A[ =
   7.281811] number of MP IRQ sources: 15.=0A[    7.282572] number of IO-AP=
IC #2 registers: 24.=0A[    7.283414] testing the IO APIC..................=
=2E....=0A[    7.284533] =0A[    7.284847] IO APIC #2......=0A[    7.285384=
] .... register #00: 00000000=0A[    7.286106] .......    : physical APIC i=
d: 00=0A[    7.286926] .......    : Delivery Type: 0=0A[    7.287708] .....=
=2E.    : LTS          : 0=0A[    7.288460] .... register #01: 00170011=0A[=
    7.289188] .......     : max redirection entries: 17=0A[    7.290182] ..=
=2E....     : PRQ implemented: 0=0A[    7.291043] .......     : IO APIC ver=
sion: 11=0A[    7.291876] .... register #02: 00000000=0A[    7.292595] ....=
=2E..     : arbitration: 00=0A[    7.293348] .... IRQ redirection table:=0A=
[    7.294102]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:=0A[    7.2953=
82]  00 00  1    0    0   0   0    0    0    00=0A[    7.296560]  01 03  0 =
   0    0   0   0    1    1    31=0A[    7.297668]  02 03  0    0    0   0 =
  0    1    1    30=0A[    7.298716]  03 03  1    0    0   0   0    1    1 =
   33=0A[    7.299823]  04 03  1    0    0   0   0    1    1    34=0A[    7=
=2E300905]  05 03  1    1    0   0   0    1    1    35=0A[    7.301939]  06=
 03  1    0    0   0   0    1    1    36=0A[    7.302973]  07 03  1    0   =
 0   0   0    1    1    37=0A[    7.304021]  08 03  1    0    0   0   0    =
1    1    38=0A[    7.305148]  09 03  0    1    0   0   0    1    1    39=
=0A[    7.306161]  0a 03  1    1    0   0   0    1    1    3A=0A[    7.3071=
84]  0b 03  1    1    0   0   0    1    1    3B=0A[    7.308198]  0c 03  0 =
   0    0   0   0    1    1    3C=0A[    7.309210]  0d 03  1    0    0   0 =
  0    1    1    3D=0A[    7.310289]  0e 03  1    0    0   0   0    1    1 =
   3E=0A[    7.311313]  0f 03  1    0    0   0   0    1    1    3F=0A[    7=
=2E312340]  10 00  1    0    0   0   0    0    0    00=0A[    7.313348]  11=
 00  1    0    0   0   0    0    0    00=0A[    7.314481]  12 00  1    0   =
 0   0   0    0    0    00=0A[    7.315504]  13 00  1    0    0   0   0    =
0    0    00=0A[    7.316523]  14 00  1    0    0   0   0    0    0    00=
=0A[    7.317547]  15 00  1    0    0   0   0    0    0    00=0A[    7.3185=
78]  16 00  1    0    0   0   0    0    0    00=0A[    7.319590]  17 00  1 =
   0    0   0   0    0    0    00=0A[    7.320639] IRQ to pin mappings:=0A[=
    7.321250] IRQ0 -> 0:2=0A[    7.321806] IRQ1 -> 0:1=0A[    7.322321] IRQ=
3 -> 0:3=0A[    7.322846] IRQ4 -> 0:4=0A[    7.323356] IRQ5 -> 0:5=0A[    7=
=2E323911] IRQ6 -> 0:6=0A[    7.324567] IRQ7 -> 0:7=0A[    7.325104] IRQ8 -=
> 0:8=0A[    7.325690] IRQ9 -> 0:9=0A[    7.326314] IRQ10 -> 0:10=0A[    7.=
326940] IRQ11 -> 0:11=0A[    7.327518] IRQ12 -> 0:12=0A[    7.328117] IRQ13=
 -> 0:13=0A[    7.328727] IRQ14 -> 0:14=0A[    7.329310] IRQ15 -> 0:15=0A[ =
   7.329902] .................................... done.=0A[    7.331133] de=
vice: 'cpu_dma_latency': device_add=0A[    7.332584] PM: Adding info for No=
 Bus:cpu_dma_latency=0A[    7.333668] device: 'network_latency': device_add=
=0A[    7.334998] PM: Adding info for No Bus:network_latency=0A[    7.33615=
1] device: 'network_throughput': device_add=0A[    7.337299] PM: Adding inf=
o for No Bus:network_throughput=0A[    7.338647] registered taskstats versi=
on 1=0A[    7.339410] Running tests on trace events:=0A[    7.340221] Testi=
ng event kfree_skb: OK=0A[    7.380657] Testing event consume_skb: OK=0A[  =
  7.420524] Testing event skb_copy_datagram_iovec: OK=0A[    7.460528] Test=
ing event net_dev_xmit: OK=0A[    7.500701] Testing event net_dev_queue: OK=
=0A[    7.550483] Testing event netif_receive_skb: OK=0A[    7.590480] Test=
ing event netif_rx: OK=0A[    7.630517] Testing event napi_poll: OK=0A[    =
7.670575] Testing event sock_rcvqueue_full: OK=0A[    7.710792] Testing eve=
nt sock_exceed_buf_limit: OK=0A[    7.750603] Testing event udp_fail_queue_=
rcv_skb: OK=0A[    7.790593] Testing event regmap_reg_write: OK=0A[    7.83=
0493] Testing event regmap_reg_read: OK=0A[    7.870544] Testing event regm=
ap_reg_read_cache: OK=0A[    7.910536] Testing event regmap_hw_read_start: =
OK=0A[    7.950445] Testing event regmap_hw_read_done: OK=0A[    7.990647] =
Testing event regmap_hw_write_start: OK=0A[    8.030602] Testing event regm=
ap_hw_write_done: OK=0A[    8.070581] Testing event regcache_sync: OK=0A[  =
  8.110784] Testing event regmap_cache_only: OK=0A[    8.150490] Testing ev=
ent regmap_cache_bypass: OK=0A[    8.190556] Testing event regulator_enable=
: OK=0A[    8.230542] Testing event regulator_enable_delay: OK=0A[    8.270=
510] Testing event regulator_enable_complete: OK=0A[    8.310461] Testing e=
vent regulator_disable: OK=0A[    8.350511] Testing event regulator_disable=
_complete: OK=0A[    8.390565] Testing event regulator_set_voltage: OK=0A[ =
   8.440431] Testing event regulator_set_voltage_complete: OK=0A[    8.4806=
10] Testing event gpio_direction: OK=0A[    8.530589] Testing event gpio_va=
lue: OK=0A[    8.570649] Testing event block_rq_abort: OK=0A[    8.610478] =
Testing event block_rq_requeue: OK=0A[    8.650553] Testing event block_rq_=
complete: OK=0A[    8.690521] Testing event block_rq_insert: OK=0A[    8.73=
0496] Testing event block_rq_issue: OK=0A[    8.770621] Testing event block=
_bio_bounce: OK=0A[    8.810611] Testing event block_bio_complete: OK=0A[  =
  8.850463] Testing event block_bio_backmerge: OK=0A[    8.890639] Testing =
event block_bio_frontmerge: OK=0A[    8.930616] Testing event block_bio_que=
ue: OK=0A[    8.970514] Testing event block_getrq: OK=0A[    9.010605] Test=
ing event block_sleeprq: OK=0A[    9.050528] Testing event block_plug: OK=
=0A[    9.090569] Testing event block_unplug: OK=0A[    9.130550] Testing e=
vent block_split: OK=0A[    9.170515] Testing event block_bio_remap: OK=0A[=
    9.210549] Testing event block_rq_remap: OK=0A[    9.250546] Testing eve=
nt writeback_nothread: OK=0A[    9.290634] Testing event writeback_queue: O=
K=0A[    9.330567] Testing event writeback_exec: OK=0A[    9.370670] Testin=
g event writeback_start: OK=0A[    9.411038] Testing event writeback_writte=
n: OK=0A[    9.450602] Testing event writeback_wait: OK=0A[    9.490568] Te=
sting event writeback_pages_written: OK=0A[    9.530697] Testing event writ=
eback_nowork: OK=0A[    9.570557] Testing event writeback_wake_background: =
OK=0A[    9.610596] Testing event writeback_wake_thread: OK=0A[    9.650655=
] Testing event writeback_wake_forker_thread: OK=0A[    9.690616] Testing e=
vent writeback_bdi_register: OK=0A[    9.730687] Testing event writeback_bd=
i_unregister: OK=0A[    9.770599] Testing event writeback_thread_start: OK=
=0A[    9.810668] Testing event writeback_thread_stop: OK=0A[    9.850632] =
Testing event wbc_writepage: OK=0A[    9.890617] Testing event writeback_qu=
eue_io: OK=0A[    9.930515] Testing event global_dirty_state:=20
--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.5.0-rc5+"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.5.0-rc5 Kernel Configuration
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
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
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
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
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
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
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
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
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
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
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
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
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
# CONFIG_PARAVIRT_SPINLOCKS is not set
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
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
CONFIG_SPARSEMEM_VMEMMAP=y
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
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
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
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
# CONFIG_ACPI_PCI_SLOT is not set
# CONFIG_X86_PM_TIMER is not set
CONFIG_ACPI_CONTAINER=m
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=m
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_XEN_PCIDEV_FRONTEND=m
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=m
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_NET_DSA=m
CONFIG_NET_DSA_TAG_DSA=y
# CONFIG_NET_DSA_TAG_EDSA is not set
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=m
CONFIG_LAPB=m
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=m
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=m
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=m
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=m
CONFIG_NET_9P=m
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
# CONFIG_NFC is not set
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
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_PARIDE is not set
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
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
CONFIG_INTEL_MID_PTI=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_PCH_PHUB=m
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP=m
CONFIG_IWMC3200TOP_DEBUG=y
CONFIG_IWMC3200TOP_DEBUGFS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
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
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=m
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_ATA_ACPI is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_SATA_INIC162X=m
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_MPIIX=m
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=m
CONFIG_PATA_PLATFORM=m
CONFIG_PATA_RZ1000=m

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=m
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=m
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_RIONET is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
# CONFIG_CAIF_SPI_SLAVE is not set
# CONFIG_CAIF_HSI is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=m
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=m
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
CONFIG_FDDI=m
CONFIG_DEFXX=m
# CONFIG_DEFXX_MMIO is not set
# CONFIG_SKFP is not set
CONFIG_NET_SB1000=m
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
# CONFIG_BROADCOM_PHY is not set
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
# CONFIG_MICREL_PHY is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
CONFIG_PLIP=m
CONFIG_PPP=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOE is not set
CONFIG_PPP_ASYNC=m
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC75XX=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=m
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_QMI_WWAN=m
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
CONFIG_WLAN=y
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
CONFIG_HOSTAP=m
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
CONFIG_WL_TI=y

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WIMAX_I2400M_SDIO=m
# CONFIG_WIMAX_IWMC3200_SDIO is not set
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
# CONFIG_HDLC_PPP is not set
CONFIG_HDLC_X25=m
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=m
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
# CONFIG_DSCC4_PCI_RST is not set
# CONFIG_DLCI is not set
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
CONFIG_SBNI=m
# CONFIG_SBNI_MULTILINE is not set
CONFIG_XEN_NETDEV_FRONTEND=m
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
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
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
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=m
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=m
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
# CONFIG_TOUCHSCREEN_EGALAX is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_UCB1400 is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_ADXL34X_I2C=m
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=m
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=m

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
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
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
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_PCH_UART=m
CONFIG_SERIAL_XILINX_PS_UART=m
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
CONFIG_R3964=m
CONFIG_APPLICOM=m
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=m
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=m
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_EG20T=m
CONFIG_I2C_GPIO=m
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
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

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=m
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=m

#
# AC97 GPIO expanders:
#
# CONFIG_GPIO_UCB1400 is not set

#
# MODULbus GPIO expanders:
#
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_W1_SLAVE_DS2780 is not set
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=m
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=m
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=m
# CONFIG_HPWDT_NMI_DECODING is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=m
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
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
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=m
CONFIG_UCB1400_CORE=m
# CONFIG_MFD_LM3533 is not set
CONFIG_TPS6105X=m
CONFIG_TPS65010=m
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_TIMBERDALE=m
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=m
CONFIG_MFD_RDC321X=m
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CONTROLLER=y
# CONFIG_VIDEO_DEV is not set
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
# CONFIG_RC_CORE is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=m
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=m
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_TDFX=m
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_KMS is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_NOUVEAU_DEBUG=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=m
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=m
# CONFIG_DRM_CIRRUS_QEMU is not set
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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=m
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=m
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=m
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=m
CONFIG_FB_VIRTUAL=m
CONFIG_XEN_FBDEV_FRONTEND=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PROGEAR=m
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_HRTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
# CONFIG_SND_ATIIXP is not set
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
# CONFIG_SND_AU8820 is not set
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=m
# CONFIG_SND_BT87X is not set
CONFIG_SND_CA0106=m
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
# CONFIG_SND_CS46XX_NEW_DSP is not set
CONFIG_SND_CS5535AUDIO=m
# CONFIG_SND_CTXFI is not set
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=m
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
CONFIG_SND_ENS1370=m
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDSP=m
# CONFIG_SND_HDSPM is not set
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
# CONFIG_SND_RME96 is not set
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=m
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=m
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MICROSOFT=m
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=m
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
# CONFIG_USB_MOUSE is not set
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
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_DWC3=m
# CONFIG_USB_DWC3_DEBUG is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_XHCI_HCD_DEBUGGING=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
CONFIG_USB_MUSB_HDRC=m
# CONFIG_USB_MUSB_TUSB6010 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_UAS=m
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=m

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_GADGET_MUSB_HDRC=m
# CONFIG_USB_M66592 is not set
CONFIG_USB_AMD5536UDC=m
CONFIG_USB_NET2272=m
# CONFIG_USB_NET2272_DMA is not set
CONFIG_USB_NET2280=m
# CONFIG_USB_GOKU is not set
CONFIG_USB_EG20T=m
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_GADGET_SUPERSPEED=y
CONFIG_USB_ZERO=m
CONFIG_USB_AUDIO=m
CONFIG_GADGET_UAC1=y
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_FILE_STORAGE=m
CONFIG_USB_FILE_STORAGE_TEST=y
CONFIG_USB_MASS_STORAGE=m
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_ACM_MS=m
# CONFIG_USB_G_MULTI is not set
CONFIG_USB_G_HID=m
# CONFIG_USB_G_DBGP is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
# CONFIG_MMC_USHC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA9633=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_MTHCA=m
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_QIB=m
CONFIG_INFINIBAND_SRP=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=m
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=m
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=m
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
# CONFIG_XEN_COMPAT_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
CONFIG_XEN_GRANT_DEV_ALLOC=m
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PRIVCMD=m
# CONFIG_XEN_ACPI_PROCESSOR is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=m
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=m

#
# Hardware Spinlock drivers
#
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
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

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
CONFIG_VME_BUS=m

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
CONFIG_VME_TSI148=m

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m

#
# VME Device Drivers
#

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

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
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
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
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_HFS_FS=m
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_LOGFS=m
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
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
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=m
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_KPROBE_EVENT is not set
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
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
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
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
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
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
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
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
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
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
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
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=m
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
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=m
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=m
CONFIG_DDR=y

--J/dobhs11T7y2rNN--
