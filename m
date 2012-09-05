Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab2IEGvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 02:51:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:16765 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab2IEGvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 02:51:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,372,1344236400"; 
   d="scan'208";a="188950079"
Date: Wed, 5 Sep 2012 14:51:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: PCI/e1000 BUG: unable to handle kernel paging request at 0ffff163
Message-ID: <20120905065118.GA9603@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Yinghai,

There are many kernel paging errors showing up in tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-for-each-res-addon-v2

The below summary shows that

1) it's a reliably reproducible bug
2) all paging fault happens at address 0ffff163 and in some e1000 functions

I'll try to bisect if the root cause is not obvious to you.  (Cannot
do so for now because there are 3 bisections on the way and I cannot
afford more..)

Thanks,
Fengguang
---

i386-randconfig-m012        _________B__________B__________B_CBC__BC__B__________B__BB__B_____B__________B_BB__________BB___BBB_

--
8:	  7d7903b  
9:	B 8200bc7  2012-09-05 kvm-ant      [  127.519645] BUG: unable to handle kernel paging request at 0ffff163 [e1000_read_mbx_vf rmt e1000_init_hw_80003es2lan tcam_assoc_write rmt]
10:	  2a80eeb  
--
19:	  e5c8ae5  
20:	B eb0ff56  2012-09-05 kvm-bens     [   14.562316] BUG: unable to handle kernel paging request at 0ffff163 [igbvf_get_msglevel rmt e1000_setup_copper_link_80003es2lan niu_set_nfc rmt]
21:	  08bd108  
--
30:	  5cdaaf8  
31:	B 532c5f6  2012-09-05 kvm-fat      [    9.702038] BUG: unable to handle kernel paging request at 0ffff163 [igbvf_get_eeprom rmt e1000_setup_copper_link_80003es2lan niu_set_nfc rmt]
32:	  479e0d4  
33:	  0d7614f  
34:	B e1c171b  2012-09-05 kvm-waimea   [   10.338600] BUG: unable to handle kernel paging request at 0ffff163 
35:	  0d7614f  
--
37:	  defb944  
38:	B a28afda  2012-09-05 kvm-stoakley [    9.315985] BUG: unable to handle kernel paging request at 0ffff163 [igbvf_set_msglevel rmt e1000_setup_copper_link_80003es2lan niu_set_nfc rmt]
39:	  0d7614f  
--
41:	  34e5484  
42:	B 0a14057  2012-09-05 kvm-slim     [   15.523994] BUG: unable to handle kernel paging request at 0fffe163 [usc_set_sdlc_mode rmt_init]
43:	  657c207  
--
52:	  f5725f4  
53:	B 0b79ca2  2012-09-05 kvm-stoakley [    9.902012] BUG: unable to handle kernel paging request at 0ffff163 [e1000_write_mbx_vf rmt e1000_init_hw_80003es2lan niu_alloc_channels rmt]
54:	  0a4af14  
55:	  c29aabe  
56:	B 7bf79d8  2012-09-05 kvm-waimea   [    9.354137] BUG: unable to handle kernel paging request at 0ffff163 [igbvf_get_coalesce rmt e1000_setup_copper_link_80003es2lan niu_set_nfc rmt]
57:	B 588dde7  2012-09-05 kvm-bens     [   10.047686] BUG: unable to handle kernel paging request at 0ffff163 
58:	  3f7aaec  
59:	  faa5956  
60:	B 6e67404  2012-09-05 kvm-xgwo     [   10.161540] WARNING: at /c/kernel-tests/src/i386/kernel/lockdep.c:3493 check_flags+0x9e/0x14f() [check_flags lock_is_held __might_sleep rt_mutex_lock rcu_kthread preempt_schedule complete __rcu_process_callbacks kthread insert_kthread_work]
61:	  73f02ab  
--
65:	  5a58343  
66:	B f773c5c  2012-09-05 kvm-stoakley [    9.378884] BUG: unable to handle kernel paging request at 0ffff163 [igbvf_get_msglevel rmt e1000_setup_copper_link_80003es2lan niu_set_nfc rmt]
67:	  1071aab  
--
76:	  4f930f1  
77:	B c7d6768  2012-09-05 kvm-ant      [  114.891808] BUG: unable to handle kernel paging request at 0ffff163 [e1000_init_mbx_params_vf rmt e1000_init_hw_80003es2lan tcam_write rmt]
78:	  6102ea8  
79:	B 242ae74  2012-09-05 kvm-bens     [   10.263933] BUG: unable to handle kernel paging request at 0ffff163 [e1000_read_mbx_vf rmt e1000_init_hw_80003es2lan tcam_write rmt]
80:	B 77d56a0  2012-09-05 kvm-ant      [   99.832354] BUG: unable to handle kernel paging request at 0ffff163 [e1000_write_mbx_vf rmt e1000_init_hw_80003es2lan tcam_flush rmt]
81:	  3cc1773  
--
90:	  e5dd9d3  
91:	B a40758f  2012-09-05 kvm-waimea   [    8.623070] BUG: unable to handle kernel paging request at 0ffff163 [e1000_set_vfta_vf smt_pmf_received_pack e1000_reset_hw_80003es2lan niu_init_tx_mac smt_pmf_received_pack]
92:	B eedd911  2012-09-05 kvm-ant      [   95.184152] BUG: unable to handle kernel paging request at 0ffff163 [e1000_get_link_up_info_vf smt_pmf_received_pack e1000_reset_hw_80003es2lan niu_init_tx_mac smt_pmf_received_pack]
93:	  f7a01f3  
--
95:	  b58d6f5  
96:	B c5cce62  2012-09-05 kvm-waimea   [    9.441889] BUG: unable to handle kernel paging request at 0ffff163 
97:	B 4dc8c06  2012-09-05 kvm-xgwo     [    9.770754] BUG: unable to handle kernel paging request at 0ffff163 [e1000_init_mac_params_vf smt_pmf_received_pack e1000_reset_hw_80003es2lan niu_init_tx_mac smt_pmf_received_pack]
98:	B 0852a83  2012-09-05 kvm-xgwo     [    9.715270] BUG: unable to handle kernel paging request at 0ffff163 [igb_ptp_remove smt_pmf_received_pack e1000_cfg_on_link_up_80003es2lan niu_stop_rx_channels smt_pmf_received_pack]
99:	  a37fbc4  

[    9.350967] cdc_acm 1-1:2.0: This device cannot do calls on its own. It is not a modem.
[    9.353255] cdc_acm 1-1:2.0: ttyACM0: USB ACM device
[    9.354137] BUG: unable to handle kernel paging request at 0ffff163
[    9.355214] IP: [<0ffff163>] 0xffff162
[    9.355869] *pde = 00000000 
[    9.356308] Oops: 0000 [#1] PREEMPT 
[    9.356308] Pid: 1, comm: swapper Not tainted 3.6.0-rc1-00061-g7bf79d8 #10 Bochs Bochs
[    9.356308] EIP: 0060:[<0ffff163>] EFLAGS: 00010246 CPU: 0
[    9.356308] EIP is at 0xffff163
[    9.356308] EAX: 00000000 EBX: 4d812f18 ECX: 4d80d410 EDX: 00000000
[    9.356308] ESI: 00000000 EDI: 4d813ef8 EBP: 0fffe163 ESP: 4d810008
[    9.356308]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    9.356308] CR0: 8005003b CR2: 0ffff163 CR3: 01d03000 CR4: 00000690
[    9.356308] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    9.356308] DR6: ffff0ff0 DR7: 00000400
[    9.356308] Process swapper (pid: 1, ti=4d80e000 task=4d80d410 task.ti=4d816000)
[    9.356308] Stack:
[    9.356308]  00000000 00000000 fed00173 00000000 07b57163 07b58163 07b59163 07b5a163
[    9.356308]  07b5b163 07b5c163 07b5d163 07b5e163 07b5f163 07b60163 07b61163 00000000
[    9.356308]  07b63163 07b66163 07b67163 07b68163 07b69163 07b6a163 07b6b163 07b6c163
[    9.356308] Call Trace:
[    9.356308]  [<414d5043>] ? igbvf_get_coalesce+0x15/0x23
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  [<414b4e4c>] ? e1000_setup_copper_link_80003es2lan+0x111/0x31d
[    9.356308]  [<41535244>] ? niu_set_nfc+0xe4/0x6fd
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  <IRQ> 

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-waimea-5013-2012-09-05-14-11-25-3.6.0-rc1-00061-g7bf79d8-10"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc1-00061-g7bf79d8 (kbuild@lkp-mb01) (gc=
c version 4.7.1 (GCC) ) #10 PREEMPT Tue Sep 4 14:48:30 CST 2012
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [4008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x02bfa0=
00-0x02bfffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128744(98%)
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
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1a6b2c1, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat 41c1f89c, node_mem_map 4d=
d3f200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3939 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 60958 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1a6b240
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64897
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 rcutre=
e.rcu_cpu_stall_timeout=3D100 branch=3Dyinghai/for-pci-for-each-res-addon-v=
2 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_p=
rintk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-=
09-04-14-49-10-yinghai:for-pci-for-each-res-addon-v2:fad110b-7bf79d8-i386-r=
andconfig-m012-1-waimea BOOT_IMAGE=3Dkernel-tests/kernels/i386-randconfig-m=
012/7bf79d8/vmlinuz-3.6.0-rc1-00061-g7bf79d8
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 206900k/262136k available (7502k kernel code, 54736k=
 reserved, 4926k data, 880k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x507fe000 - 0xff7fe000   (2800 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x4fffe000   ( 255 MB)
[    0.000000]       .init : 0x41c24000 - 0x41d00000   ( 880 kB)
[    0.000000]       .data : 0x41753871 - 0x41c23180   (4926 kB)
[    0.000000]       .text : 0x41000000 - 0x41753871   (7502 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D4d802000 soft=3D4d804000
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
[    0.000000] tsc: Detected 3300.196 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 6600.39 Bogo=
MIPS (lpj=3D13200784)
[    0.004000] pid_max: default: 4096 minimum: 301
[    0.004000] Security Framework initialized
[    0.004024] Yama: becoming mindful.
[    0.004590] Mount-cache hash table entries: 512
[    0.005899] Initializing cgroup subsys devices
[    0.006697] Initializing cgroup subsys perf_event
[    0.008013] Initializing cgroup subsys net_prio
[    0.008858] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008858] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008858] tlb_flushall_shift is 0x6
[    0.011192] CPU: Intel Common KVM processor stepping 01
[    0.016010] ACPI: Core revision 20120711
[    0.024098] ACPI: setting ELCR to 0200 (from 0c00)
[    0.025196] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.027886] device: 'platform': device_add
[    0.028053] bus: 'platform': registered
[    0.028825] bus: 'cpu': registered
[    0.029455] device: 'cpu': device_add
[    0.032715] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.033967] bus: 'virtio': registered
[    0.034722] NET: Registered protocol family 16
[    0.036453] device class 'bdi': registering
[    0.037390] bus: 'platform': add driver ramoops
[    0.038336] device class 'pci_bus': registering
[    0.039114] bus: 'pci': registered
[    0.039755] device: 'rapidio': device_add
[    0.040035] bus: 'rapidio': registered
[    0.040680] device class 'backlight': registering
[    0.044031] device class 'tty': registering
[    0.048054] bus: 'hsi': registered
[    0.048642] bus: 'i2c': registered
[    0.049698] bus: 'i2c': add driver dummy
[    0.050509] i2c-core: driver [dummy] registered
[    0.053439] ACPI: bus type pci registered
[    0.054659] device class 'dma': registering
[    0.055507] device class 'dmi': registering
[    0.056046] device: 'id': device_add
[    0.057502] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    0.058691] PCI: Using configuration type 1 for base access
[    0.061365] device: 'cpu0': device_add
[    0.062097] bus: 'cpu': add device cpu0
[    0.091191] device: 'default': device_add
[    0.092209] bio: create slab <bio-0> at 0
[    0.093573] device class 'block': registering
[    0.094460] bus: 'i2c': add driver max732x
[    0.096025] i2c-core: driver [max732x] registered
[    0.096955] bus: 'i2c': add driver pcf857x
[    0.097687] i2c-core: driver [pcf857x] registered
[    0.098560] bus: 'platform': add driver twl4030_gpio
[    0.100075] device class 'graphics': registering
[    0.100981] ACPI: Added _OSI(Module Device)
[    0.101729] ACPI: Added _OSI(Processor Device)
[    0.102508] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.103751] ACPI: Added _OSI(Processor Aggregator Device)
[    0.112321] ACPI: EC: Look up EC in DSDT
[    0.136762] ACPI: Interpreter enabled
[    0.137946] ACPI: (supports S0 S5)
[    0.138614] ACPI: Using PIC for interrupt routing
[    0.140050] bus: 'acpi': registered
[    0.140661] bus: 'acpi': add driver power
[    0.141980] device: 'LNXSYSTM:00': device_add
[    0.142723] bus: 'acpi': add device LNXSYSTM:00
[    0.144292] device: 'device:00': device_add
[    0.145464] bus: 'acpi': add device device:00
[    0.146423] device: 'PNP0A03:00': device_add
[    0.147245] bus: 'acpi': add device PNP0A03:00
[    0.149317] device: 'device:01': device_add
[    0.149989] bus: 'acpi': add device device:01
[    0.152163] device: 'device:02': device_add
[    0.152942] bus: 'acpi': add device device:02
[    0.153933] device: 'PNP0B00:00': device_add
[    0.154669] bus: 'acpi': add device PNP0B00:00
[    0.155740] device: 'PNP0303:00': device_add
[    0.156027] bus: 'acpi': add device PNP0303:00
[    0.157067] device: 'PNP0F13:00': device_add
[    0.157786] bus: 'acpi': add device PNP0F13:00
[    0.158853] device: 'PNP0700:00': device_add
[    0.160028] bus: 'acpi': add device PNP0700:00
[    0.161393] device: 'PNP0400:00': device_add
[    0.162246] bus: 'acpi': add device PNP0400:00
[    0.163514] device: 'PNP0501:00': device_add
[    0.164028] bus: 'acpi': add device PNP0501:00
[    0.165184] device: 'device:03': device_add
[    0.165956] bus: 'acpi': add device device:03
[    0.166911] device: 'device:04': device_add
[    0.168063] bus: 'acpi': add device device:04
[    0.168948] device: 'device:05': device_add
[    0.169740] bus: 'acpi': add device device:05
[    0.170692] device: 'device:06': device_add
[    0.171462] bus: 'acpi': add device device:06
[    0.172214] device: 'device:07': device_add
[    0.173000] bus: 'acpi': add device device:07
[    0.173987] device: 'device:08': device_add
[    0.174703] bus: 'acpi': add device device:08
[    0.176274] device: 'device:09': device_add
[    0.177036] bus: 'acpi': add device device:09
[    0.178039] device: 'device:0a': device_add
[    0.178825] bus: 'acpi': add device device:0a
[    0.180030] device: 'device:0b': device_add
[    0.180746] bus: 'acpi': add device device:0b
[    0.181693] device: 'device:0c': device_add
[    0.182405] bus: 'acpi': add device device:0c
[    0.183394] device: 'device:0d': device_add
[    0.184030] bus: 'acpi': add device device:0d
[    0.185093] device: 'device:0e': device_add
[    0.185919] bus: 'acpi': add device device:0e
[    0.186931] device: 'device:0f': device_add
[    0.188031] bus: 'acpi': add device device:0f
[    0.188967] device: 'device:10': device_add
[    0.189711] bus: 'acpi': add device device:10
[    0.190732] device: 'device:11': device_add
[    0.191537] bus: 'acpi': add device device:11
[    0.192263] device: 'device:12': device_add
[    0.192986] bus: 'acpi': add device device:12
[    0.193919] device: 'device:13': device_add
[    0.194687] bus: 'acpi': add device device:13
[    0.196058] device: 'device:14': device_add
[    0.196800] bus: 'acpi': add device device:14
[    0.197762] device: 'device:15': device_add
[    0.198530] bus: 'acpi': add device device:15
[    0.199452] device: 'device:16': device_add
[    0.200029] bus: 'acpi': add device device:16
[    0.200982] device: 'device:17': device_add
[    0.201722] bus: 'acpi': add device device:17
[    0.202776] device: 'device:18': device_add
[    0.203614] bus: 'acpi': add device device:18
[    0.204182] device: 'device:19': device_add
[    0.204907] bus: 'acpi': add device device:19
[    0.205848] device: 'device:1a': device_add
[    0.206611] bus: 'acpi': add device device:1a
[    0.208193] device: 'device:1b': device_add
[    0.208995] bus: 'acpi': add device device:1b
[    0.209987] device: 'device:1c': device_add
[    0.210755] bus: 'acpi': add device device:1c
[    0.211790] device: 'device:1d': device_add
[    0.212073] bus: 'acpi': add device device:1d
[    0.213097] device: 'device:1e': device_add
[    0.213898] bus: 'acpi': add device device:1e
[    0.214809] device: 'device:1f': device_add
[    0.216032] bus: 'acpi': add device device:1f
[    0.217054] device: 'device:20': device_add
[    0.217911] bus: 'acpi': add device device:20
[    0.218925] device: 'device:21': device_add
[    0.220032] bus: 'acpi': add device device:21
[    0.221100] device: 'device:22': device_add
[    0.222024] bus: 'acpi': add device device:22
[    0.223523] device: 'PNP0103:00': device_add
[    0.224031] bus: 'acpi': add device PNP0103:00
[    0.225281] device: 'PNP0C0F:00': device_add
[    0.226015] bus: 'acpi': add device PNP0C0F:00
[    0.227258] device: 'PNP0C0F:01': device_add
[    0.228033] bus: 'acpi': add device PNP0C0F:01
[    0.229540] device: 'PNP0C0F:02': device_add
[    0.230383] bus: 'acpi': add device PNP0C0F:02
[    0.232280] device: 'PNP0C0F:03': device_add
[    0.233121] bus: 'acpi': add device PNP0C0F:03
[    0.234328] device: 'PNP0C0F:04': device_add
[    0.235147] bus: 'acpi': add device PNP0C0F:04
[    0.236279] device: 'LNXCPU:00': device_add
[    0.237093] bus: 'acpi': add device LNXCPU:00
[    0.238232] device: 'LNXCPU:01': device_add
[    0.239081] bus: 'acpi': add device LNXCPU:01
[    0.240177] device: 'device:23': device_add
[    0.240869] bus: 'acpi': add device device:23
[    0.241721] device: 'LNXPWRBN:00': device_add
[    0.242508] bus: 'acpi': add device LNXPWRBN:00
[    0.243621] bus: 'acpi': add driver ec
[    0.247512] ACPI: No dock devices found.
[    0.248026] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.249716] bus: 'acpi': add driver pci_root
[    0.250519] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    0.252024] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    0.253317] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.254548] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.256027] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.257381] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.258890] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfe=
bfffff] (ignored)
[    0.260029] PCI: root bus 00: using default resources
[    0.261005] pci_root PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.
[    0.264036] device: 'pci0000:00': device_add
[    0.264919] device: '0000:00': device_add
[    0.265818] PCI host bridge to bus 0000:00
[    0.266555] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    0.268027] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.268930] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.269963] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
f]
[    0.271180] pci_bus 0000:00: scanning bus
[    0.272113] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.273210] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x9
[    0.274809] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.276646] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.279837] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.281284] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.282397] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x33
[    0.284675] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x130
[    0.285809] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.287197] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.288118] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0xf
[    0.289340] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.292148] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.294482] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.301791] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.304245] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.305865] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.308089] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.313166] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.314832] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.316313] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.320298] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.321900] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.323665] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.329565] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.331103] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.332846] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.338671] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.340071] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.341863] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.348131] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.349743] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.351552] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.357142] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.358742] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.360482] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.366766] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.368419] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.370215] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.375911] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.376287] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.381457] pci_bus 0000:00: fixups for bus
[    0.382138] pci_bus 0000:00: bus scan returning with max=3D00
[    0.383187] pci_bus 0000:00: on NUMA node 0
[    0.384073] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.390921]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.392046] device: '0000:00:00.0': device_add
[    0.397155] bus: 'pci': add device 0000:00:00.0
[    0.398132] device: '0000:00:01.0': device_add
[    0.401770] bus: 'pci': add device 0000:00:01.0
[    0.402639] device: '0000:00:01.1': device_add
[    0.406330] bus: 'pci': add device 0000:00:01.1
[    0.407296] device: '0000:00:01.3': device_add
[    0.410836] bus: 'pci': add device 0000:00:01.3
[    0.411770] device: '0000:00:02.0': device_add
[    0.414904] bus: 'pci': add device 0000:00:02.0
[    0.416145] device: '0000:00:03.0': device_add
[    0.420343] bus: 'pci': add device 0000:00:03.0
[    0.421291] device: '0000:00:04.0': device_add
[    0.425131] bus: 'pci': add device 0000:00:04.0
[    0.426156] device: '0000:00:05.0': device_add
[    0.429891] bus: 'pci': add device 0000:00:05.0
[    0.430832] device: '0000:00:06.0': device_add
[    0.434621] bus: 'pci': add device 0000:00:06.0
[    0.435561] device: '0000:00:07.0': device_add
[    0.438861] bus: 'pci': add device 0000:00:07.0
[    0.440097] device: '0000:00:08.0': device_add
[    0.444144] bus: 'pci': add device 0000:00:08.0
[    0.445118] device: '0000:00:09.0': device_add
[    0.448803] bus: 'pci': add device 0000:00:09.0
[    0.449700] device: '0000:00:0a.0': device_add
[    0.454217] bus: 'pci': add device 0000:00:0a.0
[    0.455175] device: '0000:00:0b.0': device_add
[    0.458915] bus: 'pci': add device 0000:00:0b.0
[    0.459839] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[    0.460069] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[    0.461438] bus: 'acpi': add driver pci_link
[    0.462305] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[    0.464037] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[    0.465786] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.468139] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[    0.469412] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[    0.470809] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[    0.472041] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[    0.473652] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.474916] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[    0.476040] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[    0.477344] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[    0.478778] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[    0.480297] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.481413] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[    0.482528] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[    0.484044] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[    0.485519] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[    0.487059] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.488488] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[    0.491175] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[    0.492045] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[    0.493380] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[    0.495108] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.496313] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[    0.497494] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[    0.499023] bus: 'pnp': registered
[    0.500049] device class 'misc': registering
[    0.500789] device: 'vga_arbiter': device_add
[    0.501739] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.504076] vgaarb: loaded
[    0.504529] vgaarb: bridge control possible 0000:00:02.0
[    0.505760] bus: 'tifm': registered
[    0.506396] device class 'tifm_adapter': registering
[    0.508063] bus: 'i2c': add driver 88PM80X
[    0.508814] i2c-core: driver [88PM80X] registered
[    0.509617] bus: 'i2c': add driver stmpe-i2c
[    0.510355] i2c-core: driver [stmpe-i2c] registered
[    0.511158] bus: 'i2c': add driver WM8400
[    0.512063] i2c-core: driver [WM8400] registered
[    0.512858] tps65010: version 2 May 2005
[    0.513570] bus: 'i2c': add driver tps65010
[    0.516061] i2c-core: driver [tps65010] registered
[    0.516876] bus: 'i2c': remove driver tps65010
[    0.517620] driver: 'tps65010': driver_release
[    0.518455] i2c-core: driver [tps65010] unregistered
[    0.532090] bus: 'i2c': add driver tps65010
[    0.533111] i2c-core: driver [tps65010] registered
[    0.534075] bus: 'i2c': remove driver tps65010
[    0.534831] driver: 'tps65010': driver_release
[    0.535584] i2c-core: driver [tps65010] unregistered
[    0.552059] bus: 'i2c': add driver tps65010
[    0.552817] i2c-core: driver [tps65010] registered
[    0.553617] bus: 'i2c': remove driver tps65010
[    0.554312] driver: 'tps65010': driver_release
[    0.555153] i2c-core: driver [tps65010] unregistered
[    0.556043] tps65010: no chip?
[    0.556763] bus: 'i2c': add driver twl
[    0.557434] i2c-core: driver [twl] registered
[    0.558138] bus: 'i2c': add driver da9052
[    0.559419] i2c-core: driver [da9052] registered
[    0.560561] bus: 'i2c': add driver max77686
[    0.561409] i2c-core: driver [max77686] registered
[    0.562569] bus: 'i2c': add driver max8925
[    0.564059] i2c-core: driver [max8925] registered
[    0.565917] bus: 'i2c': add driver max8998
[    0.566705] i2c-core: driver [max8998] registered
[    0.568047] bus: 'i2c': add driver pcf50633
[    0.569369] i2c-core: driver [pcf50633] registered
[    0.570739] bus: 'i2c': add driver ab3100
[    0.572115] i2c-core: driver [ab3100] registered
[    0.573971] bus: 'i2c': add driver sec_pmic
[    0.575314] i2c-core: driver [sec_pmic] registered
[    0.576047] bus: 'i2c': add driver lm3533
[    0.577851] i2c-core: driver [lm3533] registered
[    0.580199] device class 'scsi_host': registering
[    0.581589] bus: 'scsi': registered
[    0.582709] device class 'scsi_device': registering
[    0.584102] SCSI subsystem initialized
[    0.584749] device class 'mdio_bus': registering
[    0.586063] bus: 'mdio_bus': registered
[    0.587234] bus: 'mdio_bus': add driver Generic PHY
[    0.588180] ACPI: bus type usb registered
[    0.589368] bus: 'usb': registered
[    0.590569] bus: 'usb': add driver usbfs
[    0.592061] usbcore: registered new interface driver usbfs
[    0.593880] bus: 'usb': add driver hub
[    0.595041] usbcore: registered new interface driver hub
[    0.596149] bus: 'usb': add driver usb
[    0.597315] usbcore: registered new device driver usb
[    0.598718] bus: 'platform': add driver twl6030_usb
[    0.600086] bus: 'platform': add driver nop_usb_xceiv
[    0.601576] device class 'udc': registering
[    0.604131] bus: 'serio': registered
[    0.605244] bus: 'gameport': registered
[    0.606383] device class 'input': registering
[    0.607719] bus: 'i2c': add driver tca8418_keypad
[    0.608059] i2c-core: driver [tca8418_keypad] registered
[    0.609991] device class 'rtc': registering
[    0.612060] Linux video capture interface: v2.00
[    0.613843] device class 'video4linux': registering
[    0.616061] device class 'pps': registering
[    0.617354] pps_core: LinuxPPS API ver. 1 registered
[    0.619277] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.620049] device class 'ptp': registering
[    0.621481] PTP clock support registered
[    0.624051] device class 'power_supply': registering
[    0.625535] device class 'watchdog': registering
[    0.627052] bus: 'mmc': registered
[    0.627664] device class 'mmc_host': registering
[    0.628086] bus: 'sdio': registered
[    0.628714] device class 'leds': registering
[    0.630115] bus: 'acpi': add driver vmbus
[    5.632392] bus: 'acpi': remove driver vmbus
[    5.633206] driver: 'vmbus': driver_release
[    5.633948] device class 'devfreq': registering
[    5.634755] device class 'sound': registering
[    5.635544] PCI: Using ACPI for IRQ routing
[    5.636319] PCI: pci_cache_line_size set to 64 bytes
[    5.636353] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags =
0x110] (d=3D0, p=3D0)
[    5.636353] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] =
(d=3D0, p=3D0)
[    5.636372] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags =
0x110] (d=3D0, p=3D0)
[    5.640365] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] =
(d=3D0, p=3D0)
[    5.641664] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags =
0x40101] (d=3D0, p=3D0)
[    5.643222] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdfffff=
f flags 0x42208] (d=3D0, p=3D0)
[    5.644371] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4ff=
f flags 0x40200] (d=3D0, p=3D0)
[    5.646490] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbfff=
f flags 0x40200] (d=3D0, p=3D0)
[    5.648366] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags =
0x40101] (d=3D0, p=3D0)
[    5.649817] pci 0000:00:04.0: BAR 0: reserving [mem 0xfebf0000-0xfebf3ff=
f flags 0x40200] (d=3D0, p=3D0)
[    5.651400] pci 0000:00:05.0: BAR 0: reserving [io  0xc040-0xc07f flags =
0x40101] (d=3D0, p=3D0)
[    5.652366] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5ff=
f flags 0x40200] (d=3D0, p=3D0)
[    5.653680] pci 0000:00:06.0: BAR 0: reserving [io  0xc080-0xc0bf flags =
0x40101] (d=3D0, p=3D0)
[    5.655044] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6ff=
f flags 0x40200] (d=3D0, p=3D0)
[    5.656354] pci 0000:00:07.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags =
0x40101] (d=3D0, p=3D0)
[    5.656354] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf7000-0xfebf7ff=
f flags 0x40200] (d=3D0, p=3D0)
[    5.656382] pci 0000:00:08.0: BAR 0: reserving [io  0xc100-0xc13f flags =
0x40101] (d=3D0, p=3D0)
[    5.660364] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf8000-0xfebf8ff=
f flags 0x40200] (d=3D0, p=3D0)
[    5.661651] pci 0000:00:09.0: BAR 0: reserving [io  0xc140-0xc17f flags =
0x40101] (d=3D0, p=3D0)
[    5.664365] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf9000-0xfebf9ff=
f flags 0x40200] (d=3D0, p=3D0)
[    5.665680] pci 0000:00:0a.0: BAR 0: reserving [io  0xc180-0xc1bf flags =
0x40101] (d=3D0, p=3D0)
[    5.666916] pci 0000:00:0a.0: BAR 1: reserving [mem 0xfebfa000-0xfebfaff=
f flags 0x40200] (d=3D0, p=3D0)
[    5.668383] pci 0000:00:0b.0: BAR 0: reserving [mem 0xfebfb000-0xfebfb00=
f flags 0x40200] (d=3D0, p=3D0)
[    5.669932] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    5.670878] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    5.672012] device class 'net': registering
[    5.672479] device: 'lo': device_add
[    5.676483] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologi=
es Inc.
[    5.677765] device class 'ieee802154': registering
[    5.679457] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    5.680580] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    5.683677] Switching to clocksource kvm-clock
[    5.684632] FS-Cache: Loaded
[    5.685170] bus: 'pnp': add driver system
[    5.685808] pnp: PnP ACPI init
[    5.686298] device: 'pnp0': device_add
[    5.686919] ACPI: bus type pnp registered
[    5.687701] pnp 00:00: [bus 00-ff]
[    5.688363] pnp 00:00: [io  0x0cf8-0x0cff]
[    5.689099] pnp 00:00: [io  0x0000-0x0cf7 window]
[    5.689955] pnp 00:00: [io  0x0d00-0xffff window]
[    5.690858] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    5.691989] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    5.693752] device: '00:00': device_add
[    5.694590] bus: 'pnp': add device 00:00
[    5.695708] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    5.697019] pnp 00:01: [io  0x0070-0x0071]
[    5.697758] pnp 00:01: [irq 8]
[    5.698321] pnp 00:01: [io  0x0072-0x0077]
[    5.699083] device: '00:01': device_add
[    5.699940] bus: 'pnp': add device 00:01
[    5.700934] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    5.702528] pnp 00:02: [io  0x0060]
[    5.703264] pnp 00:02: [io  0x0064]
[    5.703966] pnp 00:02: [irq 1]
[    5.704695] device: '00:02': device_add
[    5.705395] bus: 'pnp': add device 00:02
[    5.706113] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    5.707626] pnp 00:03: [irq 12]
[    5.708412] device: '00:03': device_add
[    5.709169] bus: 'pnp': add device 00:03
[    5.709916] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    5.711242] pnp 00:04: [io  0x03f2-0x03f5]
[    5.712211] pnp 00:04: [io  0x03f7]
[    5.712889] pnp 00:04: [irq 6]
[    5.713459] pnp 00:04: [dma 2]
[    5.714054] device: '00:04': device_add
[    5.714815] bus: 'pnp': add device 00:04
[    5.715593] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    5.717343] pnp 00:05: [io  0x0378-0x037f]
[    5.718158] pnp 00:05: [irq 7]
[    5.718732] device: '00:05': device_add
[    5.719506] bus: 'pnp': add device 00:05
[    5.720210] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    5.721354] pnp 00:06: [io  0x03f8-0x03ff]
[    5.721978] pnp 00:06: [irq 4]
[    5.722425] device: '00:06': device_add
[    5.723041] bus: 'pnp': add device 00:06
[    5.723692] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    5.725434] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    5.726174] device: '00:07': device_add
[    5.726843] bus: 'pnp': add device 00:07
[    5.727454] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    5.729355] pnp: PnP ACPI: found 8 devices
[    5.729982] ACPI: ACPI bus type pnp unregistered
[    5.730680] device class 'mem': registering
[    5.731598] device: 'mem': device_add
[    5.732412] device: 'kmem': device_add
[    5.733136] device: 'null': device_add
[    5.733905] device: 'port': device_add
[    5.734684] device: 'zero': device_add
[    5.735456] device: 'full': device_add
[    5.736288] device: 'random': device_add
[    5.744098] device: 'urandom': device_add
[    5.744949] device: 'kmsg': device_add
[    5.745679] device: 'oldmem': device_add
[    5.746410] device: 'tty': device_add
[    5.747230] device: 'console': device_add
[    5.748006] device class 'firmware': registering
[    5.749260] device class 'thermal': registering
[    5.798748] PM-Timer running at invalid rate: 108% of normal - aborting.
[    5.800299] bus: 'ssb': registered
[    5.801015] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    5.802033] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    5.803113] NET: Registered protocol family 1
[    5.804851] pci 0000:00:00.0: calling quirk_natoma+0x0/0x25
[    5.805870] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    5.807305] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x71
[    5.808997] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    5.810950] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x28
[    5.812128] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    5.813247] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x94
[    5.814273] pci 0000:00:02.0: Boot video device
[    5.815101] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x14e
[    5.817447] PCI: CLS 0 bytes, default 64
[    5.818485] Unpacking initramfs...
[    6.884840] Freeing initrd memory: 25284k freed
[    7.098955] DMA-API: preallocated 32768 debug entries
[    7.099651] DMA-API: debugging enabled by kernel config
[    7.101903] device class 'msr': registering
[    7.102447] device: 'msr0': device_add
[    7.102990] device class 'cpuid': registering
[    7.103617] device: 'cpu0': device_add
[    7.104219] Registering platform device 'pcspkr'. Parent at platform
[    7.105023] device: 'pcspkr': device_add
[    7.105507] bus: 'platform': add device pcspkr
[    7.107837] The force parameter has not been set to 1 so the Iris powero=
ff handler will not be installed.
[    7.109249] bus: 'clocksource': registered
[    7.109796] device: 'clocksource': device_add
[    7.110324] device: 'clocksource0': device_add
[    7.110923] bus: 'clocksource': add device clocksource0
[    7.111648] bus: 'platform': add driver alarmtimer
[    7.112976] Registering platform device 'alarmtimer'. Parent at platform
[    7.113821] device: 'alarmtimer': device_add
[    7.114329] bus: 'platform': add device alarmtimer
[    7.114968] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    7.116228] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    7.117282] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    7.118186] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    7.119235] bus: 'rttest': registered
[    7.119731] device: 'rttest': device_add
[    7.120370] device: 'rttest0': device_add
[    7.120926] bus: 'rttest': add device rttest0
[    7.122274] device: 'rttest1': device_add
[    7.122823] bus: 'rttest': add device rttest1
[    7.123392] device: 'rttest2': device_add
[    7.123949] bus: 'rttest': add device rttest2
[    7.124677] device: 'rttest3': device_add
[    7.125180] bus: 'rttest': add device rttest3
[    7.125801] device: 'rttest4': device_add
[    7.126316] bus: 'rttest': add device rttest4
[    7.127488] device: 'rttest5': device_add
[    7.128070] bus: 'rttest': add device rttest5
[    7.129186] device: 'rttest6': device_add
[    7.129739] bus: 'rttest': add device rttest6
[    7.130316] device: 'rttest7': device_add
[    7.130867] bus: 'rttest': add device rttest7
[    7.131427] Initializing RT-Tester: OK
[    7.132072] rcu-torture:--- Start of test: nreaders=3D2 nfakewriters=3D4=
 stat_interval=3D0 verbose=3D0 test_no_idle_hz=3D0 shuffle_interval=3D3 stu=
tter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 tes=
t_boost=3D1/1 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    7.138005] bus: 'event_source': registered
[    7.138530] device: 'breakpoint': device_add
[    7.139100] bus: 'event_source': add device breakpoint
[    7.139787] device: 'software': device_add
[    7.140434] bus: 'event_source': add device software
[    7.142234] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    7.143036] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    7.143686] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    7.145269] QNX4 filesystem 0.2.3 registered.
[    7.146887] JFS: nTxBlock =3D 1813, nTxLock =3D 14511
[    7.149152] SGI XFS with security attributes, realtime, debug enabled
[    7.150651] NILFS version 2 loaded
[    7.151080] BeFS version: 0.9.3
[    7.151500] device: 'btrfs-control': device_add
[    7.152793] Btrfs loaded
[    7.153234] msgmni has been set to 453
[    7.154634] alg: No test for cipher_null (cipher_null-generic)
[    7.155452] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    7.156457] alg: No test for digest_null (digest_null-generic)
[    7.157326] alg: No test for compress_null (compress_null-generic)
[    7.163581] alg: No test for fcrypt (fcrypt-generic)
[    7.169399] alg: No test for stdrng (krng)
[    7.178698] NET: Registered protocol family 38
[    7.179280] device class 'bsg': registering
[    7.179849] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    7.180888] io scheduler noop registered
[    7.181374] io scheduler cfq registered (default)
[    7.181987] start plist test
[    7.183421] end plist test
[    7.183813] list_sort_test: start testing list_sort()
[    7.186250] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    7.186904] crc32: self tests passed, processed 225944 bytes in 132475 n=
sec
[    7.187909] crc32c: CRC_LE_BITS =3D 64
[    7.188509] crc32c: self tests passed, processed 225944 bytes in 66136 n=
sec
[    7.190256] bus: 'platform': add driver basic-mmio-gpio
[    7.190942] bus: 'i2c': add driver adp5588-gpio
[    7.191498] i2c-core: driver [adp5588-gpio] registered
[    7.192654] bus: 'platform': add driver janz-ttl
[    7.193208] bus: 'pci': add driver langwell_gpio
[    7.193844] bus: 'platform': add driver wp_gpio
[    7.194426] bus: 'pci': add driver ml_ioh_gpio
[    7.195036] bus: 'pci': add driver pch_gpio
[    7.195630] bus: 'platform': add driver rdc321x-gpio
[    7.197420] bus: 'pci': add driver pci-stub
[    7.198690] bus: 'platform': add driver lm3533-backlight
[    7.199360] bus: 'platform': add driver pwm-backlight
[    7.200064] bus: 'platform': add driver da9052-wled
[    7.200805] bus: 'acpi': add driver Apple backlight
[    7.201456] bus: 'platform': add driver pcf50633-backlight
[    7.202198] bus: 'pci': add driver CyberPro
[    7.202761] bus: 'pci': add driver pm3fb
[    7.203250] bus: 'pci': add driver matroxfb
[    7.203837] bus: 'pci': add driver aty128fb
[    7.205692] bus: 'pci': add driver radeonfb
[    7.206251] bus: 'pci': add driver kyrofb
[    7.206816] bus: 'pci': add driver savagefb
[    7.208056] bus: 'pci': add driver neofb
[    7.208708] bus: 'pci': add driver tdfxfb
[    7.209233] bus: 'pci': add driver vt8623fb
[    7.209822] bus: 'pci': add driver tridentfb
[    7.210358] vmlfb: initializing
[    7.210802] bus: 'pci': add driver vmlfb
[    7.211301] bus: 'pci': add driver arkfb
[    7.211873] bus: 'platform': add driver hgafb
[    7.212686] Registering platform device 'hgafb.0'. Parent at platform
[    7.213498] device: 'hgafb.0': device_add
[    7.214125] bus: 'platform': add device hgafb.0
[    7.214781] bus: 'platform': driver_probe_device: matched device hgafb.0=
 with driver hgafb
[    7.215909] bus: 'platform': really_probe: probing driver hgafb with dev=
ice hgafb.0
[    7.217269] hgafb: HGA card not detected.
[    7.217842] hgafb: probe of hgafb.0 failed with error -22
[    7.218505] bus: 'pci': add driver asiliantfb
[    7.219108] bus: 'platform': add driver metronomefb
[    7.219749] bus: 'platform': add driver broadsheetfb
[    7.221196] bus: 'platform': add driver auo_k1900fb
[    7.221865] bus: 'platform': add driver s1d13xxxfb
[    7.222463] bus: 'usb': add driver udlfb
[    7.222990] usbcore: registered new interface driver udlfb
[    7.223719] bus: 'usb': add driver smscufx
[    7.225137] usbcore: registered new interface driver smscufx
[    7.225870] bus: 'pci': add driver carminefb
[    7.226440] bus: 'platform': add driver uvesafb
[    7.227039] Registering platform device 'uvesafb.0'. Parent at platform
[    7.227877] device: 'uvesafb.0': device_add
[    7.229444] bus: 'platform': add device uvesafb.0
[    7.230074] bus: 'platform': driver_probe_device: matched device uvesafb=
=2E0 with driver uvesafb
[    7.231166] bus: 'platform': really_probe: probing driver uvesafb with d=
evice uvesafb.0
[    7.233651] uvesafb: failed to execute /sbin/v86d
[    7.234231] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    7.235171] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    7.236028] uvesafb: vbe_init() failed with -22
[    7.236750] uvesafb: probe of uvesafb.0 failed with error -22
[    7.237493] Registering platform device 'vesafb.0'. Parent at platform
[    7.238363] device: 'vesafb.0': device_add
[    7.238918] bus: 'platform': add device vesafb.0
[    7.239502] bus: 'platform': add driver vesafb
[    7.240272] bus: 'platform': driver_probe_device: matched device vesafb.=
0 with driver vesafb
[    7.241340] bus: 'platform': really_probe: probing driver vesafb with de=
vice vesafb.0
[    7.242356] vesafb: probe of vesafb.0 rejects match -19
[    7.243061] bus: 'platform': remove driver vesafb
[    7.243684] driver: 'vesafb': driver_release
[    7.244686] bus: 'platform': remove device vesafb.0
[    7.245414] pci_bus 0000:00: dev 01, created physical slot 1
[    7.246198] pci_bus 0000:00: dev 02, created physical slot 2
[    7.246978] pci_bus 0000:00: dev 03, created physical slot 3
[    7.247737] pci_bus 0000:00: dev 04, created physical slot 4
[    7.248674] pci_bus 0000:00: dev 05, created physical slot 5
[    7.249399] pci_bus 0000:00: dev 06, created physical slot 6
[    7.250158] pci_bus 0000:00: dev 07, created physical slot 7
[    7.250903] pci_bus 0000:00: dev 08, created physical slot 8
[    7.251731] pci_bus 0000:00: dev 09, created physical slot 9
[    7.252634] pci_bus 0000:00: dev 0a, created physical slot 10
[    7.253388] pci_bus 0000:00: dev 0b, created physical slot 11
[    7.254191] pci_bus 0000:00: dev 0c, created physical slot 12
[    7.254975] pci_bus 0000:00: dev 0d, created physical slot 13
[    7.255812] pci_bus 0000:00: dev 0e, created physical slot 14
[    7.256791] pci_bus 0000:00: dev 0f, created physical slot 15
[    7.258195] pci_bus 0000:00: dev 10, created physical slot 16
[    7.258995] pci_bus 0000:00: dev 11, created physical slot 17
[    7.260363] pci_bus 0000:00: dev 12, created physical slot 18
[    7.261145] pci_bus 0000:00: dev 13, created physical slot 19
[    7.261925] pci_bus 0000:00: dev 14, created physical slot 20
[    7.262748] pci_bus 0000:00: dev 15, created physical slot 21
[    7.263477] pci_bus 0000:00: dev 16, created physical slot 22
[    7.265196] pci_bus 0000:00: dev 17, created physical slot 23
[    7.265972] pci_bus 0000:00: dev 18, created physical slot 24
[    7.266774] pci_bus 0000:00: dev 19, created physical slot 25
[    7.267491] pci_bus 0000:00: dev 1a, created physical slot 26
[    7.269356] pci_bus 0000:00: dev 1b, created physical slot 27
[    7.270163] pci_bus 0000:00: dev 1c, created physical slot 28
[    7.270962] pci_bus 0000:00: dev 1d, created physical slot 29
[    7.271746] pci_bus 0000:00: dev 1e, created physical slot 30
[    7.273653] pci_bus 0000:00: dev 1f, created physical slot 31
[    7.274801] bus: 'acpi': add driver battery
[    7.275407] bus: 'platform': add driver timb-dma
[    7.276044] bus: 'pci': add driver pch-dma
[    7.276723] bus: 'pci': add driver virtio-pci
[    7.277262] bus: 'pci': driver_probe_device: matched device 0000:00:05.0=
 with driver virtio-pci
[    7.278358] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:05.0
[    7.279850] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    7.281437] PCI: setting IRQ 10 as level-triggered
[    7.282100] virtio-pci 0000:00:05.0: enabling bus mastering
[    7.282844] virtio-pci 0000:00:05.0: setting latency timer to 64
[    7.285083] device: 'virtio0': device_add
[    7.285619] bus: 'virtio': add device virtio0
[    7.286200] driver: '0000:00:05.0': driver_bound: bound to device 'virti=
o-pci'
[    7.287139] bus: 'pci': really_probe: bound device 0000:00:05.0 to drive=
r virtio-pci
[    7.288426] bus: 'pci': driver_probe_device: matched device 0000:00:06.0=
 with driver virtio-pci
[    7.289619] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:06.0
[    7.291066] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    7.291832] virtio-pci 0000:00:06.0: enabling bus mastering
[    7.292683] virtio-pci 0000:00:06.0: setting latency timer to 64
[    7.294202] device: 'virtio1': device_add
[    7.294767] bus: 'virtio': add device virtio1
[    7.295833] driver: '0000:00:06.0': driver_bound: bound to device 'virti=
o-pci'
[    7.297341] bus: 'pci': really_probe: bound device 0000:00:06.0 to drive=
r virtio-pci
[    7.298335] bus: 'pci': driver_probe_device: matched device 0000:00:07.0=
 with driver virtio-pci
[    7.299431] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:07.0
[    7.300973] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    7.301742] PCI: setting IRQ 11 as level-triggered
[    7.302358] virtio-pci 0000:00:07.0: enabling bus mastering
[    7.303113] virtio-pci 0000:00:07.0: setting latency timer to 64
[    7.304245] device: 'virtio2': device_add
[    7.304813] bus: 'virtio': add device virtio2
[    7.305367] driver: '0000:00:07.0': driver_bound: bound to device 'virti=
o-pci'
[    7.306305] bus: 'pci': really_probe: bound device 0000:00:07.0 to drive=
r virtio-pci
[    7.307294] bus: 'pci': driver_probe_device: matched device 0000:00:08.0=
 with driver virtio-pci
[    7.308567] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:08.0
[    7.309985] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    7.310778] virtio-pci 0000:00:08.0: enabling bus mastering
[    7.311481] virtio-pci 0000:00:08.0: setting latency timer to 64
[    7.312647] device: 'virtio3': device_add
[    7.313150] bus: 'virtio': add device virtio3
[    7.313760] driver: '0000:00:08.0': driver_bound: bound to device 'virti=
o-pci'
[    7.314712] bus: 'pci': really_probe: bound device 0000:00:08.0 to drive=
r virtio-pci
[    7.315725] bus: 'pci': driver_probe_device: matched device 0000:00:09.0=
 with driver virtio-pci
[    7.316991] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:09.0
[    7.318143] virtio-pci 0000:00:09.0: enabling bus mastering
[    7.318885] virtio-pci 0000:00:09.0: setting latency timer to 64
[    7.319842] device: 'virtio4': device_add
[    7.320505] bus: 'virtio': add device virtio4
[    7.321124] driver: '0000:00:09.0': driver_bound: bound to device 'virti=
o-pci'
[    7.322046] bus: 'pci': really_probe: bound device 0000:00:09.0 to drive=
r virtio-pci
[    7.323186] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0=
 with driver virtio-pci
[    7.324896] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:0a.0
[    7.327108] virtio-pci 0000:00:0a.0: enabling bus mastering
[    7.327853] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    7.329495] device: 'virtio5': device_add
[    7.330225] bus: 'virtio': add device virtio5
[    7.331015] driver: '0000:00:0a.0': driver_bound: bound to device 'virti=
o-pci'
[    7.331927] bus: 'pci': really_probe: bound device 0000:00:0a.0 to drive=
r virtio-pci
[    7.333326] HDLC line discipline maxframe=3D4096
[    7.333916] N_HDLC line discipline registered.
[    7.334489] r3964: Philips r3964 Driver $Revision: 1.10 $
[    7.335187] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    7.336019] Registering platform device 'serial8250'. Parent at platform
[    7.337019] device: 'serial8250': device_add
[    7.337581] bus: 'platform': add device serial8250
[    7.363966] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    7.365702] device: 'ttyS0': device_add
[    7.366581] device: 'ttyS1': device_add
[    7.368466] device: 'ttyS2': device_add
[    7.369037] device: 'ttyS3': device_add
[    7.369568] bus: 'platform': add driver serial8250
[    7.370169] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[    7.371265] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[    7.372467] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[    7.373442] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[    7.374432] bus: 'pnp': add driver serial
[    7.375001] bus: 'pnp': driver_probe_device: matched device 00:06 with d=
river serial
[    7.375964] bus: 'pnp': really_probe: probing driver serial with device =
00:06
[    7.377617] device: 'ttyS0': device_unregister
[    7.378240] device: 'ttyS0': device_create_release
[    7.403162] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    7.403890] device: 'ttyS0': device_add
[    7.404560] driver: '00:06': driver_bound: bound to device 'serial'
[    7.405343] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[    7.406247] bus: 'platform': add driver altera_uart
[    7.406909] bus: 'platform': add driver timb-uart
[    7.410646] bus: 'pci': add driver pch_uart
[    7.411197] MOXA Intellio family driver version 6.0k
[    7.411887] device: 'ttyMX0': device_add
[    7.412711] device: 'ttyMX1': device_add
[    7.413232] device: 'ttyMX2': device_add
[    7.413771] device: 'ttyMX3': device_add
[    7.414836] device: 'ttyMX4': device_add
[    7.415347] device: 'ttyMX5': device_add
[    7.415890] device: 'ttyMX6': device_add
[    7.416576] device: 'ttyMX7': device_add
[    7.417083] device: 'ttyMX8': device_add
[    7.417613] device: 'ttyMX9': device_add
[    7.418661] device: 'ttyMX10': device_add
[    7.419184] device: 'ttyMX11': device_add
[    7.419734] device: 'ttyMX12': device_add
[    7.421324] device: 'ttyMX13': device_add
[    7.421885] device: 'ttyMX14': device_add
[    7.422938] device: 'ttyMX15': device_add
[    7.423466] device: 'ttyMX16': device_add
[    7.424027] device: 'ttyMX17': device_add
[    7.424706] device: 'ttyMX18': device_add
[    7.425221] device: 'ttyMX19': device_add
[    7.425791] device: 'ttyMX20': device_add
[    7.426887] device: 'ttyMX21': device_add
[    7.427421] device: 'ttyMX22': device_add
[    7.427947] device: 'ttyMX23': device_add
[    7.429517] device: 'ttyMX24': device_add
[    7.430086] device: 'ttyMX25': device_add
[    7.431240] device: 'ttyMX26': device_add
[    7.431975] device: 'ttyMX27': device_add
[    7.432918] device: 'ttyMX28': device_add
[    7.433694] device: 'ttyMX29': device_add
[    7.434360] device: 'ttyMX30': device_add
[    7.435070] device: 'ttyMX31': device_add
[    7.437276] device: 'ttyMX32': device_add
[    7.438042] device: 'ttyMX33': device_add
[    7.438728] device: 'ttyMX34': device_add
[    7.439226] device: 'ttyMX35': device_add
[    7.439756] device: 'ttyMX36': device_add
[    7.440930] device: 'ttyMX37': device_add
[    7.441417] device: 'ttyMX38': device_add
[    7.441959] device: 'ttyMX39': device_add
[    7.442481] device: 'ttyMX40': device_add
[    7.443015] device: 'ttyMX41': device_add
[    7.443502] device: 'ttyMX42': device_add
[    7.444812] device: 'ttyMX43': device_add
[    7.445488] device: 'ttyMX44': device_add
[    7.446239] device: 'ttyMX45': device_add
[    7.446802] device: 'ttyMX46': device_add
[    7.447287] device: 'ttyMX47': device_add
[    7.448501] device: 'ttyMX48': device_add
[    7.449063] device: 'ttyMX49': device_add
[    7.449580] device: 'ttyMX50': device_add
[    7.450283] device: 'ttyMX51': device_add
[    7.450959] device: 'ttyMX52': device_add
[    7.451651] device: 'ttyMX53': device_add
[    7.453088] device: 'ttyMX54': device_add
[    7.453820] device: 'ttyMX55': device_add
[    7.454590] device: 'ttyMX56': device_add
[    7.455259] device: 'ttyMX57': device_add
[    7.455979] device: 'ttyMX58': device_add
[    7.457367] device: 'ttyMX59': device_add
[    7.458061] device: 'ttyMX60': device_add
[    7.458781] device: 'ttyMX61': device_add
[    7.459532] device: 'ttyMX62': device_add
[    7.460435] device: 'ttyMX63': device_add
[    7.461202] device: 'ttyMX64': device_add
[    7.462796] device: 'ttyMX65': device_add
[    7.463584] device: 'ttyMX66': device_add
[    7.464523] device: 'ttyMX67': device_add
[    7.465314] device: 'ttyMX68': device_add
[    7.466057] device: 'ttyMX69': device_add
[    7.467433] device: 'ttyMX70': device_add
[    7.468306] device: 'ttyMX71': device_add
[    7.469032] device: 'ttyMX72': device_add
[    7.469834] device: 'ttyMX73': device_add
[    7.470429] device: 'ttyMX74': device_add
[    7.471568] device: 'ttyMX75': device_add
[    7.473382] device: 'ttyMX76': device_add
[    7.473928] device: 'ttyMX77': device_add
[    7.474402] device: 'ttyMX78': device_add
[    7.475023] device: 'ttyMX79': device_add
[    7.476270] device: 'ttyMX80': device_add
[    7.476782] device: 'ttyMX81': device_add
[    7.477286] device: 'ttyMX82': device_add
[    7.477839] device: 'ttyMX83': device_add
[    7.478438] device: 'ttyMX84': device_add
[    7.479163] device: 'ttyMX85': device_add
[    7.481695] device: 'ttyMX86': device_add
[    7.482379] device: 'ttyMX87': device_add
[    7.483103] device: 'ttyMX88': device_add
[    7.483826] device: 'ttyMX89': device_add
[    7.484689] device: 'ttyMX90': device_add
[    7.485921] device: 'ttyMX91': device_add
[    7.486653] device: 'ttyMX92': device_add
[    7.487382] device: 'ttyMX93': device_add
[    7.488304] device: 'ttyMX94': device_add
[    7.489125] device: 'ttyMX95': device_add
[    7.489904] device: 'ttyMX96': device_add
[    7.491305] device: 'ttyMX97': device_add
[    7.493702] device: 'ttyMX98': device_add
[    7.494459] device: 'ttyMX99': device_add
[    7.495228] device: 'ttyMX100': device_add
[    7.496165] device: 'ttyMX101': device_add
[    7.497529] device: 'ttyMX102': device_add
[    7.498113] device: 'ttyMX103': device_add
[    7.498666] device: 'ttyMX104': device_add
[    7.499181] device: 'ttyMX105': device_add
[    7.499747] device: 'ttyMX106': device_add
[    7.500903] device: 'ttyMX107': device_add
[    7.501415] device: 'ttyMX108': device_add
[    7.502027] device: 'ttyMX109': device_add
[    7.502716] device: 'ttyMX110': device_add
[    7.503454] device: 'ttyMX111': device_add
[    7.504418] device: 'ttyMX112': device_add
[    7.505729] device: 'ttyMX113': device_add
[    7.506489] device: 'ttyMX114': device_add
[    7.507260] device: 'ttyMX115': device_add
[    7.508207] device: 'ttyMX116': device_add
[    7.508794] device: 'ttyMX117': device_add
[    7.509736] device: 'ttyMX118': device_add
[    7.510239] device: 'ttyMX119': device_add
[    7.510757] device: 'ttyMX120': device_add
[    7.511240] device: 'ttyMX121': device_add
[    7.511773] device: 'ttyMX122': device_add
[    7.513991] device: 'ttyMX123': device_add
[    7.514749] device: 'ttyMX124': device_add
[    7.515438] device: 'ttyMX125': device_add
[    7.516310] device: 'ttyMX126': device_add
[    7.517007] device: 'ttyMX127': device_add
[    7.518327] device: 'ttyMX128': device_add
[    7.519084] bus: 'pci': add driver moxa
[    7.519819] Initializing Nozomi driver 2.1d
[    7.520761] bus: 'pci': add driver nozomi
[    7.521492] SyncLink MultiPort driver $Revision: 4.38 $
[    7.522384] bus: 'pci': add driver synclinkmp
[    7.523088] device: 'ttySLM0': device_add
[    7.523720] device: 'ttySLM1': device_add
[    7.524486] device: 'ttySLM2': device_add
[    7.525912] device: 'ttySLM3': device_add
[    7.526510] device: 'ttySLM4': device_add
[    7.527169] device: 'ttySLM5': device_add
[    7.527806] device: 'ttySLM6': device_add
[    7.528595] device: 'ttySLM7': device_add
[    7.529706] device: 'ttySLM8': device_add
[    7.530320] device: 'ttySLM9': device_add
[    7.530985] device: 'ttySLM10': device_add
[    7.531623] device: 'ttySLM11': device_add
[    7.532645] device: 'ttySLM12': device_add
[    7.533942] device: 'ttySLM13': device_add
[    7.534704] device: 'ttySLM14': device_add
[    7.535423] device: 'ttySLM15': device_add
[    7.536497] device: 'ttySLM16': device_add
[    7.537267] device: 'ttySLM17': device_add
[    7.538039] device: 'ttySLM18': device_add
[    7.539468] device: 'ttySLM19': device_add
[    7.540435] device: 'ttySLM20': device_add
[    7.541267] device: 'ttySLM21': device_add
[    7.542020] device: 'ttySLM22': device_add
[    7.542786] device: 'ttySLM23': device_add
[    7.544412] device: 'ttySLM24': device_add
[    7.545190] device: 'ttySLM25': device_add
[    7.545973] device: 'ttySLM26': device_add
[    7.546755] device: 'ttySLM27': device_add
[    7.547489] device: 'ttySLM28': device_add
[    7.549983] device: 'ttySLM29': device_add
[    7.550646] device: 'ttySLM30': device_add
[    7.551265] device: 'ttySLM31': device_add
[    7.551962] device: 'ttySLM32': device_add
[    7.552752] device: 'ttySLM33': device_add
[    7.553358] device: 'ttySLM34': device_add
[    7.554476] device: 'ttySLM35': device_add
[    7.555150] device: 'ttySLM36': device_add
[    7.555811] device: 'ttySLM37': device_add
[    7.557086] device: 'ttySLM38': device_add
[    7.557735] device: 'ttySLM39': device_add
[    7.558858] device: 'ttySLM40': device_add
[    7.559679] device: 'ttySLM41': device_add
[    7.562128] device: 'ttySLM42': device_add
[    7.562938] device: 'ttySLM43': device_add
[    7.563713] device: 'ttySLM44': device_add
[    7.565281] device: 'ttySLM45': device_add
[    7.566039] device: 'ttySLM46': device_add
[    7.566812] device: 'ttySLM47': device_add
[    7.567527] device: 'ttySLM48': device_add
[    7.569105] device: 'ttySLM49': device_add
[    7.570327] device: 'ttySLM50': device_add
[    7.570985] device: 'ttySLM51': device_add
[    7.571634] device: 'ttySLM52': device_add
[    7.572438] device: 'ttySLM53': device_add
[    7.573146] device: 'ttySLM54': device_add
[    7.573813] device: 'ttySLM55': device_add
[    7.575050] device: 'ttySLM56': device_add
[    7.575850] device: 'ttySLM57': device_add
[    7.576823] device: 'ttySLM58': device_add
[    7.577609] device: 'ttySLM59': device_add
[    7.578350] device: 'ttySLM60': device_add
[    7.579800] device: 'ttySLM61': device_add
[    7.580752] device: 'ttySLM62': device_add
[    7.581482] device: 'ttySLM63': device_add
[    7.582269] device: 'ttySLM64': device_add
[    7.583084] device: 'ttySLM65': device_add
[    7.584771] device: 'ttySLM66': device_add
[    7.585516] device: 'ttySLM67': device_add
[    7.586310] device: 'ttySLM68': device_add
[    7.587091] device: 'ttySLM69': device_add
[    7.587854] device: 'ttySLM70': device_add
[    7.589239] device: 'ttySLM71': device_add
[    7.589896] device: 'ttySLM72': device_add
[    7.590566] device: 'ttySLM73': device_add
[    7.591195] device: 'ttySLM74': device_add
[    7.591871] device: 'ttySLM75': device_add
[    7.593659] device: 'ttySLM76': device_add
[    7.594915] device: 'ttySLM77': device_add
[    7.595586] device: 'ttySLM78': device_add
[    7.597283] device: 'ttySLM79': device_add
[    7.597957] device: 'ttySLM80': device_add
[    7.598606] device: 'ttySLM81': device_add
[    7.600187] device: 'ttySLM82': device_add
[    7.600948] device: 'ttySLM83': device_add
[    7.601711] device: 'ttySLM84': device_add
[    7.602438] device: 'ttySLM85': device_add
[    7.603215] device: 'ttySLM86': device_add
[    7.604916] device: 'ttySLM87': device_add
[    7.605710] device: 'ttySLM88': device_add
[    7.606426] device: 'ttySLM89': device_add
[    7.607189] device: 'ttySLM90': device_add
[    7.607947] device: 'ttySLM91': device_add
[    7.609506] device: 'ttySLM92': device_add
[    7.610279] device: 'ttySLM93': device_add
[    7.611060] device: 'ttySLM94': device_add
[    7.611843] device: 'ttySLM95': device_add
[    7.612808] device: 'ttySLM96': device_add
[    7.613611] device: 'ttySLM97': device_add
[    7.615024] device: 'ttySLM98': device_add
[    7.615696] device: 'ttySLM99': device_add
[    7.616703] device: 'ttySLM100': device_add
[    7.617334] device: 'ttySLM101': device_add
[    7.618008] device: 'ttySLM102': device_add
[    7.619294] device: 'ttySLM103': device_add
[    7.619956] device: 'ttySLM104': device_add
[    7.620765] device: 'ttySLM105': device_add
[    7.621944] device: 'ttySLM106': device_add
[    7.622625] device: 'ttySLM107': device_add
[    7.623261] device: 'ttySLM108': device_add
[    7.623977] device: 'ttySLM109': device_add
[    7.625601] device: 'ttySLM110': device_add
[    7.626384] device: 'ttySLM111': device_add
[    7.627164] device: 'ttySLM112': device_add
[    7.628840] device: 'ttySLM113': device_add
[    7.629607] device: 'ttySLM114': device_add
[    7.630333] device: 'ttySLM115': device_add
[    7.631094] device: 'ttySLM116': device_add
[    7.631880] device: 'ttySLM117': device_add
[    7.633590] device: 'ttySLM118': device_add
[    7.635075] device: 'ttySLM119': device_add
[    7.635805] device: 'ttySLM120': device_add
[    7.636593] device: 'ttySLM121': device_add
[    7.637230] device: 'ttySLM122': device_add
[    7.637898] device: 'ttySLM123': device_add
[    7.639124] device: 'ttySLM124': device_add
[    7.639786] device: 'ttySLM125': device_add
[    7.640599] device: 'ttySLM126': device_add
[    7.641230] device: 'ttySLM127': device_add
[    7.641884] SyncLink MultiPort driver $Revision: 4.38 $, tty major#248
[    7.643022] SyncLink serial driver $Revision: 4.38 $
[    7.643907] bus: 'pci': add driver synclink
[    7.645608] device: 'ttySL0': device_add
[    7.646308] device: 'ttySL1': device_add
[    7.647039] device: 'ttySL2': device_add
[    7.647836] device: 'ttySL3': device_add
[    7.649577] device: 'ttySL4': device_add
[    7.650273] device: 'ttySL5': device_add
[    7.651731] device: 'ttySL6': device_add
[    7.653573] device: 'ttySL7': device_add
[    7.654269] device: 'ttySL8': device_add
[    7.655000] device: 'ttySL9': device_add
[    7.655731] device: 'ttySL10': device_add
[    7.657389] device: 'ttySL11': device_add
[    7.658049] device: 'ttySL12': device_add
[    7.658697] device: 'ttySL13': device_add
[    7.659338] device: 'ttySL14': device_add
[    7.660219] device: 'ttySL15': device_add
[    7.660831] device: 'ttySL16': device_add
[    7.661967] device: 'ttySL17': device_add
[    7.662719] device: 'ttySL18': device_add
[    7.663443] device: 'ttySL19': device_add
[    7.664392] device: 'ttySL20': device_add
[    7.665035] device: 'ttySL21': device_add
[    7.666232] device: 'ttySL22': device_add
[    7.666781] device: 'ttySL23': device_add
[    7.667338] device: 'ttySL24': device_add
[    7.667929] device: 'ttySL25': device_add
[    7.668592] device: 'ttySL26': device_add
[    7.669314] device: 'ttySL27': device_add
[    7.670780] device: 'ttySL28': device_add
[    7.671520] device: 'ttySL29': device_add
[    7.672297] device: 'ttySL30': device_add
[    7.674071] device: 'ttySL31': device_add
[    7.674838] device: 'ttySL32': device_add
[    7.676899] device: 'ttySL33': device_add
[    7.677660] device: 'ttySL34': device_add
[    7.678380] device: 'ttySL35': device_add
[    7.679188] device: 'ttySL36': device_add
[    7.679946] device: 'ttySL37': device_add
[    7.680821] device: 'ttySL38': device_add
[    7.682162] device: 'ttySL39': device_add
[    7.682730] device: 'ttySL40': device_add
[    7.683437] device: 'ttySL41': device_add
[    7.684913] device: 'ttySL42': device_add
[    7.685684] device: 'ttySL43': device_add
[    7.687134] device: 'ttySL44': device_add
[    7.687894] device: 'ttySL45': device_add
[    7.688678] device: 'ttySL46': device_add
[    7.689224] device: 'ttySL47': device_add
[    7.689803] device: 'ttySL48': device_add
[    7.690303] device: 'ttySL49': device_add
[    7.691368] device: 'ttySL50': device_add
[    7.691967] device: 'ttySL51': device_add
[    7.693334] device: 'ttySL52': device_add
[    7.693886] device: 'ttySL53': device_add
[    7.694362] device: 'ttySL54': device_add
[    7.695628] device: 'ttySL55': device_add
[    7.696495] device: 'ttySL56': device_add
[    7.697036] device: 'ttySL57': device_add
[    7.697602] device: 'ttySL58': device_add
[    7.698098] device: 'ttySL59': device_add
[    7.698652] device: 'ttySL60': device_add
[    7.699807] device: 'ttySL61': device_add
[    7.700419] device: 'ttySL62': device_add
[    7.700992] device: 'ttySL63': device_add
[    7.701489] device: 'ttySL64': device_add
[    7.702062] device: 'ttySL65': device_add
[    7.703053] device: 'ttySL66': device_add
[    7.703593] device: 'ttySL67': device_add
[    7.704218] device: 'ttySL68': device_add
[    7.704887] device: 'ttySL69': device_add
[    7.705421] device: 'ttySL70': device_add
[    7.705976] device: 'ttySL71': device_add
[    7.707018] device: 'ttySL72': device_add
[    7.707514] device: 'ttySL73': device_add
[    7.709169] device: 'ttySL74': device_add
[    7.709702] device: 'ttySL75': device_add
[    7.710209] device: 'ttySL76': device_add
[    7.711222] device: 'ttySL77': device_add
[    7.711746] device: 'ttySL78': device_add
[    7.712385] device: 'ttySL79': device_add
[    7.712947] device: 'ttySL80': device_add
[    7.713444] device: 'ttySL81': device_add
[    7.713996] device: 'ttySL82': device_add
[    7.714969] device: 'ttySL83': device_add
[    7.715495] device: 'ttySL84': device_add
[    7.716289] device: 'ttySL85': device_add
[    7.716854] device: 'ttySL86': device_add
[    7.717325] device: 'ttySL87': device_add
[    7.718292] device: 'ttySL88': device_add
[    7.718877] device: 'ttySL89': device_add
[    7.719377] device: 'ttySL90': device_add
[    7.719958] device: 'ttySL91': device_add
[    7.720672] device: 'ttySL92': device_add
[    7.721188] device: 'ttySL93': device_add
[    7.722167] device: 'ttySL94': device_add
[    7.722712] device: 'ttySL95': device_add
[    7.723209] device: 'ttySL96': device_add
[    7.723742] device: 'ttySL97': device_add
[    7.724942] device: 'ttySL98': device_add
[    7.726120] device: 'ttySL99': device_add
[    7.726701] device: 'ttySL100': device_add
[    7.727222] device: 'ttySL101': device_add
[    7.727816] device: 'ttySL102': device_add
[    7.729036] device: 'ttySL103': device_add
[    7.730116] device: 'ttySL104': device_add
[    7.730669] device: 'ttySL105': device_add
[    7.731184] device: 'ttySL106': device_add
[    7.731726] device: 'ttySL107': device_add
[    7.733231] device: 'ttySL108': device_add
[    7.733787] device: 'ttySL109': device_add
[    7.734904] device: 'ttySL110': device_add
[    7.735444] device: 'ttySL111': device_add
[    7.735994] device: 'ttySL112': device_add
[    7.736730] device: 'ttySL113': device_add
[    7.737265] device: 'ttySL114': device_add
[    7.738284] device: 'ttySL115': device_add
[    7.738871] device: 'ttySL116': device_add
[    7.739371] device: 'ttySL117': device_add
[    7.739928] device: 'ttySL118': device_add
[    7.740598] device: 'ttySL119': device_add
[    7.741681] device: 'ttySL120': device_add
[    7.742233] device: 'ttySL121': device_add
[    7.742795] device: 'ttySL122': device_add
[    7.743295] device: 'ttySL123': device_add
[    7.743916] device: 'ttySL124': device_add
[    7.745209] device: 'ttySL125': device_add
[    7.746583] device: 'ttySL126': device_add
[    7.747148] device: 'ttySL127': device_add
[    7.747679] SyncLink serial driver $Revision: 4.38 $, tty major#247
[    7.748674] device class 'virtio-ports': registering
[    7.749297] bus: 'virtio': add driver virtio_console
[    7.749959] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    7.750848] ac.o: No PCI boards found.
[    7.751282] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    7.752341] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    7.753133] device: 'hpet': device_add
[    7.753633] bus: 'acpi': add driver hpet
[    7.754149] bus: 'acpi': driver_probe_device: matched device PNP0103:00 =
with driver hpet
[    7.755209] bus: 'acpi': really_probe: probing driver hpet with device P=
NP0103:00
[    7.756413] hpet: probe of PNP0103:00 rejects match -19
[    7.758154] device: 'nvram': device_add
[    7.759171] Non-volatile memory driver v1.3
[    7.759721] toshiba: not a supported Toshiba laptop
[    7.760873] device class 'ppdev': registering
[    7.761415] ppdev: user-space parallel port driver
[    7.762064] Registering platform device 'pc8736x_gpio.0'. Parent at plat=
form
[    7.762913] device: 'pc8736x_gpio.0': device_add
[    7.763456] bus: 'platform': add device pc8736x_gpio.0
[    7.764263] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    7.765227] platform pc8736x_gpio.0: no device found
[    7.765909] bus: 'platform': remove device pc8736x_gpio.0
[    7.766592] nsc_gpio initializing
[    7.767051] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    7.767697] bus: 'platform': add driver ax88796-pp
[    7.769128] bus: 'pci': add driver pciPTI
[    7.769739] lkdtm: No crash points registered, enable through debugfs
[    7.770490] device class 'phantom': registering
[    7.771071] bus: 'pci': add driver phantom
[    7.771602] Phantom Linux Driver, version n0.9.8, init OK
[    7.772395] bus: 'i2c': add driver bh1780
[    7.773846] i2c-core: driver [bh1780] registered
[    7.774396] bus: 'i2c': add driver bh1770glc
[    7.775011] i2c-core: driver [bh1770glc] registered
[    7.775634] bus: 'pci': add driver IOC4
[    7.776266] device class 'enclosure': registering
[    7.776896] bus: 'i2c': add driver isl29003
[    7.777389] i2c-core: driver [isl29003] registered
[    7.777989] bus: 'i2c': add driver tsl2550
[    7.778473] i2c-core: driver [tsl2550] registered
[    7.779077] bus: 'i2c': add driver eeprom
[    7.779581] i2c-core: driver [eeprom] registered
[    7.780303] bus: 'i2c': add driver max6875
[    7.780870] i2c-core: driver [max6875] registered
[    7.781418] bus: 'pci': add driver cb710
[    7.781946] bus: 'platform': add driver kim
[    7.782457] bus: 'i2c': add driver lis3lv02d_i2c
[    7.783044] i2c-core: driver [lis3lv02d_i2c] registered
[    7.783692] bus: 'i2c': add driver fsa9480
[    7.784374] i2c-core: driver [fsa9480] registered
[    7.785030] bus: 'pci': add driver mei
[    7.785510] bus: 'platform': add driver sm501
[    7.787019] bus: 'pci': add driver sm501
[    7.787519] bus: 'platform': add driver twl4030-audio
[    7.789154] bus: 'platform': add driver pcf50633-adc
[    7.789806] bus: 'pci': add driver lpc_sch
[    7.790282] bus: 'pci': add driver lpc_ich
[    7.790845] bus: 'pci': add driver RDC321x Southbridge
[    7.791462] bus: 'pci': add driver janz-cmodio
[    7.793188] bus: 'pci': add driver vx855
[    7.793713] device class 'raid_devices': registering
[    7.794305] device class 'spi_transport': registering
[    7.795024] device class 'spi_host': registering
[    7.795622] device class 'fc_host': registering
[    7.796304] device class 'fc_vports': registering
[    7.796933] device class 'fc_remote_ports': registering
[    7.797562] device class 'fc_transport': registering
[    7.798159] Loading iSCSI transport class v2.0-870.
[    7.798793] device class 'iscsi_transport': registering
[    7.800249] device class 'iscsi_endpoint': registering
[    7.800906] device class 'iscsi_iface': registering
[    7.801472] device class 'iscsi_host': registering
[    7.802099] device class 'iscsi_connection': registering
[    7.802792] device class 'iscsi_session': registering
[    7.803455] device class 'sas_host': registering
[    7.805761] device class 'sas_phy': registering
[    7.806300] device class 'sas_port': registering
[    7.806934] device class 'sas_device': registering
[    7.807492] device class 'sas_end_device': registering
[    7.808253] device class 'sas_expander': registering
[    7.808912] device class 'srp_host': registering
[    7.809449] device class 'srp_remote_ports': registering
[    7.810142] rdac: device handler registered
[    7.811646] hp_sw: device handler registered
[    7.812292] emc: device handler registered
[    7.812834] alua: device handler registered
[    7.814033] bus: 'fcoe': registered
[    7.814457] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v1.0.12 (Ju=
n 04, 2012)
[    7.815668] bus: 'pci': add driver advansys
[    7.816421] bus: 'pci': add driver arcmsr
[    7.816981] bus: 'pci': add driver aic7xxx
[    7.817484] bus: 'pci': add driver aic79xx
[    7.818028] Adaptec aacraid driver 1.2-0[29800]-ms
[    7.818626] bus: 'pci': add driver aacraid
[    7.819901] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.820878] bus: 'pci': add driver aic94xx
[    7.821385] bus: 'pci': add driver pm8001
[    7.821923] bus: 'pci': add driver ips
[    7.822404] bus: 'pci': remove driver ips
[    7.822957] driver: 'ips': driver_release
[    7.823475] scsi: <fdomain> Detection failed (no card)
[    7.824293] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.04.00.03-k.
[    7.825376] bus: 'pci': add driver qla2xxx
[    7.826013] device: 'qla4xxx': device_add
[    7.826523] iscsi: registered transport (qla4xxx)
[    7.827146] bus: 'pci': add driver qla4xxx
[    7.827675] QLogic iSCSI HBA Driver
[    7.828263] bus: 'pci': add driver hpsa
[    7.828807] bus: 'pci': add driver dc395x
[    7.829280] DC390: clustering now enabled by default. If you get problem=
s load
[    7.830151]        with "disable_clustering=3D1" and report to maintaine=
rs
[    7.830968] bus: 'pci': add driver tmscsim
[    7.831458] bus: 'pci': add driver megaraid_legacy
[    7.833003] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    7.833948] device: 'megadev0': device_add
[    7.834488] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    7.835419] bus: 'pci': add driver megaraid
[    7.835964] bus: 'pci': add driver ufshcd
[    7.836612] bus: 'pci': add driver initio
[    7.837107] bus: 'pci': add driver inia100
[    7.837640] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    7.838447] bus: 'pci': add driver 3w-xxxx
[    7.839004] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    7.839892] bus: 'pci': add driver 3w-9xxx
[    7.840736] bus: 'pci': add driver mvumi
[    7.841219] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2=
012)
[    7.842231] device: 'bnx2i': device_add
[    7.843508] iscsi: registered transport (bnx2i)
[    7.845784] bus: 'virtio': add driver virtio_scsi
[    7.846408] VMware PVSCSI driver - version 1.0.2.0-k
[    7.847027] bus: 'pci': add driver vmw_pvscsi
[    7.849137] hv_vmbus: registering driver hv_storvsc
[    7.849746] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    7.850556] device class 'scsi_tape': registering
[    7.851116] bus: 'scsi': add driver st
[    7.851612] osst :I: Tape driver with OnStream support version 0.99.4
[    7.851612] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    7.853245] device class 'onstream_tape': registering
[    7.853946] bus: 'scsi': add driver osst
[    7.854450] device class 'scsi_disk': registering
[    7.855110] bus: 'scsi': add driver sd
[    7.855634] bus: 'scsi': add driver sr
[    7.857008] device class 'scsi_generic': registering
[    7.857649] SCSI Media Changer driver v0.25=20
[    7.858222] device class 'scsi_changer': registering
[    7.859633] bus: 'scsi': add driver ch
[    7.860241] bus: 'scsi': add driver ses
[    7.861667] device: 'pseudo_0': device_add
[    7.862217] bus: 'pseudo': registered
[    7.862692] bus: 'pseudo': add driver scsi_debug
[    7.864728] device: 'adapter0': device_add
[    7.865251] bus: 'pseudo': add device adapter0
[    7.865896] bus: 'pseudo': driver_probe_device: matched device adapter0 =
with driver scsi_debug
[    7.866970] bus: 'pseudo': really_probe: probing driver scsi_debug with =
device adapter0
[    7.868162] scsi_debug: host protection
[    7.868668] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    7.869554] device: 'host0': device_add
[    7.870058] bus: 'scsi': add device host0
[    7.870589] device: 'host0': device_add
[    7.873643] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    7.874653] device: 'target0:0:0': device_add
[    7.875224] bus: 'scsi': add device target0:0:0
[    7.875861] device: '0:0:0:0': device_add
[    7.876500] bus: 'scsi': add device 0:0:0:0
[    7.877068] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 wit=
h driver st
[    7.877999] bus: 'scsi': really_probe: probing driver st with device 0:0=
:0:0
[    7.878898] st: probe of 0:0:0:0 rejects match -19
[    7.879458] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 wit=
h driver osst
[    7.880565] bus: 'scsi': really_probe: probing driver osst with device 0=
:0:0:0
[    7.881437] osst: probe of 0:0:0:0 rejects match -19
[    7.882086] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 wit=
h driver sd
[    7.883050] bus: 'scsi': really_probe: probing driver sd with device 0:0=
:0:0
[    7.885732] device: '0:0:0:0': device_add
[    7.886885] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[    7.887642] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[    7.888591] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    7.891443] device: '0:0:0:0': device_add
[    7.892122] sd 0:0:0:0: [sda] Write Protect is off
[    7.892714] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    7.893395] device: 'sg0': device_add
[    7.894466] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.895260] device: '0:0:0:0': device_add
[    7.896462] driver: 'adapter0': driver_bound: bound to device 'scsi_debu=
g'
[    7.897286] bus: 'pseudo': really_probe: bound device adapter0 to driver=
 scsi_debug
[    7.899127] Rounding down aligned max_sectors from 4294967295 to 8388600
[    7.900902] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    7.901941] device: '8:0': device_add
[    7.902943] device: 'sda': device_add
[    7.903730] device: 'dummy0': device_add
[    7.905492] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[    7.906616] device: 'eql': device_add
[    7.907858] bus: 'mdio_bus': add driver Davicom DM9161E
[    7.908731] bus: 'mdio_bus': add driver Davicom DM9161A
[    7.909787] bus: 'mdio_bus': add driver Davicom DM9131
[    7.910393] bus: 'mdio_bus': add driver SMSC LAN83C185
[    7.911041] bus: 'mdio_bus': add driver SMSC LAN8187
[    7.912225] bus: 'mdio_bus': add driver SMSC LAN8700
[    7.912877] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[    7.913614] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
[    7.914279] bus: 'mdio_bus': add driver ICPlus IP175C
[    7.914995] bus: 'mdio_bus': add driver ICPlus IP1001
[    7.915645] bus: 'mdio_bus': add driver ICPlus IP101A/G
[    7.916558] bus: 'mdio_bus': add driver ET1011C
[    7.917108] bus: 'mdio_bus': add driver NatSemi DP83640
[    7.917749] bus: 'mdio_bus': add driver STe101p
[    7.918282] bus: 'mdio_bus': add driver STe100p
[    7.918885] bus: 'mdio_bus': add driver Micrel KS8737
[    7.920239]  sda: unknown partition table
[    7.922326] bus: 'mdio_bus': add driver Micrel KS8041
[    7.922993] bus: 'mdio_bus': add driver Micrel KS8051
[    7.923624] bus: 'mdio_bus': add driver Micrel KS8001 or KS8721
[    7.924609] bus: 'mdio_bus': add driver Micrel KSZ9021 Gigabit PHY
[    7.925464] tun: Universal TUN/TAP device driver, 1.6
[    7.926090] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.926850] device: 'tun': device_add
[    7.927281] arcnet loaded.
[    7.927643] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    7.928893] arcnet: raw mode (`r') encapsulation support loaded.
[    7.929611] arcnet: cap mode (`c') encapsulation support loaded.
[    7.930310] arcnet: COM90xx chipset support
[    7.936111] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.100171] tsc: Refined TSC clocksource calibration: 3300.194 MHz
[    8.240526] S3: No ARCnet cards found.
[    8.241067] arcnet: RIM I (entirely mem-mapped) support
[    8.241705] E-mail me if you actually test the RIM I driver, please!
[    8.242486] Given: node 00h, shmem 0h, irq 0
[    8.243033] No autoprobe for RIM I; you must specify the shmem and irq!
[    8.243835] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    8.245843] device: 'ipddp0': device_add
[    8.247976] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[    8.249273] vcan: Virtual CAN interface driver
[    8.249879] bus: 'pci': add driver ne2k-pci
[    8.250405] bus: 'pci': add driver amd8111e
[    8.251468] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    8.252525] bus: 'pci': add driver pcnet32
[    8.253093] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    8.253819] Copyright (c) 2007 Atheros Corporation.
[    8.254379] bus: 'pci': add driver atl2
[    8.254989] bus: 'pci': add driver b44
[    8.255571] bus: 'ssb': add driver b44
[    8.256818] bus: 'pci': add driver bnx2
[    8.257297] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.12 (June 2=
9, 2012)
[    8.258353] bus: 'pci': add driver tg3
[    8.258910] bus: 'platform': add driver calxedaxgmac
[    8.259630] bus: 'platform': add driver dnet
[    8.260339] eth%d: D-Link DE-600 pocket adapter: not at I/O 0x378.
[    8.261212] bus: 'pci': add driver S2IO
[    8.261731] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    8.262635] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    8.263443] bus: 'pci': add driver e1000
[    8.265926] bus: 'pci': driver_probe_device: matched device 0000:00:03.0=
 with driver e1000
[    8.266941] bus: 'pci': really_probe: probing driver e1000 with device 0=
000:00:03.0
[    8.269054] e1000 0000:00:03.0: enabling bus mastering
[    8.269710] e1000 0000:00:03.0: setting latency timer to 64
[    8.626885] device: 'eth0': device_add
[    8.628918] e1000 0000:00:03.0: eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:=
56
[    8.629852] e1000 0000:00:03.0: eth0: Intel(R) PRO/1000 Network Connecti=
on
[    8.630703] driver: '0000:00:03.0': driver_bound: bound to device 'e1000'
[    8.631621] bus: 'pci': really_probe: bound device 0000:00:03.0 to drive=
r e1000
[    8.632752] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[    8.633439] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    8.634164] bus: 'pci': add driver e1000e
[    8.634788] igb: Intel(R) Gigabit Ethernet Network Driver - version 4.0.=
1-k
[    8.635703] igb: Copyright (c) 2007-2012 Intel Corporation.
[    8.637499] bus: 'pci': add driver igb
[    8.638046] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.1-k
[    8.639014] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    8.639822] bus: 'pci': add driver igbvf
[    8.640499] bus: 'pci': add driver skge
[    8.641016] sky2: driver version 1.30
[    8.641495] bus: 'pci': add driver sky2
[    8.643170] bus: 'pci': add driver mlx4_core
[    8.643737] bus: 'pci': add driver fealnx
[    8.645412] bus: 'pci': add driver qla3xxx
[    8.645954] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.0.29
[    8.646952] bus: 'pci': add driver qlcnic
[    8.647573] bus: 'pci': add driver qlge
[    8.648593] QLogic/NetXen Network Driver v4.0.80
[    8.649164] bus: 'pci': add driver netxen_nic
[    8.649739] bus: 'pci': add driver 8139cp
[    8.650239] bus: 'pci': add driver 8139too
[    8.650786] bus: 'pci': add driver r8169
[    8.652306] bus: 'pci': add driver hme
[    8.652829] bus: 'pci': add driver gem
[    8.653285] bus: 'pci': add driver cassini
[    8.653819] bus: 'pci': add driver niu
[    8.654286] bus: 'pci': add driver defxx
[    8.654909] bus: 'pci': add driver skfddi
[    8.655500] PPP generic driver version 2.4.2
[    8.656987] device class 'ppp': registering
[    8.657496] device: 'ppp': device_add
[    8.658048] PPP Deflate Compression module registered
[    8.658699] NET: Registered protocol family 24
[    8.659291] cycx_drv: Cyclom 2X Support Module v0.6 (c) 1998-2003 Arnald=
o Carvalho de Melo <acme@conectiva.com.br>
[    8.660777] cyclomx: CYCLOM 2X(tm) Sync Card Driver v0.11 (c) 1998-2003 =
Arnaldo Carvalho de Melo <acme@conectiva.com.br>
[    8.662151] airo(): Probing for PCI adapters
[    8.662702] bus: 'pci': add driver airo
[    8.663243] airo(): Finished probing for PCI adapters
[    8.663873] bus: 'pci': add driver atmel
[    8.664770] Loaded prism54 driver, version 1.2
[    8.665337] bus: 'pci': add driver prism54
[    8.665886] bus: 'pci': add driver hostap_plx
[    8.666427] bus: 'usb': add driver zd1201
[    8.666949] usbcore: registered new interface driver zd1201
[    8.667640] bus: 'usb': add driver kaweth
[    8.668764] usbcore: registered new interface driver kaweth
[    8.669786] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethern=
et driver
[    8.671088] bus: 'usb': add driver pegasus
[    8.673705] usbcore: registered new interface driver pegasus
[    8.674610] bus: 'usb': add driver rtl8150
[    8.675333] usbcore: registered new interface driver rtl8150
[    8.676496] hv_vmbus: registering driver hv_netvsc
[    8.677215] Fusion MPT base driver 3.04.20
[    8.677713] Copyright (c) 1999-2008 LSI Corporation
[    8.678299] Fusion MPT SPI Host driver 3.04.20
[    8.678851] bus: 'pci': add driver mptspi
[    8.679417] Fusion MPT SAS Host driver 3.04.20
[    8.679949] bus: 'pci': add driver mptsas
[    8.680607] Fusion MPT misc device (ioctl) driver 3.04.20
[    8.681255] device: 'mptctl': device_add
[    8.681875] mptctl: Registered with Fusion MPT base driver
[    8.682807] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    8.683606] bus: 'pci': add driver nosy
[    8.684501] device class 'uio': registering
[    8.685267] bus: 'platform': add driver uio_pdrv
[    8.686119] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[    8.687197] bus: 'pci': add driver uio_pci_generic
[    8.688309] bus: 'platform': add driver gpio-vbus
[    8.689198] bus: 'platform': remove driver gpio-vbus
[    8.690124] driver: 'gpio-vbus': driver_release
[    8.690934] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.692345] bus: 'platform': add driver ehci-platform
[    8.693229] bus: 'pci': add driver ehci_hcd
[    8.694917] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    8.695733] bus: 'pci': add driver ohci_hcd
[    8.697172] bus: 'platform': add driver sm501-usb
[    8.697765] bus: 'platform': add driver sl811-hcd
[    8.698493] bus: 'platform': add driver c67x00
[    8.699284] bus: 'usb': add driver cdc_acm
[    8.700723] usbcore: registered new interface driver cdc_acm
[    8.701742] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    8.703174] bus: 'usb': add driver usblp
[    8.703934] usbcore: registered new interface driver usblp
[    8.705903] bus: 'usb': add driver uas
[    8.706610] usbcore: registered new interface driver uas
[    8.707602] bus: 'usb': add driver libusual
[    8.708739] usbcore: registered new interface driver libusual
[    8.709788] bus: 'usb': add driver mdc800
[    8.710518] usbcore: registered new interface driver mdc800
[    8.711493] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    8.712825] bus: 'usb': add driver microtekX6
[    8.714339] usbcore: registered new interface driver microtekX6
[    8.715156] bus: 'usb-serial': registered
[    8.715679] bus: 'usb': add driver usbserial
[    8.716573] usbcore: registered new interface driver usbserial
[    8.717337] usbserial: USB Serial Driver core
[    8.717881] bus: 'usb': add driver aircable
[    8.718444] usbcore: registered new interface driver aircable
[    8.719241] bus: 'usb-serial': add driver aircable
[    8.719928] USB Serial support registered for aircable
[    8.722209] bus: 'usb': add driver belkin_sa
[    8.722778] usbcore: registered new interface driver belkin_sa
[    8.723442] bus: 'usb-serial': add driver belkin
[    8.724244] USB Serial support registered for Belkin / Peracom / GoHubs =
USB Serial Adapter
[    8.725295] bus: 'usb': add driver ch341
[    8.725851] usbcore: registered new interface driver ch341
[    8.726584] bus: 'usb-serial': add driver ch341-uart
[    8.728595] USB Serial support registered for ch341-uart
[    8.729267] bus: 'usb': add driver cp210x
[    8.730014] usbcore: registered new interface driver cp210x
[    8.730746] bus: 'usb-serial': add driver cp210x
[    8.731379] USB Serial support registered for cp210x
[    8.732314] bus: 'usb': add driver digi_acceleport
[    8.732902] usbcore: registered new interface driver digi_acceleport
[    8.733684] bus: 'usb-serial': add driver digi_2
[    8.734476] USB Serial support registered for Digi 2 port USB adapter
[    8.735633] bus: 'usb-serial': add driver digi_4
[    8.737155] USB Serial support registered for Digi 4 port USB adapter
[    8.738324] bus: 'usb': add driver io_edgeport
[    8.739147] usbcore: registered new interface driver io_edgeport
[    8.740906] bus: 'usb-serial': add driver edgeport_2
[    8.741595] USB Serial support registered for Edgeport 2 port adapter
[    8.742432] bus: 'usb-serial': add driver edgeport_4
[    8.743303] USB Serial support registered for Edgeport 4 port adapter
[    8.744370] bus: 'usb-serial': add driver edgeport_8
[    8.745070] USB Serial support registered for Edgeport 8 port adapter
[    8.745990] bus: 'usb-serial': add driver epic
[    8.746817] USB Serial support registered for EPiC device
[    8.749895] bus: 'usb': add driver io_ti
[    8.750642] usbcore: registered new interface driver io_ti
[    8.751644] bus: 'usb-serial': add driver edgeport_ti_1
[    8.752804] USB Serial support registered for Edgeport TI 1 port adapter
[    8.753987] bus: 'usb-serial': add driver edgeport_ti_2
[    8.754946] USB Serial support registered for Edgeport TI 2 port adapter
[    8.756379] bus: 'usb': add driver empeg
[    8.757120] usbcore: registered new interface driver empeg
[    8.758117] bus: 'usb-serial': add driver empeg
[    8.758762] USB Serial support registered for empeg
[    8.759397] bus: 'usb': add driver f81232
[    8.759963] usbcore: registered new interface driver f81232
[    8.761671] bus: 'usb-serial': add driver f81232
[    8.762312] USB Serial support registered for f81232
[    8.762932] bus: 'usb': add driver ftdi_sio
[    8.763426] usbcore: registered new interface driver ftdi_sio
[    8.764326] bus: 'usb-serial': add driver ftdi_sio
[    8.765003] USB Serial support registered for FTDI USB Serial Device
[    8.765765] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
[    8.766510] bus: 'usb': add driver hp4x
[    8.768249] usbcore: registered new interface driver hp4x
[    8.768914] bus: 'usb-serial': add driver hp4X
[    8.769433] USB Serial support registered for hp4X
[    8.770071] bus: 'usb': add driver ipaq
[    8.770615] usbcore: registered new interface driver ipaq
[    8.771242] bus: 'usb-serial': add driver ipaq
[    8.771814] USB Serial support registered for PocketPC PDA
[    8.772997] bus: 'usb': add driver ipw
[    8.773438] usbcore: registered new interface driver ipw
[    8.774188] bus: 'usb-serial': add driver ipw
[    8.774818] USB Serial support registered for IPWireless converter
[    8.775529] bus: 'usb': add driver keyspan
[    8.776579] usbcore: registered new interface driver keyspan
[    8.777226] bus: 'usb-serial': add driver keyspan_no_firm
[    8.777909] USB Serial support registered for Keyspan - (without firmwar=
e)
[    8.778783] bus: 'usb-serial': add driver keyspan_1
[    8.779331] USB Serial support registered for Keyspan 1 port adapter
[    8.780625] bus: 'usb-serial': add driver keyspan_2
[    8.781204] USB Serial support registered for Keyspan 2 port adapter
[    8.781986] bus: 'usb-serial': add driver keyspan_4
[    8.782650] USB Serial support registered for Keyspan 4 port adapter
[    8.784478] bus: 'usb': add driver keyspan_pda
[    8.785131] usbcore: registered new interface driver keyspan_pda
[    8.785872] bus: 'usb-serial': add driver keyspan_pda
[    8.786521] USB Serial support registered for Keyspan PDA
[    8.787187] bus: 'usb-serial': add driver keyspan_pda_pre
[    8.787861] USB Serial support registered for Keyspan PDA - (prerenumera=
tion)
[    8.789088] bus: 'usb': add driver mos7720
[    8.789614] usbcore: registered new interface driver mos7720
[    8.790346] bus: 'usb-serial': add driver moschip7720
[    8.790982] USB Serial support registered for Moschip 2 port adapter
[    8.791751] bus: 'usb': add driver opticon
[    8.793056] usbcore: registered new interface driver opticon
[    8.793758] bus: 'usb-serial': add driver opticon
[    8.794383] USB Serial support registered for opticon
[    8.795080] bus: 'usb': add driver pl2303
[    8.795590] usbcore: registered new interface driver pl2303
[    8.796340] bus: 'usb-serial': add driver pl2303
[    8.796927] USB Serial support registered for pl2303
[    8.797493] bus: 'usb': add driver qcserial
[    8.799031] usbcore: registered new interface driver qcserial
[    8.799753] bus: 'usb-serial': add driver qcserial
[    8.800447] USB Serial support registered for Qualcomm USB modem
[    8.801186] safe_serial: v0.1:USB Safe Encapsulated Serial
[    8.801867] bus: 'usb': add driver safe_serial
[    8.802461] usbcore: registered new interface driver safe_serial
[    8.803197] bus: 'usb-serial': add driver safe_serial
[    8.803839] USB Serial support registered for safe_serial
[    8.805332] bus: 'usb': add driver spcp8x5
[    8.805860] usbcore: registered new interface driver spcp8x5
[    8.806638] bus: 'usb-serial': add driver SPCP8x5
[    8.807190] USB Serial support registered for SPCP8x5
[    8.807814] bus: 'usb': add driver vivopay_serial
[    8.809122] usbcore: registered new interface driver vivopay_serial
[    8.809888] bus: 'usb-serial': add driver vivopay-serial
[    8.810641] USB Serial support registered for vivopay-serial
[    8.811299] bus: 'usb': add driver zio
[    8.811778] usbcore: registered new interface driver zio
[    8.812593] bus: 'usb-serial': add driver zio
[    8.813118] USB Serial support registered for zio
[    8.814791] bus: 'usb': add driver appledisplay
[    8.815400] usbcore: registered new interface driver appledisplay
[    8.816288] bus: 'usb': add driver cytherm
[    8.816888] usbcore: registered new interface driver cytherm
[    8.817569] bus: 'usb': add driver iowarrior
[    8.818151] usbcore: registered new interface driver iowarrior
[    8.818881] bus: 'usb': add driver isight_firmware
[    8.819428] usbcore: registered new interface driver isight_firmware
[    8.820384] bus: 'usb': add driver legousbtower
[    8.820954] usbcore: registered new interface driver legousbtower
[    8.821674] bus: 'usb': add driver rio500
[    8.822248] usbcore: registered new interface driver rio500
[    8.822935] bus: 'usb': add driver usbtest
[    8.823414] usbcore: registered new interface driver usbtest
[    8.824347] bus: 'usb': add driver uss720
[    8.824939] usbcore: registered new interface driver uss720
[    8.825631] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    8.826793] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    8.827666] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    8.829438] uss720: If you just want to connect to a printer, use usblp =
instead
[    8.830409] bus: 'usb': add driver usbsevseg
[    8.830958] usbcore: registered new interface driver usbsevseg
[    8.831658] bus: 'usb': add driver yurex
[    8.832299] usbcore: registered new interface driver yurex
[    8.832978] bus: 'platform': add driver dummy_hcd
[    8.834932] bus: 'platform': add driver dummy_udc
[    8.835498] Registering platform device 'dummy_hcd'. Parent at platform
[    8.836522] device: 'dummy_hcd': device_add
[    8.837051] bus: 'platform': add device dummy_hcd
[    8.837655] bus: 'platform': driver_probe_device: matched device dummy_h=
cd with driver dummy_hcd
[    8.838930] bus: 'platform': really_probe: probing driver dummy_hcd with=
 device dummy_hcd
[    8.839969] dummy_hcd dummy_hcd: USB Host+Gadget Emulator, driver 02 May=
 2005
[    8.842135] dummy_hcd dummy_hcd: Dummy host controller
[    8.843027] dummy_hcd dummy_hcd: new USB bus registered, assigned bus nu=
mber 1
[    8.844609] device: 'usb1': device_add
[    8.846208] bus: 'usb': add device usb1
[    8.846722] bus: 'usb': driver_probe_device: matched device usb1 with dr=
iver usb
[    8.847592] bus: 'usb': really_probe: probing driver usb with device usb1
[    8.849108] device: '1-0:1.0': device_add
[    8.849637] bus: 'usb': add device 1-0:1.0
[    8.850141] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with=
 driver hub
[    8.851049] bus: 'usb': really_probe: probing driver hub with device 1-0=
:1.0
[    8.851901] hub 1-0:1.0: USB hub found
[    8.852605] hub 1-0:1.0: 1 port detected
[    8.853124] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[    8.853985] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[    8.854906] device: 'ep_81': device_add
[    8.855380] driver: 'usb1': driver_bound: bound to device 'usb'
[    8.856332] bus: 'usb': really_probe: bound device usb1 to driver usb
[    8.858037] device: 'ep_00': device_add
[    8.858512] driver: 'dummy_hcd': driver_bound: bound to device 'dummy_hc=
d'
[    8.859368] bus: 'platform': really_probe: bound device dummy_hcd to dri=
ver dummy_hcd
[    8.860970] Registering platform device 'dummy_udc'. Parent at platform
[    8.861896] device: 'dummy_udc': device_add
[    8.862622] bus: 'platform': add device dummy_udc
[    8.863424] bus: 'platform': driver_probe_device: matched device dummy_u=
dc with driver dummy_udc
[    8.865303] bus: 'platform': really_probe: probing driver dummy_udc with=
 device dummy_udc
[    8.866701] device: 'gadget': device_add
[    8.867509] device: 'dummy_udc': device_add
[    8.870408] driver: 'dummy_udc': driver_bound: bound to device 'dummy_ud=
c'
[    8.871564] bus: 'platform': really_probe: bound device dummy_udc to dri=
ver dummy_udc
[    8.873040] bus: 'pci': add driver net2272
[    8.873573] bus: 'platform': add driver net2272
[    8.874270] bus: 'platform': add driver m66592_udc
[    8.874940] bus: 'platform': remove driver m66592_udc
[    8.875560] driver: 'm66592_udc': driver_release
[    8.876624] bus: 'platform': add driver mv-udc
[    8.877171] device: 'ttyGS0': device_add
[    8.877761]  gadget: Gadget Serial v2.4
[    8.878295]  gadget: g_serial ready
[    8.878737] bus: 'pnp': add driver i8042 kbd
[    8.879241] bus: 'pnp': driver_probe_device: matched device 00:02 with d=
river i8042 kbd
[    8.880506] bus: 'pnp': really_probe: probing driver i8042 kbd with devi=
ce 00:02
[    8.881386] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    8.882293] bus: 'pnp': really_probe: bound device 00:02 to driver i8042=
 kbd
[    8.883128] bus: 'pnp': add driver i8042 aux
[    8.885068] bus: 'pnp': driver_probe_device: matched device 00:03 with d=
river i8042 aux
[    8.886215] bus: 'pnp': really_probe: probing driver i8042 aux with devi=
ce 00:03
[    8.887432] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    8.888809] bus: 'pnp': really_probe: bound device 00:03 to driver i8042=
 aux
[    8.890040] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.891442] Registering platform device 'i8042'. Parent at platform
[    8.892695] device: 'i8042': device_add
[    8.893149] bus: 'platform': add device i8042
[    8.893765] bus: 'platform': add driver i8042
[    8.894567] bus: 'platform': driver_probe_device: matched device i8042 w=
ith driver i8042
[    8.895679] bus: 'platform': really_probe: probing driver i8042 with dev=
ice i8042
[    8.898666] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.899300] device: 'serio0': device_add
[    8.899802] bus: 'serio': add device serio0
[    8.900441] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.901065] device: 'serio1': device_add
[    8.902554] bus: 'serio': add device serio1
[    8.903090] driver: 'i8042': driver_bound: bound to device 'i8042'
[    8.903826] bus: 'platform': really_probe: bound device i8042 to driver =
i8042
[    8.904902] parkbd: no such parport
[    8.905338] bus: 'platform': add driver altera_ps2
[    8.906121] bus: 'pci': add driver Emu10k1_gameport
[    8.907037] bus: 'pci': add driver FM801_gameport
[    8.907849] bus: 'pnp': add driver ns558
[    8.979098] device: 'mice': device_add
[    8.979815] mousedev: PS/2 mouse device common for all mice
[    8.980954] bus: 'serio': add driver atkbd
[    8.981675] bus: 'serio': driver_probe_device: matched device serio0 wit=
h driver atkbd
[    8.982914] bus: 'serio': really_probe: probing driver atkbd with device=
 serio0
[    8.985975] device: 'input0': device_add
[    8.986781] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    8.988302] bus: 'platform': add driver gpio-keys-polled
[    8.989188] bus: 'i2c': add driver max7359
[    8.989890] i2c-core: driver [max7359] registered
[    8.990651] bus: 'i2c': add driver mcs_touchkey
[    8.991359] i2c-core: driver [mcs_touchkey] registered
[    8.992392] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    8.993397] bus: 'serio': really_probe: bound device serio0 to driver at=
kbd
[    8.994502] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[    8.995837] bus: 'serio': really_probe: probing driver atkbd with device=
 serio1
[    8.997349] bus: 'serio': add driver newtonkbd
[    8.999128] bus: 'platform': add driver omap4-keypad
[    8.999941] bus: 'platform': add driver opencores-kbd
[    9.000912] bus: 'i2c': add driver qt1070
[    9.001577] i2c-core: driver [qt1070] registered
[    9.002291] bus: 'platform': add driver stmpe-keypad
[    9.003099] bus: 'serio': add driver stowaway
[    9.003826] bus: 'serio': add driver xtkbd
[    9.004845] atkbd: probe of serio1 rejects match -19
[    9.005780] bus: 'i2c': add driver as5011
[    9.006423] i2c-core: driver [as5011] registered
[    9.007201] bus: 'gameport': add driver cobra
[    9.008161] bus: 'gameport': add driver gf2k
[    9.009884] bus: 'gameport': add driver joydump
[    9.010667] bus: 'gameport': add driver sidewinder
[    9.011458] bus: 'serio': add driver spaceball
[    9.013763] bus: 'serio': add driver spaceorb
[    9.014531] bus: 'serio': add driver stinger
[    9.015333] bus: 'serio': add driver warrior
[    9.016227] bus: 'serio': add driver zhenhua
[    9.017016] bus: 'i2c': add driver auo_pixcir_ts
[    9.017792] i2c-core: driver [auo_pixcir_ts] registered
[    9.018658] bus: 'i2c': add driver cy8ctmg110
[    9.020560] i2c-core: driver [cy8ctmg110] registered
[    9.021359] bus: 'platform': add driver da9052-tsi
[    9.022174] bus: 'serio': add driver dynapro
[    9.023451] bus: 'i2c': add driver egalax_ts
[    9.024312] i2c-core: driver [egalax_ts] registered
[    9.025149] bus: 'i2c': add driver ili210x_i2c
[    9.025904] i2c-core: driver [ili210x_i2c] registered
[    9.026767] bus: 'i2c': add driver max11801_ts
[    9.027481] i2c-core: driver [max11801_ts] registered
[    9.028585] mk712: device not present
[    9.029182] bus: 'usb': add driver usbtouchscreen
[    9.029952] usbcore: registered new interface driver usbtouchscreen
[    9.030945] bus: 'i2c': add driver pixcir_ts
[    9.031655] i2c-core: driver [pixcir_ts] registered
[    9.033220] bus: 'i2c': add driver st1232-ts
[    9.033951] i2c-core: driver [st1232-ts] registered
[    9.034765] bus: 'i2c': add driver tsc2007
[    9.035420] i2c-core: driver [tsc2007] registered
[    9.036594] bus: 'serio': add driver w8001
[    9.037369] bus: 'platform': add driver 88pm80x-onkey
[    9.039392] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    9.041624] bus: 'acpi': add driver Atlas ACPI
[    9.042406] bus: 'i2c': add driver bma150
[    9.043165] i2c-core: driver [bma150] registered
[    9.043931] bus: 'i2c': add driver gp2ap002a00f
[    9.044875] i2c-core: driver [gp2ap002a00f] registered
[    9.045666] bus: 'platform': add driver gpio-tilt-polled
[    9.046577] bus: 'usb': add driver keyspan_remote
[    9.047353] usbcore: registered new interface driver keyspan_remote
[    9.048659] bus: 'platform': add driver max8925-onkey
[    9.049523] bus: 'i2c': add driver mpu3050
[    9.050271] i2c-core: driver [mpu3050] registered
[    9.051081] bus: 'i2c': add driver pcf8574_keypad
[    9.051922] i2c-core: driver [pcf8574_keypad] registered
[    9.053191] bus: 'platform': add driver twl4030-vibra
[    9.054037] device: 'uinput': device_add
[    9.055764] wistron_btns: System unknown
[    9.057290] bus: 'platform': add driver ab3100-rtc
[    9.058185] bus: 'platform': remove driver ab3100-rtc
[    9.059076] driver: 'ab3100-rtc': driver_release
[    9.059886] bus: 'i2c': add driver bq32k
[    9.061724] i2c-core: driver [bq32k] registered
[    9.062450] bus: 'pnp': add driver rtc_cmos
[    9.063164] bus: 'pnp': driver_probe_device: matched device 00:01 with d=
river rtc_cmos
[    9.064694] bus: 'pnp': really_probe: probing driver rtc_cmos with devic=
e 00:01
[    9.065989] rtc_cmos 00:01: RTC can wake from S4
[    9.087127] device: 'rtc0': device_add
[    9.087879] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    9.089278] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    9.090400] driver: '00:01': driver_bound: bound to device 'rtc_cmos'
[    9.091512] bus: 'pnp': really_probe: bound device 00:01 to driver rtc_c=
mos
[    9.094427] bus: 'platform': add driver rtc-ds1286
[    9.095210] bus: 'i2c': add driver rtc-ds1374
[    9.095895] i2c-core: driver [rtc-ds1374] registered
[    9.097364] bus: 'platform': add driver ds1511
[    9.098164] bus: 'platform': add driver rtc-ds1553
[    9.099023] bus: 'i2c': add driver rtc-ds1672
[    9.099819] i2c-core: driver [rtc-ds1672] registered
[    9.100927] bus: 'platform': add driver rtc-ds1742
[    9.101702] bus: 'i2c': add driver rtc-ds3232
[    9.102419] i2c-core: driver [rtc-ds3232] registered
[    9.103313] bus: 'i2c': add driver rtc-isl1208
[    9.104618] i2c-core: driver [rtc-isl1208] registered
[    9.105501] bus: 'i2c': add driver rtc-isl12022
[    9.106269] i2c-core: driver [rtc-isl12022] registered
[    9.107102] bus: 'platform': add driver rtc-m48t59
[    9.107885] bus: 'platform': add driver rtc-m48t86
[    9.108949] bus: 'i2c': add driver rtc-max6900
[    9.110612] i2c-core: driver [rtc-max6900] registered
[    9.111432] bus: 'platform': add driver pcf50633-rtc
[    9.112468] bus: 'i2c': add driver rtc-rs5c372
[    9.113222] i2c-core: driver [rtc-rs5c372] registered
[    9.114033] bus: 'i2c': add driver rtc-rv3029c2
[    9.114794] i2c-core: driver [rtc-rv3029c2] registered
[    9.115682] bus: 'i2c': add driver rtc-rx8581
[    9.116617] i2c-core: driver [rtc-rx8581] registered
[    9.117422] bus: 'i2c': add driver rtc-s35390a
[    9.118182] i2c-core: driver [rtc-s35390a] registered
[    9.119089] bus: 'platform': add driver stk17ta8
[    9.119922] bus: 'platform': add driver rtc-test
[    9.121499] Registering platform device 'rtc-test.0'. Parent at platform
[    9.122695] device: 'rtc-test.0': device_add
[    9.123400] bus: 'platform': add device rtc-test.0
[    9.125974] bus: 'platform': driver_probe_device: matched device rtc-tes=
t.0 with driver rtc-test
[    9.127491] bus: 'platform': really_probe: probing driver rtc-test with =
device rtc-test.0
[    9.129684] device: 'rtc1': device_add
[    9.131401] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    9.133716] driver: 'rtc-test.0': driver_bound: bound to device 'rtc-tes=
t'
[    9.134897] bus: 'platform': really_probe: bound device rtc-test.0 to dr=
iver rtc-test
[    9.136271] Registering platform device 'rtc-test.1'. Parent at platform
[    9.137447] device: 'rtc-test.1': device_add
[    9.138207] bus: 'platform': add device rtc-test.1
[    9.139120] bus: 'platform': driver_probe_device: matched device rtc-tes=
t.1 with driver rtc-test
[    9.140926] bus: 'platform': really_probe: probing driver rtc-test with =
device rtc-test.1
[    9.142237] device: 'rtc2': device_add
[    9.142889] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    9.143879] driver: 'rtc-test.1': driver_bound: bound to device 'rtc-tes=
t'
[    9.145229] bus: 'platform': really_probe: bound device rtc-test.1 to dr=
iver rtc-test
[    9.146497] bus: 'platform': add driver v3020
[    9.147302] bus: 'i2c': add driver rtc-x1205
[    9.148272] i2c-core: driver [rtc-x1205] registered
[    9.149134] bus: 'i2c': add driver smbus_alert
[    9.149945] i2c-core: driver [smbus_alert] registered
[    9.150796] bus: 'pci': add driver amd756_smbus
[    9.151580] bus: 'pci': add driver sis5595_smbus
[    9.153511] bus: 'pci': add driver sis630_smbus
[    9.154335] bus: 'pci': add driver vt586b_smbus
[    9.155135] bus: 'pci': add driver i2c-designware-pci
[    9.155982] bus: 'pci': add driver i2c_eg20t
[    9.157057] bus: 'platform': add driver i2c-pca-platform
[    9.157943] bus: 'platform': add driver simtec-i2c
[    9.158741] bus: 'platform': add driver xiic-i2c
[    9.159479] bus: 'usb': add driver i2c-diolan-u2c
[    9.160480] usbcore: registered new interface driver i2c-diolan-u2c
[    9.161501] i2c-parport: adapter type unspecified
[    9.162268] bus: 'serio': add driver taos-evm
[    9.163030] bus: 'i2c': add driver tuner
[    9.163684] i2c-core: driver [tuner] registered
[    9.164580] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    9.166564] bus: 'i2c': add driver saa7115
[    9.167200] i2c-core: driver [saa7115] registered
[    9.167939] bus: 'i2c': add driver adv7180
[    9.169295] i2c-core: driver [adv7180] registered
[    9.170122] bus: 'i2c': add driver ov7670
[    9.170847] i2c-core: driver [ov7670] registered
[    9.171679] bus: 'i2c': add driver imx074
[    9.172598] i2c-core: driver [imx074] registered
[    9.173412] bus: 'i2c': add driver mt9m111
[    9.174137] i2c-core: driver [mt9m111] registered
[    9.174936] bus: 'i2c': add driver ov9740
[    9.175559] i2c-core: driver [ov9740] registered
[    9.176688] bus: 'i2c': add driver rj54n1cb0c
[    9.177470] i2c-core: driver [rj54n1cb0c] registered
[    9.178367] bus: 'usb': add driver usbvision
[    9.179163] usbcore: registered new interface driver usbvision
[    9.180654] USBVision USB Video Device Driver for Linux : 0.9.11
[    9.181698] cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.1
[    9.182764] bus: 'usb': add driver cpia2
[    9.183433] usbcore: registered new interface driver cpia2
[    9.185148] bus: 'platform': add driver timb-video
[    9.185946] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    9.186951] bus: 'pci': add driver cafe1000-ccic
[    9.187791] bus: 'usb': add driver zr364xx
[    9.189856] usbcore: registered new interface driver zr364xx
[    9.190854] bus: 'usb': add driver stkwebcam
[    9.192754] usbcore: registered new interface driver stkwebcam
[    9.193686] gspca_main: v2.14.0 registered
[    9.194318] bus: 'usb': add driver benq
[    9.194968] usbcore: registered new interface driver benq
[    9.195814] bus: 'usb': add driver conex
[    9.196617] usbcore: registered new interface driver conex
[    9.197576] bus: 'usb': add driver cpia1
[    9.198256] usbcore: registered new interface driver cpia1
[    9.199155] bus: 'usb': add driver finepix
[    9.199895] usbcore: registered new interface driver finepix
[    9.201077] bus: 'usb': add driver jeilinj
[    9.201782] usbcore: registered new interface driver jeilinj
[    9.202717] bus: 'usb': add driver kinect
[    9.203351] usbcore: registered new interface driver kinect
[    9.205304] bus: 'usb': add driver konica
[    9.206013] usbcore: registered new interface driver konica
[    9.206964] bus: 'usb': add driver mr97310a
[    9.207716] usbcore: registered new interface driver mr97310a
[    9.208880] bus: 'usb': add driver pac7311
[    9.209625] usbcore: registered new interface driver pac7311
[    9.210574] bus: 'usb': add driver se401
[    9.211196] usbcore: registered new interface driver se401
[    9.212445] bus: 'usb': add driver sn9c2028
[    9.213149] usbcore: registered new interface driver sn9c2028
[    9.214061] bus: 'usb': add driver sonixj
[    9.215727] usbcore: registered new interface driver sonixj
[    9.216976] bus: 'usb': add driver spca500
[    9.217692] usbcore: registered new interface driver spca500
[    9.218648] bus: 'usb': add driver spca506
[    9.219355] usbcore: registered new interface driver spca506
[    9.220571] bus: 'usb': add driver spca508
[    9.221293] usbcore: registered new interface driver spca508
[    9.222242] bus: 'usb': add driver spca561
[    9.222982] usbcore: registered new interface driver spca561
[    9.223922] bus: 'usb': add driver sq905
[    9.224763] usbcore: registered new interface driver sq905
[    9.225596] bus: 'usb': add driver sq905c
[    9.226194] usbcore: registered new interface driver sq905c
[    9.227069] bus: 'usb': add driver sq930x
[    9.227731] usbcore: registered new interface driver sq930x
[    9.230070] bus: 'usb': add driver stk014
[    9.230749] usbcore: registered new interface driver stk014
[    9.231639] bus: 'usb': add driver stv0680
[    9.232464] usbcore: registered new interface driver stv0680
[    9.233381] bus: 'usb': add driver t613
[    9.234022] usbcore: registered new interface driver t613
[    9.234918] bus: 'usb': add driver gspca_topro
[    9.235667] usbcore: registered new interface driver gspca_topro
[    9.237726] bus: 'usb': add driver vc032x
[    9.239449] usbcore: registered new interface driver vc032x
[    9.240595] bus: 'usb': add driver vicam
[    9.241279] usbcore: registered new interface driver vicam
[    9.242233] bus: 'usb': add driver xirlink-cit
[    9.243023] usbcore: registered new interface driver xirlink-cit
[    9.244245] bus: 'usb': add driver gspca_zc3xx
[    9.245011] usbcore: registered new interface driver gspca_zc3xx
[    9.245919] bus: 'usb': add driver gspca_gl860
[    9.246617] usbcore: registered new interface driver gspca_gl860
[    9.247640] bus: 'platform': add driver soc-camera-pdrv
[    9.248812] bus: 'platform': add driver soc_camera_platform
[    9.249809] bus: 'platform': add driver pps-gpio
[    9.250644] Driver for 1-wire Dallas network protocol.
[    9.251507] bus: 'w1': registered
[    9.252294] bus: 'w1': add driver w1_master_driver
[    9.253159] bus: 'w1': add driver w1_slave_driver
[    9.254013] bus: 'pci': add driver matrox_w1
[    9.255618] bus: 'usb': add driver DS9490R
[    9.257115] usbcore: registered new interface driver DS9490R
[    9.258055] bus: 'i2c': add driver ds2482
[    9.258720] i2c-core: driver [ds2482] registered
[    9.259435] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    9.260594] bus: 'platform': add driver ds1wm
[    9.261352] bus: 'platform': add driver pda-power
[    9.262146] device: 'test_ac': device_add
[    9.262923] device: 'test_battery': device_add
[    9.265670] device: 'thermal_zone0': device_add
[    9.267100] device: 'test_usb': device_add
[    9.268165] bus: 'platform': add driver ds2780-battery
[    9.269041] bus: 'platform': add driver ds2781-battery
[    9.269931] bus: 'i2c': add driver sbs-battery
[    9.270721] i2c-core: driver [sbs-battery] registered
[    9.271565] bus: 'i2c': add driver max17040
[    9.272504] i2c-core: driver [max17040] registered
[    9.273325] bus: 'i2c': add driver max17042
[    9.274071] i2c-core: driver [max17042] registered
[    9.274897] bus: 'platform': add driver pcf50633-mbc
[    9.275668] bus: 'platform': add driver isp1704_charger
[    9.276846] bus: 'platform': add driver twl4030_bci
[    9.277729] bus: 'platform': remove driver twl4030_bci
[    9.278633] driver: 'twl4030_bci': driver_release
[    9.279429] bus: 'platform': add driver gpio-charger
[    9.280615] bus: 'pci': add driver pcwd_pci
[    9.282232] bus: 'pci': add driver wdt_pci
[    9.282977] bus: 'platform': add driver twl4030_wdt
[    9.283771] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    9.285910] bus: 'platform': add driver advantechwdt
[    9.286777] Registering platform device 'advantechwdt'. Parent at platfo=
rm
[    9.287963] device: 'advantechwdt': device_add
[    9.288930] bus: 'platform': add device advantechwdt
[    9.289838] bus: 'platform': driver_probe_device: matched device advante=
chwdt with driver advantechwdt
[    9.291294] bus: 'platform': really_probe: probing driver advantechwdt w=
ith device advantechwdt
[    9.292925] device: 'watchdog': device_add
[    9.293643] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    9.294633] driver: 'advantechwdt': driver_bound: bound to device 'advan=
techwdt'
[    9.295827] bus: 'platform': really_probe: bound device advantechwdt to =
driver advantechwdt
[    9.298241] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    9.299206] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    9.300469] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[    9.301633] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    9.302847] bus: 'platform': add driver ib700wdt
[    9.303755] Registering platform device 'ib700wdt'. Parent at platform
[    9.305117] device: 'ib700wdt': device_add
[    9.305780] bus: 'platform': add device ib700wdt
[    9.306607] bus: 'platform': driver_probe_device: matched device ib700wd=
t with driver ib700wdt
[    9.309324] bus: 'platform': really_probe: probing driver ib700wdt with =
device ib700wdt
[    9.311190] ib700wdt: START method I/O 443 is not available
[    9.312337] ib700wdt: probe of ib700wdt failed with error -5
[    9.313251] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    9.314494] wafer5823wdt: I/O address 0x0443 already in use
[    9.315492] pc87413_wdt: Version 1.1 at io 0x2E
[    9.316476] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    9.317589] bus: 'platform': add driver rdc321x-wdt
[    9.318438] sbc60xxwdt: I/O address 0x0443 already in use
[    9.319385] cpu5wdt: misc_register failed
[    9.320799] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    9.323182] smsc37b787_wdt: Unable to register miscdev on minor 130
[    9.324503] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[    9.325999] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[    9.327239] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    9.329343] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    9.330304] machzwd: no ZF-Logic found
[    9.330927] bus: 'platform': add driver da9052-watchdog
[    9.332152] device: '1-1': device_add
[    9.333918] bus: 'usb': add device 1-1
[    9.334570] bus: 'usb': driver_probe_device: matched device 1-1 with dri=
ver usb
[    9.335763] bus: 'usb': really_probe: probing driver usb with device 1-1
[    9.337090] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/none/1.1.2.2
[    9.338281] bus: 'pci': add driver t1pci
[    9.339024] t1pci: revision 1.1.2.2
[    9.339639] b1: revision 1.1.2.2
[    9.340301]  gadget: high-speed config #2: CDC ACM config
[    9.342254] b1dma: revision 1.1.2.3
[    9.342864] bus: 'pci': add driver c4
[    9.343492] c4: revision 1.1.2.2
[    9.344190] device: '1-1:2.0': device_add
[    9.344930] bus: 'usb': add device 1-1:2.0
[    9.345694] isdnloop-ISDN-driver Rev 1.11.6.7=20
[    9.347484] isdnloop: (loop0) virtual card added
[    9.348444] bus: 'usb': driver_probe_device: matched device 1-1:2.0 with=
 driver cdc_acm
[    9.349773] bus: 'usb': really_probe: probing driver cdc_acm with device=
 1-1:2.0
[    9.350967] cdc_acm 1-1:2.0: This device cannot do calls on its own. It =
is not a modem.
[    9.353255] cdc_acm 1-1:2.0: ttyACM0: USB ACM device
[    9.354137] BUG: unable to handle kernel paging request at 0ffff163
[    9.355214] IP: [<0ffff163>] 0xffff162
[    9.355869] *pde =3D 00000000=20
[    9.356308] Oops: 0000 [#1] PREEMPT=20
[    9.356308] Pid: 1, comm: swapper Not tainted 3.6.0-rc1-00061-g7bf79d8 #=
10 Bochs Bochs
[    9.356308] EIP: 0060:[<0ffff163>] EFLAGS: 00010246 CPU: 0
[    9.356308] EIP is at 0xffff163
[    9.356308] EAX: 00000000 EBX: 4d812f18 ECX: 4d80d410 EDX: 00000000
[    9.356308] ESI: 00000000 EDI: 4d813ef8 EBP: 0fffe163 ESP: 4d810008
[    9.356308]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    9.356308] CR0: 8005003b CR2: 0ffff163 CR3: 01d03000 CR4: 00000690
[    9.356308] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    9.356308] DR6: ffff0ff0 DR7: 00000400
[    9.356308] Process swapper (pid: 1, ti=3D4d80e000 task=3D4d80d410 task.=
ti=3D4d816000)
[    9.356308] Stack:
[    9.356308]  00000000 00000000 fed00173 00000000 07b57163 07b58163 07b59=
163 07b5a163
[    9.356308]  07b5b163 07b5c163 07b5d163 07b5e163 07b5f163 07b60163 07b61=
163 00000000
[    9.356308]  07b63163 07b66163 07b67163 07b68163 07b69163 07b6a163 07b6b=
163 07b6c163
[    9.356308] Call Trace:
[    9.356308]  [<414d5043>] ? igbvf_get_coalesce+0x15/0x23
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  [<414b4e4c>] ? e1000_setup_copper_link_80003es2lan+0x111/0x=
31d
[    9.356308]  [<41535244>] ? niu_set_nfc+0xe4/0x6fd
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  [<4154535f>] ? rmt+0x357/0x604
[    9.356308]  <IRQ>=20
[    9.356308] BUG: unable to handle kernel paging request at 07b61163
[    9.356308] IP: [<41003cd8>] print_context_stack+0x75/0x94
[    9.356308] *pde =3D 00000000=20
[    9.356308] Oops: 0000 [#2] PREEMPT=20
[    9.356308] Pid: 1, comm: swapper Not tainted 3.6.0-rc1-00061-g7bf79d8 #=
10 Bochs Bochs
[    9.356308] EIP: 0060:[<41003cd8>] EFLAGS: 00010093 CPU: 0
[    9.356308] EIP is at print_context_stack+0x75/0x94
[    9.356308] EAX: 07b61ffc EBX: 07b61163 ECX: 0fffe163 EDX: 07b61163
[    9.356308] ESI: 0fffe163 EDI: ffffe000 EBP: 4d80fe24 ESP: 4d80fe00
[    9.356308]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    9.356308] CR0: 8005003b CR2: 07b61163 CR3: 01d03000 CR4: 00000690
[    9.356308] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    9.356308] DR6: ffff0ff0 DR7: 00000400
[    9.356308] Process swapper (pid: 1, ti=3D4d80e000 task=3D4d80d410 task.=
ti=3D4d816000)
[    9.356308] Stack:
[    9.356308]  0fffe163 4173b5b1 ffffe000 07b61ffc 00000000 07b60000 41755=
11c 07b60000
[    9.356308]  4d80fe40 4d80fe50 410032f2 4175511c 419253f8 00000000 4d80f=
e40 0fffe163
[    9.356308]  00000000 419253f8 00000000 00000018 4d80fe7c 41003de0 00000=
000 4175511c
[    9.356308] Call Trace:
[    9.356308]  [<4173b5b1>] ? printk+0x17/0x19
[    9.356308]  [<410032f2>] dump_trace+0x7e/0xb2
[    9.356308]  [<41003de0>] show_trace_log_lvl+0x34/0x3e
[    9.356308]  [<410033ae>] show_stack_log_lvl+0x88/0x93
[    9.356308]  [<41003455>] show_regs+0x9c/0x194
[    9.356308]  [<41003f8d>] __die+0x6d/0xcd
[    9.356308]  [<4173b014>] no_context+0x136/0x15f
[    9.356308]  [<4173b138>] __bad_area_nosemaphore+0xfb/0x105
[    9.356308]  [<41016f95>] ? do_page_fault+0xaa/0x37d
[    9.356308]  [<41015da6>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
[    9.356308]  [<4173b14f>] bad_area_nosemaphore+0xd/0x10
[    9.356308]  [<4101704e>] do_page_fault+0x163/0x37d
[    9.356308]  [<41015da6>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
[    9.356308]  [<41015dc9>] do_async_page_fault+0x23/0x4b
[    9.356308]  [<41752821>] error_code+0x5d/0x64
[    9.356308]  [<41015da6>] ? kvm_read_and_reset_pf_reason+0x1f/0x1f
[    9.356308] Code: eb 0a 8b 45 0c 31 c9 8b 7d ec ff d7 83 c3 04 83 7d 10 =
00 74 0c 3b 5d 10 73 26 3b 5d e4 73 0c eb 1f 3b 5d f0 76 1a 3b 5d e8 73 15 =
<8b> 13 89 d0 89 55 e0 e8 7a 25 03 00 8b 55 e0 85 c0 75 a1 eb cc
[    9.356308] EIP: [<41003cd8>] print_context_stack+0x75/0x94 SS:ESP 0068:=
4d80fe00
[    9.356308] CR2: 0000000007b61163
[    9.356308] ---[ end trace 96868f0933c41683 ]---
[    9.356308] note: swapper[1] exited with preempt_count 1
[    9.417737] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    9.417737]=20
[    9.419299] Rebooting in 10 seconds..
--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc1-00061-g7bf79d8"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc1 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
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
CONFIG_X86_32_LAZY_GS=y
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TINY_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_HOTPLUG is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
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
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
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
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
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
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_WANT_INTEL_MID=y
CONFIG_X86_RDC321X=y
CONFIG_X86_32_IRIS=y
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
# CONFIG_X86_PPRO_FENCE is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=1
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
CONFIG_VMSPLIT_1G=y
CONFIG_PAGE_OFFSET=0x40000000
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
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set
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
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
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
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
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
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
# CONFIG_NET_DSA_TAG_EDSA is not set
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
# CONFIG_IPDDP_DECAP is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_EMATCH_CANID=y
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=y
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_STANDALONE is not set
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
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_CMA is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
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
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_MVUMI=y
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
CONFIG_VMWARE_PVSCSI=y
CONFIG_HYPERV_STORAGE=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=y
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_TCM_FC is not set
# CONFIG_ISCSI_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_MII=y
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_IFB is not set
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
CONFIG_MACVLAN=y
# CONFIG_MACVTAP is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=y
CONFIG_VETH=y
# CONFIG_VIRTIO_NET is not set
CONFIG_SUNGEM_PHY=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_PCI is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=y
# CONFIG_NET_VENDOR_CHELSIO is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DE600=y
# CONFIG_DE620 is not set
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_PTP=y
CONFIG_IGBVF=y
# CONFIG_IXGB is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
CONFIG_NE2K_PCI=y
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_SEEQ8005 is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_USBNET is not set
# CONFIG_USB_CDC_PHONET is not set
# CONFIG_USB_IPHETH is not set
CONFIG_WLAN=y
CONFIG_AIRO=y
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
CONFIG_PRISM54=y
CONFIG_USB_ZD1201=y
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
CONFIG_HOSTAP_PLX=y
# CONFIG_HOSTAP_PCI is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set
CONFIG_WAN_ROUTER_DRIVERS=y
CONFIG_CYCLADES_SYNC=y
# CONFIG_CYCLOMX_X25 is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_HYPERV_NET=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_AUDIO is not set
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DRV_LOOP=y
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
# CONFIG_ISDN_CAPI_CAPI20 is not set
# CONFIG_ISDN_CAPI_CAPIDRV is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
CONFIG_ISDN_DRV_AVMB1_C4=y
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=y
# CONFIG_GIGASET_CAPI is not set
CONFIG_GIGASET_I4L=y
# CONFIG_GIGASET_DUMMYLL is not set
# CONFIG_GIGASET_BASE is not set
CONFIG_GIGASET_M105=y
# CONFIG_GIGASET_M101 is not set
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_MISDN is not set

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_GPIO_POLLED=y
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_OMAP4=y
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_EGALAX=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
# CONFIG_TOUCHSCREEN_USB_ITM is not set
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_STMPE is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_MAX8925_ONKEY=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
# CONFIG_SYNCLINK_GT is not set
CONFIG_NOZOMI=y
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
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_PNP=y
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
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_SONYPI=y
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
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
CONFIG_GPIO_JANZ_TTL=y
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_AVS=y
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_RDC321X_WDT=y
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
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
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_MFD_LM3533=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_VX855=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y

#
# Media drivers
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMISE=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
# CONFIG_MEDIA_TUNER_TDA18271 is not set
# CONFIG_MEDIA_TUNER_TDA9887 is not set
CONFIG_MEDIA_TUNER_TEA5761=y
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
# CONFIG_MEDIA_TUNER_MT2063 is not set
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=y
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
# CONFIG_MEDIA_TUNER_FC0011 is not set
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DMA_CONTIG=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
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
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_SAA711X=y

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
CONFIG_VIDEO_OV7670=y

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#
CONFIG_V4L_USB_DRIVERS=y

#
# Webcam devices
#
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_GSPCA=y
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
CONFIG_USB_GL860=y
CONFIG_USB_GSPCA_BENQ=y
CONFIG_USB_GSPCA_CONEX=y
CONFIG_USB_GSPCA_CPIA1=y
# CONFIG_USB_GSPCA_ETOMS is not set
CONFIG_USB_GSPCA_FINEPIX=y
CONFIG_USB_GSPCA_JEILINJ=y
# CONFIG_USB_GSPCA_JL2005BCD is not set
CONFIG_USB_GSPCA_KINECT=y
CONFIG_USB_GSPCA_KONICA=y
# CONFIG_USB_GSPCA_MARS is not set
CONFIG_USB_GSPCA_MR97310A=y
# CONFIG_USB_GSPCA_NW80X is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_OV534_9 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7302 is not set
CONFIG_USB_GSPCA_PAC7311=y
CONFIG_USB_GSPCA_SE401=y
CONFIG_USB_GSPCA_SN9C2028=y
# CONFIG_USB_GSPCA_SN9C20X is not set
# CONFIG_USB_GSPCA_SONIXB is not set
CONFIG_USB_GSPCA_SONIXJ=y
CONFIG_USB_GSPCA_SPCA500=y
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
CONFIG_USB_GSPCA_SPCA506=y
CONFIG_USB_GSPCA_SPCA508=y
CONFIG_USB_GSPCA_SPCA561=y
# CONFIG_USB_GSPCA_SPCA1528 is not set
CONFIG_USB_GSPCA_SQ905=y
CONFIG_USB_GSPCA_SQ905C=y
CONFIG_USB_GSPCA_SQ930X=y
CONFIG_USB_GSPCA_STK014=y
CONFIG_USB_GSPCA_STV0680=y
# CONFIG_USB_GSPCA_SUNPLUS is not set
CONFIG_USB_GSPCA_T613=y
CONFIG_USB_GSPCA_TOPRO=y
# CONFIG_USB_GSPCA_TV8532 is not set
CONFIG_USB_GSPCA_VC032X=y
CONFIG_USB_GSPCA_VICAM=y
CONFIG_USB_GSPCA_XIRLINK_CIT=y
CONFIG_USB_GSPCA_ZC3XX=y
# CONFIG_USB_PWC is not set
CONFIG_VIDEO_CPIA2=y
CONFIG_USB_ZR364XX=y
CONFIG_USB_STKWEBCAM=y
# CONFIG_USB_S2255 is not set
# CONFIG_USB_SN9C102 is not set

#
# Webcam and/or TV USB devices
#
# CONFIG_VIDEO_EM28XX is not set

#
# TV USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
CONFIG_VIDEO_USBVISION=y
# CONFIG_V4L_PCI_DRIVERS is not set
# CONFIG_V4L_ISA_PARPORT_DRIVERS is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=y
CONFIG_VIDEO_TIMBERDALE=y
CONFIG_SOC_CAMERA=y
CONFIG_SOC_CAMERA_IMX074=y
# CONFIG_SOC_CAMERA_MT9M001 is not set
CONFIG_SOC_CAMERA_MT9M111=y
# CONFIG_SOC_CAMERA_MT9T031 is not set
# CONFIG_SOC_CAMERA_MT9T112 is not set
# CONFIG_SOC_CAMERA_MT9V022 is not set
CONFIG_SOC_CAMERA_RJ54N1=y
# CONFIG_SOC_CAMERA_TW9910 is not set
CONFIG_SOC_CAMERA_PLATFORM=y
# CONFIG_SOC_CAMERA_OV2640 is not set
# CONFIG_SOC_CAMERA_OV5642 is not set
# CONFIG_SOC_CAMERA_OV6650 is not set
# CONFIG_SOC_CAMERA_OV772X is not set
# CONFIG_SOC_CAMERA_OV9640 is not set
CONFIG_SOC_CAMERA_OV9740=y
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
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
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_MAX8925 is not set
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_PANDORA is not set
# CONFIG_LOGO is not set
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
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_HYPERV_MOUSE is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
# CONFIG_USB_MOUSE is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_RENESAS_USBHS is not set

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
# CONFIG_USB_STORAGE is not set
CONFIG_USB_UAS=y
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=y
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_F81232=y
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_HP4X=y
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=y
CONFIG_USB_SERIAL_ZIO=y
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_MV_UDC=y
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_GADGET_SUPERSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
CONFIG_USB_G_SERIAL=y
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_TWL6030_USB=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

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
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM3556=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_MLX4_INFINIBAND=y
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_SRPT is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM80X is not set
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8925 is not set
# CONFIG_RTC_DRV_MAX8998 is not set
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_PCF50633=y
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
# CONFIG_INTEL_IOATDMA is not set
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_UTILS=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
CONFIG_HP_ACCEL=y
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

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
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
# CONFIG_GOOGLE_MEMCONSOLE is not set

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
CONFIG_JBD_DEBUG=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_LOGFS=y
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
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
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_LKDTM=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VHOST_NET is not set
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y

--huq684BweRXVnRxX--
