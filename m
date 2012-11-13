Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2KMFZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:25:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:37773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab2KMFZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:25:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="log'?scan'208";a="218731034"
Date: Tue, 13 Nov 2012 13:25:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org
Cc: Guillaume LECERF <glecerf@gmail.com>
Subject: [cfi_probe, mtd_do_chip_probe] invalid opcode: 0000 [#1]
 DEBUG_PAGEALLOC
Message-ID: <20121113052542.GA26941@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

This looks like a pretty old bug and dates back to v2.6.39.
(older kernels cannot be tested due to build problems)

[    6.100211] ------------[ cut here ]------------
[    6.101009] Kernel BUG at b144dd6f [verbose debug info unavailable]
[    6.101189] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    6.101189] Pid: 1, comm: swapper Not tainted 3.7.0-rc5 #1 Bochs Bochs
[    6.101189] EIP: 0060:[<b144dd6f>] EFLAGS: 00010286 CPU: 0
[    6.101189] EIP is at mtd_do_chip_probe+0xb/0x10
[    6.101189] EAX: b1c4b71c EBX: b1c4b338 ECX: 00000001 EDX: b1c4b330
[    6.101189] ESI: b1c4b71c EDI: b1b8f3d9 EBP: bbc2bf3c ESP: bbc2bf00
[    6.101189]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    6.101189] CR0: 8005003b CR2: 00000000 CR3: 01f51000 CR4: 00000690
[    6.101189] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    6.101189] DR6: ffff0ff0 DR7: 00000400
[    6.101189] Process swapper (pid: 1, ti=bbc2a000 task=bbc60000 task.ti=bbc2a000)
[    6.101189] Stack:
[    6.101189]  00000002 00000000 00000000 00000000 bbc60000 00000000 00000000 b1c4b308
[    6.101189]  00000000 b1b8f3d9 bbc2bf38 b11bb431 b1c4b308 b1c4b71c bbc2bf44 bbc2bf44
[    6.101189]  b144abb6 bbc2bf58 b144ab5c 00000000 b1ee1540 00000000 bbc2bf7c b1ee162b
[    6.101189] Call Trace:
[    6.101189]  [<b11bb431>] ? do_raw_spin_unlock+0xd1/0x108
[    6.101189]  [<b144abb6>] cfi_probe+0x12/0x14
[    6.101189]  [<b144ab5c>] do_map_probe+0x8c/0x95
[    6.101189]  [<b1ee1540>] ? physmap_init+0x61/0x61
[    6.101189]  [<b1ee162b>] init_sbc_gxx+0xeb/0x13d
[    6.101189]  [<b1eb6c79>] do_one_initcall+0x74/0x16e
[    6.101189]  [<b1783ed2>] ? kernel_init+0xcf/0x2d5
[    6.101189]  [<b1783ee8>] kernel_init+0xe5/0x2d5
[    6.101189]  [<b17f8cf7>] ret_from_kernel_thread+0x1b/0x28
[    6.101189]  [<b1783e03>] ? rest_init+0xab/0xab
[    6.101189] Code: 8c 53 fe ff ff 8b 45 e0 c7 40 44 e8 b3 c4 b1 89 f8 e8 cb ee ff ff 8d 65 f4 5b 5e 5f 5d c3 90 90 55 89 e5 83 ec 3c 3e 8d 74 26 00 <0f> 0b 90 90 90 55 89 e5 3e 8d 74 26 00 8b 80 dc 00 00 00 5d 03
[    6.101189] EIP: [<b144dd6f>] mtd_do_chip_probe+0xb/0x10 SS:ESP 0068:bbc2bf00

Thanks,
Fengguang


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bens-3422-2012-11-13-07-08-51-3.7.0-rc5-1"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.7.0-rc5 (kbuild@inn) (gcc version 4.7.1 (Deb=
ian 4.7.1-6) ) #1 Tue Nov 13 07:08:00 CST 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [b008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x027bd0=
00-0x027fffff]
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 198c000, base 00000000, lim=
it 00000000)
[    0.000000] cma: CMA: reserved 28 MiB at 0c800000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128324(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
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
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1c12a81, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat b1c846e0, node_mem_map be=
4bf280
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3931 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 60838 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c12a00
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64769
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 branch=3Dlinus/master log_buf_len=3D8M ignore_loglevel deb=
ug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10 =
 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  roo=
t=3D/dev/ram0 rw link=3Dvmlinuz-2012-11-13-07-09-02-linus:master:77b6706-77=
b6706-i386-randconfig-n015-3-bens BOOT_IMAGE=3Dkernel-tests/kernels/i386-ra=
ndconfig-n015/77b6706/vmlinuz-3.7.0-rc5
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 174968k/262136k available (8167k kernel code, 86668k=
 reserved, 6893k data, 608k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xc07fe000 - 0xff7fe000   (1008 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xbfffe000   ( 255 MB)
[    0.000000]       .init : 0xb1eb6000 - 0xb1f4e000   ( 608 kB)
[    0.000000]       .data : 0xb17f9c06 - 0xb1eb52c0   (6893 kB)
[    0.000000]       .text : 0xb1000000 - 0xb17f9c06   (8167 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dbbc06000 soft=3Dbbc08000
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.448 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5332.89 Bogo=
MIPS (lpj=3D2666448)
[    0.004009] pid_max: default: 32768 minimum: 301
[    0.005254] Mount-cache hash table entries: 512
[    0.007237] mce: CPU supports 10 MCE banks
[    0.008010] mce: unknown CPU type - not enabling MCE support
[    0.009047] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009047] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009047] tlb_flushall_shift: -1
[    0.010008] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, =
stepping: 01)
[    0.017497] ACPI: Core revision 20120913
[    0.020716] ACPI: setting ELCR to 0200 (from 0c00)
[    0.021051] ftrace: allocating 24522 entries in 48 pages
[    0.032253] Performance Events:=20
[    0.033878] Testing tracer nop: PASSED
[    0.037286] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.038189] device: 'platform': device_add
[    0.039043] PM: Adding info for No Bus:platform
[    0.040076] bus: 'platform': registered
[    0.041026] bus: 'cpu': registered
[    0.041602] device: 'cpu': device_add
[    0.042037] PM: Adding info for No Bus:cpu
[    0.044605] bus: 'virtio': registered
[    0.045010] cma: cma_init_reserved_areas()
[    0.046009] cma: cma_create_area(base 0000c800, count 1c00)
[    0.047664] cma: cma_create_area: returned bbc00d50
[    0.048352] NET: Registered protocol family 16
[    0.050329] device class 'bdi': registering
[    0.051143] device class 'pci_bus': registering
[    0.052081] bus: 'pci': registered
[    0.052662] device: 'rapidio': device_add
[    0.053024] PM: Adding info for No Bus:rapidio
[    0.054036] bus: 'rapidio': registered
[    0.054675] device class 'lcd': registering
[    0.055018] device class 'backlight': registering
[    0.056018] device class 'video_output': registering
[    0.057018] device class 'tty': registering
[    0.058115] bus: 'spi': registered
[    0.058696] device class 'spi_master': registering
[    0.059087] bus: 'i2c': registered
[    0.060019] bus: 'i2c': add driver dummy
[    0.061702] ACPI: bus type pci registered
[    0.062010] device class 'dma': registering
[    0.063044] device class 'dmi': registering
[    0.064021] device: 'id': device_add
[    0.064703] PM: Adding info for No Bus:id
[    0.065039] dca service started, version 1.12.1
[    0.066009] device class 'dca': registering
[    0.067264] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    0.068009] PCI: Using configuration type 1 for base access
[    0.070069] device: 'cpu0': device_add
[    0.070708] bus: 'cpu': add device cpu0
[    0.071026] PM: Adding info for cpu:cpu0
[    0.077513] device: 'default': device_add
[    0.078038] PM: Adding info for No Bus:default
[    0.079261] bus: 'i2c': add driver pca953x
[    0.080028] bus: 'platform': add driver stmpe-gpio
[    0.080848] bus: 'i2c': add driver sx150x
[    0.081073] bus: 'platform': add driver tc3589x-gpio
[    0.082025] bus: 'platform': add driver wm8350-gpio
[    0.083063] device class 'graphics': registering
[    0.084020] bus: 'platform': add driver aat2870-backlight
[    0.085046] ACPI: Added _OSI(Module Device)
[    0.086010] ACPI: Added _OSI(Processor Device)
[    0.086756] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.087010] ACPI: Added _OSI(Processor Aggregator Device)
[    0.090806] ACPI: EC: Look up EC in DSDT
[    0.097196] ACPI: Interpreter enabled
[    0.097825] ACPI: (supports S0 S3 S5)
[    0.098256] ACPI: Using PIC for interrupt routing
[    0.099048] bus: 'acpi': registered
[    0.100011] bus: 'acpi': add driver power
[    0.101015] device: 'LNXSYSTM:00': device_add
[    0.101756] bus: 'acpi': add device LNXSYSTM:00
[    0.102075] PM: Adding info for acpi:LNXSYSTM:00
[    0.103143] device: 'device:00': device_add
[    0.104061] bus: 'acpi': add device device:00
[    0.105024] PM: Adding info for acpi:device:00
[    0.106082] device: 'PNP0A03:00': device_add
[    0.106806] bus: 'acpi': add device PNP0A03:00
[    0.107023] PM: Adding info for acpi:PNP0A03:00
[    0.109166] device: 'device:01': device_add
[    0.109878] bus: 'acpi': add device device:01
[    0.110025] PM: Adding info for acpi:device:01
[    0.111096] device: 'device:02': device_add
[    0.112016] bus: 'acpi': add device device:02
[    0.113024] PM: Adding info for acpi:device:02
[    0.114043] device: 'PNP0B00:00': device_add
[    0.114779] bus: 'acpi': add device PNP0B00:00
[    0.115092] PM: Adding info for acpi:PNP0B00:00
[    0.116138] device: 'PNP0303:00': device_add
[    0.117017] bus: 'acpi': add device PNP0303:00
[    0.118025] PM: Adding info for acpi:PNP0303:00
[    0.119202] device: 'PNP0F13:00': device_add
[    0.120019] bus: 'acpi': add device PNP0F13:00
[    0.120780] PM: Adding info for acpi:PNP0F13:00
[    0.121113] device: 'PNP0700:00': device_add
[    0.122014] bus: 'acpi': add device PNP0700:00
[    0.123023] PM: Adding info for acpi:PNP0700:00
[    0.124226] device: 'PNP0400:00': device_add
[    0.125015] bus: 'acpi': add device PNP0400:00
[    0.125830] PM: Adding info for acpi:PNP0400:00
[    0.126198] device: 'PNP0501:00': device_add
[    0.127015] bus: 'acpi': add device PNP0501:00
[    0.128025] PM: Adding info for acpi:PNP0501:00
[    0.129140] device: 'device:03': device_add
[    0.130016] bus: 'acpi': add device device:03
[    0.131024] PM: Adding info for acpi:device:03
[    0.131868] device: 'device:04': device_add
[    0.132016] bus: 'acpi': add device device:04
[    0.133024] PM: Adding info for acpi:device:04
[    0.134088] device: 'device:05': device_add
[    0.135015] bus: 'acpi': add device device:05
[    0.136009] PM: Adding info for acpi:device:05
[    0.136847] device: 'device:06': device_add
[    0.137016] bus: 'acpi': add device device:06
[    0.138025] PM: Adding info for acpi:device:06
[    0.139171] device: 'device:07': device_add
[    0.140018] bus: 'acpi': add device device:07
[    0.140790] PM: Adding info for acpi:device:07
[    0.141105] device: 'device:08': device_add
[    0.142014] bus: 'acpi': add device device:08
[    0.143023] PM: Adding info for acpi:device:08
[    0.144090] device: 'device:09': device_add
[    0.144800] bus: 'acpi': add device device:09
[    0.145023] PM: Adding info for acpi:device:09
[    0.146092] device: 'device:0a': device_add
[    0.147071] bus: 'acpi': add device device:0a
[    0.148026] PM: Adding info for acpi:device:0a
[    0.149096] device: 'device:0b': device_add
[    0.149808] bus: 'acpi': add device device:0b
[    0.150035] PM: Adding info for acpi:device:0b
[    0.151091] device: 'device:0c': device_add
[    0.152016] bus: 'acpi': add device device:0c
[    0.153027] PM: Adding info for acpi:device:0c
[    0.154010] device: 'device:0d': device_add
[    0.154726] bus: 'acpi': add device device:0d
[    0.155025] PM: Adding info for acpi:device:0d
[    0.156097] device: 'device:0e': device_add
[    0.157015] bus: 'acpi': add device device:0e
[    0.158033] PM: Adding info for acpi:device:0e
[    0.158945] device: 'device:0f': device_add
[    0.159018] bus: 'acpi': add device device:0f
[    0.160025] PM: Adding info for acpi:device:0f
[    0.161096] device: 'device:10': device_add
[    0.162016] bus: 'acpi': add device device:10
[    0.162764] PM: Adding info for acpi:device:10
[    0.163103] device: 'device:11': device_add
[    0.164015] bus: 'acpi': add device device:11
[    0.165024] PM: Adding info for acpi:device:11
[    0.166091] device: 'device:12': device_add
[    0.167014] bus: 'acpi': add device device:12
[    0.167825] PM: Adding info for acpi:device:12
[    0.168098] device: 'device:13': device_add
[    0.169015] bus: 'acpi': add device device:13
[    0.170024] PM: Adding info for acpi:device:13
[    0.171091] device: 'device:14': device_add
[    0.171805] bus: 'acpi': add device device:14
[    0.172024] PM: Adding info for acpi:device:14
[    0.173091] device: 'device:15': device_add
[    0.174014] bus: 'acpi': add device device:15
[    0.175023] PM: Adding info for acpi:device:15
[    0.175847] device: 'device:16': device_add
[    0.176014] bus: 'acpi': add device device:16
[    0.177080] PM: Adding info for acpi:device:16
[    0.178167] device: 'device:17': device_add
[    0.179017] bus: 'acpi': add device device:17
[    0.180024] PM: Adding info for acpi:device:17
[    0.181128] device: 'device:18': device_add
[    0.182018] bus: 'acpi': add device device:18
[    0.183026] PM: Adding info for acpi:device:18
[    0.184051] device: 'device:19': device_add
[    0.184758] bus: 'acpi': add device device:19
[    0.185025] PM: Adding info for acpi:device:19
[    0.186092] device: 'device:1a': device_add
[    0.187015] bus: 'acpi': add device device:1a
[    0.188014] PM: Adding info for acpi:device:1a
[    0.188844] device: 'device:1b': device_add
[    0.189083] bus: 'acpi': add device device:1b
[    0.190026] PM: Adding info for acpi:device:1b
[    0.191109] device: 'device:1c': device_add
[    0.191853] bus: 'acpi': add device device:1c
[    0.192027] PM: Adding info for acpi:device:1c
[    0.193093] device: 'device:1d': device_add
[    0.194015] bus: 'acpi': add device device:1d
[    0.195038] PM: Adding info for acpi:device:1d
[    0.196110] device: 'device:1e': device_add
[    0.196828] bus: 'acpi': add device device:1e
[    0.197024] PM: Adding info for acpi:device:1e
[    0.198182] device: 'device:1f': device_add
[    0.199017] bus: 'acpi': add device device:1f
[    0.200081] PM: Adding info for acpi:device:1f
[    0.201097] device: 'device:20': device_add
[    0.201813] bus: 'acpi': add device device:20
[    0.202025] PM: Adding info for acpi:device:20
[    0.203092] device: 'device:21': device_add
[    0.204014] bus: 'acpi': add device device:21
[    0.205023] PM: Adding info for acpi:device:21
[    0.205847] device: 'device:22': device_add
[    0.206014] bus: 'acpi': add device device:22
[    0.207024] PM: Adding info for acpi:device:22
[    0.208352] device: 'PNP0103:00': device_add
[    0.209033] bus: 'acpi': add device PNP0103:00
[    0.210100] PM: Adding info for acpi:PNP0103:00
[    0.211287] device: 'PNP0C0F:00': device_add
[    0.212017] bus: 'acpi': add device PNP0C0F:00
[    0.213025] PM: Adding info for acpi:PNP0C0F:00
[    0.214197] device: 'PNP0C0F:01': device_add
[    0.215015] bus: 'acpi': add device PNP0C0F:01
[    0.215778] PM: Adding info for acpi:PNP0C0F:01
[    0.216199] device: 'PNP0C0F:02': device_add
[    0.217015] bus: 'acpi': add device PNP0C0F:02
[    0.218025] PM: Adding info for acpi:PNP0C0F:02
[    0.219281] device: 'PNP0C0F:03': device_add
[    0.220020] bus: 'acpi': add device PNP0C0F:03
[    0.221082] PM: Adding info for acpi:PNP0C0F:03
[    0.222200] device: 'PNP0C0F:04': device_add
[    0.223016] bus: 'acpi': add device PNP0C0F:04
[    0.223783] PM: Adding info for acpi:PNP0C0F:04
[    0.224126] device: 'LNXCPU:00': device_add
[    0.225016] bus: 'acpi': add device LNXCPU:00
[    0.226025] PM: Adding info for acpi:LNXCPU:00
[    0.227110] device: 'LNXCPU:01': device_add
[    0.227826] bus: 'acpi': add device LNXCPU:01
[    0.228025] PM: Adding info for acpi:LNXCPU:01
[    0.229096] device: 'device:23': device_add
[    0.230016] bus: 'acpi': add device device:23
[    0.231088] PM: Adding info for acpi:device:23
[    0.232056] device: 'LNXPWRBN:00': device_add
[    0.232794] bus: 'acpi': add device LNXPWRBN:00
[    0.233024] PM: Adding info for acpi:LNXPWRBN:00
[    0.234341] bus: 'acpi': add driver ec
[    0.235219] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.236011] bus: 'acpi': add driver pci_root
[    0.237018] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    0.238015] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    0.240052] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.241053] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.242011] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.243011] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.244011] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    0.245012] PCI: root bus 00: using default resources
[    0.246039] pci_root PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.
[    0.247024] device: 'pci0000:00': device_add
[    0.248087] PM: Adding info for No Bus:pci0000:00
[    0.249024] device: '0000:00': device_add
[    0.250046] PM: Adding info for No Bus:0000:00
[    0.250843] PCI host bridge to bus 0000:00
[    0.251020] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.252011] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.253010] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
f]
[    0.254029] pci_bus 0000:00: scanning bus
[    0.255097] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.256071] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x9
[    0.258433] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.260296] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.263392] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.265376] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.266030] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x65
[    0.268260] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x162
[    0.269028] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.270025] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.271074] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0xf
[    0.273139] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.276080] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.278555] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.285107] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.286269] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.288365] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.290376] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.294684] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.295184] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.297012] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.298696] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.303689] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.305367] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.307332] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.312320] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.314011] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.315695] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.320688] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.322749] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.324368] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.329460] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.331371] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.333011] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.338214] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.340011] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.341687] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.346647] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.348216] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.352111] pci_bus 0000:00: fixups for bus
[    0.352823] pci_bus 0000:00: bus scan returning with max=3D00
[    0.353018] pci_bus 0000:00: on NUMA node 0
[    0.354094] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.357252]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.358025] device: '0000:00:00.0': device_add
[    0.360401] bus: 'pci': add device 0000:00:00.0
[    0.361146] PM: Adding info for pci:0000:00:00.0
[    0.362084] device: '0000:00:01.0': device_add
[    0.364022] bus: 'pci': add device 0000:00:01.0
[    0.364882] PM: Adding info for pci:0000:00:01.0
[    0.365026] device: '0000:00:01.1': device_add
[    0.367463] bus: 'pci': add device 0000:00:01.1
[    0.368054] PM: Adding info for pci:0000:00:01.1
[    0.369025] device: '0000:00:01.3': device_add
[    0.370861] bus: 'pci': add device 0000:00:01.3
[    0.371115] PM: Adding info for pci:0000:00:01.3
[    0.372026] device: '0000:00:02.0': device_add
[    0.374354] bus: 'pci': add device 0000:00:02.0
[    0.375105] PM: Adding info for pci:0000:00:02.0
[    0.376029] device: '0000:00:03.0': device_add
[    0.377821] bus: 'pci': add device 0000:00:03.0
[    0.378054] PM: Adding info for pci:0000:00:03.0
[    0.379032] device: '0000:00:04.0': device_add
[    0.381270] bus: 'pci': add device 0000:00:04.0
[    0.382115] PM: Adding info for pci:0000:00:04.0
[    0.383031] device: '0000:00:05.0': device_add
[    0.384783] bus: 'pci': add device 0000:00:05.0
[    0.385054] PM: Adding info for pci:0000:00:05.0
[    0.386024] device: '0000:00:06.0': device_add
[    0.388220] bus: 'pci': add device 0000:00:06.0
[    0.389113] PM: Adding info for pci:0000:00:06.0
[    0.389905] device: '0000:00:07.0': device_add
[    0.391683] bus: 'pci': add device 0000:00:07.0
[    0.392109] PM: Adding info for pci:0000:00:07.0
[    0.393027] device: '0000:00:08.0': device_add
[    0.395179] bus: 'pci': add device 0000:00:08.0
[    0.396040] PM: Adding info for pci:0000:00:08.0
[    0.396828] device: '0000:00:09.0': device_add
[    0.398554] bus: 'pci': add device 0000:00:09.0
[    0.399107] PM: Adding info for pci:0000:00:09.0
[    0.400025] device: '0000:00:0a.0': device_add
[    0.402060] bus: 'pci': add device 0000:00:0a.0
[    0.402865] PM: Adding info for pci:0000:00:0a.0
[    0.403027] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[    0.404043] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[    0.405089] bus: 'acpi': add driver pci_link
[    0.406041] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[    0.407011] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[    0.409125] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.410329] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[    0.411012] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[    0.412014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[    0.413010] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[    0.414093] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.415373] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[    0.416011] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[    0.417013] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[    0.418010] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[    0.419098] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.420371] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[    0.421011] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[    0.422014] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[    0.423011] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[    0.424198] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.426172] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[    0.427014] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[    0.428015] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[    0.429010] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[    0.430098] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.431288] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[    0.432012] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[    0.433061] bus: 'pnp': registered
[    0.433666] device class 'misc': registering
[    0.434070] device: 'vga_arbiter': device_add
[    0.435088] PM: Adding info for No Bus:vga_arbiter
[    0.436106] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.437017] vgaarb: loaded
[    0.438008] vgaarb: bridge control possible 0000:00:02.0
[    0.439265] bus: 'tifm': registered
[    0.440009] device class 'tifm_adapter': registering
[    0.441045] bus: 'i2c': add driver 88PM80X
[    0.441756] Error: Driver '88PM80X' is already registered, aborting...
[    0.442030] bus: 'spi': add driver stmpe-spi
[    0.442761] bus: 'i2c': add driver tc3589x
[    0.443042] bus: 'i2c': add driver wm8350
[    0.444024] bus: 'i2c': add driver tps65217
[    0.445085] bus: 'spi': add driver da9052
[    0.445778] bus: 'i2c': add driver da9052
[    0.446026] bus: 'i2c': add driver max8907
[    0.447025] bus: 'i2c': add driver max8925
[    0.448027] bus: 'i2c': add driver max8997
[    0.448790] bus: 'i2c': add driver ab3100
[    0.449026] bus: 'i2c': add driver aat2870
[    0.450025] bus: 'i2c': add driver sec_pmic
[    0.451032] bus: 'i2c': add driver lm3533
[    0.451736] bus: 'platform': add driver pxa2xx-spi
[    0.452026] device class 'pcmcia_socket': registering
[    0.453211] ACPI: bus type usb registered
[    0.454030] bus: 'usb': registered
[    0.455045] bus: 'usb': add driver usbfs
[    0.456020] usbcore: registered new interface driver usbfs
[    0.456948] bus: 'usb': add driver hub
[    0.457025] usbcore: registered new interface driver hub
[    0.458121] bus: 'usb': add driver usb
[    0.459025] usbcore: registered new device driver usb
[    0.460086] bus: 'serio': registered
[    0.461016] device class 'input': registering
[    0.461775] device class 'rtc': registering
[    0.462054] device class 'pps': registering
[    0.463020] pps_core: LinuxPPS API ver. 1 registered
[    0.464009] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.465015] device class 'ptp': registering
[    0.466019] PTP clock support registered
[    0.467009] device class 'power_supply': registering
[    0.468041] device class 'hwmon': registering
[    0.469042] device class 'leds': registering
[    0.469792] device class 'wmi': registering
[    0.470024] bus: 'acpi': add driver wmi
[    0.471058] wmi: Mapper loaded
[    0.471605] PCI: Using ACPI for IRQ routing
[    0.472023] PCI: pci_cache_line_size set to 64 bytes
[    0.473074] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags =
0x110] (d=3D0, p=3D0)
[    0.474016] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] =
(d=3D0, p=3D0)
[    0.475012] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags =
0x110] (d=3D0, p=3D0)
[    0.476012] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] =
(d=3D0, p=3D0)
[    0.477011] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags =
0x40101] (d=3D0, p=3D0)
[    0.478043] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdfffff=
f flags 0x42208] (d=3D0, p=3D0)
[    0.479013] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf0000-0xfebf0ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.480029] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbfff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.481012] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags =
0x40101] (d=3D0, p=3D0)
[    0.482029] pci 0000:00:04.0: BAR 0: reserving [io  0xc040-0xc07f flags =
0x40101] (d=3D0, p=3D0)
[    0.483013] pci 0000:00:04.0: BAR 1: reserving [mem 0xfebf1000-0xfebf1ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.484030] pci 0000:00:05.0: BAR 0: reserving [io  0xc080-0xc0bf flags =
0x40101] (d=3D0, p=3D0)
[    0.485012] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf2000-0xfebf2ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.486031] pci 0000:00:06.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags =
0x40101] (d=3D0, p=3D0)
[    0.487014] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf3000-0xfebf3ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.488030] pci 0000:00:07.0: BAR 0: reserving [io  0xc100-0xc13f flags =
0x40101] (d=3D0, p=3D0)
[    0.489013] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.490029] pci 0000:00:08.0: BAR 0: reserving [io  0xc140-0xc17f flags =
0x40101] (d=3D0, p=3D0)
[    0.491012] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.492029] pci 0000:00:09.0: BAR 0: reserving [io  0xc180-0xc1bf flags =
0x40101] (d=3D0, p=3D0)
[    0.493012] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6ff=
f flags 0x40200] (d=3D0, p=3D0)
[    0.494036] pci 0000:00:0a.0: BAR 0: reserving [mem 0xfebf7000-0xfebf700=
f flags 0x40200] (d=3D0, p=3D0)
[    0.495207] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.496020] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.497069] device class 'net': registering
[    0.498271] device: 'lo': device_add
[    0.499250] PM: Adding info for No Bus:lo
[    0.500243] irda_init()
[    0.501088] NET: Registered protocol family 23
[    0.501874] Bluetooth: Core ver 2.16
[    0.502038] device class 'bluetooth': registering
[    0.503032] NET: Registered protocol family 31
[    0.504008] Bluetooth: HCI device and connection manager initialized
[    0.505032] Bluetooth: HCI socket layer initialized
[    0.506014] Bluetooth: L2CAP socket layer initialized
[    0.507065] Bluetooth: SCO socket layer initialized
[    0.508010] device class 'rfkill': registering
[    0.508782] device: 'rfkill': device_add
[    0.509106] PM: Adding info for No Bus:rfkill
[    0.511283] Switching to clocksource kvm-clock
[    0.512675] Warning: could not register all branches stats
[    0.513655] Warning: could not register annotated branches stats
[    0.527161] FS-Cache: Loaded
[    0.527842] bus: 'pnp': add driver system
[    0.528593] pnp: PnP ACPI init
[    0.529195] device: 'pnp0': device_add
[    0.529855] PM: Adding info for No Bus:pnp0
[    0.530617] ACPI: bus type pnp registered
[    0.531453] pnp 00:00: [bus 00-ff]
[    0.532092] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.532786] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.533617] pnp 00:00: [io  0x0d00-0xffff window]
[    0.534450] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.535395] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.536347] device: '00:00': device_add
[    0.537089] bus: 'pnp': add device 00:00
[    0.537774] PM: Adding info for pnp:00:00
[    0.538539] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.539718] pnp 00:01: [io  0x0070-0x0071]
[    0.540458] pnp 00:01: [irq 8]
[    0.541038] pnp 00:01: [io  0x0072-0x0077]
[    0.541740] device: '00:01': device_add
[    0.542451] bus: 'pnp': add device 00:01
[    0.543189] PM: Adding info for pnp:00:01
[    0.543931] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.545249] pnp 00:02: [io  0x0060]
[    0.545851] pnp 00:02: [io  0x0064]
[    0.546486] pnp 00:02: [irq 1]
[    0.547067] device: '00:02': device_add
[    0.547794] bus: 'pnp': add device 00:02
[    0.548522] PM: Adding info for pnp:00:02
[    0.549257] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.550437] pnp 00:03: [irq 12]
[    0.551032] device: '00:03': device_add
[    0.551697] bus: 'pnp': add device 00:03
[    0.552421] PM: Adding info for pnp:00:03
[    0.553156] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.554330] pnp 00:04: [io  0x03f2-0x03f5]
[    0.555073] pnp 00:04: [io  0x03f7]
[    0.555661] pnp 00:04: [irq 6]
[    0.556234] pnp 00:04: [dma 2]
[    0.556766] device: '00:04': device_add
[    0.557473] bus: 'pnp': add device 00:04
[    0.558215] PM: Adding info for pnp:00:04
[    0.558952] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.560189] pnp 00:05: [io  0x0378-0x037f]
[    0.560940] pnp 00:05: [irq 7]
[    0.561463] device: '00:05': device_add
[    0.562178] bus: 'pnp': add device 00:05
[    0.562977] PM: Adding info for pnp:00:05
[    0.563669] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.564976] pnp 00:06: [io  0x03f8-0x03ff]
[    0.565673] pnp 00:06: [irq 4]
[    0.566261] device: '00:06': device_add
[    0.566994] bus: 'pnp': add device 00:06
[    0.567686] PM: Adding info for pnp:00:06
[    0.568430] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.569966] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.570779] device: '00:07': device_add
[    0.571506] bus: 'pnp': add device 00:07
[    0.572239] PM: Adding info for pnp:00:07
[    0.572980] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.574372] pnp: PnP ACPI: found 8 devices
[    0.575111] ACPI: ACPI bus type pnp unregistered
[    0.575944] device class 'mem': registering
[    0.576660] device: 'mem': device_add
[    0.577437] PM: Adding info for No Bus:mem
[    0.578236] device: 'kmem': device_add
[    0.578987] PM: Adding info for No Bus:kmem
[    0.579704] device: 'null': device_add
[    0.580410] PM: Adding info for No Bus:null
[    0.581242] device: 'port': device_add
[    0.581959] PM: Adding info for No Bus:port
[    0.582671] device: 'zero': device_add
[    0.583381] PM: Adding info for No Bus:zero
[    0.584151] device: 'full': device_add
[    0.584928] PM: Adding info for No Bus:full
[    0.585637] device: 'random': device_add
[    0.586500] PM: Adding info for No Bus:random
[    0.587303] device: 'urandom': device_add
[    0.588054] PM: Adding info for No Bus:urandom
[    0.588813] device: 'kmsg': device_add
[    0.589511] PM: Adding info for No Bus:kmsg
[    0.590273] device: 'oldmem': device_add
[    0.591074] PM: Adding info for No Bus:oldmem
[    0.591826] device: 'tty': device_add
[    0.592521] PM: Adding info for No Bus:tty
[    0.593375] device: 'console': device_add
[    0.594137] PM: Adding info for No Bus:console
[    0.594957] device class 'firmware': registering
[    0.595769] bus: 'pcmcia': registered
[    0.596456] device class 'thermal': registering
[    0.632093] bus: 'ssb': registered
[    0.632776] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.633757] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.634865] NET: Registered protocol family 1
[    0.635702] pci 0000:00:00.0: calling quirk_natoma+0x0/0x45
[    0.636666] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.637717] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x91
[    0.638838] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.639902] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x43
[    0.640975] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.642078] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xfb
[    0.643114] pci 0000:00:02.0: Boot video device
[    0.643946] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x1c5
[    0.645161] PCI: CLS 0 bytes, default 64
[    0.646248] Unpacking initramfs...
[    4.141699] debug: unmapping init [mem 0xbe73f000-0xbffeffff]
[    4.145342] device class 'msr': registering
[    4.148148] device: 'msr0': device_add
[    4.149002] PM: Adding info for No Bus:msr0
[    4.154911] cryptomgr_test (15) used greatest stack depth: 7012 bytes le=
ft
[    4.159379] cryptomgr_probe (23) used greatest stack depth: 6996 bytes l=
eft
[    4.174574] cryptomgr_test (22) used greatest stack depth: 6344 bytes le=
ft
[    4.177302] The force parameter has not been set to 1 so the Iris powero=
ff handler will not be installed.
[    4.179227] bus: 'clocksource': registered
[    4.179979] device: 'clocksource': device_add
[    4.180732] PM: Adding info for No Bus:clocksource
[    4.182011] device: 'clocksource0': device_add
[    4.182768] bus: 'clocksource': add device clocksource0
[    4.183700] PM: Adding info for clocksource:clocksource0
[    4.184686] bus: 'platform': add driver alarmtimer
[    4.185617] Registering platform device 'alarmtimer'. Parent at platform
[    4.186971] device: 'alarmtimer': device_add
[    4.187698] bus: 'platform': add device alarmtimer
[    4.188721] PM: Adding info for platform:alarmtimer
[    4.189737] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    4.191272] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    4.192706] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    4.194098] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    4.195624] rcu-torture:--- Start of test: nreaders=3D2 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D0 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    4.202650] Testing tracer function: PASSED
[    4.472777] Testing dynamic ftrace: PASSED
[    4.767975] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 =
3 1 3) (2 2 4 1 82) PASSED
[    4.995083] Testing dynamic ftrace ops #2: (1 0 1 3 0) (1 1 2 170 0) (2 =
1 3 1 114) (2 2 4 88 201) PASSED
[    5.183765] Testing ftrace recursion: PASSED
[    5.201786] Testing ftrace recursion safe: PASSED
[    5.220784] Testing ftrace regs: PASSED
[    5.239060] Testing tracer wakeup: [    5.301023] tsc: Refined TSC clock=
source calibration: 2666.662 MHz
PASSED
[    5.402168] Testing tracer wakeup_rt: PASSED
[    5.564422] Testing tracer branch: PASSED
[    5.666480] bus: 'event_source': registered
[    5.667258] device: 'breakpoint': device_add
[    5.668056] bus: 'event_source': add device breakpoint
[    5.669026] PM: Adding info for event_source:breakpoint
[    5.670002] device: 'tracepoint': device_add
[    5.670729] bus: 'event_source': add device tracepoint
[    5.671637] PM: Adding info for event_source:tracepoint
[    5.672560] device: 'software': device_add
[    5.674156] bus: 'event_source': add device software
[    5.675084] PM: Adding info for event_source:software
[    5.676947] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    5.684954] VFS: Disk quotas dquot_6.5.2
[    5.685820] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    5.688340] alg: No test for cipher_null (cipher_null-generic)
[    5.690580] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    5.692353] alg: No test for compress_null (compress_null-generic)
[    5.693992] alg: No test for digest_null (digest_null-generic)
[    5.723288] alg: No test for stdrng (krng)
[    5.724621] NET: Registered protocol family 38
[    5.734564] xz_dec_test: module loaded
[    5.735268] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
252 0' and write .xz files to it.
[    5.737144] bus: 'platform': add driver basic-mmio-gpio
[    5.738113] bus: 'i2c': add driver adp5588-gpio
[    5.738950] bus: 'platform': add driver da9052-gpio
[    5.739777] bus: 'platform': add driver gpio_ich
[    5.740713] bus: 'pci': add driver langwell_gpio
[    5.741555] bus: 'platform': add driver wp_gpio
[    5.742376] bus: 'pci': add driver ml_ioh_gpio
[    5.743227] bus: 'pci': add driver pch_gpio
[    5.744315] bus: 'platform': add driver rdc321x-gpio
[    5.745212] bus: 'platform': add driver sch_gpio
[    5.746045] bus: 'platform': add driver twl6040-gpo
[    5.747005] bus: 'pci': add driver pci-stub
[    5.747745] bus: 'spi': add driver l4f00242t03
[    5.748552] bus: 'spi': add driver ltv350qv
[    5.749279] bus: 'spi': add driver VGG2432A4
[    5.749524] bus: 'spi': add driver ld9040
[    5.749524] bus: 'platform': add driver generic-bl
[    5.753847] bus: 'i2c': add driver lm3639_bl
[    5.754667] bus: 'platform': add driver cr_backlight
[    5.755596] Registering platform device 'cr_backlight'. Parent at platfo=
rm
[    5.756793] device: 'cr_backlight': device_add
[    5.757594] bus: 'platform': add device cr_backlight
[    5.758511] PM: Adding info for platform:cr_backlight
[    5.759434] bus: 'platform': driver_probe_device: matched device cr_back=
light with driver cr_backlight
[    5.761042] bus: 'platform': really_probe: probing driver cr_backlight w=
ith device cr_backlight
[    5.763073] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    5.764105] cr_backlight: probe of cr_backlight rejects match -19
[    5.765181] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    5.766252] bus: 'platform': add driver da9052-wled
[    5.767757] bus: 'i2c': add driver adp8860_bl
[    5.768555] i2c-core: driver [adp8860_bl] using legacy suspend method
[    5.769665] i2c-core: driver [adp8860_bl] using legacy resume method
[    5.770764] bus: 'i2c': add driver adp8870_bl
[    5.772169] i2c-core: driver [adp8870_bl] using legacy suspend method
[    5.773294] i2c-core: driver [adp8870_bl] using legacy resume method
[    5.774399] bus: 'pci': add driver CyberPro
[    5.775197] bus: 'pci': add driver pm3fb
[    5.775893] bus: 'pci': add driver matroxfb
[    5.777835] nvidiafb_setup START
[    5.778448] bus: 'pci': add driver nvidiafb
[    5.779268] bus: 'pci': add driver radeonfb
[    5.780063] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    5.781234] bus: 'platform': add driver viafb-i2c
[    5.782084] bus: 'platform': add driver viafb-gpio
[    5.782934] bus: 'pci': add driver viafb
[    5.783621] bus: 'pci': add driver savagefb
[    5.785785] bus: 'pci': add driver tdfxfb
[    5.786537] bus: 'pci': add driver vt8623fb
[    5.787309] vmlfb: initializing
[    5.787851] bus: 'pci': add driver vmlfb
[    5.788591] Could not find Carillo Ranch MCH device.
[    5.789468] bus: 'pci': add driver s3fb
[    5.790248] bus: 'pci': add driver arkfb
[    5.790995] bus: 'platform': add driver hecubafb
[    5.791789] no IO addresses supplied
[    5.792459] bus: 'platform': add driver hgafb
[    5.794278] Registering platform device 'hgafb.0'. Parent at platform
[    5.795434] device: 'hgafb.0': device_add
[    5.796182] bus: 'platform': add device hgafb.0
[    5.796995] PM: Adding info for platform:hgafb.0
[    5.797800] bus: 'platform': driver_probe_device: matched device hgafb.0=
 with driver hgafb
[    5.799232] bus: 'platform': really_probe: probing driver hgafb with dev=
ice hgafb.0
[    5.803260] hgafb: HGA card not detected.
[    5.803957] hgafb: probe of hgafb.0 failed with error -22
[    5.804093] bus: 'pci': add driver sstfb
[    5.805637] bus: 'platform': add driver broadsheetfb
[    5.806546] bus: 'platform': add driver auo_k1901fb
[    5.807449] bus: 'platform': add driver s1d13xxxfb
[    5.808336] bus: 'usb': add driver udlfb
[    5.809064] usbcore: registered new interface driver udlfb
[    5.810038] bus: 'usb': add driver smscufx
[    5.810790] usbcore: registered new interface driver smscufx
[    5.811775] bus: 'pci': add driver carminefb
[    5.813161] Registering platform device 'vesafb.0'. Parent at platform
[    5.814290] device: 'vesafb.0': device_add
[    5.815031] bus: 'platform': add device vesafb.0
[    5.815825] PM: Adding info for platform:vesafb.0
[    5.816672] bus: 'platform': add driver vesafb
[    5.817437] bus: 'platform': driver_probe_device: matched device vesafb.=
0 with driver vesafb
[    5.818897] bus: 'platform': really_probe: probing driver vesafb with de=
vice vesafb.0
[    5.820259] vesafb: probe of vesafb.0 rejects match -19
[    5.821235] bus: 'platform': remove driver vesafb
[    5.823019] driver: 'vesafb': driver_release
[    5.823743] PM: Removing info for platform:vesafb.0
[    5.824721] bus: 'platform': remove device vesafb.0
[    5.825603] bus: 'acpi': add driver ac
[    5.826381] bus: 'acpi': add driver button
[    5.827814] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00=
 with driver button
[    5.829234] bus: 'acpi': really_probe: probing driver button with device=
 LNXPWRBN:00
[    5.830571] device: 'input0': device_add
[    5.831337] PM: Adding info for No Bus:input0
[    5.832172] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.833450] ACPI: Power Button [PWRF]
[    5.834169] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    5.836299] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to drive=
r button
[    5.837624] bus: 'acpi': add driver fan
[    5.838364] bus: 'acpi': add driver video
[    5.839128] bus: 'acpi': add driver processor
[    5.839890] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 w=
ith driver processor
[    5.841352] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:00
[    5.842964] device: 'cooling_device0': device_add
[    5.843787] PM: Adding info for No Bus:cooling_device0
[    5.845580] driver: 'LNXCPU:00': driver_bound: bound to device 'processo=
r'
[    5.846771] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver =
processor
[    5.848085] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 w=
ith driver processor
[    5.849521] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:01
[    5.851023] driver: 'LNXCPU:01': driver_bound: bound to device 'processo=
r'
[    5.852211] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver =
processor
[    5.853869] bus: 'acpi': add driver thermal
[    5.854665] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    5.855801] bus: 'pci': add driver ioatdma
[    5.856560] bus: 'platform': add driver timb-dma
[    5.857393] bus: 'platform': add driver virtio-mmio
[    5.858303] bus: 'pci': add driver virtio-pci
[    5.859189] bus: 'acpi': add driver battery
[    5.860058] bus: 'pci': driver_probe_device: matched device 0000:00:04.0=
 with driver virtio-pci
[    5.861546] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:04.0
[    5.863359] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    5.865335] PCI: setting IRQ 11 as level-triggered
[    5.867328] virtio-pci 0000:00:04.0: enabling bus mastering
[    5.868335] virtio-pci 0000:00:04.0: setting latency timer to 64
[    5.869766] device: 'virtio0': device_add
[    5.871643] bus: 'virtio': add device virtio0
[    5.872455] PM: Adding info for virtio:virtio0
[    5.873317] driver: '0000:00:04.0': driver_bound: bound to device 'virti=
o-pci'
[    5.874558] bus: 'pci': really_probe: bound device 0000:00:04.0 to drive=
r virtio-pci
[    5.878289] bus: 'pci': driver_probe_device: matched device 0000:00:05.0=
 with driver virtio-pci
[    5.879788] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:05.0
[    5.881574] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    5.882589] PCI: setting IRQ 10 as level-triggered
[    5.883464] virtio-pci 0000:00:05.0: enabling bus mastering
[    5.884469] virtio-pci 0000:00:05.0: setting latency timer to 64
[    5.885777] device: 'virtio1': device_add
[    5.887078] bus: 'virtio': add device virtio1
[    5.887845] PM: Adding info for virtio:virtio1
[    5.888665] driver: '0000:00:05.0': driver_bound: bound to device 'virti=
o-pci'
[    5.889905] bus: 'pci': really_probe: bound device 0000:00:05.0 to drive=
r virtio-pci
[    5.891238] bus: 'pci': driver_probe_device: matched device 0000:00:06.0=
 with driver virtio-pci
[    5.892719] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:06.0
[    5.894499] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.895533] virtio-pci 0000:00:06.0: enabling bus mastering
[    5.896526] virtio-pci 0000:00:06.0: setting latency timer to 64
[    5.897813] device: 'virtio2': device_add
[    5.898835] bus: 'virtio': add device virtio2
[    5.899690] PM: Adding info for virtio:virtio2
[    5.900496] driver: '0000:00:06.0': driver_bound: bound to device 'virti=
o-pci'
[    5.901750] bus: 'pci': really_probe: bound device 0000:00:06.0 to drive=
r virtio-pci
[    5.903095] bus: 'pci': driver_probe_device: matched device 0000:00:07.0=
 with driver virtio-pci
[    5.904613] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:07.0
[    5.907313] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    5.908354] virtio-pci 0000:00:07.0: enabling bus mastering
[    5.909356] virtio-pci 0000:00:07.0: setting latency timer to 64
[    5.910700] device: 'virtio3': device_add
[    5.911444] bus: 'virtio': add device virtio3
[    5.912264] PM: Adding info for virtio:virtio3
[    5.913091] driver: '0000:00:07.0': driver_bound: bound to device 'virti=
o-pci'
[    5.914346] bus: 'pci': really_probe: bound device 0000:00:07.0 to drive=
r virtio-pci
[    5.915683] bus: 'pci': driver_probe_device: matched device 0000:00:08.0=
 with driver virtio-pci
[    5.917198] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:08.0
[    5.918759] virtio-pci 0000:00:08.0: enabling bus mastering
[    5.919752] virtio-pci 0000:00:08.0: setting latency timer to 64
[    5.921093] device: 'virtio4': device_add
[    5.922657] bus: 'virtio': add device virtio4
[    5.923466] PM: Adding info for virtio:virtio4
[    5.924268] driver: '0000:00:08.0': driver_bound: bound to device 'virti=
o-pci'
[    5.925506] bus: 'pci': really_probe: bound device 0000:00:08.0 to drive=
r virtio-pci
[    5.926832] bus: 'pci': driver_probe_device: matched device 0000:00:09.0=
 with driver virtio-pci
[    5.928321] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:09.0
[    5.929873] virtio-pci 0000:00:09.0: enabling bus mastering
[    5.930867] virtio-pci 0000:00:09.0: setting latency timer to 64
[    5.932168] device: 'virtio5': device_add
[    5.933082] bus: 'virtio': add device virtio5
[    5.933881] PM: Adding info for virtio:virtio5
[    5.934684] driver: '0000:00:09.0': driver_bound: bound to device 'virti=
o-pci'
[    5.935941] bus: 'pci': really_probe: bound device 0000:00:09.0 to drive=
r virtio-pci
[    5.937287] HDLC line discipline maxframe=3D4096
[    5.938107] N_HDLC line discipline registered.
[    5.938972] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.940094] bus: 'pnp': add driver serial
[    5.940862] bus: 'pnp': driver_probe_device: matched device 00:06 with d=
river serial
[    5.942203] bus: 'pnp': really_probe: probing driver serial with device =
00:06
[    5.965971] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    5.988695] device: 'ttyS0': device_add
[    5.989533] PM: Adding info for No Bus:ttyS0
[    5.990390] driver: '00:06': driver_bound: bound to device 'serial'
[    5.991488] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[    5.992912] Registering platform device 'serial8250'. Parent at platform
[    5.994077] device: 'serial8250': device_add
[    5.994805] bus: 'platform': add device serial8250
[    5.995685] PM: Adding info for platform:serial8250
[    5.996639] device: 'ttyS1': device_add
[    5.997379] PM: Adding info for No Bus:ttyS1
[    5.998226] device: 'ttyS2': device_add
[    5.998904] PM: Adding info for No Bus:ttyS2
[    6.002989] device: 'ttyS3': device_add
[    6.003667] PM: Adding info for No Bus:ttyS3
[    6.004464] bus: 'platform': add driver serial8250
[    6.005321] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[    6.006854] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[    6.008802] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[    6.010052] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[    6.011440] bus: 'spi': add driver max3100
[    6.012223] bus: 'platform': add driver uartlite
[    6.013565] bus: 'platform': add driver altera_uart
[    6.014524] bus: 'platform': add driver altera_jtaguart
[    6.015470] bus: 'spi': add driver ifx6x60
[    6.016326] bus: 'pci': add driver isicom
[    6.017083] MOXA Intellio family driver version 6.0k
[    6.017989] bus: 'pci': add driver moxa
[    6.018658] Initializing Nozomi driver 2.1d
[    6.019482] bus: 'pci': add driver nozomi
[    6.020320] RocketPort device driver module, version 2.09, 12-June-2003
[    6.021528] No rocketport ports found; unloading driver
[    6.022471] SyncLink GT
[    6.022958] SyncLink GT, tty major#248
[    6.023589] bus: 'pci': add driver synclink_gt
[    6.024396] SyncLink GT no devices found
[    6.025146] toshiba: not a supported Toshiba laptop
[    6.026018] nsc_gpio initializing
[    6.026596] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    6.028217] smapi::smapi_init, ERROR invalid usSmapiID
[    6.029124] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    6.030705] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    6.031969] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    6.033065] device class 'cardman_4000': registering
[    6.033961] bus: 'pcmcia': add driver cm4000_cs
[    6.034746] device class 'drm': registering
[    6.036300] [drm] Initialized drm 1.1.0 20060810
[    6.037150] device: 'ttm': device_add
[    6.037806] PM: Adding info for No Bus:ttm
[    6.038623] bus: 'pci': add driver mgag200
[    6.039478] bus: 'pci': add driver vmwgfx
[    6.041457] bus: 'pci': add driver nouveau
[    6.042238] bus: 'i2c': add driver sil164
[    6.042995] bus: 'pci': add driver ibmasm
[    6.043705] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    6.044860] bus: 'pci': add driver pciPTI
[    6.045601] bus: 'i2c': add driver bmp085
[    6.046344] bus: 'spi': add driver bmp085
[    6.047088] bus: 'pci': add driver tifm_7xx1
[    6.047845] device class 'phantom': registering
[    6.049707] bus: 'pci': add driver phantom
[    6.050503] Phantom Linux Driver, version n0.9.8, init OK
[    6.051453] bus: 'i2c': add driver bh1780
[    6.052194] bus: 'i2c': add driver bh1770glc
[    6.052989] bus: 'i2c': add driver apds990x
[    6.053710] device class 'iLO': registering
[    6.054474] bus: 'pci': add driver hpilo
[    6.055208] bus: 'i2c': add driver isl29003
[    6.055979] i2c-core: driver [isl29003] using legacy suspend method
[    6.057077] i2c-core: driver [isl29003] using legacy resume method
[    6.058361] bus: 'i2c': add driver isl29020
[    6.059159] bus: 'i2c': add driver tsl2550
[    6.059889] i2c-core: driver [tsl2550] using legacy suspend method
[    6.060983] i2c-core: driver [tsl2550] using legacy resume method
[    6.062051] bus: 'i2c': add driver ds1682
[    6.062748] bus: 'spi': add driver dac7512
[    6.063501] bus: 'i2c': add driver hmc6352
[    6.064255] bus: 'i2c': add driver at24
[    6.064985] bus: 'i2c': add driver max6875
[    6.065691] bus: 'spi': add driver 93xx46
[    6.067134] bus: 'pci': add driver pch_phub
[    6.067909] bus: 'platform': add driver kim
[    6.068666] bus: 'i2c': add driver htcpld-chip
[    6.069478] bus: 'platform': add driver i2c-htcpld
[    6.070352] bus: 'platform': remove driver i2c-htcpld
[    6.071255] driver: 'i2c-htcpld': driver_release
[    6.072085] bus: 'i2c': add driver arizona
[    6.072802] bus: 'i2c': add driver twl6040
[    6.074109] bus: 'i2c': add driver smsc
[    6.074783] bus: 'platform': add driver ab3100-otp
[    6.075642] bus: 'platform': remove driver ab3100-otp
[    6.076533] driver: 'ab3100-otp': driver_release
[    6.077366] bus: 'pci': add driver timberdale
[    6.078171] Driver for timberdale has been successfully registered.
[    6.079277] bus: 'pci': add driver lpc_sch
[    6.080045] bus: 'pci': add driver lpc_ich
[    6.080805] bus: 'pci': add driver RDC321x Southbridge
[    6.083441] bus: 'pci': add driver janz-cmodio
[    6.084268] bus: 'pci': add driver vx855
[    6.085015] bus: 'pci': add driver cs5535-mfd
[    6.085779] device class 'mtd': registering
[    6.086542] device: 'mtd-unmap': device_add
[    6.087324] PM: Adding info for No Bus:mtd-unmap
[    6.088188] device: 'mtd-romap': device_add
[    6.088979] PM: Adding info for No Bus:mtd-romap
[    6.089789] device: 'mtd-rwmap': device_add
[    6.091982] PM: Adding info for No Bus:mtd-rwmap
[    6.092881] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    6.094033] bus: 'platform': add driver physmap-flash
[    6.094907] physmap-flash.0: failed to claim resource 0
[    6.097379] bus: 'platform': remove driver physmap-flash
[    6.098336] driver: 'physmap-flash': driver_release
[    6.099200] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    6.100211] ------------[ cut here ]------------
[    6.101009] Kernel BUG at b144dd6f [verbose debug info unavailable]
[    6.101189] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    6.101189] Pid: 1, comm: swapper Not tainted 3.7.0-rc5 #1 Bochs Bochs
[    6.101189] EIP: 0060:[<b144dd6f>] EFLAGS: 00010286 CPU: 0
[    6.101189] EIP is at mtd_do_chip_probe+0xb/0x10
[    6.101189] EAX: b1c4b71c EBX: b1c4b338 ECX: 00000001 EDX: b1c4b330
[    6.101189] ESI: b1c4b71c EDI: b1b8f3d9 EBP: bbc2bf3c ESP: bbc2bf00
[    6.101189]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    6.101189] CR0: 8005003b CR2: 00000000 CR3: 01f51000 CR4: 00000690
[    6.101189] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    6.101189] DR6: ffff0ff0 DR7: 00000400
[    6.101189] Process swapper (pid: 1, ti=3Dbbc2a000 task=3Dbbc60000 task.=
ti=3Dbbc2a000)
[    6.101189] Stack:
[    6.101189]  00000002 00000000 00000000 00000000 bbc60000 00000000 00000=
000 b1c4b308
[    6.101189]  00000000 b1b8f3d9 bbc2bf38 b11bb431 b1c4b308 b1c4b71c bbc2b=
f44 bbc2bf44
[    6.101189]  b144abb6 bbc2bf58 b144ab5c 00000000 b1ee1540 00000000 bbc2b=
f7c b1ee162b
[    6.101189] Call Trace:
[    6.101189]  [<b11bb431>] ? do_raw_spin_unlock+0xd1/0x108
[    6.101189]  [<b144abb6>] cfi_probe+0x12/0x14
[    6.101189]  [<b144ab5c>] do_map_probe+0x8c/0x95
[    6.101189]  [<b1ee1540>] ? physmap_init+0x61/0x61
[    6.101189]  [<b1ee162b>] init_sbc_gxx+0xeb/0x13d
[    6.101189]  [<b1eb6c79>] do_one_initcall+0x74/0x16e
[    6.101189]  [<b1783ed2>] ? kernel_init+0xcf/0x2d5
[    6.101189]  [<b1783ee8>] kernel_init+0xe5/0x2d5
[    6.101189]  [<b17f8cf7>] ret_from_kernel_thread+0x1b/0x28
[    6.101189]  [<b1783e03>] ? rest_init+0xab/0xab
[    6.101189] Code: 8c 53 fe ff ff 8b 45 e0 c7 40 44 e8 b3 c4 b1 89 f8 e8 =
cb ee ff ff 8d 65 f4 5b 5e 5f 5d c3 90 90 55 89 e5 83 ec 3c 3e 8d 74 26 00 =
<0f> 0b 90 90 90 55 89 e5 3e 8d 74 26 00 8b 80 dc 00 00 00 5d 03
[    6.101189] EIP: [<b144dd6f>] mtd_do_chip_probe+0xb/0x10 SS:ESP 0068:bbc=
2bf00
[    6.132394] ---[ end trace f3bf3bbbdf419073 ]---
[    6.133209] Kernel panic - not syncing: Fatal exception
[    6.134099] Rebooting in 10 seconds..
--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="77b6706-bisect.log"

git checkout 8c23f406c6d86808726ace580657186bc3b44587

2012-11-13-12:23:13 8c23f406c6d86808726ace580657186bc3b44587 compiling
/home/wfg/mm

2012-11-13-12:24:56 detecting boot state 3.7.0-rc3-bisect3-00077-g8c23f40 #3 ....1 TEST FAILURE
bisect: bad commit 8c23f406c6d86808726ace580657186bc3b44587
git checkout v3.6

2012-11-13-12:25:13 a0d271cbfed1dd50278c6b06bead3d00ba0a88f9 compiling
/home/wfg/mm

2012-11-13-12:27:37 detecting boot state 3.6.0-bisect3 #4 1.............2 TEST FAILURE
bisect: bad commit v3.6
git checkout v3.5

2012-11-13-12:28:01 28a33cbc24e4256c143dce96c7d93bf423229f92 compiling
/home/wfg/mm

2012-11-13-12:30:13 detecting boot state 3.5.0-bisect3 #5 ..1....2..3........4 TEST FAILURE
bisect: bad commit v3.5
git checkout v3.4

2012-11-13-12:30:44 76e10d158efb6d4516018846f60c2ab5501900bc compiling
/home/wfg/mm

2012-11-13-12:36:01 detecting boot state 3.4.0-bisect3 #6 ..... TEST FAILURE
bisect: bad commit v3.4
git checkout v3.3

2012-11-13-12:36:15 c16fa4f2ad19908a47c63d8fa436a1178438c7e7 compiling
/home/wfg/mm

2012-11-13-12:38:58 detecting boot state 3.3.0-bisect3 #7 ..12.3.... TEST FAILURE
bisect: bad commit v3.3
git checkout v3.2

2012-11-13-12:39:16 805a6af8dba5dfdd35ec35dc52ec0122400b2610 compiling
/home/wfg/mm

2012-11-13-12:41:50 detecting boot state 3.2.0-bisect3 #8 ..1 TEST FAILURE
bisect: bad commit v3.2
git checkout v3.1

2012-11-13-12:42:03 c3b92c8787367a8bb53d57d9789b558f1295cc96 compiling
/home/wfg/mm

2012-11-13-12:45:28 detecting boot state 3.1.0-bisect3 #9 ...........1 TEST FAILURE
bisect: bad commit v3.1
git checkout v3.0

2012-11-13-12:45:49 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe compiling
/home/wfg/mm

2012-11-13-12:48:04 detecting boot state 3.0.0-bisect3 #10 .......1 TEST FAILURE
bisect: bad commit v3.0
git checkout v2.6.39

2012-11-13-12:48:21 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf compiling
/home/wfg/mm

2012-11-13-12:50:07 detecting boot state 2.6.39-bisect3 #11 .............1 TEST FAILURE
bisect: bad commit v2.6.39
git checkout v2.6.38

2012-11-13-12:50:30 521cb40b0c44418a4fd36dc633f575813d59a43d compiling
2012-11-13-12:51:21 521cb40b0c44418a4fd36dc633f575813d59a43d SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   .
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   arch/x86/boot/compressed
  CLEAN   arch/x86/boot
  CLEAN   .tmp_versions
  CLEAN   vmlinux System.map .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsyms2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2 .tmp_System.map
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated
  CLEAN   .config .config.old .version include/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.38
git checkout v2.6.37

2012-11-13-12:51:32 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5 compiling
2012-11-13-12:52:46 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   .
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   Documentation/accounting
  CLEAN   Documentation/auxdisplay
  CLEAN   Documentation/connector
  CLEAN   Documentation/filesystems
  CLEAN   Documentation/ia64
  CLEAN   Documentation/laptops
  CLEAN   Documentation/networking/timestamping
  CLEAN   Documentation/networking
  CLEAN   Documentation/pcmcia
  CLEAN   Documentation/spi
  CLEAN   Documentation/timers
  CLEAN   Documentation/vm
  CLEAN   Documentation/watchdog/src
  CLEAN   .tmp_versions
  CLEAN   .tmp_kallsyms1.S .tmp_kallsyms1.o .tmp_kallsyms2.S .tmp_kallsyms2.o .tmp_vmlinux1 .tmp_vmlinux2
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config usr/include include/generated
  CLEAN   .config .config.old .version .old_version include/linux/version.h Module.symvers
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.37
git checkout v2.6.36

2012-11-13-12:52:56 f6f94e2ab1b33f0082ac22d71f66385a60d8157f compiling
2012-11-13-12:54:03 f6f94e2ab1b33f0082ac22d71f66385a60d8157f SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   /c/wfg/mm
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated
  CLEAN   .config .config.old .version include/linux/version.h
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.36
git checkout v2.6.35

2012-11-13-12:54:13 9fe6206f400646a2322096b56c59891d530e8d51 compiling
2012-11-13-12:56:00 9fe6206f400646a2322096b56c59891d530e8d51 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   /c/wfg/mm
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   arch/x86/lib
  CLEAN   kernel
  CLEAN   lib
  CLEAN   net/caif
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated
  CLEAN   .config .config.old .version include/linux/version.h
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.35
git checkout v2.6.34

2012-11-13-12:56:11 e40152ee1e1c7a63f4777791863215e3faa37a86 compiling
2012-11-13-12:57:15 e40152ee1e1c7a63f4777791863215e3faa37a86 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   /c/wfg/mm
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated
  CLEAN   .config .config.old .version include/linux/version.h
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.34
git checkout v2.6.33

2012-11-13-12:57:28 60b341b778cc2929df16c0a504c91621b3c6a4ad compiling
2012-11-13-12:58:24 60b341b778cc2929df16c0a504c91621b3c6a4ad SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   /c/wfg/mm
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include/generated
  CLEAN   .config .config.old .version include/linux/version.h
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.33
git checkout v2.6.32

2012-11-13-12:58:35 22763c5cf3690a681551162c15d34d935308c8d7 compiling
2012-11-13-12:59:28 22763c5cf3690a681551162c15d34d935308c8d7 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   /c/wfg/mm
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   init
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include2
  CLEAN   .config .config.old include/asm .version include/linux/autoconf.h include/linux/version.h include/linux/utsrelease.h include/linux/bounds.h include/asm-x86/asm-offsets.h include/asm/asm-offsets.h
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.32
git checkout v2.6.31

2012-11-13-12:59:38 74fca6a42863ffacaf7ba6f1936a9f228950f657 compiling
2012-11-13-13:00:31 74fca6a42863ffacaf7ba6f1936a9f228950f657 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   /c/wfg/mm
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   init
  CLEAN   kernel
  CLEAN   lib
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include2
  CLEAN   .config .config.old include/asm .version include/linux/autoconf.h include/linux/version.h include/linux/utsrelease.h include/linux/bounds.h include/asm-x86/asm-offsets.h include/asm/asm-offsets.h
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.31
git checkout v2.6.30

2012-11-13-13:00:42 07a2039b8eb0af4ff464efd3dfd95de5c02648c6 compiling
2012-11-13-13:01:01 07a2039b8eb0af4ff464efd3dfd95de5c02648c6 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   /c/wfg/mm
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   init
  CLEAN   kernel
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include2
  CLEAN   .config .config.old include/asm .version include/linux/autoconf.h include/linux/version.h include/linux/utsrelease.h include/linux/bounds.h include/asm-x86/asm-offsets.h include/asm/asm-offsets.h
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.30
git checkout v2.6.29

2012-11-13-13:01:12 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84 compiling
2012-11-13-13:01:38 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   /c/wfg/mm
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   init
  CLEAN   kernel
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include2
  CLEAN   .config .config.old include/asm .version include/linux/autoconf.h include/linux/version.h include/linux/utsrelease.h include/linux/bounds.h include/asm-x86/asm-offsets.h include/asm/asm-offsets.h
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.29
git checkout v2.6.28

2012-11-13-13:01:48 4a6908a3a050aacc9c3a2f36b276b46c0629ad91 compiling
2012-11-13-13:02:13 4a6908a3a050aacc9c3a2f36b276b46c0629ad91 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   /c/wfg/mm
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel/cpu
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   init
  CLEAN   kernel
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include2
  CLEAN   .config .config.old include/asm .version include/linux/autoconf.h include/linux/version.h include/linux/utsrelease.h include/linux/bounds.h include/asm-x86/asm-offsets.h include/asm/asm-offsets.h
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.28
git checkout v2.6.27

2012-11-13-13:02:22 3fa8749e584b55f1180411ab1b51117190bac1e5 compiling
2012-11-13-13:02:44 3fa8749e584b55f1180411ab1b51117190bac1e5 SKIP BROKEN BUILD
/usr/bin/make -C source O=/cc/wfg/mm-bisect3-i386 ARCH=i386 distclean
make: Entering directory `/c/wfg/mm'
  CLEAN   /c/wfg/mm
  CLEAN   arch/x86/kernel/acpi/realmode
  CLEAN   arch/x86/kernel
  CLEAN   arch/x86/vdso
  CLEAN   init
  CLEAN   kernel
  CLEAN   usr
  CLEAN   .tmp_versions
  CLEAN   scripts/basic
  CLEAN   scripts/kconfig
  CLEAN   scripts/mod
  CLEAN   scripts
  CLEAN   include/config include2
  CLEAN   .config .config.old include/asm .version include/linux/autoconf.h include/linux/version.h include/linux/utsrelease.h include/linux/bounds.h include/asm-x86/asm-offsets.h include/asm/asm-offsets.h
make: Leaving directory `/c/wfg/mm'
bisect: skip broken build for v2.6.27
ERROR# 1: /c/kernel-tests/bisect:2685: main: return 1

========= linux-next =========

2012-11-13-13:03:09 6d6b785abc93179b02b2e62bb73a9335ebcaf24a compiling
/home/wfg/mm

2012-11-13-13:05:44 detecting boot state 3.7.0-rc5-bisect3-next-20121112 #1 ...1..2....3 TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:25: main: $BISECT_TEST $KBUILD_OUTPUT

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.7.0-rc5 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
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
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
# CONFIG_X86_ANCIENT_MCE is not set
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_3G_OPT=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xB0000000
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
CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
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
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
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
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
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
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_JANZ_ICAN3 is not set
CONFIG_PCH_CAN=y
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=y
CONFIG_CAN_EMS_PCMCIA=y
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCMCIA is not set
CONFIG_CAN_PEAK_PCI=y
# CONFIG_CAN_PEAK_PCIEC is not set
CONFIG_CAN_KVASER_PCI=y
# CONFIG_CAN_PLX_PCI is not set
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
CONFIG_CAN_ESD_USB2=y
CONFIG_CAN_PEAK_USB=y
CONFIG_CAN_SOFTING=y
CONFIG_CAN_SOFTING_CS=y
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
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
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=y
# CONFIG_WINBOND_FIR is not set
CONFIG_TOSHIBA_FIR=y
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=y
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
# CONFIG_BT_HCIBLUECARD is not set
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_ATH3K is not set
CONFIG_BT_WILINK=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
# CONFIG_NFC is not set

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_OMAP_OCP2SCP is not set
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
# CONFIG_MTD_CFI_I2 is not set
CONFIG_MTD_CFI_I4=y
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SBC_GXX=y
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=y
CONFIG_MTD_DOC2001=y
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_DOCPROBE=y
CONFIG_MTD_DOCECC=y
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
CONFIG_MTD_DOCPROBE_HIGH=y
CONFIG_MTD_DOCPROBE_55AA=y
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_MUSEUM_IDS=y
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ALAUDA=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
# CONFIG_MTD_ONENAND_SIM is not set

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

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
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
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
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
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_OMAP4=y
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=y
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
# CONFIG_TOUCHSCREEN_USB_JASTEC is not set
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MRST_MAX3110=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
CONFIG_MWAVE=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_INTEL_MID=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y
# CONFIG_HDQ_MASTER_OMAP is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
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
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_MFD_LM3533=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_STMPE_SPI=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_SMSC=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_CS5535=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_VX855=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_TTM is not set
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_MGA=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
# CONFIG_LCD_LMS283GF05 is not set
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_PS3REMOTE=y
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_SUSPEND is not set
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_SSB is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=y
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=y
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MOTOROLA=y
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIEMENS_MPI=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=y
CONFIG_USB_SERIAL_ZIO=y
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y

#
# USB Physical Layer drivers
#
CONFIG_OMAP_USB2=y
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
# CONFIG_RTC_DRV_M41T94 is not set
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_WM8350 is not set
CONFIG_RTC_DRV_AB3100=y

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
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
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_SLICOSS=y
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
# CONFIG_ASUS_OLED is not set
CONFIG_TRANZPORT=y
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_DX_SEP is not set
# CONFIG_ZSMALLOC is not set
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
# CONFIG_FT1000_USB is not set
CONFIG_FT1000_PCMCIA=y

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ANDROID_LOGGER is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=y
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
CONFIG_PHONE=y
CONFIG_PHONE_IXJ=y
# CONFIG_PHONE_IXJ_PCMCIA is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
CONFIG_DGRP=y
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_ACPI_WMI=y
CONFIG_MXM_WMI=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_MAX8997=y
# CONFIG_EXTCON_ARIZONA is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
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
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
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
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_MMIOTRACE=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
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
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set

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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
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
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--C7zPtVaVf+AK4Oqc--
