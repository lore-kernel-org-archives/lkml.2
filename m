Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab2JFOmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 10:42:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:56127 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab2JFOml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 10:42:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,543,1344236400"; 
   d="scan'208";a="230731125"
Date: Sat, 6 Oct 2012 22:42:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: staging: dgrp: NULL pointer dereference BUG in register_proc_table()
Message-ID: <20121006144225.GA15028@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Bill,

The below error happens in linus/master and linux-next, and first
shows up in

commit 7b6d45c211a401a9bdeebfa96f8a4c811bd3eeaf
Author: Bill Pemberton <wfp5p@virginia.edu>
Date:   Thu Sep 20 16:55:28 2012 -0400

    staging: dgrp: add dgrp to the build

[    9.623477] device: 'nodes': device_add
[    9.624106] PM: Adding info for No Bus:nodes
[    9.624673] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
[    9.625654] IP: [<ffffffff81de20a0>] register_proc_table+0x80/0x2c0
[    9.626441] PGD 0 
[    9.626712] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    9.627326] CPU 0 
[    9.627564] Pid: 1, comm: swapper/0 Not tainted 3.6.0-03042-g11126c6 #12  
[    9.628022] RIP: 0010:[<ffffffff81de20a0>]  [<ffffffff81de20a0>] register_proc_table+0x80/0x2c0
[    9.628022] RSP: 0018:ffff880000161e70  EFLAGS: 00010246
[    9.628022] RAX: 0000000000000003 RBX: 0000000000000006 RCX: 0000000000000001
[    9.628022] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffffff82634845
[    9.628022] RBP: ffff880000161eb0 R08: 0000000000000000 R09: 2222222222222222
[    9.628022] R10: 2222222222222222 R11: 2222222222222222 R12: 0000000000000003
[    9.628022] R13: 0000000000000003 R14: ffffffff82634845 R15: ffffffff8273ce38
[    9.628022] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:0000000000000000
[    9.628022] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    9.628022] CR2: 0000000000000040 CR3: 000000000268c000 CR4: 00000000000006b0
[    9.628022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    9.628022] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    9.628022] Process swapper/0 (pid: 1, threadinfo ffff880000160000, task ffff880000148000)
[    9.628022] Stack:
[    9.628022]  0000000000000000 ffffffff830ea640 ffffffff81dda890 0000000000000006
[    9.628022]  ffffffff81dda890 0000000000000000 0000000000000000 0000000000000000
[    9.628022]  ffff880000161ec0 ffffffff81de2e22 ffff880000161ed0 ffffffff81dda906
[    9.628022] Call Trace:
[    9.628022]  [<ffffffff81dda890>] ? dgrp_cleanup_module+0x60/0x60
[    9.628022]  [<ffffffff81dda890>] ? dgrp_cleanup_module+0x60/0x60
[    9.628022]  [<ffffffff81de2e22>] dgrp_register_proc+0x22/0x30
[    9.628022]  [<ffffffff81dda906>] dgrp_init_module+0x76/0x80
[    9.628022]  [<ffffffff82e8afa5>] do_one_initcall+0x86/0x19e
[    9.628022]  [<ffffffff82e8b1d3>] kernel_init+0x116/0x1da
[    9.628022]  [<ffffffff82e8a664>] ? loglevel+0x48/0x48
[    9.628022]  [<ffffffff810ce7a9>] ? schedule_tail+0x29/0x110
[    9.628022]  [<ffffffff82189d84>] kernel_thread_helper+0x4/0x10
[    9.628022]  [<ffffffff8218819d>] ? retint_restore_args+0x13/0x13
[    9.628022]  [<ffffffff82e8b0bd>] ? do_one_initcall+0x19e/0x19e
[    9.628022]  [<ffffffff82189d80>] ? gs_change+0x13/0x13
[    9.628022] Code: 49 83 7f 20 00 0f 85 e8 01 00 00 49 83 7f 18 00 0f 84 19 02 00 00 0f 85 d7 01 00 00 e9 0e 02 00 00 48 8b 55 c0 41 89 c4 4c 63 e8 <48> 8b 5a 40 48 85 db 75 1f 0f 1f 80 00 00 00 00 b8 01 00 00 00 
[    9.628022] RIP  [<ffffffff81de20a0>] register_proc_table+0x80/0x2c0
[    9.628022]  RSP <ffff880000161e70>
[    9.628022] CR2: 0000000000000040

Thanks,
Fengguang

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-kbuild-1594-2012-10-06-15-25-28-3.6.0-03042-g11126c6-12"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-03042-g11126c6 (kbuild@snb) (gcc version=
 4.7.1 (Debian 4.7.1-6) ) #12 SMP Sat Oct 6 15:24:55 CST 2012
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 branch=3Ddevel-snb-x86_64-2012-10-06-14-30 log_buf_len=3D8M ignor=
e_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabl=
ed panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=
=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-10-06-15-25-44-devel-snb=
-x86_64-2012-10-06-14-30:5733400-11126c6-x86_64-randconfig-s052-3-kbuild BO=
OT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-s052/11126c6/vmlinuz-3.6.=
0-03042-g11126c6
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e8540=
00-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128856(98%)
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
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:2e89101, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d40000=
0-ffff88000d7fffff] on node 0
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
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
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
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000de00000 s81744 r0 d2=
0656 u1048576
[    0.000000] pcpu-alloc: s81744 r0 d20656 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:de13101, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr de0d9c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64379
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 branch=3Ddevel-snb-x86_64-2012-10-06-14-30 log_buf_len=3D8=
M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_alway=
s_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dt=
ty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-10-06-15-25-44-de=
vel-snb-x86_64-2012-10-06-14-30:5733400-11126c6-x86_64-randconfig-s052-3-kb=
uild BOOT_IMAGE=3Dkernel-tests/kernels/x86_64-randconfig-s052/11126c6/vmlin=
uz-3.6.0-03042-g11126c6
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 190608k/262136k available (17962k kernel code, 500k =
absent, 71028k reserved, 13222k data, 1048k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |failed|  ok =
 |failed|failed|
[    0.000000]                   initialize held:failed|failed|failed|faile=
d|failed|failed|
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |failed|
[    0.000000]             mixed read-write-lock:             |failed|     =
        |failed|
[    0.000000]             mixed write-read-lock:             |failed|     =
        |failed|
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
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
[    0.000000] --------------------------------------------------------
[    0.000000] 142 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ODEBUG: 2 of 2 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.352 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.70 Bogo=
MIPS (lpj=3D10773408)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Security Framework initialized
[    0.008247] Mount-cache hash table entries: 256
[    0.010079] Initializing cgroup subsys devices
[    0.010979] Initializing cgroup subsys freezer
[    0.012041] Initializing cgroup subsys perf_event
[    0.012932] Initializing cgroup subsys net_prio
[    0.013741] Initializing cgroup subsys hugetlb
[    0.014918] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014918] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014918] tlb_flushall_shift: -1
[    0.016060] debug: unmapping init [mem 0xffffffff82f7c000-0xffffffff82f8=
3fff]
[    0.026020] ACPI: Core revision 20120711
[    0.066357] ftrace: allocating 37401 entries in 147 pages
[    0.080253] Getting VERSION: 50014
[    0.080758] Getting VERSION: 50014
[    0.081219] Getting ID: 0
[    0.081592] Getting ID: ff000000
[    0.082013] Getting LVT0: 8700
[    0.082418] Getting LVT1: 8400
[    0.084110] enabled ExtINT on CPU#0
[    0.085649] ENABLING IO-APIC IRQs
[    0.086125] init IO_APIC IRQs
[    0.086510]  apic 2 pin 0 not connected
[    0.087032] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.088090] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.089693] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.092074] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.093492] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.094836] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.096076] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.097571] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.100074] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.101595] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.103110] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.104080] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.105589] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.108087] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.109609] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.112059]  apic 2 pin 16 not connected
[    0.112775]  apic 2 pin 17 not connected
[    0.113486]  apic 2 pin 18 not connected
[    0.114199]  apic 2 pin 19 not connected
[    0.116034]  apic 2 pin 20 not connected
[    0.116742]  apic 2 pin 21 not connected
[    0.117475]  apic 2 pin 22 not connected
[    0.118193]  apic 2 pin 23 not connected
[    0.119090] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.120036] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, m=
odel: 06, stepping: 01)
[    0.122455] Using local APIC timer interrupts.
[    0.122455] calibrating APIC timer ...
[    0.128008] ... lapic delta =3D 6245765
[    0.128008] ... PM-Timer delta =3D 357707
[    0.128008] ... PM-Timer result ok
[    0.128008] ..... delta 6245765
[    0.128008] ..... mult: 268236799
[    0.128008] ..... calibration result: 3997289
[    0.128008] ..... CPU clock speed is 2691.2546 MHz.
[    0.128008] ..... host bus clock speed is 999.1289 MHz.
[    0.128115] Performance Events:=20
[    0.130458] ftrace: Allocated trace_printk buffers
[    0.133104] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:df13101, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.146326] Brought up 2 CPUs
[    0.146305] KVM setup async PF for cpu 1
[    0.146305] kvm-stealtime: cpu 1, msr df0d9c0
[    0.147736] ----------------
[    0.148024] | NMI testsuite:
[    0.148383] --------------------
[    0.148789]   remote IPI:  ok  |
[    0.168362]    local IPI:  ok  |
[    0.208076] --------------------
[    0.208765] Good, all   2 testcases passed! |
[    0.209548] ---------------------------------
[    0.210341] smpboot: Total of 2 processors activated (10773.40 BogoMIPS)
[    0.214878] devtmpfs: initialized
[    0.215962] device: 'platform': device_add
[    0.216260] PM: Adding info for No Bus:platform
[    0.217249] bus: 'platform': registered
[    0.218071] bus: 'cpu': registered
[    0.218756] device: 'cpu': device_add
[    0.220297] PM: Adding info for No Bus:cpu
[    0.221226] bus: 'memory': registered
[    0.221948] device: 'memory': device_add
[    0.222799] PM: Adding info for No Bus:memory
[    0.223656] device: 'memory0': device_add
[    0.224158] bus: 'memory': add device memory0
[    0.225065] PM: Adding info for memory:memory0
[    0.226038] device: 'memory1': device_add
[    0.226784] bus: 'memory': add device memory1
[    0.228175] PM: Adding info for memory:memory1
[    0.232577] EVM: security.ima
[    0.233161] EVM: security.capability
[    0.234939] bus: 'virtio': registered
[    0.235707] device class 'regulator': registering
[    0.236400] Registering platform device 'reg-dummy'. Parent at platform
[    0.237596] device: 'reg-dummy': device_add
[    0.238335] bus: 'platform': add device reg-dummy
[    0.240088] PM: Adding info for platform:reg-dummy
[    0.241048] bus: 'platform': add driver reg-dummy
[    0.241929] bus: 'platform': driver_probe_device: matched device reg-dum=
my with driver reg-dummy
[    0.243457] bus: 'platform': really_probe: probing driver reg-dummy with=
 device reg-dummy
[    0.244153] device: 'regulator.0': device_add
[    0.245392] PM: Adding info for No Bus:regulator.0
[    0.246387] regulator-dummy: no parameters
[    0.248282] driver: 'reg-dummy': driver_bound: bound to device 'reg-dumm=
y'
[    0.249483] bus: 'platform': really_probe: bound device reg-dummy to dri=
ver reg-dummy
[    0.250997] RTC time:  7:25:14, date: 10/06/12
[    0.252500] NET: Registered protocol family 16
[    0.253916] device class 'bdi': registering
[    0.254933] device class 'pci_bus': registering
[    0.256071] bus: 'pci': registered
[    0.256722] device class 'lcd': registering
[    0.257524] device class 'backlight': registering
[    0.258421] device class 'video_output': registering
[    0.259416] device class 'tty': registering
[    0.260411] bus: 'spi': registered
[    0.261078] device class 'spi_master': registering
[    0.262153] bus: 'hsi': registered
[    0.312693] ACPI: bus type pci registered
[    0.313605] PCI: Using configuration type 1 for base access
[    0.315048] device: 'cpu0': device_add
[    0.315825] bus: 'cpu': add device cpu0
[    0.316225] PM: Adding info for cpu:cpu0
[    0.317107] device: 'cpu1': device_add
[    0.317901] bus: 'cpu': add device cpu1
[    0.318846] PM: Adding info for cpu:cpu1
[    0.379661] device: 'default': device_add
[    0.380335] PM: Adding info for No Bus:default
[    0.381912] bio: create slab <bio-0> at 0
[    0.382673] device class 'block': registering
[    0.384246] ACPI: Added _OSI(Module Device)
[    0.384832] ACPI: Added _OSI(Processor Device)
[    0.385412] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.386012] ACPI: Added _OSI(Processor Aggregator Device)
[    0.388135] ACPI: EC: Look up EC in DSDT
[    0.454615] ACPI: Interpreter enabled
[    0.455339] ACPI: (supports S0 S3 S4 S5)
[    0.456760] ACPI: Using IOAPIC for interrupt routing
[    0.457949] bus: 'acpi': registered
[    0.458636] bus: 'acpi': add driver power
[    0.459701] device: 'LNXSYSTM:00': device_add
[    0.460086] bus: 'acpi': add device LNXSYSTM:00
[    0.460986] PM: Adding info for acpi:LNXSYSTM:00
[    0.462720] device: 'device:00': device_add
[    0.463565] bus: 'acpi': add device device:00
[    0.464189] PM: Adding info for acpi:device:00
[    0.466013] device: 'PNP0A03:00': device_add
[    0.466856] bus: 'acpi': add device PNP0A03:00
[    0.468203] PM: Adding info for acpi:PNP0A03:00
[    0.472439] device: 'device:01': device_add
[    0.473350] bus: 'acpi': add device device:01
[    0.474306] PM: Adding info for acpi:device:01
[    0.476043] device: 'device:02': device_add
[    0.476850] bus: 'acpi': add device device:02
[    0.477771] PM: Adding info for acpi:device:02
[    0.479580] device: 'PNP0B00:00': device_add
[    0.480094] bus: 'acpi': add device PNP0B00:00
[    0.481035] PM: Adding info for acpi:PNP0B00:00
[    0.483263] device: 'PNP0303:00': device_add
[    0.484099] bus: 'acpi': add device PNP0303:00
[    0.485089] PM: Adding info for acpi:PNP0303:00
[    0.487223] device: 'PNP0F13:00': device_add
[    0.488102] bus: 'acpi': add device PNP0F13:00
[    0.489039] PM: Adding info for acpi:PNP0F13:00
[    0.492138] device: 'PNP0700:00': device_add
[    0.493079] bus: 'acpi': add device PNP0700:00
[    0.494086] PM: Adding info for acpi:PNP0700:00
[    0.498437] device: 'PNP0400:00': device_add
[    0.499248] bus: 'acpi': add device PNP0400:00
[    0.500233] PM: Adding info for acpi:PNP0400:00
[    0.504147] device: 'PNP0501:00': device_add
[    0.504988] bus: 'acpi': add device PNP0501:00
[    0.506000] PM: Adding info for acpi:PNP0501:00
[    0.508934] device: 'device:03': device_add
[    0.509824] bus: 'acpi': add device device:03
[    0.510813] PM: Adding info for acpi:device:03
[    0.512655] device: 'device:04': device_add
[    0.513464] bus: 'acpi': add device device:04
[    0.514332] PM: Adding info for acpi:device:04
[    0.516066] device: 'device:05': device_add
[    0.516986] bus: 'acpi': add device device:05
[    0.517960] PM: Adding info for acpi:device:05
[    0.519950] device: 'device:06': device_add
[    0.520119] bus: 'acpi': add device device:06
[    0.521141] PM: Adding info for acpi:device:06
[    0.522936] device: 'device:07': device_add
[    0.524103] bus: 'acpi': add device device:07
[    0.525085] PM: Adding info for acpi:device:07
[    0.526990] device: 'device:08': device_add
[    0.528109] bus: 'acpi': add device device:08
[    0.529107] PM: Adding info for acpi:device:08
[    0.530964] device: 'device:09': device_add
[    0.532120] bus: 'acpi': add device device:09
[    0.533114] PM: Adding info for acpi:device:09
[    0.535036] device: 'device:0a': device_add
[    0.536095] bus: 'acpi': add device device:0a
[    0.537024] PM: Adding info for acpi:device:0a
[    0.538965] device: 'device:0b': device_add
[    0.539874] bus: 'acpi': add device device:0b
[    0.540279] PM: Adding info for acpi:device:0b
[    0.542156] device: 'device:0c': device_add
[    0.543135] bus: 'acpi': add device device:0c
[    0.544204] PM: Adding info for acpi:device:0c
[    0.546561] device: 'device:0d': device_add
[    0.548174] bus: 'acpi': add device device:0d
[    0.549099] PM: Adding info for acpi:device:0d
[    0.550981] device: 'device:0e': device_add
[    0.551780] bus: 'acpi': add device device:0e
[    0.552252] PM: Adding info for acpi:device:0e
[    0.554039] device: 'device:0f': device_add
[    0.554976] bus: 'acpi': add device device:0f
[    0.556247] PM: Adding info for acpi:device:0f
[    0.558225] device: 'device:10': device_add
[    0.559042] bus: 'acpi': add device device:10
[    0.560261] PM: Adding info for acpi:device:10
[    0.562245] device: 'device:11': device_add
[    0.563269] bus: 'acpi': add device device:11
[    0.564260] PM: Adding info for acpi:device:11
[    0.566139] device: 'device:12': device_add
[    0.566972] bus: 'acpi': add device device:12
[    0.567912] PM: Adding info for acpi:device:12
[    0.569127] device: 'device:13': device_add
[    0.569912] bus: 'acpi': add device device:13
[    0.570805] PM: Adding info for acpi:device:13
[    0.573045] device: 'device:14': device_add
[    0.573841] bus: 'acpi': add device device:14
[    0.574675] PM: Adding info for acpi:device:14
[    0.577003] device: 'device:15': device_add
[    0.577813] bus: 'acpi': add device device:15
[    0.578758] PM: Adding info for acpi:device:15
[    0.580717] device: 'device:16': device_add
[    0.581552] bus: 'acpi': add device device:16
[    0.582506] PM: Adding info for acpi:device:16
[    0.584369] device: 'device:17': device_add
[    0.585293] bus: 'acpi': add device device:17
[    0.586279] PM: Adding info for acpi:device:17
[    0.588152] device: 'device:18': device_add
[    0.589025] bus: 'acpi': add device device:18
[    0.589996] PM: Adding info for acpi:device:18
[    0.591853] device: 'device:19': device_add
[    0.592100] bus: 'acpi': add device device:19
[    0.593044] PM: Adding info for acpi:device:19
[    0.594997] device: 'device:1a': device_add
[    0.596100] bus: 'acpi': add device device:1a
[    0.597117] PM: Adding info for acpi:device:1a
[    0.598990] device: 'device:1b': device_add
[    0.600102] bus: 'acpi': add device device:1b
[    0.601110] PM: Adding info for acpi:device:1b
[    0.603077] device: 'device:1c': device_add
[    0.604099] bus: 'acpi': add device device:1c
[    0.605033] PM: Adding info for acpi:device:1c
[    0.606793] device: 'device:1d': device_add
[    0.607590] bus: 'acpi': add device device:1d
[    0.608188] PM: Adding info for acpi:device:1d
[    0.610064] device: 'device:1e': device_add
[    0.610922] bus: 'acpi': add device device:1e
[    0.612196] PM: Adding info for acpi:device:1e
[    0.614050] device: 'device:1f': device_add
[    0.614930] bus: 'acpi': add device device:1f
[    0.616124] PM: Adding info for acpi:device:1f
[    0.618041] device: 'device:20': device_add
[    0.618974] bus: 'acpi': add device device:20
[    0.619972] PM: Adding info for acpi:device:20
[    0.621127] device: 'device:21': device_add
[    0.622041] bus: 'acpi': add device device:21
[    0.623064] PM: Adding info for acpi:device:21
[    0.625054] device: 'device:22': device_add
[    0.625997] bus: 'acpi': add device device:22
[    0.627043] PM: Adding info for acpi:device:22
[    0.633446] device: 'PNP0103:00': device_add
[    0.634279] bus: 'acpi': add device PNP0103:00
[    0.635303] PM: Adding info for acpi:PNP0103:00
[    0.639115] device: 'PNP0C0F:00': device_add
[    0.640218] bus: 'acpi': add device PNP0C0F:00
[    0.641361] PM: Adding info for acpi:PNP0C0F:00
[    0.645006] device: 'PNP0C0F:01': device_add
[    0.645927] bus: 'acpi': add device PNP0C0F:01
[    0.646934] PM: Adding info for acpi:PNP0C0F:01
[    0.650510] device: 'PNP0C0F:02': device_add
[    0.651423] bus: 'acpi': add device PNP0C0F:02
[    0.652245] PM: Adding info for acpi:PNP0C0F:02
[    0.655704] device: 'PNP0C0F:03': device_add
[    0.656125] bus: 'acpi': add device PNP0C0F:03
[    0.657130] PM: Adding info for acpi:PNP0C0F:03
[    0.661331] device: 'PNP0C0F:04': device_add
[    0.662227] bus: 'acpi': add device PNP0C0F:04
[    0.663231] PM: Adding info for acpi:PNP0C0F:04
[    0.665768] device: 'LNXCPU:00': device_add
[    0.666553] bus: 'acpi': add device LNXCPU:00
[    0.667417] PM: Adding info for acpi:LNXCPU:00
[    0.669800] device: 'LNXCPU:01': device_add
[    0.670709] bus: 'acpi': add device LNXCPU:01
[    0.671464] PM: Adding info for acpi:LNXCPU:01
[    0.672722] device: 'device:23': device_add
[    0.673336] bus: 'acpi': add device device:23
[    0.673968] PM: Adding info for acpi:device:23
[    0.674701] device: 'LNXPWRBN:00': device_add
[    0.675284] bus: 'acpi': add device LNXPWRBN:00
[    0.676152] PM: Adding info for acpi:LNXPWRBN:00
[    0.677120] bus: 'acpi': add driver ec
[    0.687534] ACPI: No dock devices found.
[    0.688058] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.689235] bus: 'acpi': add driver pci_root
[    0.689826] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    0.690888] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    0.692273] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.693777] device: 'pci0000:00': device_add
[    0.694644] PM: Adding info for No Bus:pci0000:00
[    0.695312] device: '0000:00': device_add
[    0.696013] PM: Adding info for No Bus:0000:00
[    0.696100] PCI host bridge to bus 0000:00
[    0.696629] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.697333] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.698415] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.700079] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.700974] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.701833] pci_bus 0000:00: scanning bus
[    0.702606] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.703546] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0xa
[    0.704388] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.705581] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.708615] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.710130] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.711373] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x66
[    0.712615] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x186
[    0.713772] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.715146] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.716153] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x10
[    0.717490] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.724573] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.727166] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.733940] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.735541] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.737018] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.740081] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.745336] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.746706] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.748507] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.750376] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.756433] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.758543] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.760510] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.766147] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.768531] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.770477] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.776409] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.778538] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.780505] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.785746] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.788072] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.789917] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.795879] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.797042] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.798918] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.805746] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.807489] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.811147] pci_bus 0000:00: fixups for bus
[    0.812087] pci_bus 0000:00: bus scan returning with max=3D00
[    0.813155] pci_bus 0000:00: on NUMA node 0
[    0.814034] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.839568]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.840078]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.841545] device: '0000:00:00.0': device_add
[    0.862059] bus: 'pci': add device 0000:00:00.0
[    0.863380] PM: Adding info for pci:0000:00:00.0
[    0.864223] device: '0000:00:01.0': device_add
[    0.883752] bus: 'pci': add device 0000:00:01.0
[    0.884412] PM: Adding info for pci:0000:00:01.0
[    0.885375] device: '0000:00:01.1': device_add
[    0.905156] bus: 'pci': add device 0000:00:01.1
[    0.906422] PM: Adding info for pci:0000:00:01.1
[    0.907302] device: '0000:00:01.3': device_add
[    0.926522] bus: 'pci': add device 0000:00:01.3
[    0.927654] PM: Adding info for pci:0000:00:01.3
[    0.928158] device: '0000:00:02.0': device_add
[    0.947215] bus: 'pci': add device 0000:00:02.0
[    0.948448] PM: Adding info for pci:0000:00:02.0
[    0.949331] device: '0000:00:03.0': device_add
[    0.967899] bus: 'pci': add device 0000:00:03.0
[    0.968384] PM: Adding info for pci:0000:00:03.0
[    0.969350] device: '0000:00:04.0': device_add
[    0.989304] bus: 'pci': add device 0000:00:04.0
[    0.990487] PM: Adding info for pci:0000:00:04.0
[    0.991376] device: '0000:00:05.0': device_add
[    1.010641] bus: 'pci': add device 0000:00:05.0
[    1.011842] PM: Adding info for pci:0000:00:05.0
[    1.012152] device: '0000:00:06.0': device_add
[    1.031828] bus: 'pci': add device 0000:00:06.0
[    1.032416] PM: Adding info for pci:0000:00:06.0
[    1.033386] device: '0000:00:07.0': device_add
[    1.051211] bus: 'pci': add device 0000:00:07.0
[    1.052111] PM: Adding info for pci:0000:00:07.0
[    1.052769] device: '0000:00:08.0': device_add
[    1.065263] bus: 'pci': add device 0000:00:08.0
[    1.066140] PM: Adding info for pci:0000:00:08.0
[    1.066787] device: '0000:00:09.0': device_add
[    1.080464] bus: 'pci': add device 0000:00:09.0
[    1.081536] PM: Adding info for pci:0000:00:09.0
[    1.082192] device: '0000:00:0a.0': device_add
[    1.098723] bus: 'pci': add device 0000:00:0a.0
[    1.100017] PM: Adding info for pci:0000:00:0a.0
[    1.100183] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[    1.101495] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[    1.103014] bus: 'acpi': add driver pci_link
[    1.104169] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[    1.105701] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[    1.109306] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.110982] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[    1.111848] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[    1.112091] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[    1.113112] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[    1.115115] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.116630] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[    1.117498] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[    1.118618] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[    1.120085] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[    1.122026] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.123559] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[    1.124093] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[    1.125388] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[    1.126941] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[    1.129644] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.132612] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[    1.133946] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[    1.135440] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[    1.136105] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[    1.138187] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    1.140248] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[    1.141306] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[    1.142832] bus: 'pnp': registered
[    1.143563] bus: 'xen': registered
[    1.144109] bus: 'platform': add driver da9052-regulator
[    1.145170] device class 'misc': registering
[    1.146384] device: 'vga_arbiter': device_add
[    1.148250] PM: Adding info for No Bus:vga_arbiter
[    1.149169] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.150479] vgaarb: loaded
[    1.150966] vgaarb: bridge control possible 0000:00:02.0
[    1.152838] bus: 'tifm': registered
[    1.153538] device class 'tifm_adapter': registering
[    1.154515] bus: 'spi': add driver wm831x
[    1.155353] bus: 'spi': add driver ezx-pcap
[    1.156239] bus: 'spi': add driver da9052
[    1.158578] device class 'scsi_host': registering
[    1.160255] bus: 'scsi': registered
[    1.160916] device class 'scsi_device': registering
[    1.161978] SCSI subsystem initialized
[    1.162732] ACPI: bus type scsi registered
[    1.164149] device class 'ata_link': registering
[    1.165093] device class 'ata_port': registering
[    1.165950] device class 'ata_device': registering
[    1.168205] libata version 3.00 loaded.
[    1.168963] device class 'mdio_bus': registering
[    1.170035] bus: 'mdio_bus': registered
[    1.170671] bus: 'mdio_bus': add driver Generic PHY
[    1.171634] device class 'pcmcia_socket': registering
[    1.172355] bus: 'serio': registered
[    1.173112] bus: 'gameport': registered
[    1.173821] device class 'input': registering
[    1.174766] Linux video capture interface: v2.00
[    1.176107] device class 'video4linux': registering
[    1.177085] device class 'dvb': registering
[    1.177914] device class 'power_supply': registering
[    1.178864] device class 'hwmon': registering
[    1.180407] device class 'leds': registering
[    1.181213] device class 'wmi': registering
[    1.182001] bus: 'acpi': add driver wmi
[    1.182775] wmi: Mapper loaded
[    1.183350] device class 'devfreq': registering
[    1.184174] PCI: Using ACPI for IRQ routing
[    1.184880] PCI: pci_cache_line_size set to 64 bytes
[    1.185721] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags =
0x110] (d=3D0, p=3D0)
[    1.187009] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] =
(d=3D0, p=3D0)
[    1.188106] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags =
0x110] (d=3D0, p=3D0)
[    1.189501] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] =
(d=3D0, p=3D0)
[    1.190765] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags =
0x40101] (d=3D0, p=3D0)
[    1.192143] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdfffff=
f flags 0x42208] (d=3D0, p=3D0)
[    1.193661] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf0000-0xfebf0ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.195122] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbfff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.196099] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags =
0x40101] (d=3D0, p=3D0)
[    1.197475] pci 0000:00:04.0: BAR 0: reserving [io  0xc040-0xc07f flags =
0x40101] (d=3D0, p=3D0)
[    1.198845] pci 0000:00:04.0: BAR 1: reserving [mem 0xfebf1000-0xfebf1ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.200132] pci 0000:00:05.0: BAR 0: reserving [io  0xc080-0xc0bf flags =
0x40101] (d=3D0, p=3D0)
[    1.201434] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf2000-0xfebf2ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.202930] pci 0000:00:06.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags =
0x40101] (d=3D0, p=3D0)
[    1.204105] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf3000-0xfebf3ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.205584] pci 0000:00:07.0: BAR 0: reserving [io  0xc100-0xc13f flags =
0x40101] (d=3D0, p=3D0)
[    1.208100] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.209621] pci 0000:00:08.0: BAR 0: reserving [io  0xc140-0xc17f flags =
0x40101] (d=3D0, p=3D0)
[    1.210995] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.212133] pci 0000:00:09.0: BAR 0: reserving [io  0xc180-0xc1bf flags =
0x40101] (d=3D0, p=3D0)
[    1.213542] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6ff=
f flags 0x40200] (d=3D0, p=3D0)
[    1.215104] pci 0000:00:0a.0: BAR 0: reserving [mem 0xfebf7000-0xfebf700=
f flags 0x40200] (d=3D0, p=3D0)
[    1.216302] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.217489] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.218601] device class 'net': registering
[    1.220356] device: 'lo': device_add
[    1.221577] PM: Adding info for No Bus:lo
[    1.223130] NET: Registered protocol family 23
[    1.224178] NET: Registered protocol family 8
[    1.224946] NET: Registered protocol family 20
[    1.225783] device class 'atm': registering
[    1.226634] device class 'ieee80211': registering
[    1.228218] Registering platform device 'regulatory.0'. Parent at platfo=
rm
[    1.229547] device: 'regulatory.0': device_add
[    1.230441] bus: 'platform': add device regulatory.0
[    1.231529] PM: Adding info for platform:regulatory.0
[    1.232593] cfg80211: Calling CRDA to update world regulatory domain
[    1.233794] nfc: nfc_init: NFC Core ver 0.1
[    1.234515] device class 'nfc': registering
[    1.235428] NET: Registered protocol family 39
[    1.236842] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.240143] Switching to clocksource kvm-clock
[    1.242438] Warning: could not register all branches stats
[    1.243587] Warning: could not register annotated branches stats
[    1.322577] FS-Cache: Loaded
[    1.323327] bus: 'pnp': add driver system
[    1.324190] pnp: PnP ACPI init
[    1.324801] device: 'pnp0': device_add
[    1.325694] PM: Adding info for No Bus:pnp0
[    1.326547] ACPI: bus type pnp registered
[    1.327675] pnp 00:00: [bus 00-ff]
[    1.328388] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.329114] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.329926] pnp 00:00: [io  0x0d00-0xffff window]
[    1.330857] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.331902] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    1.332996] device: '00:00': device_add
[    1.333849] bus: 'pnp': add device 00:00
[    1.334798] PM: Adding info for pnp:00:00
[    1.335629] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.337136] pnp 00:01: [io  0x0070-0x0071]
[    1.338028] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.339609] pnp 00:01: [irq 8]
[    1.340235] pnp 00:01: [io  0x0072-0x0077]
[    1.341044] device: '00:01': device_add
[    1.341906] bus: 'pnp': add device 00:01
[    1.342873] PM: Adding info for pnp:00:01
[    1.343723] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.345841] pnp 00:02: [io  0x0060]
[    1.346572] pnp 00:02: [io  0x0064]
[    1.347049] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.348144] pnp 00:02: [irq 1]
[    1.348580] device: '00:02': device_add
[    1.349149] bus: 'pnp': add device 00:02
[    1.349812] PM: Adding info for pnp:00:02
[    1.350374] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.351755] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.352848] pnp 00:03: [irq 12]
[    1.353274] device: '00:03': device_add
[    1.353889] bus: 'pnp': add device 00:03
[    1.354512] PM: Adding info for pnp:00:03
[    1.355078] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.356478] pnp 00:04: [io  0x03f2-0x03f5]
[    1.357021] pnp 00:04: [io  0x03f7]
[    1.357578] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.359206] pnp 00:04: [irq 6]
[    1.359665] pnp 00:04: [dma 2]
[    1.360127] device: '00:04': device_add
[    1.360716] bus: 'pnp': add device 00:04
[    1.361330] PM: Adding info for pnp:00:04
[    1.361901] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.363705] pnp 00:05: [io  0x0378-0x037f]
[    1.364295] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.365309] pnp 00:05: [irq 7]
[    1.365732] device: '00:05': device_add
[    1.366402] bus: 'pnp': add device 00:05
[    1.367123] PM: Adding info for pnp:00:05
[    1.367850] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.370067] pnp 00:06: [io  0x03f8-0x03ff]
[    1.370943] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.372198] pnp 00:06: [irq 4]
[    1.372794] device: '00:06': device_add
[    1.373374] bus: 'pnp': add device 00:06
[    1.374003] PM: Adding info for pnp:00:06
[    1.374574] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.378332] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    1.379021] device: '00:07': device_add
[    1.379665] bus: 'pnp': add device 00:07
[    1.380296] PM: Adding info for pnp:00:07
[    1.380862] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.383924] pnp: PnP ACPI: found 8 devices
[    1.384502] ACPI: ACPI bus type pnp unregistered
[    1.385141] device class 'mem': registering
[    1.385747] device: 'mem': device_add
[    1.386551] PM: Adding info for No Bus:mem
[    1.387502] device: 'null': device_add
[    1.388637] PM: Adding info for No Bus:null
[    1.389481] device: 'port': device_add
[    1.390596] PM: Adding info for No Bus:port
[    1.391516] device: 'zero': device_add
[    1.393180] PM: Adding info for No Bus:zero
[    1.394138] device: 'full': device_add
[    1.395574] PM: Adding info for No Bus:full
[    1.396555] device: 'random': device_add
[    1.398680] PM: Adding info for No Bus:random
[    1.399652] device: 'urandom': device_add
[    1.401507] PM: Adding info for No Bus:urandom
[    1.402502] device: 'kmsg': device_add
[    1.403851] PM: Adding info for No Bus:kmsg
[    1.404817] device: 'tty': device_add
[    1.405945] PM: Adding info for No Bus:tty
[    1.406874] device: 'console': device_add
[    1.409412] PM: Adding info for No Bus:console
[    1.410107] device class 'firmware': registering
[    1.410879] bus: 'pcmcia': registered
[    1.411354] device class 'thermal': registering
[    1.416864] bus: 'ssb': registered
[    1.417336] bus: 'pci': add driver b43-pci-bridge
[    1.418446] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.419365] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.420457] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.421621] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    1.422603] NET: Registered protocol family 2
[    1.423633] TCP established hash table entries: 8192 (order: 5, 131072 b=
ytes)
[    1.424725] TCP bind hash table entries: 8192 (order: 6, 262144 bytes)
[    1.425764] TCP: Hash tables configured (established 8192 bind 8192)
[    1.426692] TCP: reno registered
[    1.427114] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    1.428237] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    1.429763] NET: Registered protocol family 1
[    1.430723] pci 0000:00:00.0: calling quirk_natoma+0x0/0x47
[    1.431802] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.432971] pci 0000:00:00.0: calling quirk_passive_release+0x0/0xb0
[    1.433812] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.434548] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x45
[    1.435294] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.436112] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x116
[    1.436849] pci 0000:00:02.0: Boot video device
[    1.437414] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x1e6
[    1.438732] PCI: CLS 0 bytes, default 64
[    1.440156] Trying to unpack rootfs image as initramfs...
[    3.131205] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffe=
ffff]
[    3.133438] device class 'msr': registering
[    3.134145] device: 'msr0': device_add
[    3.134918] PM: Adding info for No Bus:msr0
[    3.135570] device: 'msr1': device_add
[    3.136351] PM: Adding info for No Bus:msr1
[    3.136998] device class 'cpuid': registering
[    3.137787] device: 'cpu0': device_add
[    3.138829] PM: Adding info for No Bus:cpu0
[    3.139443] device: 'cpu1': device_add
[    3.140152] PM: Adding info for No Bus:cpu1
[    3.140766] microcode: no support for this CPU vendor
[    3.141854] AVX instructions are not detected.
[    3.142729] cryptomgr_test (25) used greatest stack depth: 6320 bytes le=
ft
[    3.146720] cryptomgr_test (27) used greatest stack depth: 5296 bytes le=
ft
[    3.150217] AVX instructions are not detected.
[    3.154268] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.155701] device: 'snapshot': device_add
[    3.156853] PM: Adding info for No Bus:snapshot
[    3.158035] bus: 'clocksource': registered
[    3.158861] device: 'clocksource': device_add
[    3.159821] PM: Adding info for No Bus:clocksource
[    3.160839] device: 'clocksource0': device_add
[    3.161760] bus: 'clocksource': add device clocksource0
[    3.162923] PM: Adding info for clocksource:clocksource0
[    3.163933] bus: 'platform': add driver alarmtimer
[    3.164933] Registering platform device 'alarmtimer'. Parent at platform
[    3.166266] device: 'alarmtimer': device_add
[    3.167181] bus: 'platform': add device alarmtimer
[    3.168710] PM: Adding info for platform:alarmtimer
[    3.169738] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    3.171330] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    3.172875] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    3.174201] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    3.175751] rcu-torture:--- Start of test: nreaders=3D4 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D0 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    3.189180] bus: 'event_source': registered
[    3.190208] device: 'breakpoint': device_add
[    3.191207] bus: 'event_source': add device breakpoint
[    3.192345] PM: Adding info for event_source:breakpoint
[    3.193122] device: 'tracepoint': device_add
[    3.193758] bus: 'event_source': add device tracepoint
[    3.194522] PM: Adding info for event_source:tracepoint
[    3.195567] device: 'software': device_add
[    3.196515] bus: 'event_source': add device software
[    3.197308] PM: Adding info for event_source:software
[    3.200347] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.219369] VFS: Disk quotas dquot_6.5.2
[    3.220263] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.223303] device: 'autofs': device_add
[    3.224157] PM: Adding info for No Bus:autofs
[    3.225363] JFS: nTxBlock =3D 1489, nTxLock =3D 11913
[    3.228125] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, debug enabled
[    3.235797] GFS2 installed
[    3.240224] alg: No test for fcrypt (fcrypt-generic)
[    3.248026] alg: No test for stdrng (krng)
[    3.249281] NET: Registered protocol family 38
[    3.250140] device class 'bsg': registering
[    3.250816] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    3.251758] io scheduler noop registered
[    3.252901] io scheduler cfq registered (default)
[    3.253851] bus: 'platform': add driver omap-ocp2scp
[    3.254618] bus: 'pci': add driver ioapic
[    3.255220] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.256044] bus: 'pci': add driver shpchp
[    3.256703] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.257605] bus: 'pci': add driver pci-stub
[    3.258255] bus: 'platform': add driver platform-lcd
[    3.258967] bus: 'spi': add driver s6e63m0
[    3.259593] bus: 'spi': add driver ld9040
[    3.260197] bus: 'spi': add driver ams369fg06
[    3.260827] bus: 'platform': add driver generic-bl
[    3.261588] bus: 'acpi': add driver fan
[    3.262196] bus: 'acpi': add driver video
[    3.263210] pci_bus 0000:00: dev 01, created physical slot 1
[    3.264162] pci_bus 0000:00: dev 02, created physical slot 2
[    3.265129] pci_bus 0000:00: dev 03, created physical slot 3
[    3.266006] pci_bus 0000:00: dev 04, created physical slot 4
[    3.266869] pci_bus 0000:00: dev 05, created physical slot 5
[    3.267761] pci_bus 0000:00: dev 06, created physical slot 6
[    3.269320] pci_bus 0000:00: dev 07, created physical slot 7
[    3.270228] pci_bus 0000:00: dev 08, created physical slot 8
[    3.271119] pci_bus 0000:00: dev 09, created physical slot 9
[    3.271991] pci_bus 0000:00: dev 0a, created physical slot 10
[    3.272935] pci_bus 0000:00: dev 0b, created physical slot 11
[    3.273824] pci_bus 0000:00: dev 0c, created physical slot 12
[    3.274701] pci_bus 0000:00: dev 0d, created physical slot 13
[    3.275565] pci_bus 0000:00: dev 0e, created physical slot 14
[    3.276411] pci_bus 0000:00: dev 0f, created physical slot 15
[    3.277330] pci_bus 0000:00: dev 10, created physical slot 16
[    3.278601] pci_bus 0000:00: dev 11, created physical slot 17
[    3.279886] pci_bus 0000:00: dev 12, created physical slot 18
[    3.281216] pci_bus 0000:00: dev 13, created physical slot 19
[    3.282513] pci_bus 0000:00: dev 14, created physical slot 20
[    3.283857] pci_bus 0000:00: dev 15, created physical slot 21
[    3.285208] pci_bus 0000:00: dev 16, created physical slot 22
[    3.286518] pci_bus 0000:00: dev 17, created physical slot 23
[    3.287786] pci_bus 0000:00: dev 18, created physical slot 24
[    3.289249] pci_bus 0000:00: dev 19, created physical slot 25
[    3.290618] pci_bus 0000:00: dev 1a, created physical slot 26
[    3.291889] pci_bus 0000:00: dev 1b, created physical slot 27
[    3.293138] pci_bus 0000:00: dev 1c, created physical slot 28
[    3.294426] pci_bus 0000:00: dev 1d, created physical slot 29
[    3.295688] pci_bus 0000:00: dev 1e, created physical slot 30
[    3.296980] pci_bus 0000:00: dev 1f, created physical slot 31
[    3.300530] bus: 'acpi': add driver processor
[    3.301492] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 w=
ith driver processor
[    3.303112] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:00
[    3.307471] device: 'cooling_device0': device_add
[    3.308663] PM: Adding info for No Bus:cooling_device0
[    3.309742] driver: 'LNXCPU:00': driver_bound: bound to device 'processo=
r'
[    3.310958] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver =
processor
[    3.312228] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 w=
ith driver processor
[    3.313707] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:01
[    3.317814] device: 'cooling_device1': device_add
[    3.318915] PM: Adding info for No Bus:cooling_device1
[    3.320038] driver: 'LNXCPU:01': driver_bound: bound to device 'processo=
r'
[    3.321307] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver =
processor
[    3.358411] bus: 'acpi': add driver container
[    3.388917] bus: 'acpi': add driver thermal
[    3.389992] bus: 'acpi': add driver hardware_error_device
[    3.391069] bus: 'pci': add driver virtio-pci
[    3.391863] bus: 'pci': driver_probe_device: matched device 0000:00:04.0=
 with driver virtio-pci
[    3.393400] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:04.0
[    3.398235] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    3.399433] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    3.400882] virtio-pci 0000:00:04.0: enabling bus mastering
[    3.401822] virtio-pci 0000:00:04.0: setting latency timer to 64
[    3.403361] device: 'virtio0': device_add
[    3.403969] bus: 'acpi': add driver battery
[    3.404955] bus: 'virtio': add device virtio0
[    3.405970] PM: Adding info for virtio:virtio0
[    3.406888] driver: '0000:00:04.0': driver_bound: bound to device 'virti=
o-pci'
[    3.408678] bus: 'pci': really_probe: bound device 0000:00:04.0 to drive=
r virtio-pci
[    3.410113] bus: 'pci': driver_probe_device: matched device 0000:00:05.0=
 with driver virtio-pci
[    3.411707] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:05.0
[    3.416209] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    3.417308] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    3.418846] virtio-pci 0000:00:05.0: enabling bus mastering
[    3.419856] virtio-pci 0000:00:05.0: setting latency timer to 64
[    3.421361] device: 'virtio1': device_add
[    3.422129] bus: 'virtio': add device virtio1
[    3.423114] PM: Adding info for virtio:virtio1
[    3.424048] driver: '0000:00:05.0': driver_bound: bound to device 'virti=
o-pci'
[    3.425259] bus: 'pci': really_probe: bound device 0000:00:05.0 to drive=
r virtio-pci
[    3.426591] bus: 'pci': driver_probe_device: matched device 0000:00:06.0=
 with driver virtio-pci
[    3.428132] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:06.0
[    3.432940] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    3.434064] virtio-pci 0000:00:06.0: enabling bus mastering
[    3.435158] virtio-pci 0000:00:06.0: setting latency timer to 64
[    3.436533] device: 'virtio2': device_add
[    3.437324] bus: 'virtio': add device virtio2
[    3.438421] PM: Adding info for virtio:virtio2
[    3.439253] driver: '0000:00:06.0': driver_bound: bound to device 'virti=
o-pci'
[    3.440515] bus: 'pci': really_probe: bound device 0000:00:06.0 to drive=
r virtio-pci
[    3.441794] bus: 'pci': driver_probe_device: matched device 0000:00:07.0=
 with driver virtio-pci
[    3.443207] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:07.0
[    3.448121] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    3.449215] virtio-pci 0000:00:07.0: enabling bus mastering
[    3.450190] virtio-pci 0000:00:07.0: setting latency timer to 64
[    3.451617] device: 'virtio3': device_add
[    3.452358] bus: 'virtio': add device virtio3
[    3.453258] PM: Adding info for virtio:virtio3
[    3.454107] driver: '0000:00:07.0': driver_bound: bound to device 'virti=
o-pci'
[    3.455262] bus: 'pci': really_probe: bound device 0000:00:07.0 to drive=
r virtio-pci
[    3.456626] bus: 'pci': driver_probe_device: matched device 0000:00:08.0=
 with driver virtio-pci
[    3.458251] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:08.0
[    3.459933] virtio-pci 0000:00:08.0: enabling bus mastering
[    3.461046] virtio-pci 0000:00:08.0: setting latency timer to 64
[    3.462572] device: 'virtio4': device_add
[    3.463415] bus: 'virtio': add device virtio4
[    3.464445] PM: Adding info for virtio:virtio4
[    3.465362] driver: '0000:00:08.0': driver_bound: bound to device 'virti=
o-pci'
[    3.466746] bus: 'pci': really_probe: bound device 0000:00:08.0 to drive=
r virtio-pci
[    3.468122] bus: 'pci': driver_probe_device: matched device 0000:00:09.0=
 with driver virtio-pci
[    3.469653] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:09.0
[    3.471423] virtio-pci 0000:00:09.0: enabling bus mastering
[    3.472443] virtio-pci 0000:00:09.0: setting latency timer to 64
[    3.473915] device: 'virtio5': device_add
[    3.474745] bus: 'virtio': add device virtio5
[    3.475815] PM: Adding info for virtio:virtio5
[    3.476684] driver: '0000:00:09.0': driver_bound: bound to device 'virti=
o-pci'
[    3.478135] bus: 'pci': really_probe: bound device 0000:00:09.0 to drive=
r virtio-pci
[    3.479689] bus: 'virtio': add driver virtio_balloon
[    3.480735] bus: 'pci': add driver xen-platform-pci
[    3.481783] bus: 'platform': add driver reg-virt-consumer
[    3.482970] bus: 'platform': add driver reg-userspace-consumer
[    3.484292] device: 'ptyp0': device_add
[    3.485284] PM: Adding info for No Bus:ptyp0
[    3.486186] device: 'ptyp1': device_add
[    3.487262] PM: Adding info for No Bus:ptyp1
[    3.488198] device: 'ptyp2': device_add
[    3.489153] PM: Adding info for No Bus:ptyp2
[    3.490062] device: 'ptyp3': device_add
[    3.491103] PM: Adding info for No Bus:ptyp3
[    3.492081] device: 'ptyp4': device_add
[    3.493099] PM: Adding info for No Bus:ptyp4
[    3.493962] device: 'ptyp5': device_add
[    3.495046] PM: Adding info for No Bus:ptyp5
[    3.496045] device: 'ptyp6': device_add
[    3.497103] PM: Adding info for No Bus:ptyp6
[    3.497944] device: 'ptyp7': device_add
[    3.498977] PM: Adding info for No Bus:ptyp7
[    3.499884] device: 'ptyp8': device_add
[    3.501008] PM: Adding info for No Bus:ptyp8
[    3.501843] device: 'ptyp9': device_add
[    3.502840] PM: Adding info for No Bus:ptyp9
[    3.503764] device: 'ptypa': device_add
[    3.504839] PM: Adding info for No Bus:ptypa
[    3.505725] device: 'ptypb': device_add
[    3.506741] PM: Adding info for No Bus:ptypb
[    3.507673] device: 'ptypc': device_add
[    3.508672] PM: Adding info for No Bus:ptypc
[    3.509559] device: 'ptypd': device_add
[    3.510604] PM: Adding info for No Bus:ptypd
[    3.511511] device: 'ptype': device_add
[    3.512544] PM: Adding info for No Bus:ptype
[    3.513413] device: 'ptypf': device_add
[    3.514566] PM: Adding info for No Bus:ptypf
[    3.515513] device: 'ptyq0': device_add
[    3.516854] PM: Adding info for No Bus:ptyq0
[    3.517787] device: 'ptyq1': device_add
[    3.518781] PM: Adding info for No Bus:ptyq1
[    3.519623] device: 'ptyq2': device_add
[    3.520692] PM: Adding info for No Bus:ptyq2
[    3.521591] device: 'ptyq3': device_add
[    3.522495] PM: Adding info for No Bus:ptyq3
[    3.523269] device: 'ptyq4': device_add
[    3.524339] PM: Adding info for No Bus:ptyq4
[    3.525170] device: 'ptyq5': device_add
[    3.526184] PM: Adding info for No Bus:ptyq5
[    3.527133] device: 'ptyq6': device_add
[    3.528213] PM: Adding info for No Bus:ptyq6
[    3.529044] device: 'ptyq7': device_add
[    3.530036] PM: Adding info for No Bus:ptyq7
[    3.530905] device: 'ptyq8': device_add
[    3.531903] PM: Adding info for No Bus:ptyq8
[    3.532838] device: 'ptyq9': device_add
[    3.533872] PM: Adding info for No Bus:ptyq9
[    3.534810] device: 'ptyqa': device_add
[    3.535760] PM: Adding info for No Bus:ptyqa
[    3.536855] device: 'ptyqb': device_add
[    3.537895] PM: Adding info for No Bus:ptyqb
[    3.538742] device: 'ptyqc': device_add
[    3.539763] PM: Adding info for No Bus:ptyqc
[    3.540664] device: 'ptyqd': device_add
[    3.541672] PM: Adding info for No Bus:ptyqd
[    3.542501] device: 'ptyqe': device_add
[    3.543430] PM: Adding info for No Bus:ptyqe
[    3.544320] device: 'ptyqf': device_add
[    3.545421] PM: Adding info for No Bus:ptyqf
[    3.546277] device: 'ptyr0': device_add
[    3.547254] PM: Adding info for No Bus:ptyr0
[    3.548148] device: 'ptyr1': device_add
[    3.549090] PM: Adding info for No Bus:ptyr1
[    3.549953] device: 'ptyr2': device_add
[    3.551017] PM: Adding info for No Bus:ptyr2
[    3.551886] device: 'ptyr3': device_add
[    3.552970] PM: Adding info for No Bus:ptyr3
[    3.553825] device: 'ptyr4': device_add
[    3.554838] PM: Adding info for No Bus:ptyr4
[    3.555690] device: 'ptyr5': device_add
[    3.556744] PM: Adding info for No Bus:ptyr5
[    3.557560] device: 'ptyr6': device_add
[    3.558479] PM: Adding info for No Bus:ptyr6
[    3.559293] device: 'ptyr7': device_add
[    3.560328] PM: Adding info for No Bus:ptyr7
[    3.561138] device: 'ptyr8': device_add
[    3.562089] PM: Adding info for No Bus:ptyr8
[    3.562917] device: 'ptyr9': device_add
[    3.563897] PM: Adding info for No Bus:ptyr9
[    3.564738] device: 'ptyra': device_add
[    3.565747] PM: Adding info for No Bus:ptyra
[    3.566575] device: 'ptyrb': device_add
[    3.567719] PM: Adding info for No Bus:ptyrb
[    3.568639] device: 'ptyrc': device_add
[    3.569710] PM: Adding info for No Bus:ptyrc
[    3.570667] device: 'ptyrd': device_add
[    3.571742] PM: Adding info for No Bus:ptyrd
[    3.572657] device: 'ptyre': device_add
[    3.573679] PM: Adding info for No Bus:ptyre
[    3.574544] device: 'ptyrf': device_add
[    3.575604] PM: Adding info for No Bus:ptyrf
[    3.576599] device: 'ptys0': device_add
[    3.577625] PM: Adding info for No Bus:ptys0
[    3.578554] device: 'ptys1': device_add
[    3.579652] PM: Adding info for No Bus:ptys1
[    3.580549] device: 'ptys2': device_add
[    3.581587] PM: Adding info for No Bus:ptys2
[    3.582424] device: 'ptys3': device_add
[    3.583408] PM: Adding info for No Bus:ptys3
[    3.584258] device: 'ptys4': device_add
[    3.585374] PM: Adding info for No Bus:ptys4
[    3.586276] device: 'ptys5': device_add
[    3.587529] PM: Adding info for No Bus:ptys5
[    3.588411] device: 'ptys6': device_add
[    3.589469] PM: Adding info for No Bus:ptys6
[    3.590348] device: 'ptys7': device_add
[    3.591304] PM: Adding info for No Bus:ptys7
[    3.592208] device: 'ptys8': device_add
[    3.593161] PM: Adding info for No Bus:ptys8
[    3.593993] device: 'ptys9': device_add
[    3.594967] PM: Adding info for No Bus:ptys9
[    3.595937] device: 'ptysa': device_add
[    3.597014] PM: Adding info for No Bus:ptysa
[    3.597968] device: 'ptysb': device_add
[    3.599027] PM: Adding info for No Bus:ptysb
[    3.600050] device: 'ptysc': device_add
[    3.601045] PM: Adding info for No Bus:ptysc
[    3.601877] device: 'ptysd': device_add
[    3.602885] PM: Adding info for No Bus:ptysd
[    3.603819] device: 'ptyse': device_add
[    3.604948] PM: Adding info for No Bus:ptyse
[    3.605782] device: 'ptysf': device_add
[    3.606795] PM: Adding info for No Bus:ptysf
[    3.607671] device: 'ptyt0': device_add
[    3.608819] PM: Adding info for No Bus:ptyt0
[    3.609720] device: 'ptyt1': device_add
[    3.610826] PM: Adding info for No Bus:ptyt1
[    3.611660] device: 'ptyt2': device_add
[    3.612629] PM: Adding info for No Bus:ptyt2
[    3.613505] device: 'ptyt3': device_add
[    3.614632] PM: Adding info for No Bus:ptyt3
[    3.615538] device: 'ptyt4': device_add
[    3.616642] PM: Adding info for No Bus:ptyt4
[    3.617640] device: 'ptyt5': device_add
[    3.618703] PM: Adding info for No Bus:ptyt5
[    3.619566] device: 'ptyt6': device_add
[    3.620665] PM: Adding info for No Bus:ptyt6
[    3.621575] device: 'ptyt7': device_add
[    3.622644] PM: Adding info for No Bus:ptyt7
[    3.623529] device: 'ptyt8': device_add
[    3.624630] PM: Adding info for No Bus:ptyt8
[    3.625501] device: 'ptyt9': device_add
[    3.626569] PM: Adding info for No Bus:ptyt9
[    3.627615] device: 'ptyta': device_add
[    3.628683] PM: Adding info for No Bus:ptyta
[    3.629569] device: 'ptytb': device_add
[    3.630598] PM: Adding info for No Bus:ptytb
[    3.631451] device: 'ptytc': device_add
[    3.632475] PM: Adding info for No Bus:ptytc
[    3.633360] device: 'ptytd': device_add
[    3.634417] PM: Adding info for No Bus:ptytd
[    3.635312] device: 'ptyte': device_add
[    3.636359] PM: Adding info for No Bus:ptyte
[    3.637224] device: 'ptytf': device_add
[    3.638282] PM: Adding info for No Bus:ptytf
[    3.639150] device: 'ptyu0': device_add
[    3.640253] PM: Adding info for No Bus:ptyu0
[    3.641207] device: 'ptyu1': device_add
[    3.642263] PM: Adding info for No Bus:ptyu1
[    3.643130] device: 'ptyu2': device_add
[    3.644121] PM: Adding info for No Bus:ptyu2
[    3.644965] device: 'ptyu3': device_add
[    3.646051] PM: Adding info for No Bus:ptyu3
[    3.646993] device: 'ptyu4': device_add
[    3.648147] PM: Adding info for No Bus:ptyu4
[    3.649062] device: 'ptyu5': device_add
[    3.650158] PM: Adding info for No Bus:ptyu5
[    3.651083] device: 'ptyu6': device_add
[    3.652201] PM: Adding info for No Bus:ptyu6
[    3.653125] device: 'ptyu7': device_add
[    3.654090] PM: Adding info for No Bus:ptyu7
[    3.654914] device: 'ptyu8': device_add
[    3.655869] PM: Adding info for No Bus:ptyu8
[    3.656674] device: 'ptyu9': device_add
[    3.657706] PM: Adding info for No Bus:ptyu9
[    3.658596] device: 'ptyua': device_add
[    3.659696] PM: Adding info for No Bus:ptyua
[    3.660661] device: 'ptyub': device_add
[    3.661844] PM: Adding info for No Bus:ptyub
[    3.662780] device: 'ptyuc': device_add
[    3.663874] PM: Adding info for No Bus:ptyuc
[    3.664815] device: 'ptyud': device_add
[    3.665731] PM: Adding info for No Bus:ptyud
[    3.666590] device: 'ptyue': device_add
[    3.667618] PM: Adding info for No Bus:ptyue
[    3.668480] device: 'ptyuf': device_add
[    3.669472] PM: Adding info for No Bus:ptyuf
[    3.670360] device: 'ptyv0': device_add
[    3.671385] PM: Adding info for No Bus:ptyv0
[    3.672295] device: 'ptyv1': device_add
[    3.673356] PM: Adding info for No Bus:ptyv1
[    3.674247] device: 'ptyv2': device_add
[    3.675316] PM: Adding info for No Bus:ptyv2
[    3.676190] device: 'ptyv3': device_add
[    3.677223] PM: Adding info for No Bus:ptyv3
[    3.678120] device: 'ptyv4': device_add
[    3.679198] PM: Adding info for No Bus:ptyv4
[    3.680110] device: 'ptyv5': device_add
[    3.681248] PM: Adding info for No Bus:ptyv5
[    3.682225] device: 'ptyv6': device_add
[    3.683275] PM: Adding info for No Bus:ptyv6
[    3.684167] device: 'ptyv7': device_add
[    3.685211] PM: Adding info for No Bus:ptyv7
[    3.686029] device: 'ptyv8': device_add
[    3.687104] PM: Adding info for No Bus:ptyv8
[    3.688003] device: 'ptyv9': device_add
[    3.688993] PM: Adding info for No Bus:ptyv9
[    3.689868] device: 'ptyva': device_add
[    3.690889] PM: Adding info for No Bus:ptyva
[    3.691778] device: 'ptyvb': device_add
[    3.692883] PM: Adding info for No Bus:ptyvb
[    3.693782] device: 'ptyvc': device_add
[    3.694867] PM: Adding info for No Bus:ptyvc
[    3.695735] device: 'ptyvd': device_add
[    3.696957] PM: Adding info for No Bus:ptyvd
[    3.697940] device: 'ptyve': device_add
[    3.698988] PM: Adding info for No Bus:ptyve
[    3.699867] device: 'ptyvf': device_add
[    3.701064] PM: Adding info for No Bus:ptyvf
[    3.702042] device: 'ptyw0': device_add
[    3.703153] PM: Adding info for No Bus:ptyw0
[    3.704078] device: 'ptyw1': device_add
[    3.705313] PM: Adding info for No Bus:ptyw1
[    3.706321] device: 'ptyw2': device_add
[    3.707422] PM: Adding info for No Bus:ptyw2
[    3.708358] device: 'ptyw3': device_add
[    3.709421] PM: Adding info for No Bus:ptyw3
[    3.710320] device: 'ptyw4': device_add
[    3.711382] PM: Adding info for No Bus:ptyw4
[    3.712320] device: 'ptyw5': device_add
[    3.713419] PM: Adding info for No Bus:ptyw5
[    3.714390] device: 'ptyw6': device_add
[    3.715561] PM: Adding info for No Bus:ptyw6
[    3.716568] device: 'ptyw7': device_add
[    3.717570] PM: Adding info for No Bus:ptyw7
[    3.718387] device: 'ptyw8': device_add
[    3.719372] PM: Adding info for No Bus:ptyw8
[    3.720226] device: 'ptyw9': device_add
[    3.721339] PM: Adding info for No Bus:ptyw9
[    3.722258] device: 'ptywa': device_add
[    3.723295] PM: Adding info for No Bus:ptywa
[    3.724153] device: 'ptywb': device_add
[    3.725275] PM: Adding info for No Bus:ptywb
[    3.726206] device: 'ptywc': device_add
[    3.727339] PM: Adding info for No Bus:ptywc
[    3.728353] device: 'ptywd': device_add
[    3.729386] PM: Adding info for No Bus:ptywd
[    3.730193] device: 'ptywe': device_add
[    3.731170] PM: Adding info for No Bus:ptywe
[    3.732036] device: 'ptywf': device_add
[    3.733088] PM: Adding info for No Bus:ptywf
[    3.733992] device: 'ptyx0': device_add
[    3.735048] PM: Adding info for No Bus:ptyx0
[    3.736027] device: 'ptyx1': device_add
[    3.737118] PM: Adding info for No Bus:ptyx1
[    3.738095] device: 'ptyx2': device_add
[    3.739057] PM: Adding info for No Bus:ptyx2
[    3.739888] device: 'ptyx3': device_add
[    3.740814] PM: Adding info for No Bus:ptyx3
[    3.741679] device: 'ptyx4': device_add
[    3.742724] PM: Adding info for No Bus:ptyx4
[    3.743626] device: 'ptyx5': device_add
[    3.744740] PM: Adding info for No Bus:ptyx5
[    3.745622] device: 'ptyx6': device_add
[    3.746572] PM: Adding info for No Bus:ptyx6
[    3.747394] device: 'ptyx7': device_add
[    3.748512] PM: Adding info for No Bus:ptyx7
[    3.749353] device: 'ptyx8': device_add
[    3.750469] PM: Adding info for No Bus:ptyx8
[    3.751341] device: 'ptyx9': device_add
[    3.752430] PM: Adding info for No Bus:ptyx9
[    3.753259] device: 'ptyxa': device_add
[    3.754227] PM: Adding info for No Bus:ptyxa
[    3.755077] device: 'ptyxb': device_add
[    3.756217] PM: Adding info for No Bus:ptyxb
[    3.757059] device: 'ptyxc': device_add
[    3.758120] PM: Adding info for No Bus:ptyxc
[    3.758995] device: 'ptyxd': device_add
[    3.760110] PM: Adding info for No Bus:ptyxd
[    3.760951] device: 'ptyxe': device_add
[    3.761867] PM: Adding info for No Bus:ptyxe
[    3.762691] device: 'ptyxf': device_add
[    3.763632] PM: Adding info for No Bus:ptyxf
[    3.764412] device: 'ptyy0': device_add
[    3.765531] PM: Adding info for No Bus:ptyy0
[    3.766402] device: 'ptyy1': device_add
[    3.767424] PM: Adding info for No Bus:ptyy1
[    3.768397] device: 'ptyy2': device_add
[    3.769443] PM: Adding info for No Bus:ptyy2
[    3.770355] device: 'ptyy3': device_add
[    3.771494] PM: Adding info for No Bus:ptyy3
[    3.772144] device: 'ptyy4': device_add
[    3.772886] PM: Adding info for No Bus:ptyy4
[    3.773501] device: 'ptyy5': device_add
[    3.774211] PM: Adding info for No Bus:ptyy5
[    3.774818] device: 'ptyy6': device_add
[    3.775527] PM: Adding info for No Bus:ptyy6
[    3.776146] device: 'ptyy7': device_add
[    3.776862] PM: Adding info for No Bus:ptyy7
[    3.777504] device: 'ptyy8': device_add
[    3.778613] PM: Adding info for No Bus:ptyy8
[    3.779655] device: 'ptyy9': device_add
[    3.780790] PM: Adding info for No Bus:ptyy9
[    3.781749] device: 'ptyya': device_add
[    3.782886] PM: Adding info for No Bus:ptyya
[    3.783896] device: 'ptyyb': device_add
[    3.785044] PM: Adding info for No Bus:ptyyb
[    3.785996] device: 'ptyyc': device_add
[    3.787042] PM: Adding info for No Bus:ptyyc
[    3.788002] device: 'ptyyd': device_add
[    3.789045] PM: Adding info for No Bus:ptyyd
[    3.789957] device: 'ptyye': device_add
[    3.790949] PM: Adding info for No Bus:ptyye
[    3.791929] device: 'ptyyf': device_add
[    3.793072] PM: Adding info for No Bus:ptyyf
[    3.794033] device: 'ptyz0': device_add
[    3.795132] PM: Adding info for No Bus:ptyz0
[    3.796072] device: 'ptyz1': device_add
[    3.797246] PM: Adding info for No Bus:ptyz1
[    3.798247] device: 'ptyz2': device_add
[    3.799438] PM: Adding info for No Bus:ptyz2
[    3.800450] device: 'ptyz3': device_add
[    3.801640] PM: Adding info for No Bus:ptyz3
[    3.802660] device: 'ptyz4': device_add
[    3.803776] PM: Adding info for No Bus:ptyz4
[    3.804769] device: 'ptyz5': device_add
[    3.805828] PM: Adding info for No Bus:ptyz5
[    3.806799] device: 'ptyz6': device_add
[    3.808023] PM: Adding info for No Bus:ptyz6
[    3.808982] device: 'ptyz7': device_add
[    3.810131] PM: Adding info for No Bus:ptyz7
[    3.811152] device: 'ptyz8': device_add
[    3.812272] PM: Adding info for No Bus:ptyz8
[    3.813230] device: 'ptyz9': device_add
[    3.814436] PM: Adding info for No Bus:ptyz9
[    3.815456] device: 'ptyza': device_add
[    3.816649] PM: Adding info for No Bus:ptyza
[    3.817700] device: 'ptyzb': device_add
[    3.818847] PM: Adding info for No Bus:ptyzb
[    3.819859] device: 'ptyzc': device_add
[    3.821046] PM: Adding info for No Bus:ptyzc
[    3.821964] device: 'ptyzd': device_add
[    3.823159] PM: Adding info for No Bus:ptyzd
[    3.824200] device: 'ptyze': device_add
[    3.825321] PM: Adding info for No Bus:ptyze
[    3.826286] device: 'ptyzf': device_add
[    3.827392] PM: Adding info for No Bus:ptyzf
[    3.828458] device: 'ptya0': device_add
[    3.829635] PM: Adding info for No Bus:ptya0
[    3.830559] device: 'ptya1': device_add
[    3.831641] PM: Adding info for No Bus:ptya1
[    3.832598] device: 'ptya2': device_add
[    3.833573] PM: Adding info for No Bus:ptya2
[    3.834584] device: 'ptya3': device_add
[    3.835769] PM: Adding info for No Bus:ptya3
[    3.836811] device: 'ptya4': device_add
[    3.838003] PM: Adding info for No Bus:ptya4
[    3.838994] device: 'ptya5': device_add
[    3.840138] PM: Adding info for No Bus:ptya5
[    3.841062] device: 'ptya6': device_add
[    3.842119] PM: Adding info for No Bus:ptya6
[    3.843128] device: 'ptya7': device_add
[    3.844307] PM: Adding info for No Bus:ptya7
[    3.845198] device: 'ptya8': device_add
[    3.846374] PM: Adding info for No Bus:ptya8
[    3.847354] device: 'ptya9': device_add
[    3.848603] PM: Adding info for No Bus:ptya9
[    3.849565] device: 'ptyaa': device_add
[    3.850687] PM: Adding info for No Bus:ptyaa
[    3.851617] device: 'ptyab': device_add
[    3.852686] PM: Adding info for No Bus:ptyab
[    3.853622] device: 'ptyac': device_add
[    3.854739] PM: Adding info for No Bus:ptyac
[    3.855769] device: 'ptyad': device_add
[    3.856898] PM: Adding info for No Bus:ptyad
[    3.857900] device: 'ptyae': device_add
[    3.858947] PM: Adding info for No Bus:ptyae
[    3.859870] device: 'ptyaf': device_add
[    3.860985] PM: Adding info for No Bus:ptyaf
[    3.861917] device: 'ptyb0': device_add
[    3.863112] PM: Adding info for No Bus:ptyb0
[    3.864108] device: 'ptyb1': device_add
[    3.865203] PM: Adding info for No Bus:ptyb1
[    3.866193] device: 'ptyb2': device_add
[    3.867361] PM: Adding info for No Bus:ptyb2
[    3.868384] device: 'ptyb3': device_add
[    3.869438] PM: Adding info for No Bus:ptyb3
[    3.870288] device: 'ptyb4': device_add
[    3.871317] PM: Adding info for No Bus:ptyb4
[    3.872254] device: 'ptyb5': device_add
[    3.873321] PM: Adding info for No Bus:ptyb5
[    3.874256] device: 'ptyb6': device_add
[    3.875333] PM: Adding info for No Bus:ptyb6
[    3.876324] device: 'ptyb7': device_add
[    3.877371] PM: Adding info for No Bus:ptyb7
[    3.878313] device: 'ptyb8': device_add
[    3.879331] PM: Adding info for No Bus:ptyb8
[    3.880394] device: 'ptyb9': device_add
[    3.881417] PM: Adding info for No Bus:ptyb9
[    3.882479] device: 'ptyba': device_add
[    3.883631] PM: Adding info for No Bus:ptyba
[    3.884657] device: 'ptybb': device_add
[    3.885753] PM: Adding info for No Bus:ptybb
[    3.886859] device: 'ptybc': device_add
[    3.887980] PM: Adding info for No Bus:ptybc
[    3.889042] device: 'ptybd': device_add
[    3.890169] PM: Adding info for No Bus:ptybd
[    3.891148] device: 'ptybe': device_add
[    3.892325] PM: Adding info for No Bus:ptybe
[    3.893238] device: 'ptybf': device_add
[    3.894391] PM: Adding info for No Bus:ptybf
[    3.895434] device: 'ptyc0': device_add
[    3.896463] PM: Adding info for No Bus:ptyc0
[    3.897310] device: 'ptyc1': device_add
[    3.898380] PM: Adding info for No Bus:ptyc1
[    3.899405] device: 'ptyc2': device_add
[    3.900544] PM: Adding info for No Bus:ptyc2
[    3.901556] device: 'ptyc3': device_add
[    3.902736] PM: Adding info for No Bus:ptyc3
[    3.903737] device: 'ptyc4': device_add
[    3.905005] PM: Adding info for No Bus:ptyc4
[    3.906017] device: 'ptyc5': device_add
[    3.907117] PM: Adding info for No Bus:ptyc5
[    3.908248] device: 'ptyc6': device_add
[    3.909448] PM: Adding info for No Bus:ptyc6
[    3.910540] device: 'ptyc7': device_add
[    3.911716] PM: Adding info for No Bus:ptyc7
[    3.912799] device: 'ptyc8': device_add
[    3.913857] PM: Adding info for No Bus:ptyc8
[    3.914837] device: 'ptyc9': device_add
[    3.915928] PM: Adding info for No Bus:ptyc9
[    3.916961] device: 'ptyca': device_add
[    3.918170] PM: Adding info for No Bus:ptyca
[    3.919180] device: 'ptycb': device_add
[    3.920343] PM: Adding info for No Bus:ptycb
[    3.921217] device: 'ptycc': device_add
[    3.922199] PM: Adding info for No Bus:ptycc
[    3.923150] device: 'ptycd': device_add
[    3.924304] PM: Adding info for No Bus:ptycd
[    3.925326] device: 'ptyce': device_add
[    3.926447] PM: Adding info for No Bus:ptyce
[    3.927426] device: 'ptycf': device_add
[    3.928757] PM: Adding info for No Bus:ptycf
[    3.929820] device: 'ptyd0': device_add
[    3.930954] PM: Adding info for No Bus:ptyd0
[    3.931920] device: 'ptyd1': device_add
[    3.933060] PM: Adding info for No Bus:ptyd1
[    3.934137] device: 'ptyd2': device_add
[    3.935282] PM: Adding info for No Bus:ptyd2
[    3.936384] device: 'ptyd3': device_add
[    3.937491] PM: Adding info for No Bus:ptyd3
[    3.938505] device: 'ptyd4': device_add
[    3.939568] PM: Adding info for No Bus:ptyd4
[    3.940567] device: 'ptyd5': device_add
[    3.941727] PM: Adding info for No Bus:ptyd5
[    3.942692] device: 'ptyd6': device_add
[    3.943741] PM: Adding info for No Bus:ptyd6
[    3.944667] device: 'ptyd7': device_add
[    3.945745] PM: Adding info for No Bus:ptyd7
[    3.946600] device: 'ptyd8': device_add
[    3.947646] PM: Adding info for No Bus:ptyd8
[    3.948442] device: 'ptyd9': device_add
[    3.949666] PM: Adding info for No Bus:ptyd9
[    3.950648] device: 'ptyda': device_add
[    3.951729] PM: Adding info for No Bus:ptyda
[    3.952679] device: 'ptydb': device_add
[    3.953700] PM: Adding info for No Bus:ptydb
[    3.954608] device: 'ptydc': device_add
[    3.955702] PM: Adding info for No Bus:ptydc
[    3.956625] device: 'ptydd': device_add
[    3.957661] PM: Adding info for No Bus:ptydd
[    3.958596] device: 'ptyde': device_add
[    3.959556] PM: Adding info for No Bus:ptyde
[    3.960410] device: 'ptydf': device_add
[    3.961375] PM: Adding info for No Bus:ptydf
[    3.962276] device: 'ptye0': device_add
[    3.963290] PM: Adding info for No Bus:ptye0
[    3.964204] device: 'ptye1': device_add
[    3.965268] PM: Adding info for No Bus:ptye1
[    3.966157] device: 'ptye2': device_add
[    3.967212] PM: Adding info for No Bus:ptye2
[    3.968173] device: 'ptye3': device_add
[    3.969197] PM: Adding info for No Bus:ptye3
[    3.970008] device: 'ptye4': device_add
[    3.971032] PM: Adding info for No Bus:ptye4
[    3.971844] device: 'ptye5': device_add
[    3.972882] PM: Adding info for No Bus:ptye5
[    3.973762] device: 'ptye6': device_add
[    3.974857] PM: Adding info for No Bus:ptye6
[    3.975728] device: 'ptye7': device_add
[    3.976851] PM: Adding info for No Bus:ptye7
[    3.977723] device: 'ptye8': device_add
[    3.978832] PM: Adding info for No Bus:ptye8
[    3.979771] device: 'ptye9': device_add
[    3.980824] PM: Adding info for No Bus:ptye9
[    3.981729] device: 'ptyea': device_add
[    3.982715] PM: Adding info for No Bus:ptyea
[    3.983568] device: 'ptyeb': device_add
[    3.984696] PM: Adding info for No Bus:ptyeb
[    3.985650] device: 'ptyec': device_add
[    3.986686] PM: Adding info for No Bus:ptyec
[    3.987623] device: 'ptyed': device_add
[    3.988754] PM: Adding info for No Bus:ptyed
[    3.989656] device: 'ptyee': device_add
[    3.990743] PM: Adding info for No Bus:ptyee
[    3.991652] device: 'ptyef': device_add
[    3.992710] PM: Adding info for No Bus:ptyef
[    3.993576] device: 'ttyp0': device_add
[    3.994510] PM: Adding info for No Bus:ttyp0
[    3.995341] device: 'ttyp1': device_add
[    3.996381] PM: Adding info for No Bus:ttyp1
[    3.997317] device: 'ttyp2': device_add
[    3.998356] PM: Adding info for No Bus:ttyp2
[    3.999237] device: 'ttyp3': device_add
[    4.000387] PM: Adding info for No Bus:ttyp3
[    4.001305] device: 'ttyp4': device_add
[    4.002288] PM: Adding info for No Bus:ttyp4
[    4.003113] device: 'ttyp5': device_add
[    4.004218] PM: Adding info for No Bus:ttyp5
[    4.005193] device: 'ttyp6': device_add
[    4.006255] PM: Adding info for No Bus:ttyp6
[    4.007080] device: 'ttyp7': device_add
[    4.008166] PM: Adding info for No Bus:ttyp7
[    4.009031] device: 'ttyp8': device_add
[    4.010090] PM: Adding info for No Bus:ttyp8
[    4.011009] device: 'ttyp9': device_add
[    4.012037] PM: Adding info for No Bus:ttyp9
[    4.012900] device: 'ttypa': device_add
[    4.013987] PM: Adding info for No Bus:ttypa
[    4.014914] device: 'ttypb': device_add
[    4.016095] PM: Adding info for No Bus:ttypb
[    4.017038] device: 'ttypc': device_add
[    4.018166] PM: Adding info for No Bus:ttypc
[    4.019091] device: 'ttypd': device_add
[    4.020248] PM: Adding info for No Bus:ttypd
[    4.021182] device: 'ttype': device_add
[    4.022302] PM: Adding info for No Bus:ttype
[    4.023219] device: 'ttypf': device_add
[    4.024316] PM: Adding info for No Bus:ttypf
[    4.025247] device: 'ttyq0': device_add
[    4.026381] PM: Adding info for No Bus:ttyq0
[    4.027316] device: 'ttyq1': device_add
[    4.028438] PM: Adding info for No Bus:ttyq1
[    4.029425] device: 'ttyq2': device_add
[    4.030568] PM: Adding info for No Bus:ttyq2
[    4.031621] device: 'ttyq3': device_add
[    4.032751] PM: Adding info for No Bus:ttyq3
[    4.033691] device: 'ttyq4': device_add
[    4.034793] PM: Adding info for No Bus:ttyq4
[    4.035763] device: 'ttyq5': device_add
[    4.036875] PM: Adding info for No Bus:ttyq5
[    4.037867] device: 'ttyq6': device_add
[    4.038822] PM: Adding info for No Bus:ttyq6
[    4.039741] device: 'ttyq7': device_add
[    4.040935] PM: Adding info for No Bus:ttyq7
[    4.041859] device: 'ttyq8': device_add
[    4.042893] PM: Adding info for No Bus:ttyq8
[    4.043787] device: 'ttyq9': device_add
[    4.044788] PM: Adding info for No Bus:ttyq9
[    4.045721] device: 'ttyqa': device_add
[    4.046763] PM: Adding info for No Bus:ttyqa
[    4.047718] device: 'ttyqb': device_add
[    4.048688] PM: Adding info for No Bus:ttyqb
[    4.049603] device: 'ttyqc': device_add
[    4.050676] PM: Adding info for No Bus:ttyqc
[    4.051587] device: 'ttyqd': device_add
[    4.052679] PM: Adding info for No Bus:ttyqd
[    4.053610] device: 'ttyqe': device_add
[    4.054708] PM: Adding info for No Bus:ttyqe
[    4.055629] device: 'ttyqf': device_add
[    4.056678] PM: Adding info for No Bus:ttyqf
[    4.057499] device: 'ttyr0': device_add
[    4.058634] PM: Adding info for No Bus:ttyr0
[    4.059512] device: 'ttyr1': device_add
[    4.060544] PM: Adding info for No Bus:ttyr1
[    4.061378] device: 'ttyr2': device_add
[    4.062307] PM: Adding info for No Bus:ttyr2
[    4.063133] device: 'ttyr3': device_add
[    4.064095] PM: Adding info for No Bus:ttyr3
[    4.065026] device: 'ttyr4': device_add
[    4.066134] PM: Adding info for No Bus:ttyr4
[    4.067046] device: 'ttyr5': device_add
[    4.068312] PM: Adding info for No Bus:ttyr5
[    4.069330] device: 'ttyr6': device_add
[    4.070450] PM: Adding info for No Bus:ttyr6
[    4.071385] device: 'ttyr7': device_add
[    4.072425] PM: Adding info for No Bus:ttyr7
[    4.073273] device: 'ttyr8': device_add
[    4.074318] PM: Adding info for No Bus:ttyr8
[    4.075205] device: 'ttyr9': device_add
[    4.076317] PM: Adding info for No Bus:ttyr9
[    4.077266] device: 'ttyra': device_add
[    4.078368] PM: Adding info for No Bus:ttyra
[    4.079242] device: 'ttyrb': device_add
[    4.080353] PM: Adding info for No Bus:ttyrb
[    4.081227] device: 'ttyrc': device_add
[    4.082170] PM: Adding info for No Bus:ttyrc
[    4.083015] device: 'ttyrd': device_add
[    4.084190] PM: Adding info for No Bus:ttyrd
[    4.085136] device: 'ttyre': device_add
[    4.086155] PM: Adding info for No Bus:ttyre
[    4.086994] device: 'ttyrf': device_add
[    4.088246] PM: Adding info for No Bus:ttyrf
[    4.089077] device: 'ttys0': device_add
[    4.090027] PM: Adding info for No Bus:ttys0
[    4.090832] device: 'ttys1': device_add
[    4.091843] PM: Adding info for No Bus:ttys1
[    4.092778] device: 'ttys2': device_add
[    4.093818] PM: Adding info for No Bus:ttys2
[    4.094634] device: 'ttys3': device_add
[    4.095557] PM: Adding info for No Bus:ttys3
[    4.096399] device: 'ttys4': device_add
[    4.097369] PM: Adding info for No Bus:ttys4
[    4.098266] device: 'ttys5': device_add
[    4.099245] PM: Adding info for No Bus:ttys5
[    4.100223] device: 'ttys6': device_add
[    4.101194] PM: Adding info for No Bus:ttys6
[    4.102042] device: 'ttys7': device_add
[    4.103009] PM: Adding info for No Bus:ttys7
[    4.103928] device: 'ttys8': device_add
[    4.104999] PM: Adding info for No Bus:ttys8
[    4.105911] device: 'ttys9': device_add
[    4.106980] PM: Adding info for No Bus:ttys9
[    4.107929] device: 'ttysa': device_add
[    4.109039] PM: Adding info for No Bus:ttysa
[    4.109842] device: 'ttysb': device_add
[    4.110824] PM: Adding info for No Bus:ttysb
[    4.111732] device: 'ttysc': device_add
[    4.112832] PM: Adding info for No Bus:ttysc
[    4.113684] device: 'ttysd': device_add
[    4.114649] PM: Adding info for No Bus:ttysd
[    4.115489] device: 'ttyse': device_add
[    4.116525] PM: Adding info for No Bus:ttyse
[    4.117422] device: 'ttysf': device_add
[    4.118451] PM: Adding info for No Bus:ttysf
[    4.119315] device: 'ttyt0': device_add
[    4.120443] PM: Adding info for No Bus:ttyt0
[    4.121362] device: 'ttyt1': device_add
[    4.122434] PM: Adding info for No Bus:ttyt1
[    4.123464] device: 'ttyt2': device_add
[    4.124561] PM: Adding info for No Bus:ttyt2
[    4.125435] device: 'ttyt3': device_add
[    4.126439] PM: Adding info for No Bus:ttyt3
[    4.127389] device: 'ttyt4': device_add
[    4.128535] PM: Adding info for No Bus:ttyt4
[    4.129372] device: 'ttyt5': device_add
[    4.130409] PM: Adding info for No Bus:ttyt5
[    4.131289] device: 'ttyt6': device_add
[    4.132362] PM: Adding info for No Bus:ttyt6
[    4.133215] device: 'ttyt7': device_add
[    4.134170] PM: Adding info for No Bus:ttyt7
[    4.135049] device: 'ttyt8': device_add
[    4.136045] PM: Adding info for No Bus:ttyt8
[    4.136967] device: 'ttyt9': device_add
[    4.138026] PM: Adding info for No Bus:ttyt9
[    4.138918] device: 'ttyta': device_add
[    4.139934] PM: Adding info for No Bus:ttyta
[    4.140937] device: 'ttytb': device_add
[    4.141990] PM: Adding info for No Bus:ttytb
[    4.142821] device: 'ttytc': device_add
[    4.143807] PM: Adding info for No Bus:ttytc
[    4.144830] device: 'ttytd': device_add
[    4.145970] PM: Adding info for No Bus:ttytd
[    4.146883] device: 'ttyte': device_add
[    4.148042] PM: Adding info for No Bus:ttyte
[    4.148950] device: 'ttytf': device_add
[    4.149905] PM: Adding info for No Bus:ttytf
[    4.150776] device: 'ttyu0': device_add
[    4.151760] PM: Adding info for No Bus:ttyu0
[    4.152689] device: 'ttyu1': device_add
[    4.153668] PM: Adding info for No Bus:ttyu1
[    4.154497] device: 'ttyu2': device_add
[    4.155430] PM: Adding info for No Bus:ttyu2
[    4.156287] device: 'ttyu3': device_add
[    4.157286] PM: Adding info for No Bus:ttyu3
[    4.158146] device: 'ttyu4': device_add
[    4.159120] PM: Adding info for No Bus:ttyu4
[    4.159992] device: 'ttyu5': device_add
[    4.161021] PM: Adding info for No Bus:ttyu5
[    4.161848] device: 'ttyu6': device_add
[    4.162793] PM: Adding info for No Bus:ttyu6
[    4.163676] device: 'ttyu7': device_add
[    4.164705] PM: Adding info for No Bus:ttyu7
[    4.165578] device: 'ttyu8': device_add
[    4.166608] PM: Adding info for No Bus:ttyu8
[    4.167492] device: 'ttyu9': device_add
[    4.168536] PM: Adding info for No Bus:ttyu9
[    4.169426] device: 'ttyua': device_add
[    4.170395] PM: Adding info for No Bus:ttyua
[    4.171248] device: 'ttyub': device_add
[    4.172224] PM: Adding info for No Bus:ttyub
[    4.173122] device: 'ttyuc': device_add
[    4.174176] PM: Adding info for No Bus:ttyuc
[    4.175081] device: 'ttyud': device_add
[    4.176224] PM: Adding info for No Bus:ttyud
[    4.177130] device: 'ttyue': device_add
[    4.178184] PM: Adding info for No Bus:ttyue
[    4.179038] device: 'ttyuf': device_add
[    4.180113] PM: Adding info for No Bus:ttyuf
[    4.181001] device: 'ttyv0': device_add
[    4.182089] PM: Adding info for No Bus:ttyv0
[    4.182936] device: 'ttyv1': device_add
[    4.184120] PM: Adding info for No Bus:ttyv1
[    4.185002] device: 'ttyv2': device_add
[    4.186046] PM: Adding info for No Bus:ttyv2
[    4.186893] device: 'ttyv3': device_add
[    4.187899] PM: Adding info for No Bus:ttyv3
[    4.188753] device: 'ttyv4': device_add
[    4.189784] PM: Adding info for No Bus:ttyv4
[    4.190679] device: 'ttyv5': device_add
[    4.191716] PM: Adding info for No Bus:ttyv5
[    4.192613] device: 'ttyv6': device_add
[    4.193539] PM: Adding info for No Bus:ttyv6
[    4.194353] device: 'ttyv7': device_add
[    4.195286] PM: Adding info for No Bus:ttyv7
[    4.196122] device: 'ttyv8': device_add
[    4.197146] PM: Adding info for No Bus:ttyv8
[    4.198096] device: 'ttyv9': device_add
[    4.199193] PM: Adding info for No Bus:ttyv9
[    4.199979] device: 'ttyva': device_add
[    4.200909] PM: Adding info for No Bus:ttyva
[    4.201680] device: 'ttyvb': device_add
[    4.202682] PM: Adding info for No Bus:ttyvb
[    4.203594] device: 'ttyvc': device_add
[    4.204661] PM: Adding info for No Bus:ttyvc
[    4.205455] device: 'ttyvd': device_add
[    4.206485] PM: Adding info for No Bus:ttyvd
[    4.207398] device: 'ttyve': device_add
[    4.208479] PM: Adding info for No Bus:ttyve
[    4.209405] device: 'ttyvf': device_add
[    4.210550] PM: Adding info for No Bus:ttyvf
[    4.211462] device: 'ttyw0': device_add
[    4.212516] PM: Adding info for No Bus:ttyw0
[    4.213475] device: 'ttyw1': device_add
[    4.214538] PM: Adding info for No Bus:ttyw1
[    4.215491] device: 'ttyw2': device_add
[    4.216538] PM: Adding info for No Bus:ttyw2
[    4.217476] device: 'ttyw3': device_add
[    4.218583] PM: Adding info for No Bus:ttyw3
[    4.219465] device: 'ttyw4': device_add
[    4.220574] PM: Adding info for No Bus:ttyw4
[    4.221493] device: 'ttyw5': device_add
[    4.222539] PM: Adding info for No Bus:ttyw5
[    4.223489] device: 'ttyw6': device_add
[    4.224589] PM: Adding info for No Bus:ttyw6
[    4.225502] device: 'ttyw7': device_add
[    4.226615] PM: Adding info for No Bus:ttyw7
[    4.227588] device: 'ttyw8': device_add
[    4.228670] PM: Adding info for No Bus:ttyw8
[    4.229609] device: 'ttyw9': device_add
[    4.230666] PM: Adding info for No Bus:ttyw9
[    4.231595] device: 'ttywa': device_add
[    4.232689] PM: Adding info for No Bus:ttywa
[    4.233616] device: 'ttywb': device_add
[    4.234708] PM: Adding info for No Bus:ttywb
[    4.235633] device: 'ttywc': device_add
[    4.236737] PM: Adding info for No Bus:ttywc
[    4.237701] device: 'ttywd': device_add
[    4.238682] PM: Adding info for No Bus:ttywd
[    4.239648] device: 'ttywe': device_add
[    4.240750] PM: Adding info for No Bus:ttywe
[    4.241718] device: 'ttywf': device_add
[    4.242758] PM: Adding info for No Bus:ttywf
[    4.243715] device: 'ttyx0': device_add
[    4.244877] PM: Adding info for No Bus:ttyx0
[    4.245810] device: 'ttyx1': device_add
[    4.246926] PM: Adding info for No Bus:ttyx1
[    4.247867] device: 'ttyx2': device_add
[    4.248917] PM: Adding info for No Bus:ttyx2
[    4.249943] device: 'ttyx3': device_add
[    4.251046] PM: Adding info for No Bus:ttyx3
[    4.251932] device: 'ttyx4': device_add
[    4.253130] PM: Adding info for No Bus:ttyx4
[    4.254044] device: 'ttyx5': device_add
[    4.255103] PM: Adding info for No Bus:ttyx5
[    4.255961] device: 'ttyx6': device_add
[    4.256936] PM: Adding info for No Bus:ttyx6
[    4.257888] device: 'ttyx7': device_add
[    4.258920] PM: Adding info for No Bus:ttyx7
[    4.259733] device: 'ttyx8': device_add
[    4.260698] PM: Adding info for No Bus:ttyx8
[    4.261521] device: 'ttyx9': device_add
[    4.262564] PM: Adding info for No Bus:ttyx9
[    4.263492] device: 'ttyxa': device_add
[    4.264617] PM: Adding info for No Bus:ttyxa
[    4.265522] device: 'ttyxb': device_add
[    4.266527] PM: Adding info for No Bus:ttyxb
[    4.267422] device: 'ttyxc': device_add
[    4.268507] PM: Adding info for No Bus:ttyxc
[    4.269346] device: 'ttyxd': device_add
[    4.270387] PM: Adding info for No Bus:ttyxd
[    4.271302] device: 'ttyxe': device_add
[    4.272397] PM: Adding info for No Bus:ttyxe
[    4.273243] device: 'ttyxf': device_add
[    4.274241] PM: Adding info for No Bus:ttyxf
[    4.275156] device: 'ttyy0': device_add
[    4.276195] PM: Adding info for No Bus:ttyy0
[    4.277023] device: 'ttyy1': device_add
[    4.278113] PM: Adding info for No Bus:ttyy1
[    4.279052] device: 'ttyy2': device_add
[    4.280223] PM: Adding info for No Bus:ttyy2
[    4.281153] device: 'ttyy3': device_add
[    4.282230] PM: Adding info for No Bus:ttyy3
[    4.283193] device: 'ttyy4': device_add
[    4.284366] PM: Adding info for No Bus:ttyy4
[    4.285246] device: 'ttyy5': device_add
[    4.286252] PM: Adding info for No Bus:ttyy5
[    4.287294] device: 'ttyy6': device_add
[    4.288511] PM: Adding info for No Bus:ttyy6
[    4.289406] device: 'ttyy7': device_add
[    4.290508] PM: Adding info for No Bus:ttyy7
[    4.291413] device: 'ttyy8': device_add
[    4.292507] PM: Adding info for No Bus:ttyy8
[    4.293389] device: 'ttyy9': device_add
[    4.294517] PM: Adding info for No Bus:ttyy9
[    4.295439] device: 'ttyya': device_add
[    4.296570] PM: Adding info for No Bus:ttyya
[    4.297411] device: 'ttyyb': device_add
[    4.298487] PM: Adding info for No Bus:ttyyb
[    4.299352] device: 'ttyyc': device_add
[    4.300371] PM: Adding info for No Bus:ttyyc
[    4.301207] device: 'ttyyd': device_add
[    4.302408] PM: Adding info for No Bus:ttyyd
[    4.303326] device: 'ttyye': device_add
[    4.304452] PM: Adding info for No Bus:ttyye
[    4.305268] device: 'ttyyf': device_add
[    4.306239] PM: Adding info for No Bus:ttyyf
[    4.307106] device: 'ttyz0': device_add
[    4.308292] PM: Adding info for No Bus:ttyz0
[    4.309213] device: 'ttyz1': device_add
[    4.310140] PM: Adding info for No Bus:ttyz1
[    4.311135] device: 'ttyz2': device_add
[    4.312227] PM: Adding info for No Bus:ttyz2
[    4.313170] device: 'ttyz3': device_add
[    4.314088] PM: Adding info for No Bus:ttyz3
[    4.314887] device: 'ttyz4': device_add
[    4.315816] PM: Adding info for No Bus:ttyz4
[    4.316776] device: 'ttyz5': device_add
[    4.317843] PM: Adding info for No Bus:ttyz5
[    4.318761] device: 'ttyz6': device_add
[    4.319818] PM: Adding info for No Bus:ttyz6
[    4.320759] device: 'ttyz7': device_add
[    4.321827] PM: Adding info for No Bus:ttyz7
[    4.322683] device: 'ttyz8': device_add
[    4.323792] PM: Adding info for No Bus:ttyz8
[    4.324763] device: 'ttyz9': device_add
[    4.325773] PM: Adding info for No Bus:ttyz9
[    4.326562] device: 'ttyza': device_add
[    4.327460] PM: Adding info for No Bus:ttyza
[    4.328437] device: 'ttyzb': device_add
[    4.329460] PM: Adding info for No Bus:ttyzb
[    4.330358] device: 'ttyzc': device_add
[    4.331357] PM: Adding info for No Bus:ttyzc
[    4.332248] device: 'ttyzd': device_add
[    4.333355] PM: Adding info for No Bus:ttyzd
[    4.334260] device: 'ttyze': device_add
[    4.335268] PM: Adding info for No Bus:ttyze
[    4.336273] device: 'ttyzf': device_add
[    4.337336] PM: Adding info for No Bus:ttyzf
[    4.338312] device: 'ttya0': device_add
[    4.339347] PM: Adding info for No Bus:ttya0
[    4.340296] device: 'ttya1': device_add
[    4.341363] PM: Adding info for No Bus:ttya1
[    4.342281] device: 'ttya2': device_add
[    4.343372] PM: Adding info for No Bus:ttya2
[    4.344270] device: 'ttya3': device_add
[    4.345193] PM: Adding info for No Bus:ttya3
[    4.345992] device: 'ttya4': device_add
[    4.346930] PM: Adding info for No Bus:ttya4
[    4.347795] device: 'ttya5': device_add
[    4.348873] PM: Adding info for No Bus:ttya5
[    4.349799] device: 'ttya6': device_add
[    4.350923] PM: Adding info for No Bus:ttya6
[    4.351803] device: 'ttya7': device_add
[    4.352872] PM: Adding info for No Bus:ttya7
[    4.353753] device: 'ttya8': device_add
[    4.354836] PM: Adding info for No Bus:ttya8
[    4.355727] device: 'ttya9': device_add
[    4.356808] PM: Adding info for No Bus:ttya9
[    4.357720] device: 'ttyaa': device_add
[    4.358783] PM: Adding info for No Bus:ttyaa
[    4.359747] device: 'ttyab': device_add
[    4.360836] PM: Adding info for No Bus:ttyab
[    4.361772] device: 'ttyac': device_add
[    4.362802] PM: Adding info for No Bus:ttyac
[    4.363731] device: 'ttyad': device_add
[    4.364824] PM: Adding info for No Bus:ttyad
[    4.365738] device: 'ttyae': device_add
[    4.366787] PM: Adding info for No Bus:ttyae
[    4.367623] device: 'ttyaf': device_add
[    4.368567] PM: Adding info for No Bus:ttyaf
[    4.369370] device: 'ttyb0': device_add
[    4.370333] PM: Adding info for No Bus:ttyb0
[    4.371162] device: 'ttyb1': device_add
[    4.372171] PM: Adding info for No Bus:ttyb1
[    4.372978] device: 'ttyb2': device_add
[    4.373938] PM: Adding info for No Bus:ttyb2
[    4.374754] device: 'ttyb3': device_add
[    4.375719] PM: Adding info for No Bus:ttyb3
[    4.376594] device: 'ttyb4': device_add
[    4.377658] PM: Adding info for No Bus:ttyb4
[    4.378588] device: 'ttyb5': device_add
[    4.379686] PM: Adding info for No Bus:ttyb5
[    4.380600] device: 'ttyb6': device_add
[    4.381608] PM: Adding info for No Bus:ttyb6
[    4.382451] device: 'ttyb7': device_add
[    4.383465] PM: Adding info for No Bus:ttyb7
[    4.384433] device: 'ttyb8': device_add
[    4.385450] PM: Adding info for No Bus:ttyb8
[    4.386279] device: 'ttyb9': device_add
[    4.387292] PM: Adding info for No Bus:ttyb9
[    4.388212] device: 'ttyba': device_add
[    4.389213] PM: Adding info for No Bus:ttyba
[    4.390096] device: 'ttybb': device_add
[    4.391172] PM: Adding info for No Bus:ttybb
[    4.392144] device: 'ttybc': device_add
[    4.393200] PM: Adding info for No Bus:ttybc
[    4.394117] device: 'ttybd': device_add
[    4.395173] PM: Adding info for No Bus:ttybd
[    4.396163] device: 'ttybe': device_add
[    4.397238] PM: Adding info for No Bus:ttybe
[    4.398179] device: 'ttybf': device_add
[    4.399127] PM: Adding info for No Bus:ttybf
[    4.400032] device: 'ttyc0': device_add
[    4.401136] PM: Adding info for No Bus:ttyc0
[    4.401997] device: 'ttyc1': device_add
[    4.403069] PM: Adding info for No Bus:ttyc1
[    4.404095] device: 'ttyc2': device_add
[    4.405061] PM: Adding info for No Bus:ttyc2
[    4.405920] device: 'ttyc3': device_add
[    4.407084] PM: Adding info for No Bus:ttyc3
[    4.408028] device: 'ttyc4': device_add
[    4.409090] PM: Adding info for No Bus:ttyc4
[    4.409984] device: 'ttyc5': device_add
[    4.411028] PM: Adding info for No Bus:ttyc5
[    4.411878] device: 'ttyc6': device_add
[    4.412932] PM: Adding info for No Bus:ttyc6
[    4.413821] device: 'ttyc7': device_add
[    4.414845] PM: Adding info for No Bus:ttyc7
[    4.415730] device: 'ttyc8': device_add
[    4.416768] PM: Adding info for No Bus:ttyc8
[    4.417693] device: 'ttyc9': device_add
[    4.418865] PM: Adding info for No Bus:ttyc9
[    4.419757] device: 'ttyca': device_add
[    4.420778] PM: Adding info for No Bus:ttyca
[    4.421610] device: 'ttycb': device_add
[    4.422592] PM: Adding info for No Bus:ttycb
[    4.423392] device: 'ttycc': device_add
[    4.424412] PM: Adding info for No Bus:ttycc
[    4.425324] device: 'ttycd': device_add
[    4.426331] PM: Adding info for No Bus:ttycd
[    4.427216] device: 'ttyce': device_add
[    4.428233] PM: Adding info for No Bus:ttyce
[    4.429197] device: 'ttycf': device_add
[    4.430315] PM: Adding info for No Bus:ttycf
[    4.431250] device: 'ttyd0': device_add
[    4.432238] PM: Adding info for No Bus:ttyd0
[    4.433056] device: 'ttyd1': device_add
[    4.434042] PM: Adding info for No Bus:ttyd1
[    4.434899] device: 'ttyd2': device_add
[    4.435880] PM: Adding info for No Bus:ttyd2
[    4.436743] device: 'ttyd3': device_add
[    4.437745] PM: Adding info for No Bus:ttyd3
[    4.438597] device: 'ttyd4': device_add
[    4.439793] PM: Adding info for No Bus:ttyd4
[    4.440735] device: 'ttyd5': device_add
[    4.441689] PM: Adding info for No Bus:ttyd5
[    4.442505] device: 'ttyd6': device_add
[    4.443479] PM: Adding info for No Bus:ttyd6
[    4.444210] device: 'ttyd7': device_add
[    4.445168] PM: Adding info for No Bus:ttyd7
[    4.446112] device: 'ttyd8': device_add
[    4.447229] PM: Adding info for No Bus:ttyd8
[    4.448293] device: 'ttyd9': device_add
[    4.449332] PM: Adding info for No Bus:ttyd9
[    4.450274] device: 'ttyda': device_add
[    4.451305] PM: Adding info for No Bus:ttyda
[    4.452264] device: 'ttydb': device_add
[    4.453297] PM: Adding info for No Bus:ttydb
[    4.454197] device: 'ttydc': device_add
[    4.455224] PM: Adding info for No Bus:ttydc
[    4.456112] device: 'ttydd': device_add
[    4.457156] PM: Adding info for No Bus:ttydd
[    4.458082] device: 'ttyde': device_add
[    4.459100] PM: Adding info for No Bus:ttyde
[    4.460026] device: 'ttydf': device_add
[    4.461023] PM: Adding info for No Bus:ttydf
[    4.461923] device: 'ttye0': device_add
[    4.462966] PM: Adding info for No Bus:ttye0
[    4.463858] device: 'ttye1': device_add
[    4.464932] PM: Adding info for No Bus:ttye1
[    4.465728] device: 'ttye2': device_add
[    4.466702] PM: Adding info for No Bus:ttye2
[    4.467578] device: 'ttye3': device_add
[    4.468670] PM: Adding info for No Bus:ttye3
[    4.469588] device: 'ttye4': device_add
[    4.470685] PM: Adding info for No Bus:ttye4
[    4.471579] device: 'ttye5': device_add
[    4.472658] PM: Adding info for No Bus:ttye5
[    4.473593] device: 'ttye6': device_add
[    4.474590] PM: Adding info for No Bus:ttye6
[    4.475486] device: 'ttye7': device_add
[    4.476548] PM: Adding info for No Bus:ttye7
[    4.477460] device: 'ttye8': device_add
[    4.478508] PM: Adding info for No Bus:ttye8
[    4.479357] device: 'ttye9': device_add
[    4.480396] PM: Adding info for No Bus:ttye9
[    4.481315] device: 'ttyea': device_add
[    4.482347] PM: Adding info for No Bus:ttyea
[    4.483240] device: 'ttyeb': device_add
[    4.484295] PM: Adding info for No Bus:ttyeb
[    4.485191] device: 'ttyec': device_add
[    4.486266] PM: Adding info for No Bus:ttyec
[    4.487142] device: 'ttyed': device_add
[    4.488186] PM: Adding info for No Bus:ttyed
[    4.489027] device: 'ttyee': device_add
[    4.490007] PM: Adding info for No Bus:ttyee
[    4.490908] device: 'ttyef': device_add
[    4.491979] PM: Adding info for No Bus:ttyef
[    4.493008] device: 'ptmx': device_add
[    4.494039] PM: Adding info for No Bus:ptmx
[    4.494914] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.496050] bus: 'pnp': add driver serial
[    4.496918] bus: 'pnp': driver_probe_device: matched device 00:06 with d=
river serial
[    4.498240] bus: 'pnp': really_probe: probing driver serial with device =
00:06
[    4.521948] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    4.523153] device: 'ttyS0': device_add
[    4.524374] PM: Adding info for No Bus:ttyS0
[    4.525448] driver: '00:06': driver_bound: bound to device 'serial'
[    4.526660] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[    4.528173] Registering platform device 'serial8250'. Parent at platform
[    4.529415] device: 'serial8250': device_add
[    4.530284] bus: 'platform': add device serial8250
[    4.531368] PM: Adding info for platform:serial8250
[    4.532504] device: 'ttyS1': device_add
[    4.533670] PM: Adding info for No Bus:ttyS1
[    4.534804] device: 'ttyS2': device_add
[    4.535880] PM: Adding info for No Bus:ttyS2
[    4.537003] device: 'ttyS3': device_add
[    4.538142] PM: Adding info for No Bus:ttyS3
[    4.539124] bus: 'platform': add driver serial8250
[    4.540084] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[    4.541815] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[    4.543518] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[    4.544914] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[    4.546543] bus: 'pci': add driver serial
[    4.547525] bus: 'spi': add driver max310x
[    4.548457] bus: 'platform': add driver uart-sccnxp
[    4.549665] bus: 'platform': add driver altera_uart
[    4.550795] bus: 'platform': add driver timb-uart
[    4.551914] bus: 'platform': add driver altera_jtaguart
[    4.553482] bus: 'pci': add driver HSU serial
[    4.554660] bus: 'pci': add driver pch_uart
[    4.555719] bus: 'platform': add driver xuartps
[    4.556758] Initializing Nozomi driver 2.1d
[    4.557725] bus: 'pci': add driver nozomi
[    4.558681] device class 'virtio-ports': registering
[    4.559804] bus: 'virtio': add driver virtio_console
[    4.561036] device: 'rtc': device_add
[    4.562097] PM: Adding info for No Bus:rtc
[    4.562996] Real Time Clock Driver v1.12b
[    4.563830] device: 'nvram': device_add
[    4.564954] PM: Adding info for No Bus:nvram
[    4.565934] Non-volatile memory driver v1.3
[    4.566746] bus: 'platform': add driver timeriomem_rng
[    4.567893] bus: 'virtio': add driver virtio_rng
[    4.568952] device class 'ppdev': registering
[    4.569813] ppdev: user-space parallel port driver
[    4.570718] Linux agpgart interface v0.103
[    4.571487] bus: 'pci': add driver agpgart-intel
[    4.572400] bus: 'pci': driver_probe_device: matched device 0000:00:00.0=
 with driver agpgart-intel
[    4.573903] bus: 'pci': really_probe: probing driver agpgart-intel with =
device 0000:00:00.0
[    4.575844] agpgart-intel: probe of 0000:00:00.0 rejects match -19
[    4.577005] bus: 'pci': add driver agpgart-sis
[    4.577929] device class 'cardman_4040': registering
[    4.578963] bus: 'pcmcia': add driver cm4040_cs
[    4.579906] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.581623] Hangcheck: Using getrawmonotonic().
[    4.582472] bus: 'pnp': add driver tpm_tis
[    4.583423] bus: 'platform': add driver tpm_atmel
[    4.584406] bus: 'platform': remove driver tpm_atmel
[    4.585310] driver: 'tpm_atmel': driver_release
[    4.586196] bus: 'pci': add driver poulsbo
[    4.587147] bus: 'platform': add driver ax88796-pp
[    4.590585] device: '1:0': device_add
[    4.591637] PM: Adding info for No Bus:1:0
[    4.592541] device: 'ram0': device_add
[    4.593677] PM: Adding info for No Bus:ram0
[    4.595093] device: '1:1': device_add
[    4.596052] PM: Adding info for No Bus:1:1
[    4.596958] device: 'ram1': device_add
[    4.597974] PM: Adding info for No Bus:ram1
[    4.599094] device: '1:2': device_add
[    4.599929] PM: Adding info for No Bus:1:2
[    4.600756] device: 'ram2': device_add
[    4.601715] PM: Adding info for No Bus:ram2
[    4.602780] device: '1:3': device_add
[    4.603675] PM: Adding info for No Bus:1:3
[    4.604540] device: 'ram3': device_add
[    4.605599] PM: Adding info for No Bus:ram3
[    4.606890] device: '1:4': device_add
[    4.607829] PM: Adding info for No Bus:1:4
[    4.608702] device: 'ram4': device_add
[    4.609763] PM: Adding info for No Bus:ram4
[    4.610938] device: '1:5': device_add
[    4.611828] PM: Adding info for No Bus:1:5
[    4.612741] device: 'ram5': device_add
[    4.613742] PM: Adding info for No Bus:ram5
[    4.614855] device: '1:6': device_add
[    4.615739] PM: Adding info for No Bus:1:6
[    4.616691] device: 'ram6': device_add
[    4.617780] PM: Adding info for No Bus:ram6
[    4.618962] device: '1:7': device_add
[    4.619855] PM: Adding info for No Bus:1:7
[    4.620748] device: 'ram7': device_add
[    4.621804] PM: Adding info for No Bus:ram7
[    4.622954] device: '1:8': device_add
[    4.623874] PM: Adding info for No Bus:1:8
[    4.624866] device: 'ram8': device_add
[    4.625986] PM: Adding info for No Bus:ram8
[    4.627180] device: '1:9': device_add
[    4.628150] PM: Adding info for No Bus:1:9
[    4.628970] device: 'ram9': device_add
[    4.630075] PM: Adding info for No Bus:ram9
[    4.631290] device: '1:10': device_add
[    4.632296] PM: Adding info for No Bus:1:10
[    4.633334] device: 'ram10': device_add
[    4.634356] PM: Adding info for No Bus:ram10
[    4.635449] device: '1:11': device_add
[    4.636311] PM: Adding info for No Bus:1:11
[    4.637256] device: 'ram11': device_add
[    4.638375] PM: Adding info for No Bus:ram11
[    4.639576] device: '1:12': device_add
[    4.640535] PM: Adding info for No Bus:1:12
[    4.641463] device: 'ram12': device_add
[    4.642487] PM: Adding info for No Bus:ram12
[    4.643614] device: '1:13': device_add
[    4.644570] PM: Adding info for No Bus:1:13
[    4.645498] device: 'ram13': device_add
[    4.646607] PM: Adding info for No Bus:ram13
[    4.647852] device: '1:14': device_add
[    4.648830] PM: Adding info for No Bus:1:14
[    4.649780] device: 'ram14': device_add
[    4.650985] PM: Adding info for No Bus:ram14
[    4.652212] device: '1:15': device_add
[    4.653133] PM: Adding info for No Bus:1:15
[    4.654023] device: 'ram15': device_add
[    4.655059] PM: Adding info for No Bus:ram15
[    4.656190] brd: module loaded
[    4.656768] bus: 'pci': add driver umem
[    4.657647] MM: desc_per_page =3D 128
[    4.661827] nbd: registered device at major 43
[    4.662738] device: '43:0': device_add
[    4.663633] PM: Adding info for No Bus:43:0
[    4.664537] device: 'nbd0': device_add
[    4.665574] PM: Adding info for No Bus:nbd0
[    4.666819] device: '43:1': device_add
[    4.667749] PM: Adding info for No Bus:43:1
[    4.668739] device: 'nbd1': device_add
[    4.669877] PM: Adding info for No Bus:nbd1
[    4.671107] device: '43:2': device_add
[    4.671936] PM: Adding info for No Bus:43:2
[    4.672843] device: 'nbd2': device_add
[    4.673968] PM: Adding info for No Bus:nbd2
[    4.675284] device: '43:3': device_add
[    4.676232] PM: Adding info for No Bus:43:3
[    4.677212] device: 'nbd3': device_add
[    4.678380] PM: Adding info for No Bus:nbd3
[    4.679777] device: '43:4': device_add
[    4.680779] PM: Adding info for No Bus:43:4
[    4.681645] device: 'nbd4': device_add
[    4.682808] PM: Adding info for No Bus:nbd4
[    4.684224] device: '43:5': device_add
[    4.685111] PM: Adding info for No Bus:43:5
[    4.686090] device: 'nbd5': device_add
[    4.687220] PM: Adding info for No Bus:nbd5
[    4.688772] device: '43:6': device_add
[    4.689773] PM: Adding info for No Bus:43:6
[    4.690725] device: 'nbd6': device_add
[    4.691828] PM: Adding info for No Bus:nbd6
[    4.693175] device: '43:7': device_add
[    4.694117] PM: Adding info for No Bus:43:7
[    4.695053] device: 'nbd7': device_add
[    4.696227] PM: Adding info for No Bus:nbd7
[    4.697559] device: '43:8': device_add
[    4.698554] PM: Adding info for No Bus:43:8
[    4.699505] device: 'nbd8': device_add
[    4.700644] PM: Adding info for No Bus:nbd8
[    4.701959] device: '43:9': device_add
[    4.702903] PM: Adding info for No Bus:43:9
[    4.703892] device: 'nbd9': device_add
[    4.705127] PM: Adding info for No Bus:nbd9
[    4.706431] device: '43:10': device_add
[    4.707420] PM: Adding info for No Bus:43:10
[    4.708407] device: 'nbd10': device_add
[    4.709707] PM: Adding info for No Bus:nbd10
[    4.711030] device: '43:11': device_add
[    4.711968] PM: Adding info for No Bus:43:11
[    4.712959] device: 'nbd11': device_add
[    4.714084] PM: Adding info for No Bus:nbd11
[    4.715380] device: '43:12': device_add
[    4.716305] PM: Adding info for No Bus:43:12
[    4.717280] device: 'nbd12': device_add
[    4.718371] PM: Adding info for No Bus:nbd12
[    4.719733] device: '43:13': device_add
[    4.720646] PM: Adding info for No Bus:43:13
[    4.721504] device: 'nbd13': device_add
[    4.722638] PM: Adding info for No Bus:nbd13
[    4.724032] device: '43:14': device_add
[    4.724974] PM: Adding info for No Bus:43:14
[    4.725920] device: 'nbd14': device_add
[    4.727002] PM: Adding info for No Bus:nbd14
[    4.728468] device: '43:15': device_add
[    4.729457] PM: Adding info for No Bus:43:15
[    4.730459] device: 'nbd15': device_add
[    4.731553] PM: Adding info for No Bus:nbd15
[    4.732925] bus: 'virtio': add driver virtio_blk
[    4.733867] bus: 'virtio': driver_probe_device: matched device virtio0 w=
ith driver virtio_blk
[    4.735443] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio0
[    4.737487] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    4.738589] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    4.784509] device: '252:0': device_add
[    4.785498] PM: Adding info for No Bus:252:0
[    4.786495] device: 'vda': device_add
[    4.787749] PM: Adding info for No Bus:vda
[    4.789610]  vda: unknown partition table
[    4.791349] driver: 'virtio0': driver_bound: bound to device 'virtio_blk'
[    4.792617] bus: 'virtio': really_probe: bound device virtio0 to driver =
virtio_blk
[    4.793879] bus: 'virtio': driver_probe_device: matched device virtio1 w=
ith driver virtio_blk
[    4.795464] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio1
[    4.797465] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    4.800741] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    4.847336] device: '252:16': device_add
[    4.848385] PM: Adding info for No Bus:252:16
[    4.849383] device: 'vdb': device_add
[    4.850558] PM: Adding info for No Bus:vdb
[    4.852062]  vdb: unknown partition table
[    4.853575] driver: 'virtio1': driver_bound: bound to device 'virtio_blk'
[    4.854875] bus: 'virtio': really_probe: bound device virtio1 to driver =
virtio_blk
[    4.856323] bus: 'virtio': driver_probe_device: matched device virtio2 w=
ith driver virtio_blk
[    4.858943] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio2
[    4.860981] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    4.862057] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    4.892377] device: '252:32': device_add
[    4.893374] PM: Adding info for No Bus:252:32
[    4.894298] device: 'vdc': device_add
[    4.895563] PM: Adding info for No Bus:vdc
[    4.897047]  vdc: unknown partition table
[    4.898740] driver: 'virtio2': driver_bound: bound to device 'virtio_blk'
[    4.899911] bus: 'virtio': really_probe: bound device virtio2 to driver =
virtio_blk
[    4.901236] bus: 'virtio': driver_probe_device: matched device virtio3 w=
ith driver virtio_blk
[    4.902664] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio3
[    4.904632] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    4.905740] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    4.948452] device: '252:48': device_add
[    4.949449] PM: Adding info for No Bus:252:48
[    4.950362] device: 'vdd': device_add
[    4.951490] PM: Adding info for No Bus:vdd
[    4.953722]  vdd: unknown partition table
[    4.955432] driver: 'virtio3': driver_bound: bound to device 'virtio_blk'
[    4.956682] bus: 'virtio': really_probe: bound device virtio3 to driver =
virtio_blk
[    4.958025] bus: 'virtio': driver_probe_device: matched device virtio4 w=
ith driver virtio_blk
[    4.959597] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio4
[    4.961542] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    4.962675] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    5.008425] device: '252:64': device_add
[    5.009461] PM: Adding info for No Bus:252:64
[    5.010415] device: 'vde': device_add
[    5.011562] PM: Adding info for No Bus:vde
[    5.013021]  vde: unknown partition table
[    5.014745] driver: 'virtio4': driver_bound: bound to device 'virtio_blk'
[    5.016036] bus: 'virtio': really_probe: bound device virtio4 to driver =
virtio_blk
[    5.017354] bus: 'virtio': driver_probe_device: matched device virtio5 w=
ith driver virtio_blk
[    5.019923] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio5
[    5.022027] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    5.023053] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    5.069280] device: '252:80': device_add
[    5.070262] PM: Adding info for No Bus:252:80
[    5.071260] device: 'vdf': device_add
[    5.072726] PM: Adding info for No Bus:vdf
[    5.075748]  vdf: unknown partition table
[    5.077501] driver: 'virtio5': driver_bound: bound to device 'virtio_blk'
[    5.078866] bus: 'virtio': really_probe: bound device virtio5 to driver =
virtio_blk
[    5.080328] bus: 'spi': add driver ad_dpot
[    5.081344] bus: 'spi': add driver bmp085
[    5.082249] lkdtm: No crash points registered, enable through debugfs
[    5.083424] bus: 'pci': add driver tifm_7xx1
[    5.084377] device class 'phantom': registering
[    5.085310] bus: 'pci': add driver phantom
[    5.086271] Phantom Linux Driver, version n0.9.8, init OK
[    5.087359] bus: 'pci': add driver IOC4
[    5.088372] device class 'enclosure': registering
[    5.089347] bus: 'platform': add driver cs5535-mfgpt
[    5.090368] device class 'iLO': registering
[    5.091279] bus: 'pci': add driver hpilo
[    5.092176] bus: 'spi': add driver dac7512
[    5.093056] bus: 'pci': add driver cb710
[    5.093949] bus: 'pci': add driver pch_phub
[    5.094892] bus: 'pci': add driver lpc_sch
[    5.095876] bus: 'pci': add driver vx855
[    5.096801] bus: 'pci': add driver cs5535-mfd
[    5.097785] Uniform Multi-Platform E-IDE driver
[    5.098857] bus: 'ide': registered
[    5.099518] device class 'ide_port': registering
[    5.100538] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    5.102035] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    5.103402] pci 0000:00:01.1: enabling bus mastering
[    5.104420] pci 0000:00:01.1: setting latency timer to 64
[    5.105359]     ide0: BM-DMA at 0xc1c0-0xc1c7
[    5.106164]     ide1: BM-DMA at 0xc1c8-0xc1cf
[    5.106959] Probing IDE interface ide0...
[    5.676069] device: 'ide0': device_add
[    5.677049] PM: Adding info for No Bus:ide0
[    5.677955] device: 'ide0': device_add
[    5.678935] PM: Adding info for No Bus:ide0
[    5.679806] Probing IDE interface ide1...
[    6.416205] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    7.088107] device: 'ide1': device_add
[    7.089073] PM: Adding info for No Bus:ide1
[    7.089930] device: 'ide1': device_add
[    7.090950] PM: Adding info for No Bus:ide1
[    7.091842] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    7.093070] hdc: MWDMA2 mode selected
[    7.094104] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    7.095163] ide1 at 0x170-0x177,0x376 on irq 15
[    7.096479] device: '1.0': device_add
[    7.097290] bus: 'ide': add device 1.0
[    7.098296] PM: Adding info for ide:1.0
[    7.099046] bus: 'pci': add driver ALI15x3_IDE
[    7.100068] bus: 'pci': add driver CMD64x_IDE
[    7.101051] bus: 'pci': add driver Cyrix_IDE
[    7.102005] bus: 'pci': add driver CS5530 IDE
[    7.102997] bus: 'pci': add driver IT8172_IDE
[    7.103936] bus: 'pci': add driver ITE8213_IDE
[    7.108224] bus: 'pci': add driver JMicron IDE
[    7.109409] bus: 'pci': add driver Promise_Old_IDE
[    7.110491] bus: 'pci': add driver PIIX_IDE
[    7.111345] bus: 'pci': driver_probe_device: matched device 0000:00:01.1=
 with driver PIIX_IDE
[    7.112975] bus: 'pci': really_probe: probing driver PIIX_IDE with devic=
e 0000:00:01.1
[    7.114389] driver: '0000:00:01.1': driver_bound: bound to device 'PIIX_=
IDE'
[    7.115613] bus: 'pci': really_probe: bound device 0000:00:01.1 to drive=
r PIIX_IDE
[    7.117115] bus: 'pci': add driver SIS_IDE
[    7.118095] bus: 'pci': add driver SLC90e66_IDE
[    7.119099] bus: 'pci': add driver TC86C001
[    7.120109] bus: 'pci': add driver TRIFLEX_IDE
[    7.121148] bus: 'pci': add driver VIA_IDE
[    7.122633] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    7.124446] bus: 'pnp': add driver ide
[    7.125268] ide-cd driver 5.00
[    7.125859] bus: 'ide': add driver ide-cdrom
[    7.126676] bus: 'ide': driver_probe_device: matched device 1.0 with dri=
ver ide-cdrom
[    7.128099] bus: 'ide': really_probe: probing driver ide-cdrom with devi=
ce 1.0
[    7.129658] device: '1.0': device_add
[    7.130523] PM: Adding info for No Bus:1.0
[    7.132017] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[    7.133159] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.135909] device: '22:0': device_add
[    7.136924] PM: Adding info for No Bus:22:0
[    7.138040] device: 'hdc': device_add
[    7.139290] PM: Adding info for No Bus:hdc
[    7.140724] driver: '1.0': driver_bound: bound to device 'ide-cdrom'
[    7.142537] bus: 'ide': really_probe: bound device 1.0 to driver ide-cdr=
om
[    7.143824] device class 'ide_tape': registering
[    7.144866] bus: 'ide': add driver ide-tape
[    7.146964] bus: 'platform': add driver pata_platform
[    7.148712] device: 'tgt': device_add
[    7.149798] PM: Adding info for No Bus:tgt
[    7.150709] device class 'raid_devices': registering
[    7.151786] device class 'spi_transport': registering
[    7.152739] device class 'spi_host': registering
[    7.153626] device class 'fc_host': registering
[    7.154498] device class 'fc_vports': registering
[    7.155419] device class 'fc_remote_ports': registering
[    7.156426] device class 'fc_transport': registering
[    7.157362] Loading iSCSI transport class v2.0-870.
[    7.158240] device class 'iscsi_transport': registering
[    7.159194] device class 'iscsi_endpoint': registering
[    7.160188] device class 'iscsi_iface': registering
[    7.161167] device class 'iscsi_host': registering
[    7.162095] device class 'iscsi_connection': registering
[    7.163156] device class 'iscsi_session': registering
[    7.164398] device class 'sas_host': registering
[    7.165266] device class 'sas_phy': registering
[    7.166142] device class 'sas_port': registering
[    7.167038] device class 'sas_device': registering
[    7.167935] device class 'sas_end_device': registering
[    7.168930] device class 'sas_expander': registering
[    7.170294] rdac: device handler registered
[    7.171309] hp_sw: device handler registered
[    7.173439] bus: 'fcoe': registered
[    7.174223] fnic: Cisco FCoE HBA Driver, ver 1.5.0.2
[    7.176291] bus: 'pci': add driver fnic
[    7.177140] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v1.0.12 (Ju=
n 04, 2012)
[    7.648184] device: 'tcp': device_add
[    7.649161] PM: Adding info for No Bus:tcp
[    7.649962] iscsi: registered transport (tcp)
[    7.650755] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    7.651787] Detecting Adaptec I2O RAID controllers...
[    7.652842] bus: 'pci': add driver aic7xxx
[    7.653787] Adaptec aacraid driver 1.2-0[29800]-ms
[    7.654643] bus: 'pci': add driver aacraid
[    7.655942] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.658052] bus: 'pci': add driver aic94xx
[    7.659033] bus: 'pci': add driver pm8001
[    7.659880] bus: 'pci': add driver ips
[    7.660730] bus: 'pci': remove driver ips
[    7.661520] driver: 'ips': driver_release
[    7.662779] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.04.00.07-k.
[    7.664375] bus: 'pci': add driver qla2xxx
[    7.665373] bus: 'pci': add driver sym53c8xx
[    7.666361] bus: 'pci': add driver megaraid_legacy
[    7.667316] mpt2sas version 14.100.00.00 loaded
[    7.668240] device: 'mpt2ctl': device_add
[    7.708325] PM: Adding info for No Bus:mpt2ctl
[    7.709328] bus: 'pci': add driver mpt2sas
[    7.710250] bus: 'pci': add driver ufshcd
[    7.711073] bus: 'pci': add driver atp870u
[    7.711944] bus: 'pci': add driver initio
[    7.712871] bus: 'pci': add driver inia100
[    7.713723] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    7.715009] bus: 'pci': add driver 3w-9xxx
[    7.715910] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    7.717292] bus: 'pci': add driver 3w-sas
[    7.718203] ipr: IBM Power RAID SCSI Device Driver version: 2.5.4 (July =
11, 2012)
[    7.719554] bus: 'pci': add driver ipr
[    7.724244] RocketRAID 3xxx/4xxx Controller driver v1.6 (091225)
[    7.725556] bus: 'pci': add driver hptiop
[    7.726635] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    7.727750] bus: 'pci': add driver stex
[    7.729206] bus: 'pci': add driver mvsas
[    7.730145] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    7.731473] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    7.732800] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    7.733979] device: 'cxgb3i': device_add
[    7.734909] PM: Adding info for No Bus:cxgb3i
[    7.735842] iscsi: registered transport (cxgb3i)
[    7.736685] Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
[    7.737754] device: 'cxgb4i': device_add
[    7.738898] PM: Adding info for No Bus:cxgb4i
[    7.739781] iscsi: registered transport (cxgb4i)
[    7.740641] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2=
012)
[    7.741859] device: 'bnx2i': device_add
[    7.742655] PM: Adding info for No Bus:bnx2i
[    7.743503] iscsi: registered transport (bnx2i)
[    7.744786] device: 'be2iscsi': device_add
[    7.745728] PM: Adding info for No Bus:be2iscsi
[    7.746644] iscsi: registered transport (be2iscsi)
[    7.747481] In beiscsi_module_init, tt=3Dffffffff8270a5a0
[    7.748417] bus: 'pci': add driver be2iscsi
[    7.750128] bus: 'virtio': add driver virtio_scsi
[    7.751144] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    7.752367] device class 'scsi_tape': registering
[    7.753345] bus: 'scsi': add driver st
[    7.754207] bus: 'scsi': add driver sr
[    7.768331] device: 'pseudo_0': device_add
[    7.769391] PM: Adding info for No Bus:pseudo_0
[    7.770464] bus: 'pseudo': registered
[    7.771248] bus: 'pseudo': add driver scsi_debug
[    7.772557] device: 'adapter0': device_add
[    7.773403] bus: 'pseudo': add device adapter0
[    7.774364] PM: Adding info for pseudo:adapter0
[    7.775316] bus: 'pseudo': driver_probe_device: matched device adapter0 =
with driver scsi_debug
[    7.776824] bus: 'pseudo': really_probe: probing driver scsi_debug with =
device adapter0
[    7.928033] scsi_debug: host protection
[    7.928812] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    7.931299] device: 'host0': device_add
[    7.932242] bus: 'scsi': add device host0
[    7.933253] PM: Adding info for scsi:host0
[    7.934082] device: 'host0': device_add
[    7.935113] PM: Adding info for No Bus:host0
[    7.941100] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    7.942811] device: 'target0:0:0': device_add
[    7.943695] bus: 'scsi': add device target0:0:0
[    7.944772] PM: Adding info for scsi:target0:0:0
[    7.945852] device: '0:0:0:0': device_add
[    7.946869] bus: 'scsi': add device 0:0:0:0
[    7.948031] PM: Adding info for scsi:0:0:0:0
[    7.948902] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 wit=
h driver st
[    7.950222] bus: 'scsi': really_probe: probing driver st with device 0:0=
:0:0
[    7.951669] st: probe of 0:0:0:0 rejects match -19
[    7.952652] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 wit=
h driver sr
[    7.954143] bus: 'scsi': really_probe: probing driver sr with device 0:0=
:0:0
[    7.955568] sr: probe of 0:0:0:0 rejects match -19
[    7.956441] device: '0:0:0:0': device_add
[    7.957411] PM: Adding info for No Bus:0:0:0:0
[    7.958414] device: '0:0:0:0': device_add
[    7.992378] PM: Adding info for No Bus:0:0:0:0
[    7.993605] driver: 'adapter0': driver_bound: bound to device 'scsi_debu=
g'
[    7.994923] bus: 'pseudo': really_probe: bound device adapter0 to driver=
 scsi_debug
[    7.996408] bus: 'pci': add driver ahci
[    7.997304] bus: 'platform': add driver ahci
[    7.998179] bus: 'platform': remove driver ahci
[    7.999072] driver: 'ahci': driver_release
[    8.000017] bus: 'pci': add driver sata_inic162x
[    8.000841] bus: 'pci': add driver sata_sil24
[    8.001760] bus: 'pci': add driver sata_qstor
[    8.002649] bus: 'pci': add driver sata_sx4
[    8.003506] bus: 'pci': add driver pata_cmd640
[    8.004501] bus: 'pci': add driver pata_mpiix
[    8.005438] bus: 'pci': add driver pata_ns87410
[    8.006458] bus: 'pci': add driver pata_opti
[    8.007431] Error: Driver 'pata_platform' is already registered, abortin=
g...
[    8.012079] device class 'spidev': registering
[    8.012833] bus: 'spi': add driver spidev
[    8.013439] bus: 'platform': add driver spi_altera
[    8.014137] bus: 'spi': add driver tle62x0
[    8.014760] bus: 'platform': add driver xilinx_spi
[    8.015469] bus: 'hsi': add driver hsi_char
[    8.016095] HSI/SSI char device loaded
[    8.016578] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
[    8.764035] device: 'bond0': device_add
[    8.765613] PM: Adding info for No Bus:bond0
[    8.770247] device: 'dummy0': device_add
[    8.771496] PM: Adding info for No Bus:dummy0
[    8.772647] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[    8.774405] device: 'eql': device_add
[    8.775632] PM: Adding info for No Bus:eql
[    8.776919] device class 'macvtap': registering
[    8.779179] D-Link DE-620 pocket adapter not identified in the printer p=
ort
[    8.780675] bus: 'mdio_bus': add driver LXT970
[    8.781601] bus: 'mdio_bus': add driver LXT971
[    8.782473] bus: 'mdio_bus': add driver LXT973-A2
[    8.783381] bus: 'mdio_bus': add driver LXT973
[    8.784271] bus: 'mdio_bus': add driver QS6612
[    8.785122] bus: 'mdio_bus': add driver SMSC LAN83C185
[    8.786071] bus: 'mdio_bus': add driver SMSC LAN8187
[    8.786985] bus: 'mdio_bus': add driver SMSC LAN8700
[    8.788030] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[    8.789183] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
[    8.790317] bus: 'mdio_bus': add driver Broadcom BCM5411
[    8.791336] bus: 'mdio_bus': add driver Broadcom BCM5421
[    8.792346] bus: 'mdio_bus': add driver Broadcom BCM5461
[    8.793460] bus: 'mdio_bus': add driver Broadcom BCM5464
[    8.794420] bus: 'mdio_bus': add driver Broadcom BCM5481
[    8.795405] bus: 'mdio_bus': add driver Broadcom BCM5482
[    8.796244] bus: 'mdio_bus': add driver Broadcom BCM50610
[    8.797236] bus: 'mdio_bus': add driver Broadcom BCM50610M
[    8.798339] bus: 'mdio_bus': add driver Broadcom BCM57780
[    8.799201] bus: 'mdio_bus': add driver Broadcom BCMAC131
[    8.800035] bus: 'mdio_bus': add driver Broadcom BCM5241
[    8.800724] bus: 'mdio_bus': add driver RTL821x Gigabit Ethernet
[    8.801538] bus: 'mdio_bus': add driver STe101p
[    8.802190] bus: 'mdio_bus': add driver STe100p
[    8.802859] spi_ks8995: Micrel KS8995 Ethernet switch SPI driver version=
 0.1.1
[    8.803938] bus: 'spi': add driver spi-ks8995
[    8.804702] tun: Universal TUN/TAP device driver, 1.6
[    8.805340] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    8.806161] device: 'tun': device_add
[    8.806956] PM: Adding info for No Bus:tun
[    8.807518] bus: 'virtio': add driver virtio_net
[    8.808606] arcnet loaded.
[    8.809093] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    8.809948] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    8.810878] arcnet: raw mode (`r') encapsulation support loaded.
[    8.811619] arcnet: cap mode (`c') encapsulation support loaded.
[    8.812250] arcnet: COM90xx chipset support
[    9.115734] S3: No ARCnet cards found.
[    9.116626] arcnet: RIM I (entirely mem-mapped) support
[    9.117611] E-mail me if you actually test the RIM I driver, please!
[    9.118733] Given: node 00h, shmem 0h, irq 0
[    9.119446] No autoprobe for RIM I; you must specify the shmem and irq!
[    9.120713] bus: 'pcmcia': add driver com20020_cs
[    9.121789] bus: 'pci': add driver amd8111e
[    9.122734] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    9.124030] bus: 'pci': add driver pcnet32
[    9.124844] bus: 'pci': add driver atl1
[    9.125686] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    9.126689] Copyright (c) 2007 Atheros Corporation.
[    9.127578] bus: 'pci': add driver atl2
[    9.128586] bus: 'pci': add driver ATL1E
[    9.129663] bus: 'pci': add driver b44
[    9.130488] bus: 'ssb': add driver b44
[    9.131296] bus: 'pci': add driver bnx2
[    9.132035] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.14 (Sep 30=
, 2012)
[    9.133577] bus: 'platform': add driver calxedaxgmac
[    9.134669] bus: 'pci': add driver cxgb
[    9.136103] bus: 'pci': add driver cxgb3
[    9.140141] bus: 'pci': add driver cxgb4
[    9.141143] bus: 'pci': add driver cxgb4vf
[    9.142052] bus: 'platform': add driver dnet
[    9.143061] bus: 'pci': add driver dl2k
[    9.144043] bus: 'pci': add driver sundance
[    9.144816] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    9.145827] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    9.146844] bus: 'pci': add driver e1000e
[    9.147488] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Ne=
twork Driver - version 2.6.0-k
[    9.149318] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    9.150023] bus: 'pci': add driver ixgbevf
[    9.150820] bus: 'pci': add driver Sundance Technology IPG Triple-Speed =
Ethernet
[    9.152447] sky2: driver version 1.30
[    9.153225] bus: 'pci': add driver sky2
[    9.154039] bus: 'spi': add driver ks8851
[    9.154622] bus: 'platform': add driver ks8851_mll
[    9.155309] bus: 'pci': add driver natsemi
[    9.156026] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    9.157013] bus: 'pci': add driver pch_gbe
[    9.157650] bus: 'platform': add driver ethoc
[    9.158615] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.0.29
[    9.224164] bus: 'pci': add driver qlcnic
[    9.225129] bus: 'pci': add driver qlge
[    9.226067] bus: 'pcmcia': add driver smc91c92_cs
[    9.227095] bus: 'pci': add driver epic100
[    9.227971] bus: 'pci': add driver smsc9420
[    9.228880] tlan: ThunderLAN driver v1.17
[    9.229624] bus: 'pci': add driver tlan
[    9.230521] tlan: 0 devices installed, PCI: 0  EISA: 0
[    9.231533] bus: 'pci': remove driver tlan
[    9.232397] driver: 'tlan': driver_release
[    9.233213] bus: 'platform': add driver w5100
[    9.234113] bus: 'pcmcia': add driver xirc2ps_cs
[    9.235013] bus: 'pci': add driver defxx
[    9.235850] bus: 'pci': add driver vlsi_ir
[    9.356117] PPP generic driver version 2.4.2
[    9.357069] device class 'ppp': registering
[    9.357985] device: 'ppp': device_add
[    9.416317] PM: Adding info for No Bus:ppp
[    9.417201] PPP BSD Compression module registered
[    9.418072] PPP Deflate Compression module registered
[    9.418940] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    9.420163] SLIP linefill/keepalive option.
[    9.420863] bus: 'pnp': add driver sb1000
[    9.421667] hdlc: HDLC support module revision 1.22
[    9.422528] bus: 'pci': add driver fst
[    9.423316] bus: 'pci': add driver lmc
[    9.424250] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    9.425384] bus: 'pci': add driver wanXL
[    9.426249] bus: 'pci': add driver PC300
[    9.427075] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2=
=2E2kmprq
[    9.428383] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[    9.429394] bus: 'pci': add driver ipw2200
[    9.432278] libipw: Unable to create ieee80211 proc directory
[    9.433334] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, P=
avel Roskin <proski@gnu.org>, et al)
[    9.435090] orinoco_tmd 0.15 (Joerg Dorchain <joerg@dorchain.net>)
[    9.436266] bus: 'pci': add driver orinoco_tmd
[    9.437238] bus: 'pcmcia': add driver airo_cs
[    9.438193] airo(): Probing for PCI adapters
[    9.438995] bus: 'pci': add driver airo
[    9.439861] airo(): Finished probing for PCI adapters
[    9.440789] bus: 'pcmcia': add driver b43-pcmcia
[    9.441688] bus: 'ssb': add driver b43
[    9.442445] Broadcom 43xx driver loaded [ Features: PMNL ]
[    9.443401] bus: 'ssb': add driver b43legacy
[    9.444369] Broadcom 43xx-legacy driver loaded [ Features: PLI ]
[    9.445491] bus: 'pci': add driver rtl8180
[    9.446452] bus: 'pci': add driver rtl8192se
[    9.447415] bus: 'pcmcia': add driver wl3501_cs
[    9.448466] bus: 'pcmcia': add driver libertas_cs
[    9.449486] bus: 'pci': add driver adm8211
[    9.450361] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[    9.451327] Copyright(c) 2003-2012 Intel Corporation
[    9.452240] bus: 'pci': add driver iwlwifi
[    9.453122] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in=
-tree:d
[    9.454400] iwldvm: Copyright(c) 2003-2012 Intel Corporation
[    9.455438] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection=
 driver for Linux, in-tree:ds
[    9.457042] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[    9.458121] bus: 'pci': add driver iwl3945
[    9.459028] bus: 'pci': add driver rt2500pci
[    9.459893] bus: 'pci': add driver p54pci
[    9.460697] bus: 'spi': add driver p54spi
[    9.461533] bus: 'pci': add driver ath5k
[    9.462383] bus: 'pci': add driver ath9k
[    9.463180] bus: 'platform': add driver ath9k
[    9.464070] bus: 'pci': add driver nosy
[    9.464902] device class 'uio': registering
[    9.465684] bus: 'pci': add driver hilscher
[    9.466492] bus: 'platform': add driver uio_pdrv
[    9.467327] bus: 'platform': add driver uio_pdrv_genirq
[    9.468387] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[    9.469375] bus: 'pci': add driver uio_pci_generic
[    9.470311] device class 'vfio': registering
[    9.471192] device: 'vfio': device_add
[    9.472305] PM: Adding info for No Bus:vfio
[    9.473194] VFIO - User Level meta-driver version: 0.3
[    9.474436] bus: 'pci': add driver vfio-pci
[    9.475302] bus: 'pci': add driver yenta_cardbus
[    9.476376] bus: 'pci': add driver pd6729
[    9.477269] device class 'aoe': registering
[    9.478105] device: 'err': device_add
[    9.479095] PM: Adding info for No Bus:err
[    9.479863] device: 'discover': device_add
[    9.481013] PM: Adding info for No Bus:discover
[    9.481966] device: 'interfaces': device_add
[    9.483070] PM: Adding info for No Bus:interfaces
[    9.483973] device: 'revalidate': device_add
[    9.485117] PM: Adding info for No Bus:revalidate
[    9.486082] device: 'flush': device_add
[    9.487083] PM: Adding info for No Bus:flush
[    9.488626] aoe: AoE v50 initialised.
[    9.489411] device class 'uwb_rc': registering
[    9.490517] bus: 'umc': registered
[    9.491187] bus: 'pci': add driver whci
[    9.492162] bus: 'umc': add driver whc-rc
[    9.492968] bus: 'pnp': add driver i8042 kbd
[    9.493816] bus: 'pnp': driver_probe_device: matched device 00:02 with d=
river i8042 kbd
[    9.495226] bus: 'pnp': really_probe: probing driver i8042 kbd with devi=
ce 00:02
[    9.496712] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    9.497973] bus: 'pnp': really_probe: bound device 00:02 to driver i8042=
 kbd
[    9.499252] bus: 'pnp': add driver i8042 aux
[    9.500113] bus: 'pnp': driver_probe_device: matched device 00:03 with d=
river i8042 aux
[    9.501572] bus: 'pnp': really_probe: probing driver i8042 aux with devi=
ce 00:03
[    9.503008] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    9.504117] bus: 'pnp': really_probe: bound device 00:03 to driver i8042=
 aux
[    9.505483] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    9.506994] Registering platform device 'i8042'. Parent at platform
[    9.508197] device: 'i8042': device_add
[    9.508866] bus: 'platform': add device i8042
[    9.509806] PM: Adding info for platform:i8042
[    9.510711] bus: 'platform': add driver i8042
[    9.511573] bus: 'platform': driver_probe_device: matched device i8042 w=
ith driver i8042
[    9.512960] bus: 'platform': really_probe: probing driver i8042 with dev=
ice i8042
[    9.518501] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.519555] serio: i8042 AUX port at 0x60,0x64 irq 12
[    9.520580] device: 'serio0': device_add
[    9.521416] bus: 'serio': add device serio0
[    9.522400] PM: Adding info for serio:serio0
[    9.523318] driver: 'i8042': driver_bound: bound to device 'i8042'
[    9.524576] device: 'serio1': device_add
[    9.525431] bus: 'serio': add device serio1
[    9.526457] PM: Adding info for serio:serio1
[    9.527376] bus: 'platform': really_probe: bound device i8042 to driver =
i8042
[    9.528986] device: 'mice': device_add
[    9.530157] PM: Adding info for No Bus:mice
[    9.531128] device: 'psaux': device_add
[    9.532196] PM: Adding info for No Bus:psaux
[    9.533116] mousedev: PS/2 mouse device common for all mice
[    9.534178] bus: 'serio': add driver atkbd
[    9.535187] bus: 'spi': add driver ad7877
[    9.535991] bus: 'serio': driver_probe_device: matched device serio0 wit=
h driver atkbd
[    9.537541] bus: 'serio': really_probe: probing driver atkbd with device=
 serio0
[    9.539309] bus: 'serio': add driver hampshire
[    9.540377] bus: 'serio': add driver gunze
[    9.541328] bus: 'serio': add driver elo
[    9.542216] bus: 'serio': add driver inexio
[    9.543130] bus: 'serio': add driver mtouch
[    9.544389] bus: 'serio': add driver touchit213
[    9.545522] bus: 'serio': add driver tsc40
[    9.546451] device: 'input0': device_add
[    9.547648] PM: Adding info for No Bus:input0
[    9.548688] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    9.550408] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    9.551974] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    9.553229] bus: 'spi': add driver tsc2005
[    9.553973] bus: 'spi': add driver adxl34x
[    9.554739] bus: 'acpi': add driver Atlas ACPI
[    9.555503] bus: 'serio': really_probe: bound device serio0 to driver at=
kbd
[    9.556673] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[    9.558052] bus: 'serio': really_probe: probing driver atkbd with device=
 serio1
[    9.559724] bus: 'platform': add driver pcap-keys
[    9.560812] device: 'uinput': device_add
[    9.561693] PM: Adding info for No Bus:uinput
[    9.562507] bus: 'platform': add driver wm831x-on
[    9.563430] I2O subsystem v1.325
[    9.563970] i2o: max drivers =3D 8
[    9.564735] bus: 'i2o': registered
[    9.565666] atkbd: probe of serio1 rejects match -19
[    9.566571] bus: 'i2o': add driver exec-osm
[    9.567488] bus: 'pci': add driver PCI_I2O
[    9.568208] I2O SCSI Peripheral OSM v1.316
[    9.568716] bus: 'i2o': add driver scsi-osm
[    9.569337] Colour QuickCam for Video4Linux v0.06
[    9.569932] Driver for 1-wire Dallas network protocol.
[    9.570675] bus: 'w1': registered
[    9.571216] bus: 'w1': add driver w1_master_driver
[    9.571894] bus: 'w1': add driver w1_slave_driver
[    9.572579] bus: 'pci': add driver matrox_w1
[    9.573249] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    9.573998] bus: 'platform': add driver ds1wm
[    9.574611] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    9.575698] bus: 'platform': add driver pda-power
[    9.576400] bus: 'platform': add driver wm831x-backup
[    9.577115] bus: 'platform': add driver wm831x-power
[    9.577834] bus: 'platform': add driver ds2780-battery
[    9.578546] bus: 'platform': add driver ds2781-battery
[    9.579281] bus: 'acpi': add driver ATK0110
[    9.579934] bus: 'spi': add driver adcxx
[    9.580529] applesmc: supported laptop not found!
[    9.581129] applesmc: driver init failed (ret=3D-19)!
[    9.581734] bus: 'platform': add driver da9052-hwmon
[    9.582470] f71882fg: Not a Fintek device
[    9.583012] f71882fg: Not a Fintek device
[    9.583519] bus: 'platform': add driver i5k_amb
[    9.584195] Registering platform device 'i5k_amb.0'. Parent at platform
[    9.585026] device: 'i5k_amb.0': device_add
[    9.585567] bus: 'platform': add device i5k_amb.0
[    9.586254] PM: Adding info for platform:i5k_amb.0
[    9.586909] bus: 'platform': driver_probe_device: matched device i5k_amb=
=2E0 with driver i5k_amb
[    9.587960] bus: 'platform': really_probe: probing driver i5k_amb with d=
evice i5k_amb.0
[    9.589048] i5k_amb: probe of i5k_amb.0 rejects match -19
[    9.589784] bus: 'spi': add driver lm70
[    9.590388] bus: 'pci': add driver sis5595
[    9.591002] bus: 'pci': add driver vt8231
[    9.591613] md: linear personality registered for level -1
[    9.592309] md: raid0 personality registered for level 0
[    9.592974] cpuidle: using governor ladder
[    9.593740] bus: 'memstick': registered
[    9.594232] device class 'memstick_host': registering
[    9.594929] bus: 'memstick': add driver mspro_block
[    9.595605] bus: 'tifm': add driver tifm_ms
[    9.596277] bus: 'pci': add driver jmb38x_ms
[    9.596924] bus: 'pci': add driver r592
[    9.597498] bus: 'platform': add driver leds-ot200
[    9.598174] bus: 'platform': add driver wm831x-status
[    9.598919] bus: 'platform': add driver leds-regulator
[    9.599647] bus: 'spi': add driver dac124s085
[    9.600327] Registering platform device 'dell_rbu'. Parent at platform
[    9.601156] device: 'dell_rbu': device_add
[    9.601697] bus: 'platform': add device dell_rbu
[    9.602398] PM: Adding info for platform:dell_rbu
[    9.603225] bus: 'pci': add driver slicoss
[    9.603853] rts_pstor: Initializing Realtek PCIE storage driver...
[    9.604633] bus: 'pci': add driver rts_pstor
[    9.605301] VME User Space Access Driver
[    9.605795] vme_user: No cards, skipping registration
[    9.606529] bus: 'ipack': registered
[    9.607019] bus: 'pci': add driver tpci200
[    9.607604] Loading crystalhd 0.9.27
[    9.608109] bus: 'pci': add driver Broadcom 70012 Decoder
[    9.608909] cxt1e1: $Release: PMCC4_3_1B,  Copyright (c) 2008 One Stop S=
ystems$
[    9.609807] cxt1e1: No boards found
[    9.610275] bus: 'pci': add driver SBE T3E3
[    9.610910] bus: 'pcmcia': add driver ft1000_cs
[    9.611726] device: 'log_main': device_add
[    9.612496] PM: Adding info for No Bus:log_main
[    9.613113] logger: created 256K log 'log_main'
[    9.613854] device: 'log_events': device_add
[    9.614612] PM: Adding info for No Bus:log_events
[    9.615239] logger: created 256K log 'log_events'
[    9.615999] device: 'log_radio': device_add
[    9.616780] PM: Adding info for No Bus:log_radio
[    9.617396] logger: created 256K log 'log_radio'
[    9.618131] device: 'log_system': device_add
[    9.618840] PM: Adding info for No Bus:log_system
[    9.619467] logger: created 256K log 'log_system'
[    9.620095] device class 'timed_output': registering
[    9.620752] Linux telephony interface: v1.00
[    9.621343] device class 'digi_realport': registering
[    9.622046] device: 'driver_settings': device_add
[    9.622772] PM: Adding info for No Bus:driver_settings
[    9.623477] device: 'nodes': device_add
[    9.624106] PM: Adding info for No Bus:nodes
[    9.624673] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000040
[    9.625654] IP: [<ffffffff81de20a0>] register_proc_table+0x80/0x2c0
[    9.626441] PGD 0=20
[    9.626712] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    9.627326] CPU 0=20
[    9.627564] Pid: 1, comm: swapper/0 Not tainted 3.6.0-03042-g11126c6 #12=
 =20
[    9.628022] RIP: 0010:[<ffffffff81de20a0>]  [<ffffffff81de20a0>] registe=
r_proc_table+0x80/0x2c0
[    9.628022] RSP: 0018:ffff880000161e70  EFLAGS: 00010246
[    9.628022] RAX: 0000000000000003 RBX: 0000000000000006 RCX: 00000000000=
00001
[    9.628022] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffffff826=
34845
[    9.628022] RBP: ffff880000161eb0 R08: 0000000000000000 R09: 22222222222=
22222
[    9.628022] R10: 2222222222222222 R11: 2222222222222222 R12: 00000000000=
00003
[    9.628022] R13: 0000000000000003 R14: ffffffff82634845 R15: ffffffff827=
3ce38
[    9.628022] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:=
0000000000000000
[    9.628022] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    9.628022] CR2: 0000000000000040 CR3: 000000000268c000 CR4: 00000000000=
006b0
[    9.628022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    9.628022] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[    9.628022] Process swapper/0 (pid: 1, threadinfo ffff880000160000, task=
 ffff880000148000)
[    9.628022] Stack:
[    9.628022]  0000000000000000 ffffffff830ea640 ffffffff81dda890 00000000=
00000006
[    9.628022]  ffffffff81dda890 0000000000000000 0000000000000000 00000000=
00000000
[    9.628022]  ffff880000161ec0 ffffffff81de2e22 ffff880000161ed0 ffffffff=
81dda906
[    9.628022] Call Trace:
[    9.628022]  [<ffffffff81dda890>] ? dgrp_cleanup_module+0x60/0x60
[    9.628022]  [<ffffffff81dda890>] ? dgrp_cleanup_module+0x60/0x60
[    9.628022]  [<ffffffff81de2e22>] dgrp_register_proc+0x22/0x30
[    9.628022]  [<ffffffff81dda906>] dgrp_init_module+0x76/0x80
[    9.628022]  [<ffffffff82e8afa5>] do_one_initcall+0x86/0x19e
[    9.628022]  [<ffffffff82e8b1d3>] kernel_init+0x116/0x1da
[    9.628022]  [<ffffffff82e8a664>] ? loglevel+0x48/0x48
[    9.628022]  [<ffffffff810ce7a9>] ? schedule_tail+0x29/0x110
[    9.628022]  [<ffffffff82189d84>] kernel_thread_helper+0x4/0x10
[    9.628022]  [<ffffffff8218819d>] ? retint_restore_args+0x13/0x13
[    9.628022]  [<ffffffff82e8b0bd>] ? do_one_initcall+0x19e/0x19e
[    9.628022]  [<ffffffff82189d80>] ? gs_change+0x13/0x13
[    9.628022] Code: 49 83 7f 20 00 0f 85 e8 01 00 00 49 83 7f 18 00 0f 84 =
19 02 00 00 0f 85 d7 01 00 00 e9 0e 02 00 00 48 8b 55 c0 41 89 c4 4c 63 e8 =
<48> 8b 5a 40 48 85 db 75 1f 0f 1f 80 00 00 00 00 b8 01 00 00 00=20
[    9.628022] RIP  [<ffffffff81de20a0>] register_proc_table+0x80/0x2c0
[    9.628022]  RSP <ffff880000161e70>
[    9.628022] CR2: 0000000000000040
[    9.656776] ---[ end trace f6ee180054e72290 ]---
[    9.657392] swapper/0 (1) used greatest stack depth: 3600 bytes left
[    9.658196] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    9.658196]=20
[    9.659369] Rebooting in 10 seconds..
--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-03042-g11126c6"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.6.0 Kernel Configuration
#
CONFIG_64BIT=y
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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_HAVE_INTEL_TXT=y
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
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
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
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
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_RCU_USER_QS=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
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
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
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
CONFIG_SPARSEMEM_VMEMMAP=y
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
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
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
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
# CONFIG_IPV6_PIMSM_V2 is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_RDS=y
# CONFIG_RDS_TCP is not set
CONFIG_RDS_DEBUG=y
# CONFIG_TIPC is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
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
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
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
# CONFIG_DONGLE is not set

#
# FIR device drivers
#
CONFIG_VLSI_FIR=y
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_MINSTREL_HT is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_MESSAGE_TRACING=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set
# CONFIG_NFC_LLCP is not set

#
# Near Field Communication (NFC) devices
#
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
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_OMAP_OCP2SCP=y
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
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
CONFIG_XEN_BLKDEV_FRONTEND=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_SPI=y
CONFIG_PCH_PHUB=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#

#
# Altera FPGA firmware download module
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=y
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
CONFIG_SCSI_CXGB4_ISCSI=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_HPTIOP=y
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=y
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=y
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_NS87410=y
CONFIG_PATA_OPTI=y
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
CONFIG_NET_FC=y
CONFIG_MII=y
CONFIG_NET_TEAM=y
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_VXLAN=y
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_ARCNET_COM20020_CS=y
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
# CONFIG_ATL1C is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DE600 is not set
CONFIG_DE620=y
CONFIG_DL2K=y
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=y
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
CONFIG_IXGBEVF=y
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_IP1000=y
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851=y
CONFIG_KS8851_MLL=y
# CONFIG_KSZ884X_PCI is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
# CONFIG_NS83820 is not set
# CONFIG_NET_VENDOR_8390 is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
CONFIG_QLCNIC=y
CONFIG_QLGE=y
# CONFIG_NETXEN_NIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_SEEQ8005=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
CONFIG_EPIC100=y
CONFIG_SMSC9420=y
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
# CONFIG_WIZNET_W5300 is not set
# CONFIG_WIZNET_BUS_DIRECT is not set
# CONFIG_WIZNET_BUS_INDIRECT is not set
CONFIG_WIZNET_BUS_ANY=y
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
# CONFIG_PPPOATM is not set
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_ATMEL is not set
CONFIG_AIRO_CS=y
CONFIG_PCMCIA_WL3501=y
# CONFIG_PRISM54 is not set
CONFIG_RTL8180=y
CONFIG_ADM8211=y
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=y
CONFIG_ATH_DEBUG=y
CONFIG_ATH5K=y
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH5K_TRACER=y
CONFIG_ATH5K_PCI=y
# CONFIG_ATH5K_TEST_CHANNELS is not set
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
# CONFIG_ATH9K_BTCOEX_SUPPORT is not set
CONFIG_ATH9K=y
CONFIG_ATH9K_PCI=y
CONFIG_ATH9K_AHB=y
# CONFIG_ATH9K_DEBUGFS is not set
# CONFIG_ATH9K_DFS_CERTIFIED is not set
CONFIG_ATH9K_RATE_CONTROL=y
# CONFIG_ATH6KL is not set
CONFIG_B43=y
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
CONFIG_B43_PHY_LP=y
# CONFIG_B43_PHY_HT is not set
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_PIO=y
# CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
# CONFIG_B43LEGACY_DMA_MODE is not set
CONFIG_B43LEGACY_PIO_MODE=y
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=y
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=y
CONFIG_LIBIPW_DEBUG=y
CONFIG_IWLWIFI=y
CONFIG_IWLDVM=y

#
# Debugging Options
#
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLWIFI_DEVICE_TESTMODE=y
# CONFIG_IWLWIFI_P2P is not set
CONFIG_IWLWIFI_EXPERIMENTAL_MFP=y
CONFIG_IWLEGACY=y
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=y

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=y
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_CS=y
# CONFIG_LIBERTAS_SPI is not set
CONFIG_LIBERTAS_DEBUG=y
# CONFIG_LIBERTAS_MESH is not set
CONFIG_HERMES=y
# CONFIG_HERMES_PRISM is not set
CONFIG_HERMES_CACHE_FW_ON_INIT=y
# CONFIG_PLX_HERMES is not set
CONFIG_TMD_HERMES=y
# CONFIG_NORTEL_HERMES is not set
# CONFIG_PCMCIA_HERMES is not set
# CONFIG_PCMCIA_SPECTRUM is not set
CONFIG_P54_COMMON=y
CONFIG_P54_PCI=y
CONFIG_P54_SPI=y
# CONFIG_P54_SPI_DEFAULT_EEPROM is not set
CONFIG_P54_LEDS=y
CONFIG_RT2X00=y
# CONFIG_RT2400PCI is not set
CONFIG_RT2500PCI=y
# CONFIG_RT61PCI is not set
# CONFIG_RT2800PCI is not set
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_RTL8192CE is not set
CONFIG_RTL8192SE=y
# CONFIG_RTL8192DE is not set
CONFIG_RTLWIFI=y
CONFIG_RTLWIFI_DEBUG=y
# CONFIG_WL_TI is not set
# CONFIG_MWIFIEX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
# CONFIG_HDLC_RAW is not set
# CONFIG_HDLC_RAW_ETH is not set
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
# CONFIG_HDLC_PPP is not set
# CONFIG_HDLC_X25 is not set
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=y
CONFIG_PC300TOO=y
CONFIG_FARSYNC=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
# CONFIG_LAPBETHER is not set
# CONFIG_X25_ASY is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_PCAP is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_SPI is not set
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_PCAP=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_SPI=y
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_XEN_KBDDEV_FRONTEND is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
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
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
CONFIG_SERIAL_XILINX_PS_UART=y
# CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
# CONFIG_HVC_XEN_FRONTEND is not set
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

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
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_HDQ_MASTER_OMAP is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
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
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_ABX500_CORE=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_CS5535=y
CONFIG_LPC_SCH=y
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_PCAP is not set
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_WM831X is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y

#
# Media drivers
#
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y

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
CONFIG_V4L_ISA_PARPORT_DRIVERS=y
# CONFIG_VIDEO_BWQCAM is not set
CONFIG_VIDEO_CQCAM=y
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set
CONFIG_STUB_POULSBO=y
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
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
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_OMAP_USB2 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO=y
CONFIG_VFIO_PCI=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
# CONFIG_XEN_BACKEND is not set
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PRIVCMD=y
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=y
CONFIG_ECHO=y
# CONFIG_PANEL is not set
CONFIG_RTS_PSTOR=y
CONFIG_RTS_PSTOR_DEBUG=y
# CONFIG_DX_SEP is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
CONFIG_CRYSTALHD=y
CONFIG_CXT1E1=y
CONFIG_SBE_PMCC4_NCOMM=y
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_SBE_2T3E3=y
CONFIG_FT1000=y
CONFIG_FT1000_PCMCIA=y

#
# Speakup console speech
#
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_PHONE=y
# CONFIG_PHONE_IXJ is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=y
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
CONFIG_XO15_EBOOK=y
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_IRQ_REMAP is not set

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
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

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
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_LOCK_STAT is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
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
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_APPRAISE=y
CONFIG_EVM=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
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
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
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
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--u3/rZRmxL6MmkK24--
