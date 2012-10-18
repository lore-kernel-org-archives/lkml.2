Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2JRCnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 22:43:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:41037 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab2JRCni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 22:43:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,604,1344236400"; 
   d="scan'208";a="235337653"
Date: Thu, 18 Oct 2012 10:43:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ima_inode_post_setattr] kernel BUG at mm/slub.c:3479!
Message-ID: <20121018024317.GA25407@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Mimi,

Although this occurs in the xen tree head, it's more likely related to
ima_inode_post_setattr().

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/for-linus-3.8
head:   d01b193de1a961e028ee6df5ad0b34c3e56a995f
commit: d01b193de1a961e028ee6df5ad0b34c3e56a995f [0/0] xen/acpi: Support ACPI hotplug of CPUs.

[  115.499469] Write protecting the kernel read-only data: 2752k
[  134.707390] ------------[ cut here ]------------
[  134.707390] kernel BUG at /c/kernel-tests/src/linux/mm/slub.c:3479!
[  134.707390] invalid opcode: 0000 [#1] 
[  134.707390] Pid: 1, comm: init Not tainted 3.6.0-00451-gd01b193 #2 Bochs Bochs
[  134.707390] EIP: 0060:[<c1235dbe>] EFLAGS: 00000246 CPU: 0
[  134.707390] EIP is at kfree+0x2be/0x490
[  134.707390] EAX: 00000001 EBX: 00000001 ECX: 00000000 EDX: 00000000
[  134.707390] ESI: cdeef760 EDI: cd83bdac EBP: cd83bd70 ESP: cd83bd50
[  134.707390]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[  134.707390] CR0: 80050033 CR2: b7782000 CR3: 0f9a8000 CR4: 00000690
[  134.707390] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  134.707390] DR6: 00000000 DR7: 00000000
[  134.707390] Process init (pid: 1, ti=cd83a000 task=cd838000 task.ti=cd83a000)
[  134.707390] Stack:
[  134.707390]  00000000 cd83bd5c c1085b74 cd83bd88 c1298a5e cd83a000 ffffffc3 cd83bd90
[  134.707390]  cd83bd88 c1298a5e cd83bd90 c1ffdf63 00000001 cd832914 cd83bd98 c1298d4a
[  134.707390]  00000000 00000002 cd83bdac c11e0400 c995c980 cd832914 00000000 cd83bdc4
[  134.707390] Call Trace:
[  134.707390]  [<c1085b74>] ? irq_exit+0x74/0x180
[  134.707390]  [<c1298a5e>] ? __simple_xattr_set+0x28e/0x360
[  134.707390]  [<c1298a5e>] __simple_xattr_set+0x28e/0x360
[  134.707390]  [<c1298d4a>] simple_xattr_remove+0x2a/0x40
[  134.707390]  [<c11e0400>] shmem_removexattr+0xc0/0x120
[  134.707390]  [<c14f11ed>] ima_inode_post_setattr+0x21d/0x250
[  134.707390]  [<c1284316>] notify_change+0xb66/0xc40
[  134.707390]  [<c1239c58>] do_truncate+0xf8/0x160
[  134.707390]  [<c1261fcd>] do_last.isra.38+0xb3d/0x1a80
[  134.707390]  [<c12632e1>] path_openat+0x3d1/0xd10
[  134.707390]  [<c11476cb>] ? note_interrupt+0x4db/0x7f0
[  134.707390]  [<c1263c57>] do_filp_open+0x37/0x140
[  134.707390]  [<c123ce71>] do_sys_open+0x471/0x630
[  134.707390]  [<c10881b6>] ? __find_resource+0x166/0x470
[  134.707390]  [<c123d06b>] sys_open+0x3b/0x70
[  134.707390]  [<c1de6ce1>] sysenter_do_call+0x12/0x2c
[  134.707390] Code: 89 d0 f3 ff 8b 04 9d 8c a0 2c c2 83 c0 01 85 db 89 04 9d 8c a0 2c c2 0f 84 6a 01 00 00 83 05 a8 4b 61 c2 01 83 15 ac 4b 61 c2 00 <0f> 0b 83 05 b8 4b 61 c2 01 83 15 bc 4b 61 c2 00 83 05 30 4c 61
[  134.707390] EIP: [<c1235dbe>] kfree+0x2be/0x490 SS:ESP 0068:cd83bd50

Thanks,
Fengguang

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-9785-2012-10-12-21-41-48-3.6.0-00451-gd01b193-2"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-00451-gd01b193 (kbuild@bee) (gcc version=
 4.7.1 (Debian 4.7.1-6) ) #2 Fri Oct 12 21:35:59 CST 2012
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x02bfa0=
00-0x02bfffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128808(98%)
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
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c22571a0, node_mem_map cd=
d3f200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3939 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 60958 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64897
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 branch=3Dxen/devel/for-linus-3.8 log_buf_len=3D8M ignore_l=
oglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabled =
panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-10-12-21-36-58-xen:devel:fo=
r-linus-3.8:d01b193-d01b193-i386-randconfig-b207-3-ant noapic nolapic nohz=
=3Doff BOOT_IMAGE=3Dkernel-tests/kernels/i386-randconfig-b207/d01b193/vmlin=
uz-3.6.0-00451-gd01b193
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 199560k/262136k available (14239k kernel code, 62076=
k reserved, 6436k data, 824k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc2433000 - 0xc2501000   ( 824 kB)
[    0.000000]       .data : 0xc1de7d37 - 0xc2430d80   (6436 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1de7d37   (14239 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dcd808000 soft=3Dcd80a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3191.986 MHz processor
[    0.044098] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6386.97 BogoMIPS (lpj=3D10639953)
[    0.050459] pid_max: default: 32768 minimum: 301
[    0.059779] Security Framework initialized
[    0.076051] Mount-cache hash table entries: 512
[    0.172465] Initializing cgroup subsys debug
[    0.175067] Initializing cgroup subsys freezer
[    0.177543] Initializing cgroup subsys blkio
[    0.198403] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.198403] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.198403] tlb_flushall_shift: -1
[    0.200427] CPU: AMD QEMU Virtual CPU version 1.1.0 (fam: 06, model: 02,=
 stepping: 03)
[    0.317891] ACPI: Core revision 20120913
[    0.667941] ACPI: setting ELCR to 0200 (from 0c00)
[    0.734797] Performance Events: Broken PMU hardware detected, using soft=
ware events only.
[    0.740494] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.789429] ftrace: Allocated trace_printk buffers
[    0.800985] Testing tracer nop: PASSED
[    1.111436] atomic64 test passed for i586+ platform with CX8 and with SSE
[    1.160601] regulator-dummy: no parameters
[    1.181515] NET: Registered protocol family 16
[    1.257379] ACPI: bus type pci registered
[    1.263944] dca service started, version 1.12.1
[    1.280586] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    1.282556] PCI: Using configuration type 1 for base access
[    1.443756] bio: create slab <bio-0> at 0
[    1.478669] ACPI: Added _OSI(Module Device)
[    1.480446] ACPI: Added _OSI(Processor Device)
[    1.481746] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.483607] ACPI: Added _OSI(Processor Aggregator Device)
[    1.562561] ACPI: EC: Look up EC in DSDT
[    2.070772] ACPI: Interpreter enabled
[    2.072407] ACPI: (supports S0 S3 S5)
[    2.081212] ACPI: Using PIC for interrupt routing
[    2.692505] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    2.712146] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.722353] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    2.723900] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    2.727149] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    2.730249] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    2.734565] PCI: root bus 00: using default resources
[    2.738212] pci_root PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.
[    2.751228] PCI host bridge to bus 0000:00
[    2.754701] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.757302] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    2.758966] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
f]
[    2.767410] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    2.780967] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    2.785667] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    2.796942] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    2.803861] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    2.809392] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    2.810516] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    2.815003] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    2.821652] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    2.825839] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    2.841530] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    2.844730] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    2.850363] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    2.854629] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    2.868029] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    2.873780] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    2.878008] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    2.882275] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    2.897932] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    2.902559] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    2.907917] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    2.922451] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    2.927976] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    2.932314] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    2.947933] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    2.952539] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    2.956981] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    2.972244] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    2.977978] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    2.982340] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    2.997910] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    3.002366] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    3.006972] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    3.022189] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    3.026983] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    3.039313] pci_bus 0000:00: on NUMA node 0
[    3.041143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    3.148311]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    3.150686]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    4.244802] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    4.262161] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    4.277470] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    4.292036] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    4.306764] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    4.349718] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    4.353922] vgaarb: loaded
[    4.355061] vgaarb: bridge control possible 0000:00:02.0
[    4.403502] PCI: Using ACPI for IRQ routing
[    4.405858] PCI: pci_cache_line_size set to 64 bytes
[    4.414738] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    4.418082] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    4.496935] Switching to clocksource hpet
[    4.503479] CE: hpet increased min_delta_ns to 5000 nsec
[    4.503479] CE: hpet increased min_delta_ns to 7500 nsec
[    4.536347] Warning: could not register all branches stats
[    4.539246] Warning: could not register annotated branches stats
[    6.068018] FS-Cache: Loaded
[    6.074450] CacheFiles: Loaded
[    6.085511] pnp: PnP ACPI init
[    6.088601] ACPI: bus type pnp registered
[    6.099261] pnp 00:00: [bus 00-ff]
[    6.102124] pnp 00:00: [io  0x0cf8-0x0cff]
[    6.104555] pnp 00:00: [io  0x0000-0x0cf7 window]
[    6.106025] pnp 00:00: [io  0x0d00-0xffff window]
[    6.108816] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    6.111289] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    6.121567] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    6.128557] pnp 00:01: [io  0x0070-0x0071]
[    6.132408] pnp 00:01: [irq 8]
[    6.134701] pnp 00:01: [io  0x0072-0x0077]
[    6.139573] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    6.149439] pnp 00:02: [io  0x0060]
[    6.151590] pnp 00:02: [io  0x0064]
[    6.152790] pnp 00:02: [irq 1]
[    6.156940] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    6.165217] pnp 00:03: [irq 12]
[    6.169481] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    6.178194] pnp 00:04: [io  0x03f2-0x03f5]
[    6.179634] pnp 00:04: [io  0x03f7]
[    6.181559] pnp 00:04: [irq 6]
[    6.183524] pnp 00:04: [dma 2]
[    6.188460] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    6.199715] pnp 00:05: [io  0x0378-0x037f]
[    6.202017] pnp 00:05: [irq 7]
[    6.206160] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    6.217911] pnp 00:06: [io  0x03f8-0x03ff]
[    6.219439] pnp 00:06: [irq 4]
[    6.224648] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.255089] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    6.260295] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    6.286293] pnp: PnP ACPI: found 8 devices
[    6.288838] ACPI: ACPI bus type pnp unregistered
[    6.291009] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    6.539719] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    6.542323] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    6.550986] NET: Registered protocol family 1
[    6.554767] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    6.557694] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    6.561426] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    6.564771] pci 0000:00:02.0: Boot video device
[    6.568292] PCI: CLS 0 bytes, default 64
[    6.631523] Unpacking initramfs...
[   79.825928] Freeing initrd memory: 25284k freed
[   80.242003] NatSemi SCx200 Driver
[   80.305892] Testing tracer branch:=20
[   80.862224] hrtimer: interrupt took 7899253 ns
[   80.891208] PASSED
[   81.155552] tsc: Refined TSC clocksource calibration: 3192.000 MHz
[   81.159695] Switching to clocksource tsc
[   81.212884] fuse init (API version 7.20)
[   81.229045] SGI XFS with security attributes, realtime, no debug enabled
[   81.761883] alg: No test for stdrng (krng)
[   81.782737] io scheduler noop registered (default)
[   81.831408] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[   81.833053] crc32: self tests passed, processed 225944 bytes in 7357422 =
nsec
[   81.846187] crc32c: CRC_LE_BITS =3D 64
[   81.848852] crc32c: self tests passed, processed 225944 bytes in 3803243=
 nsec
[   81.879584] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   81.882588] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[   81.891599] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   81.919409] rivafb_setup START
[   81.938721] no IO addresses supplied
[   81.949535] hgafb: HGA card not detected.
[   81.955280] hgafb: probe of hgafb.0 failed with error -22
[   81.996456] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   82.009747] ACPI: Power Button [PWRF]
[   82.098660] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   83.442846] HDLC line discipline maxframe=3D4096
[   83.446031] N_HDLC line discipline registered.
[   83.448891] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   83.501917] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   83.568144] Cyclades driver 2.6
[   83.573202] MOXA Smartio/Industio family driver version 2.0.5
[   83.579362] RocketPort device driver module, version 2.09, 12-June-2003
[   83.585694] No rocketport ports found; unloading driver
[   83.592051] SyncLink serial driver $Revision: 4.38 $
[   83.949930] SyncLink serial driver $Revision: 4.38 $, tty major#253
[   83.965826] Non-volatile memory driver v1.3
[   83.968928] toshiba: not a supported Toshiba laptop
[   83.975538] ppdev: user-space parallel port driver
[   83.978308] scx200_gpio: no SCx200 gpio present
[   83.983128] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   83.987839] platform pc8736x_gpio.0: no device found
[   84.003497] nsc_gpio initializing
[   84.008139] smapi::smapi_init, ERROR invalid usSmapiID
[   84.009661] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[   84.014450] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[   84.016375] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   84.019895] Linux agpgart interface v0.103
[   84.052832] ipmi message handler version 39.2
[   84.056272] ipmi device interface
[   84.062778] IPMI System Interface driver.
[   84.072452] ipmi_si: Adding default-specified kcs state machine
[   84.076227] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   84.082243] ipmi_si: Interface detection failed
[   84.091844] ipmi_si: Adding default-specified smic state machine
[   84.095283] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   84.099515] ipmi_si: Interface detection failed
[   84.105569] ipmi_si: Adding default-specified bt state machine
[   84.108812] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   84.113076] ipmi_si: Interface detection failed
[   84.123280] ipmi_si: Unable to find any System Interface(s)
[   84.129111] IPMI Watchdog: driver initialized
[   84.131839] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   84.135606] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   84.138940] Hangcheck: Using getrawmonotonic().
[   84.152495] [drm] Initialized drm 1.1.0 20060810
[   84.319215] loop: module loaded
[   84.321725] Compaq SMART2 Driver (v 2.6.0)
[   84.328169] HP CISS Driver (v 3.6.26)
[   84.342630] mtip32xx Version 1.2.6os3
[   84.352882] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   84.362559] Phantom Linux Driver, version n0.9.8, init OK
[   84.375692] i2c-core: driver [apds9802als] using legacy suspend method
[   84.379047] i2c-core: driver [apds9802als] using legacy resume method
[   84.382081] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   84.393015] i2c-core: driver [fsa9480] using legacy suspend method
[   84.396129] i2c-core: driver [fsa9480] using legacy resume method
[   84.408885] Driver for timberdale has been successfully registered.
[   84.425220] Uniform Multi-Platform E-IDE driver
[   84.456348] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[   84.478418] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[   84.488117] PIIX_IDE 0000:00:01.1: setting latency timer to 64
[   84.491332]     ide0: BM-DMA at 0xc1c0-0xc1c7
[   84.499230]     ide1: BM-DMA at 0xc1c8-0xc1cf
[   84.505403] Probing IDE interface ide0...
[   84.573525] Floppy drive(s): fd0 is 1.44M
[   84.625262] FDC 0 is a S82078B
[   85.268902] Probing IDE interface ide1...
[   86.252303] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[   87.141517] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[   87.151988] hdc: MWDMA2 mode selected
[   87.165948] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   87.169296] ide1 at 0x170-0x177,0x376 on irq 15
[   87.190193] ide-gd driver 1.18
[   87.195130] ide-cd driver 5.00
[   87.256352] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[   87.261655] cdrom: Uniform CD-ROM driver Revision: 3.20
[   87.332563] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   87.362797] serio: i8042 KBD port at 0x60,0x64 irq 1
[   87.366904] serio: i8042 AUX port at 0x60,0x64 irq 12
[   87.371567] parkbd: no such parport
[   87.384225] mousedev: PS/2 mouse device common for all mice
[   87.421057] i2c /dev entries driver
[   87.434698] i2c-parport: adapter type unspecified
[   87.439168] scx200_i2c: no SCx200 gpio pins available
[   87.495024] pc87360: PC8736x not detected, module not inserted
[   87.512622] cpuidle: using governor ladder
[   87.549282] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   87.597908] panel: driver version 0.9.5 not yet registered
[   87.604648] Loading crystalhd 0.9.27
[   87.621380] input: Speakup as /devices/virtual/input/input2
[   87.635635] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[   87.641717] speakup 3.1.6: initialized
[   87.645205] synth name on entry is: (null)
[   87.648672] i2c-core: driver [cptm1217] using legacy suspend method
[   87.651342] i2c-core: driver [cptm1217] using legacy resume method
[   87.671703] oprofile: using timer interrupt.
[   87.707877] Running tests on trace events:
[   87.709618] Testing event kfree_skb: OK
[   87.768862] Testing event consume_skb: OK
[   87.804423] Testing event skb_copy_datagram_iovec: OK
[   87.840792] Testing event net_dev_xmit: OK
[   87.873171] Testing event net_dev_queue: OK
[   87.906398] Testing event netif_receive_skb: OK
[   87.939141] Testing event netif_rx: OK
[   87.972800] Testing event napi_poll: OK
[   88.006343] Testing event sock_rcvqueue_full: OK
[   88.039689] Testing event sock_exceed_buf_limit: OK
[   88.073049] Testing event udp_fail_queue_rcv_skb: OK
[   88.106864] Testing event sep_func_start: OK
[   88.139723] Testing event sep_func_end: OK
[   88.173224] Testing event sep_misc_event: OK
[   88.268566] Testing event regmap_reg_write: OK
[   88.301184] Testing event regmap_reg_read: OK
[   88.337657] Testing event regmap_reg_read_cache: OK
[   88.370211] Testing event regmap_hw_read_start: OK
[   88.404687] Testing event regmap_hw_read_done: OK
[   88.439788] Testing event regmap_hw_write_start: OK
[   88.473014] Testing event regmap_hw_write_done: OK
[   88.507527] Testing event regcache_sync: OK
[   88.539360] Testing event regmap_cache_only: OK
[   88.574243] Testing event regmap_cache_bypass: OK
[   88.607903] Testing event i915_gem_object_create: OK
[   88.643324] Testing event i915_gem_object_bind: OK
[   88.676494] Testing event i915_gem_object_unbind: OK
[   88.709505] Testing event i915_gem_object_change_domain: OK
[   88.743037] Testing event i915_gem_object_pwrite: OK
[   88.776387] Testing event i915_gem_object_pread: OK
[   88.872541] Testing event i915_gem_object_fault: OK
[   88.906413] Testing event i915_gem_object_clflush: OK
[   88.939743] Testing event i915_gem_object_destroy: OK
[   88.972950] Testing event i915_gem_evict: OK
[   89.006626] Testing event i915_gem_evict_everything: OK
[   89.039809] Testing event i915_gem_ring_dispatch: OK
[   89.075452] Testing event i915_gem_ring_flush: OK
[   89.109922] Testing event i915_gem_request_add: OK
[   89.142899] Testing event i915_gem_request_complete: OK
[   89.176488] Testing event i915_gem_request_retire: OK
[   89.209438] Testing event i915_gem_request_wait_begin: OK
[   89.243282] Testing event i915_gem_request_wait_end: OK
[   89.277491] Testing event i915_ring_wait_begin: OK
[   89.309816] Testing event i915_ring_wait_end: OK
[   89.342826] Testing event i915_flip_request: OK
[   89.376066] Testing event i915_flip_complete: OK
[   89.474317] Testing event i915_reg_rw: OK
[   89.506446] Testing event intel_gpu_freq_change: OK
[   89.539659] Testing event drm_vblank_event: OK
[   89.573324] Testing event drm_vblank_event_queued: OK
[   89.606589] Testing event drm_vblank_event_delivered: OK
[   89.640186] Testing event mix_pool_bytes: OK
[   89.674215] Testing event mix_pool_bytes_nolock: OK
[   89.707716] Testing event credit_entropy_bits: OK
[   89.739871] Testing event get_random_bytes: OK
[   89.773190] Testing event extract_entropy: OK
[   89.807668] Testing event extract_entropy_user: OK
[   89.839901] Testing event regulator_enable: OK
[   89.873100] Testing event regulator_enable_delay: OK
[   89.906249] Testing event regulator_enable_complete: OK
[   89.939629] Testing event regulator_disable: OK
[   89.973507] Testing event regulator_disable_complete: OK
[   90.071550] Testing event regulator_set_voltage: OK
[   90.103258] Testing event regulator_set_voltage_complete: OK
[   90.136474] Testing event gpio_direction: OK
[   90.171168] Testing event gpio_value: OK
[   90.203109] Testing event block_rq_abort: OK
[   90.236413] Testing event block_rq_requeue: OK
[   90.271200] Testing event block_rq_complete: OK
[   90.303560] Testing event block_rq_insert: OK
[   90.336550] Testing event block_rq_issue: OK
[   90.369620] Testing event block_bio_bounce: OK
[   90.402910] Testing event block_bio_complete: OK
[   90.436521] Testing event block_bio_backmerge: OK
[   90.469554] Testing event block_bio_frontmerge: OK
[   90.503031] Testing event block_bio_queue: OK
[   90.536806] Testing event block_getrq: OK
[   90.569573] Testing event block_sleeprq: OK
[   90.666152] Testing event block_plug: OK
[   90.699793] Testing event block_unplug: OK
[   90.734219] Testing event block_split: OK
[   90.767523] Testing event block_bio_remap: OK
[   90.799740] Testing event block_rq_remap: OK
[   90.833104] Testing event xfs_attr_list_sf: OK
[   90.867644] Testing event xfs_attr_list_sf_all: OK
[   90.899498] Testing event xfs_attr_list_leaf: OK
[   90.933503] Testing event xfs_attr_list_leaf_end: OK
[   90.970184] Testing event xfs_attr_list_full: OK
[   91.022166] Testing event xfs_attr_list_add: OK
[   91.052760] Testing event xfs_attr_list_wrong_blk: OK
[   91.082727] Testing event xfs_attr_list_notfound: OK
[   91.115630] Testing event xfs_perag_get: OK
[   91.145182] Testing event xfs_perag_get_tag: OK
[   91.175939] Testing event xfs_perag_put: OK
[   91.205832] Testing event xfs_perag_set_reclaim: OK
[   91.236110] Testing event xfs_perag_clear_reclaim: OK
[   91.268874] Testing event xfs_attr_list_node_descend: OK
[   91.302460] Testing event xfs_iext_insert: OK
[   91.335078] Testing event xfs_iext_remove: OK
[   91.366268] Testing event xfs_bmap_pre_update: OK
[   91.398993] Testing event xfs_bmap_post_update: OK
[   91.429602] Testing event xfs_extlist: OK
[   91.459005] Testing event xfs_buf_init: OK
[   91.489482] Testing event xfs_buf_free: OK
[   91.519058] Testing event xfs_buf_hold: OK
[   91.550900] Testing event xfs_buf_rele: OK
[   91.582893] Testing event xfs_buf_iodone: OK
[   91.618619] Testing event xfs_buf_iorequest: OK
[   91.652359] Testing event xfs_buf_bawrite: OK
[   91.682987] Testing event xfs_buf_lock: OK
[   91.716208] Testing event xfs_buf_lock_done: OK
[   91.749483] Testing event xfs_buf_trylock: OK
[   91.779641] Testing event xfs_buf_unlock: OK
[   91.809810] Testing event xfs_buf_iowait: OK
[   91.838955] Testing event xfs_buf_iowait_done: OK
[   91.871136] Testing event xfs_buf_delwri_queue: OK
[   91.906208] Testing event xfs_buf_delwri_queued: OK
[   91.959554] Testing event xfs_buf_delwri_split: OK
[   92.010910] Testing event xfs_buf_get_uncached: OK
[   92.043470] Testing event xfs_bdstrat_shut: OK
[   92.082344] Testing event xfs_buf_item_relse: OK
[   92.128937] Testing event xfs_buf_item_iodone: OK
[   92.175183] Testing event xfs_buf_item_iodone_async: OK
[   92.216281] Testing event xfs_buf_error_relse: OK
[   92.249063] Testing event xfs_trans_read_buf_io: OK
[   92.278892] Testing event xfs_trans_read_buf_shut: OK
[   92.309571] Testing event xfs_btree_corrupt: OK
[   92.342400] Testing event xfs_da_btree_corrupt: OK
[   92.372755] Testing event xfs_reset_dqcounts: OK
[   92.403205] Testing event xfs_inode_item_push: OK
[   92.438050] Testing event xfs_buf_find: OK
[   92.469082] Testing event xfs_buf_get: OK
[   92.499478] Testing event xfs_buf_read: OK
[   92.529210] Testing event xfs_buf_ioerror: OK
[   92.559545] Testing event xfs_buf_item_size: OK
[   92.592156] Testing event xfs_buf_item_size_stale: OK
[   92.622886] Testing event xfs_buf_item_format: OK
[   92.656197] Testing event xfs_buf_item_format_stale: OK
[   92.689165] Testing event xfs_buf_item_pin: OK
[   92.718952] Testing event xfs_buf_item_unpin: OK
[   92.749486] Testing event xfs_buf_item_unpin_stale: OK
[   92.782197] Testing event xfs_buf_item_unlock: OK
[   92.813514] Testing event xfs_buf_item_unlock_stale: OK
[   92.845529] Testing event xfs_buf_item_committed: OK
[   92.878124] Testing event xfs_buf_item_push: OK
[   92.909443] Testing event xfs_trans_get_buf: OK
[   92.938822] Testing event xfs_trans_get_buf_recur: OK
[   92.969524] Testing event xfs_trans_getsb: OK
[   93.002644] Testing event xfs_trans_getsb_recur: OK
[   93.034816] Testing event xfs_trans_read_buf: OK
[   93.069678] Testing event xfs_trans_read_buf_recur: OK
[   93.112435] Testing event xfs_trans_log_buf: OK
[   93.146190] Testing event xfs_trans_brelse: OK
[   93.175878] Testing event xfs_trans_bjoin: OK
[   93.205601] Testing event xfs_trans_bhold: OK
[   93.242843] Testing event xfs_trans_bhold_release: OK
[   93.279420] Testing event xfs_trans_binval: OK
[   93.319138] Testing event xfs_ilock: OK
[   93.348627] Testing event xfs_ilock_nowait: OK
[   93.381055] Testing event xfs_ilock_demote: OK
[   93.412385] Testing event xfs_iunlock: OK
[   93.442665] Testing event xfs_iget_skip: OK
[   93.472269] Testing event xfs_iget_reclaim: OK
[   93.502474] Testing event xfs_iget_reclaim_fail: OK
[   93.533514] Testing event xfs_iget_hit: OK
[   93.566636] Testing event xfs_iget_miss: OK
[   93.599305] Testing event xfs_getattr: OK
[   93.629127] Testing event xfs_setattr: OK
[   93.658845] Testing event xfs_readlink: OK
[   93.689592] Testing event xfs_alloc_file_space: OK
[   93.718895] Testing event xfs_free_file_space: OK
[   93.749295] Testing event xfs_readdir: OK
[   93.778804] Testing event xfs_vm_bmap: OK
[   93.809206] Testing event xfs_file_ioctl: OK
[   93.838865] Testing event xfs_file_compat_ioctl: OK
[   93.869305] Testing event xfs_ioctl_setattr: OK
[   93.898986] Testing event xfs_dir_fsync: OK
[   93.929104] Testing event xfs_file_fsync: OK
[   93.958786] Testing event xfs_destroy_inode: OK
[   93.989265] Testing event xfs_evict_inode: OK
[   94.018731] Testing event xfs_update_time: OK
[   94.049263] Testing event xfs_dquot_dqalloc: OK
[   94.078760] Testing event xfs_dquot_dqdetach: OK
[   94.109260] Testing event xfs_ihold: OK
[   94.138873] Testing event xfs_irele: OK
[   94.176273] Testing event xfs_inode_pin: OK
[   94.216043] Testing event xfs_inode_unpin: OK
[   94.252653] Testing event xfs_inode_unpin_nowait: OK
[   94.284280] Testing event xfs_remove: OK
[   94.317907] Testing event xfs_link: OK
[   94.362052] Testing event xfs_lookup: OK
[   94.402838] Testing event xfs_create: OK
[   94.442298] Testing event xfs_symlink: OK
[   94.472625] Testing event xfs_rename: OK
[   94.502024] Testing event xfs_dqadjust: OK
[   94.532479] Testing event xfs_dqreclaim_want: OK
[   94.562048] Testing event xfs_dqreclaim_dirty: OK
[   94.594157] Testing event xfs_dqreclaim_busy: OK
[   94.625184] Testing event xfs_dqreclaim_done: OK
[   94.655761] Testing event xfs_dqattach_found: OK
[   94.686547] Testing event xfs_dqattach_get: OK
[   94.720861] Testing event xfs_dqalloc: OK
[   94.751709] Testing event xfs_dqtobp_read: OK
[   94.782009] Testing event xfs_dqread: OK
[   94.812197] Testing event xfs_dqread_fail: OK
[   94.842506] Testing event xfs_dqget_hit: OK
[   94.872120] Testing event xfs_dqget_miss: OK
[   94.904611] Testing event xfs_dqget_freeing: OK
[   94.935566] Testing event xfs_dqget_dup: OK
[   94.970905] Testing event xfs_dqput: OK
[   95.001867] Testing event xfs_dqput_wait: OK
[   95.035473] Testing event xfs_dqput_free: OK
[   95.092062] Testing event xfs_dqrele: OK
[   95.125825] Testing event xfs_dqflush: OK
[   95.156658] Testing event xfs_dqflush_force: OK
[   95.191458] Testing event xfs_dqflush_done: OK
[   95.222821] Testing event xfs_log_done_nonperm: OK
[   95.255860] Testing event xfs_log_done_perm: OK
[   95.290903] Testing event xfs_log_umount_write: OK
[   95.324610] Testing event xfs_log_grant_sleep: OK
[   95.356877] Testing event xfs_log_grant_wake: OK
[   95.391224] Testing event xfs_log_grant_wake_up: OK
[   95.421783] Testing event xfs_log_reserve: OK
[   95.466278] Testing event xfs_log_reserve_exit: OK
[   95.507445] Testing event xfs_log_regrant: OK
[   95.552479] Testing event xfs_log_regrant_exit: OK
[   95.584906] Testing event xfs_log_regrant_reserve_enter: OK
[   95.637884] Testing event xfs_log_regrant_reserve_exit: OK
[   95.683206] Testing event xfs_log_regrant_reserve_sub: OK
[   95.715518] Testing event xfs_log_ungrant_enter: OK
[   95.745519] Testing event xfs_log_ungrant_exit: OK
[   95.775865] Testing event xfs_log_ungrant_sub: OK
[   95.805812] Testing event xfs_log_force: OK
[   95.835904] Testing event xfs_ail_push: OK
[   95.865571] Testing event xfs_ail_pinned: OK
[   95.896021] Testing event xfs_ail_locked: OK
[   95.925468] Testing event xfs_ail_flushing: OK
[   95.955799] Testing event xfs_file_read: OK
[   95.985342] Testing event xfs_file_buffered_write: OK
[   96.018449] Testing event xfs_file_direct_write: OK
[   96.055275] Testing event xfs_file_splice_read: OK
[   96.115723] Testing event xfs_file_splice_write: OK
[   96.148795] Testing event xfs_writepage: OK
[   96.179211] Testing event xfs_releasepage: OK
[   96.208922] Testing event xfs_invalidatepage: OK
[   96.239201] Testing event xfs_map_blocks_found: OK
[   96.268759] Testing event xfs_map_blocks_alloc: OK
[   96.299283] Testing event xfs_get_blocks_found: OK
[   96.329067] Testing event xfs_get_blocks_alloc: OK
[   96.359337] Testing event xfs_delalloc_enospc: OK
[   96.388845] Testing event xfs_unwritten_convert: OK
[   96.419301] Testing event xfs_get_blocks_notfound: OK
[   96.448870] Testing event xfs_setfilesize: OK
[   96.479318] Testing event xfs_itruncate_extents_start: OK
[   96.508904] Testing event xfs_itruncate_extents_end: OK
[   96.542569] Testing event xfs_pagecache_inval: OK
[   96.571971] Testing event xfs_bunmap: OK
[   96.604802] Testing event xfs_extent_busy: OK
[   96.652574] Testing event xfs_extent_busy_enomem: OK
[   96.692777] Testing event xfs_extent_busy_force: OK
[   96.722401] Testing event xfs_extent_busy_reuse: OK
[   96.752519] Testing event xfs_extent_busy_clear: OK
[   96.782072] Testing event xfs_extent_busy_trim: OK
[   96.813093] Testing event xfs_trans_commit_lsn: OK
[   96.843532] Testing event xfs_agf: OK
[   96.878110] Testing event xfs_free_extent: OK
[   96.909158] Testing event xfs_alloc_exact_done: OK
[   96.939166] Testing event xfs_alloc_exact_notfound: OK
[   96.974840] Testing event xfs_alloc_exact_error: OK
[   97.009939] Testing event xfs_alloc_near_nominleft: OK
[   97.044558] Testing event xfs_alloc_near_first: OK
[   97.076556] Testing event xfs_alloc_near_greater: OK
[   97.105982] Testing event xfs_alloc_near_lesser: OK
[   97.135353] Testing event xfs_alloc_near_error: OK
[   97.165804] Testing event xfs_alloc_near_noentry: OK
[   97.195538] Testing event xfs_alloc_near_busy: OK
[   97.225465] Testing event xfs_alloc_size_neither: OK
[   97.255443] Testing event xfs_alloc_size_noentry: OK
[   97.287509] Testing event xfs_alloc_size_nominleft: OK
[   97.319106] Testing event xfs_alloc_size_done: OK
[   97.349921] Testing event xfs_alloc_size_error: OK
[   97.382756] Testing event xfs_alloc_size_busy: OK
[   97.412601] Testing event xfs_alloc_small_freelist: OK
[   97.442208] Testing event xfs_alloc_small_notenough: OK
[   97.472664] Testing event xfs_alloc_small_done: OK
[   97.503469] Testing event xfs_alloc_small_error: OK
[   97.538230] Testing event xfs_alloc_vextent_badargs: OK
[   97.573083] Testing event xfs_alloc_vextent_nofix: OK
[   97.608166] Testing event xfs_alloc_vextent_noagbp: OK
[   97.638764] Testing event xfs_alloc_vextent_loopfailed: OK
[   97.671373] Testing event xfs_alloc_vextent_allfailed: OK
[   97.716651] Testing event xfs_dir2_sf_addname: OK
[   97.759065] Testing event xfs_dir2_sf_create: OK
[   97.804400] Testing event xfs_dir2_sf_lookup: OK
[   97.842744] Testing event xfs_dir2_sf_replace: OK
[   97.884117] Testing event xfs_dir2_sf_removename: OK
[   97.922842] Testing event xfs_dir2_sf_toino4: OK
[   97.962300] Testing event xfs_dir2_sf_toino8: OK
[   98.006338] Testing event xfs_dir2_sf_to_block: OK
[   98.041624] Testing event xfs_dir2_block_addname: OK
[   98.079025] Testing event xfs_dir2_block_lookup: OK
[   98.125992] Testing event xfs_dir2_block_replace: OK
[   98.162482] Testing event xfs_dir2_block_removename: OK
[   98.194896] Testing event xfs_dir2_block_to_sf: OK
[   98.225651] Testing event xfs_dir2_block_to_leaf: OK
[   98.256279] Testing event xfs_dir2_leaf_addname: OK
[   98.288864] Testing event xfs_dir2_leaf_lookup: OK
[   98.319399] Testing event xfs_dir2_leaf_replace: OK
[   98.348769] Testing event xfs_dir2_leaf_removename: OK
[   98.379420] Testing event xfs_dir2_leaf_to_block: OK
[   98.408837] Testing event xfs_dir2_leaf_to_node: OK
[   98.447537] Testing event xfs_dir2_node_addname: OK
[   98.475984] Testing event xfs_dir2_node_lookup: OK
[   98.506141] Testing event xfs_dir2_node_replace: OK
[   98.536141] Testing event xfs_dir2_node_removename: OK
[   98.565048] Testing event xfs_dir2_node_to_leaf: OK
[   98.595017] Testing event xfs_attr_sf_add: OK
[   98.625358] Testing event xfs_attr_sf_addname: OK
[   98.655107] Testing event xfs_attr_sf_create: OK
[   98.684653] Testing event xfs_attr_sf_lookup: OK
[   98.711299] Testing event xfs_attr_sf_remove: OK
[   98.738742] Testing event xfs_attr_sf_removename: OK
[   98.767848] Testing event xfs_attr_sf_to_leaf: OK
[   98.795303] Testing event xfs_attr_leaf_add: OK
[   98.824452] Testing event xfs_attr_leaf_add_old: OK
[   98.851654] Testing event xfs_attr_leaf_add_new: OK
[   98.881115] Testing event xfs_attr_leaf_addname: OK
[   98.908310] Testing event xfs_attr_leaf_create: OK
[   98.937853] Testing event xfs_attr_leaf_lookup: OK
[   98.965825] Testing event xfs_attr_leaf_replace: OK
[   98.994692] Testing event xfs_attr_leaf_removename: OK
[   99.026871] Testing event xfs_attr_leaf_split: OK
[   99.067036] Testing event xfs_attr_leaf_split_before: OK
[   99.119020] Testing event xfs_attr_leaf_split_after: OK
[   99.162698] Testing event xfs_attr_leaf_clearflag: OK
[   99.203324] Testing event xfs_attr_leaf_setflag: OK
[   99.246099] Testing event xfs_attr_leaf_flipflags: OK
[   99.286575] Testing event xfs_attr_leaf_to_sf: OK
[   99.320148] Testing event xfs_attr_leaf_to_node: OK
[   99.352153] Testing event xfs_attr_leaf_rebalance: OK
[   99.382817] Testing event xfs_attr_leaf_unbalance: OK
[   99.412321] Testing event xfs_attr_node_addname: OK
[   99.443001] Testing event xfs_attr_node_lookup: OK
[   99.475377] Testing event xfs_attr_node_replace: OK
[   99.506881] Testing event xfs_attr_node_removename: OK
[   99.538741] Testing event xfs_da_split: OK
[   99.569409] Testing event xfs_da_join: OK
[   99.598893] Testing event xfs_da_link_before: OK
[   99.629473] Testing event xfs_da_link_after: OK
[   99.659017] Testing event xfs_da_unlink_back: OK
[   99.689481] Testing event xfs_da_unlink_forward: OK
[   99.718992] Testing event xfs_da_root_split: OK
[   99.749287] Testing event xfs_da_root_join: OK
[   99.778861] Testing event xfs_da_node_add: OK
[   99.809395] Testing event xfs_da_node_create: OK
[   99.838852] Testing event xfs_da_node_split: OK
[   99.869284] Testing event xfs_da_node_remove: OK
[   99.899117] Testing event xfs_da_node_rebalance: OK
[   99.929420] Testing event xfs_da_node_unbalance: OK
[   99.959048] Testing event xfs_da_swap_lastblock: OK
[   99.989401] Testing event xfs_da_grow_inode: OK
[  100.025504] Testing event xfs_da_shrink_inode: OK
[  100.059618] Testing event xfs_dir2_leafn_add: OK
[  100.092109] Testing event xfs_dir2_leafn_remove: OK
[  100.128998] Testing event xfs_dir2_grow_inode: OK
[  100.159289] Testing event xfs_dir2_shrink_inode: OK
[  100.189434] Testing event xfs_dir2_leafn_moveents: OK
[  100.225112] Testing event xfs_swap_extent_before: OK
[  100.292697] Testing event xfs_swap_extent_after: OK
[  100.335263] Testing event xfs_log_recover_item_add: OK
[  100.385214] Testing event xfs_log_recover_item_add_cont: OK
[  100.415416] Testing event xfs_log_recover_item_reorder_head: OK
[  100.445640] Testing event xfs_log_recover_item_reorder_tail: OK
[  100.476658] Testing event xfs_log_recover_item_recover: OK
[  100.508640] Testing event xfs_log_recover_buf_not_cancel: OK
[  100.539444] Testing event xfs_log_recover_buf_cancel: OK
[  100.568764] Testing event xfs_log_recover_buf_cancel_add: OK
[  100.599525] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[  100.632181] Testing event xfs_log_recover_buf_recover: OK
[  100.664434] Testing event xfs_log_recover_buf_inode_buf: OK
[  100.695598] Testing event xfs_log_recover_buf_reg_buf: OK
[  100.725506] Testing event xfs_log_recover_buf_dquot_buf: OK
[  100.755869] Testing event xfs_log_recover_inode_recover: OK
[  100.785494] Testing event xfs_log_recover_inode_cancel: OK
[  100.816242] Testing event xfs_log_recover_inode_skip: OK
[  100.845978] Testing event xfs_discard_extent: OK
[  100.875972] Testing event xfs_discard_toosmall: OK
[  100.906847] Testing event xfs_discard_exclude: OK
[  100.939405] Testing event xfs_discard_busy: OK
[  100.968740] Testing event writeback_nothread: OK
[  100.999148] Testing event writeback_queue: OK
[  101.032799] Testing event writeback_exec: OK
[  101.066629] Testing event writeback_start: OK
[  101.099439] Testing event writeback_written: OK
[  101.134189] Testing event writeback_wait: OK
[  101.165970] Testing event writeback_pages_written: OK
[  101.199660] Testing event writeback_nowork: OK
[  101.232860] Testing event writeback_wake_background: OK
[  101.266162] Testing event writeback_wake_thread: OK
[  101.303243] Testing event writeback_wake_forker_thread: OK
[  101.336428] Testing event writeback_bdi_register: OK
[  101.370812] Testing event writeback_bdi_unregister: OK
[  101.409975] Testing event writeback_thread_start: OK
[  101.454936] Testing event writeback_thread_stop: OK
[  101.492997] Testing event wbc_writepage: OK
[  101.526436] Testing event writeback_queue_io: OK
[  101.569311] Testing event global_dirty_state: OK
[  101.599933] Testing event bdi_dirty_ratelimit: OK
[  101.636523] Testing event balance_dirty_pages: OK
[  101.673547] Testing event writeback_sb_inodes_requeue: OK
[  101.709364] Testing event writeback_congestion_wait: OK
[  101.745686] Testing event writeback_wait_iff_congested: OK
[  101.779563] Testing event writeback_single_inode: OK
[  101.814207] Testing event kmalloc: OK
[  101.849147] Testing event kmem_cache_alloc: OK
[  101.883140] Testing event kmalloc_node: OK
[  101.916363] Testing event kmem_cache_alloc_node: OK
[  101.949796] Testing event kfree: OK
[  101.983183] Testing event kmem_cache_free: OK
[  102.019938] Testing event mm_page_free: OK
[  102.054687] Testing event mm_page_free_batched: OK
[  102.086180] Testing event mm_page_alloc: OK
[  102.128878] Testing event mm_page_alloc_zone_locked: OK
[  102.162754] Testing event mm_page_pcpu_drain: OK
[  102.195829] Testing event mm_page_alloc_extfrag: OK
[  102.229623] Testing event mm_vmscan_kswapd_sleep: OK
[  102.262835] Testing event mm_vmscan_kswapd_wake: OK
[  102.296187] Testing event mm_vmscan_wakeup_kswapd: OK
[  102.329344] Testing event mm_vmscan_direct_reclaim_begin: OK
[  102.362988] Testing event mm_vmscan_memcg_reclaim_begin: OK
[  102.396273] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[  102.429935] Testing event mm_vmscan_direct_reclaim_end: OK
[  102.462929] Testing event mm_vmscan_memcg_reclaim_end: OK
[  102.496309] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[  102.530821] Testing event mm_shrink_slab_start: OK
[  102.562802] Testing event mm_shrink_slab_end: OK
[  102.612760] Testing event mm_vmscan_lru_isolate: OK
[  102.668812] Testing event mm_vmscan_memcg_isolate: OK
[  102.712555] Testing event mm_vmscan_writepage: OK
[  102.751131] Testing event mm_vmscan_lru_shrink_inactive: OK
[  102.789183] Testing event oom_score_adj_update: OK
[  102.836551] Testing event cpu_idle: OK
[  102.869740] Testing event cpu_frequency: OK
[  102.903096] Testing event machine_suspend: OK
[  102.939816] Testing event wakeup_source_activate: OK
[  102.972917] Testing event wakeup_source_deactivate: OK
[  103.005898] Testing event clock_enable: OK
[  103.055428] Testing event clock_disable: OK
[  103.107918] Testing event clock_set_rate: OK
[  103.139550] Testing event power_domain_target: OK
[  103.173231] Testing event ftrace_test_filter: OK
[  103.209569] Testing event sched_kthread_stop: OK
[  103.244295] Testing event sched_kthread_stop_ret: OK
[  103.277706] Testing event sched_wakeup: OK
[  103.324481] Testing event sched_wakeup_new: OK
[  103.356408] Testing event sched_switch: OK
[  103.389838] Testing event sched_migrate_task: OK
[  103.423262] Testing event sched_process_free: OK
[  103.458142] Testing event sched_process_exit: OK
[  103.494396] Testing event sched_wait_task: OK
[  103.530808] Testing event sched_process_wait: OK
[  103.562777] Testing event sched_process_fork: OK
[  103.596450] Testing event sched_process_exec: OK
[  103.629731] Testing event sched_stat_wait: OK
[  103.662964] Testing event sched_stat_sleep: OK
[  103.696149] Testing event sched_stat_iowait: OK
[  103.729690] Testing event sched_stat_blocked: OK
[  103.762797] Testing event sched_stat_runtime: OK
[  103.796649] Testing event sched_pi_setprio: OK
[  103.848263] Testing event rcu_utilization: OK
[  103.885901] Testing event workqueue_queue_work: OK
[  103.919289] Testing event workqueue_activate_work: OK
[  103.999365] Testing event workqueue_execute_start: OK
[  104.070272] Testing event workqueue_execute_end: OK
[  104.132306] Testing event signal_generate: OK
[  104.176293] Testing event signal_deliver: OK
[  104.209114] Testing event timer_init: OK
[  104.246553] Testing event timer_start: OK
[  104.283135] Testing event timer_expire_entry: OK
[  104.317715] Testing event timer_expire_exit: OK
[  104.349743] Testing event timer_cancel: OK
[  104.384441] Testing event hrtimer_init: OK
[  104.419390] Testing event hrtimer_start: OK
[  104.462877] Testing event hrtimer_expire_entry: OK
[  104.496616] Testing event hrtimer_expire_exit: OK
[  104.529601] Testing event hrtimer_cancel: OK
[  104.563516] Testing event itimer_state: OK
[  104.596572] Testing event itimer_expire: OK
[  104.629716] Testing event irq_handler_entry: OK
[  104.663022] Testing event irq_handler_exit: OK
[  104.696571] Testing event softirq_entry: OK
[  104.729654] Testing event softirq_exit: OK
[  104.764189] Testing event softirq_raise: OK
[  104.797430] Testing event console: OK
[  104.829213] Testing event task_newtask: OK
[  104.862595] Testing event task_rename: OK
[  104.896345] Testing event sys_enter: OK
[  104.931471] Testing event sys_exit: OK
[  104.971692] Running tests on trace event systems:
[  104.973521] Testing event system raw_syscalls: OK
[  105.016183] Testing event system task: OK
[  105.058684] Testing event system printk: OK
[  105.099693] Testing event system irq: OK
[  105.154216] Testing event system timer: OK
[  105.265147] Testing event system signal: OK
[  105.306422] Testing event system workqueue: OK
[  105.364190] Testing event system rcu: OK
[  105.415443] Testing event system sched: OK
[  105.556862] Testing event system test: OK
[  105.594690] Testing event system power: OK
[  105.664180] Testing event system oom: OK
[  105.701465] Testing event system vmscan: OK
[  105.798690] Testing event system kmem: OK
[  105.898664] Testing event system writeback: OK
[  106.038902] Testing event system xfs: OK
[  108.580828] Testing event system block: OK
[  108.712659] Testing event system gpio: OK
[  108.752840] Testing event system regulator: OK
[  108.814250] Testing event system random: OK
[  108.875275] Testing event system drm: OK
[  108.919064] Testing event system i915: OK
[  109.069282] Testing event system regmap: OK
[  109.143158] Testing event system sep: OK
[  109.188755] Testing event system syscalls: OK
[  109.249312] Testing event system udp: OK
[  109.284961] Testing event system sock: OK
[  109.322818] Testing event system napi: OK
[  109.358156] Testing event system net: OK
[  109.408636] Testing event system skb: OK
[  109.451936] Running tests on all trace events:
[  109.454157] Testing all events: OK
[  115.155796] Testing ftrace filter: OK
[  115.247866] IMA: No TPM chip found, activating TPM-bypass!
[  115.302586] register_blkdev: cannot get major 3 for hd
[  115.372093] Freeing unused kernel memory: 824k freed
[  115.485901] Write protecting the kernel text: 14240k
[  115.499469] Write protecting the kernel read-only data: 2752k
[  134.707390] ------------[ cut here ]------------
[  134.707390] kernel BUG at /c/kernel-tests/src/linux/mm/slub.c:3479!
[  134.707390] invalid opcode: 0000 [#1]=20
[  134.707390] Pid: 1, comm: init Not tainted 3.6.0-00451-gd01b193 #2 Bochs=
 Bochs
[  134.707390] EIP: 0060:[<c1235dbe>] EFLAGS: 00000246 CPU: 0
[  134.707390] EIP is at kfree+0x2be/0x490
[  134.707390] EAX: 00000001 EBX: 00000001 ECX: 00000000 EDX: 00000000
[  134.707390] ESI: cdeef760 EDI: cd83bdac EBP: cd83bd70 ESP: cd83bd50
[  134.707390]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[  134.707390] CR0: 80050033 CR2: b7782000 CR3: 0f9a8000 CR4: 00000690
[  134.707390] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  134.707390] DR6: 00000000 DR7: 00000000
[  134.707390] Process init (pid: 1, ti=3Dcd83a000 task=3Dcd838000 task.ti=
=3Dcd83a000)
[  134.707390] Stack:
[  134.707390]  00000000 cd83bd5c c1085b74 cd83bd88 c1298a5e cd83a000 fffff=
fc3 cd83bd90
[  134.707390]  cd83bd88 c1298a5e cd83bd90 c1ffdf63 00000001 cd832914 cd83b=
d98 c1298d4a
[  134.707390]  00000000 00000002 cd83bdac c11e0400 c995c980 cd832914 00000=
000 cd83bdc4
[  134.707390] Call Trace:
[  134.707390]  [<c1085b74>] ? irq_exit+0x74/0x180
[  134.707390]  [<c1298a5e>] ? __simple_xattr_set+0x28e/0x360
[  134.707390]  [<c1298a5e>] __simple_xattr_set+0x28e/0x360
[  134.707390]  [<c1298d4a>] simple_xattr_remove+0x2a/0x40
[  134.707390]  [<c11e0400>] shmem_removexattr+0xc0/0x120
[  134.707390]  [<c14f11ed>] ima_inode_post_setattr+0x21d/0x250
[  134.707390]  [<c1284316>] notify_change+0xb66/0xc40
[  134.707390]  [<c1239c58>] do_truncate+0xf8/0x160
[  134.707390]  [<c1261fcd>] do_last.isra.38+0xb3d/0x1a80
[  134.707390]  [<c12632e1>] path_openat+0x3d1/0xd10
[  134.707390]  [<c11476cb>] ? note_interrupt+0x4db/0x7f0
[  134.707390]  [<c1263c57>] do_filp_open+0x37/0x140
[  134.707390]  [<c123ce71>] do_sys_open+0x471/0x630
[  134.707390]  [<c10881b6>] ? __find_resource+0x166/0x470
[  134.707390]  [<c123d06b>] sys_open+0x3b/0x70
[  134.707390]  [<c1de6ce1>] sysenter_do_call+0x12/0x2c
[  134.707390] Code: 89 d0 f3 ff 8b 04 9d 8c a0 2c c2 83 c0 01 85 db 89 04 =
9d 8c a0 2c c2 0f 84 6a 01 00 00 83 05 a8 4b 61 c2 01 83 15 ac 4b 61 c2 00 =
<0f> 0b 83 05 b8 4b 61 c2 01 83 15 bc 4b 61 c2 00 83 05 30 4c 61
[  134.707390] EIP: [<c1235dbe>] kfree+0x2be/0x490 SS:ESP 0068:cd83bd50
[  134.837660] ---[ end trace b3795e84c08137ea ]---
[  135.017006] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x0000000b
[  135.017006]=20
[  135.017006] Rebooting in 10 seconds..
--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-00451-gd01b193"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0 Kernel Configuration
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
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
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
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
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
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
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
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_BSGLIB is not set
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
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_32_IRIS is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
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
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
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
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
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
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_PHONET is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_OMAP_OCP2SCP is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_BLK_DEV_HD=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
# CONFIG_BLK_DEV_CS5536 is not set
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=y
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set
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
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
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
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
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
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
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
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_INTEL_MID=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
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
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_DA9052=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_GPIO_TPS6586X=y
CONFIG_GPIO_TPS65910=y
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_MAX8998 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM8350 is not set
# CONFIG_SENSORS_APPLESMC is not set

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
# CONFIG_SSB is not set
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
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_MFD_LM3533=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_SMSC=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_TIMBERDALE=y
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_VX855=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_PALMAS=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8788 is not set
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
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
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
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
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
# CONFIG_FB_MATROX_I2C is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_PANDORA is not set
# CONFIG_BACKLIGHT_TPS65217 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
CONFIG_FONT_7x14=y
CONFIG_FONT_PEARL_8x8=y
# CONFIG_FONT_ACORN_8x8 is not set
CONFIG_FONT_MINI_4x6=y
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
# CONFIG_LOGO is not set
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

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_OMAP_USB2 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
# CONFIG_LEDS_WM8350 is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
# CONFIG_RTC_DRV_TPS65910 is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
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
CONFIG_DX_SEP=y
# CONFIG_ZSMALLOC is not set
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
# CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
# CONFIG_SPEAKUP_SYNTH_ACNTPC is not set
CONFIG_SPEAKUP_SYNTH_APOLLO=y
# CONFIG_SPEAKUP_SYNTH_AUDPTR is not set
# CONFIG_SPEAKUP_SYNTH_BNS is not set
CONFIG_SPEAKUP_SYNTH_DECTLK=y
# CONFIG_SPEAKUP_SYNTH_DECEXT is not set
# CONFIG_SPEAKUP_SYNTH_DTLK is not set
CONFIG_SPEAKUP_SYNTH_KEYPC=y
CONFIG_SPEAKUP_SYNTH_LTLK=y
# CONFIG_SPEAKUP_SYNTH_SOFT is not set
# CONFIG_SPEAKUP_SYNTH_SPKOUT is not set
CONFIG_SPEAKUP_SYNTH_TXPRT=y
# CONFIG_SPEAKUP_SYNTH_DUMMY is not set
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_PHONE is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=y
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y

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
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
# CONFIG_OCFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
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
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
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
# CONFIG_DEBUG_HIGHMEM is not set
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
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
CONFIG_MMIOTRACE=y
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_APPRAISE=y
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set

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
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
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
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
CONFIG_DDR=y

--BOKacYhQ+x31HxR3--
