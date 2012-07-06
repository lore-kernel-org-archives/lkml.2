Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab2GFOq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:46:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:42370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab2GFOq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:46:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174173903"
Date: Fri, 6 Jul 2012 22:46:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: general protection fault on ttm_init()
Message-ID: <20120706144622.GA13387@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Thomas,

I got this error while running kvm boot tests on linux-next.
Attached is the kconfig.

[    7.064962] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    7.067443] general protection fault: 0000 [#1] PREEMPT 
[    7.068713] CPU 0 
[    7.068713] Pid: 1, comm: swapper Not tainted 3.5.0-rc5-07204-g646e30b #8 Bochs Bochs
[    7.068713] RIP: 0010:[<ffffffff8105e55b>]  [<ffffffff8105e55b>] __lock_acquire.isra.19+0x64/0x7c9
[    7.068713] RSP: 0018:ffff88000006fd10  EFLAGS: 00010097
[    7.068713] RAX: 0000000000000000 RBX: ffff880000070000 RCX: 0000000000000000
[    7.068713] RDX: 0000000000000000 RSI: 0000000000000000 RDI: a56b6b6b6b6b6e73
[    7.068713] RBP: ffff88000006fd80 R08: 0000000000000000 R09: 0000000000000000
[    7.068713] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000246
[    7.068713] R13: 0000000000000000 R14: 0000000000000000 R15: a56b6b6b6b6b6e73
[    7.068713] FS:  0000000000000000(0000) GS:ffffffff81a24000(0000) knlGS:0000000000000000
[    7.068713] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.068713] CR2: 0000000000000000 CR3: 0000000001a12000 CR4: 00000000000006f0
[    7.068713] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.068713] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    7.068713] Process swapper (pid: 1, threadinfo ffff88000006e000, task ffff880000070000)
[    7.068713] Stack:
[    7.068713]  0000000000000000 0000000000000046 ffff88000006fd50 0000000081c40020
[    7.068713]  0000000000000000 ffffffff8105d409 ffff88000006fd90 0000000000000000
[    7.068713]  ffff88000006fde0 ffff880000070000 0000000000000246 ffff8800001c0ab8
[    7.068713] Call Trace:
[    7.068713]  [<ffffffff8105d409>] ? mutex_remove_waiter+0x6a/0x7e
[    7.068713]  [<ffffffff8105f074>] lock_acquire+0x5b/0x78
[    7.068713]  [<ffffffff81352a9a>] ? get_device_parent+0x98/0x1b0
[    7.068713]  [<ffffffff81560b72>] _raw_spin_lock+0x3c/0x6f
[    7.068713]  [<ffffffff81352a9a>] ? get_device_parent+0x98/0x1b0
[    7.068713]  [<ffffffff81352a9a>] get_device_parent+0x98/0x1b0
[    7.068713]  [<ffffffff8135312e>] device_add+0xf4/0x589
[    7.068713]  [<ffffffff81cff357>] ? drm_core_init+0xca/0xca
[    7.068713]  [<ffffffff8135ad4d>] ? pm_runtime_init+0xfa/0xfe
[    7.068713]  [<ffffffff81cff357>] ? drm_core_init+0xca/0xca
[    7.068713]  [<ffffffff813535d9>] device_register+0x16/0x1a
[    7.068713]  [<ffffffff81224acd>] drm_class_device_register+0x17/0x19
[    7.068713]  [<ffffffff81cff38e>] ttm_init+0x37/0x62
[    7.068713]  [<ffffffff81cdbbca>] do_one_initcall+0x78/0x131
[    7.068713]  [<ffffffff81cdbd77>] kernel_init+0xf4/0x178
[    7.068713]  [<ffffffff81cdb45d>] ? loglevel+0x31/0x31
[    7.068713]  [<ffffffff81562e94>] kernel_thread_helper+0x4/0x10
[    7.068713]  [<ffffffff81cdbc83>] ? do_one_initcall+0x131/0x131
[    7.068713]  [<ffffffff81562e90>] ? gs_change+0x13/0x13
[    7.068713] Code: 49 89 ff 41 89 f5 0f 85 fe 06 00 00 9c 58 66 66 90 66 90 f6 c4 02 0f 84 ee 06 00 00 e8 2b 00 0e 00 31 c0 e9 59 07 00 00 44 89 e8 <4d> 8b 64 c7 08 4d 85 e4 0f 85 04 03 00 00 83 3d 20 7c 18 01 00 
[    7.068713] RIP  [<ffffffff8105e55b>] __lock_acquire.isra.19+0x64/0x7c9
[    7.068713]  RSP <ffff88000006fd10>
[    7.068713] ---[ end trace 6e1803df9f758306 ]---
[    7.068713] Kernel panic - not syncing: Fatal exception

Thanks,
Fengguang

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=dmesg-kvm-xgwo-3621-2012-07-06-22-36-35
Content-Transfer-Encoding: 8bit

[    0.000000] Linux version 3.5.0-rc5-07204-g646e30b (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #8 PREEMPT Fri Jul 6 22:35:45 CST 2012
[    0.000000] Command line: rcutorture.rcutorture_runnable=0 tree=mm:akpm auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=vmlinuz-2012-07-06-22-36-01-mm-origin.akpm-dece410-646e30b-x86_64-randconfig-mm3-1 BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-mm3/646e30b5919c3a3424f981cb66b932dbfa8563ce/vmlinuz-3.5.0-rc5-07204-g646e30b
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820: last_pfn = 0x1fffd max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
[    0.000000] init_memory_mapping: [mem 0x00000000-0x1fffcfff]
[    0.000000] RAMDISK: [mem 0x1e8d6000-0x1ffeffff]
[    0.000000] kvm-clock: cpu 0, msr 0:1a2e841, boot clock
[    0.000000] Zone ranges:
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffcfff]
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] e820: [mem 0x20000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128902
[    0.000000] Kernel command line: 
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 469080k/524276k available (5525k kernel code, 452k absent, 54744k reserved, 7631k data, 840k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.000000]             mixed read-write-lock:             |failed|             |failed|
[    0.000000]             mixed write-read-lock:             |failed|             |failed|
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
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
[    0.000000] 133 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] tsc: Detected 2666.698 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 5333.39 BogoMIPS (lpj=10666792)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004284] Security Framework initialized
[    0.005514] TOMOYO Linux initialized
[    0.006616] AppArmor: AppArmor disabled by boot time parameter
[    0.008100] Mount-cache hash table entries: 256
[    0.010160] Disabled fast string operations
[    0.012031] mce: CPU supports 10 MCE banks
[    0.013344] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013344] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013344] tlb_flushall_shift is 0x6
[    0.016009] CPU: Intel Common KVM processor stepping 01
[    0.025691] ACPI: Core revision 20120518
[    0.044261] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.051124] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.054403] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.060003] EVM: security.capability
[    0.060003] dummy: 
[    0.060104] NET: Registered protocol family 16
[    0.062685] ACPI: bus type pci registered
[    0.064165] PCI: Using configuration type 1 for base access
[    0.083328] ACPI: Added _OSI(Module Device)
[    0.084017] ACPI: Added _OSI(Processor Device)
[    0.085784] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.088022] ACPI: Added _OSI(Processor Aggregator Device)
[    0.131551] ACPI: Interpreter enabled
[    0.132010] ACPI: (supports S0 S5)
[    0.133564] ACPI: Using IOAPIC for interrupt routing
[    0.174560] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.176158] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.180178] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.184314] PCI host bridge to bus 0000:00
[    0.185989] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.188020] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.192020] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.252981]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x18)
[    0.396326] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.399743] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.401637] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.405622] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.410154] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.412087] vgaarb: loaded
[    0.413201] vgaarb: bridge control possible 0000:00:02.0
[    0.416342] tps65010: version 2 May 2005
[    0.448086] tps65010: no chip?
[    0.450084] ACPI: bus type usb registered
[    0.451814] usbcore: registered new interface driver usbfs
[    0.452083] usbcore: registered new interface driver hub
[    0.456214] usbcore: registered new device driver usb
[    0.458798] wmi: Mapper loaded
[    5.460536] PCI: Using ACPI for IRQ routing
[    5.464646] NET: Registered protocol family 23
[    5.466504] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    5.472607] Switching to clocksource kvm-clock
[    5.475110] pnp: PnP ACPI init
[    5.476341] ACPI: bus type pnp registered
[    5.484319] pnp: PnP ACPI: found 8 devices
[    5.485954] ACPI: ACPI bus type pnp unregistered
[    5.494486] NET: Registered protocol family 1
[    5.496710] Unpacking initramfs...
[    6.828511] Freeing initrd memory: 23656k freed
[    6.864033] Machine check injector initialized
[    6.866674] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    6.870730] cryptomgr_test (13) used greatest stack depth: 6488 bytes left
[    6.874483] cryptomgr_test (19) used greatest stack depth: 5384 bytes left
[    6.877752] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    6.882155] Initializing RT-Tester: OK
[    6.883744] audit: initializing netlink socket (disabled)
[    6.886019] type=2000 audit(1341585388.884:1): initialized
[    6.901896] jffs2: version 2.2. © 2001-2006 Red Hat, Inc.
[    6.906142] msgmni has been set to 962
[    6.913102] alg: No test for stdrng (krng)
[    6.923012] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    6.925433] NET: Registered protocol family 38
[    6.927401] xz_dec_test: module loaded
[    6.928933] xz_dec_test: Create a device node with 'mknod xz_dec_test c 251 0' and write .xz files to it.
[    6.933340] i2c-core: driver [adp8860_bl] using legacy suspend method
[    6.935944] i2c-core: driver [adp8860_bl] using legacy resume method
[    6.939041] no IO addresses supplied
[    6.940808] hgafb: HGA card not detected.
[    6.942455] hgafb: probe of hgafb.0 failed with error -22
[    6.944824] usbcore: registered new interface driver smscufx
[    6.947818] uvesafb: failed to execute /sbin/v86d
[    6.949751] uvesafb: make sure that the v86d helper is installed and executable
[    6.952793] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    6.955465] uvesafb: vbe_init() failed with -22
[    6.957323] uvesafb: probe of uvesafb.0 failed with error -22
[    6.960432] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    6.963422] ACPI: Power Button [PWRF]
[    6.971210] r3964: Philips r3964 Driver $Revision: 1.10 $
[    6.973378] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    7.003421] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.007410] MOXA Intellio family driver version 6.0k
[    7.023560] MOXA Smartio/Industio family driver version 2.0.5
[    7.025953] RocketPort device driver module, version 2.09, 12-June-2003
[    7.028682] No rocketport ports found; unloading driver
[    7.030830] SyncLink serial driver $Revision: 4.38 $
[    7.046991] SyncLink serial driver $Revision: 4.38 $, tty major#249
[    7.049676] Non-volatile memory driver v1.3
[    7.051471] ppdev: user-space parallel port driver
[    7.053451] smapi::smapi_init, ERROR invalid usSmapiID
[    7.055548] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    7.059286] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    7.062146] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    7.064962] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    7.067443] general protection fault: 0000 [#1] PREEMPT 
[    7.068713] CPU 0 
[    7.068713] Pid: 1, comm: swapper Not tainted 3.5.0-rc5-07204-g646e30b #8 Bochs Bochs
[    7.068713] RIP: 0010:[<ffffffff8105e55b>]  [<ffffffff8105e55b>] __lock_acquire.isra.19+0x64/0x7c9
[    7.068713] RSP: 0018:ffff88000006fd10  EFLAGS: 00010097
[    7.068713] RAX: 0000000000000000 RBX: ffff880000070000 RCX: 0000000000000000
[    7.068713] RDX: 0000000000000000 RSI: 0000000000000000 RDI: a56b6b6b6b6b6e73
[    7.068713] RBP: ffff88000006fd80 R08: 0000000000000000 R09: 0000000000000000
[    7.068713] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000246
[    7.068713] R13: 0000000000000000 R14: 0000000000000000 R15: a56b6b6b6b6b6e73
[    7.068713] FS:  0000000000000000(0000) GS:ffffffff81a24000(0000) knlGS:0000000000000000
[    7.068713] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.068713] CR2: 0000000000000000 CR3: 0000000001a12000 CR4: 00000000000006f0
[    7.068713] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.068713] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    7.068713] Process swapper (pid: 1, threadinfo ffff88000006e000, task ffff880000070000)
[    7.068713] Stack:
[    7.068713]  0000000000000000 0000000000000046 ffff88000006fd50 0000000081c40020
[    7.068713]  0000000000000000 ffffffff8105d409 ffff88000006fd90 0000000000000000
[    7.068713]  ffff88000006fde0 ffff880000070000 0000000000000246 ffff8800001c0ab8
[    7.068713] Call Trace:
[    7.068713]  [<ffffffff8105d409>] ? mutex_remove_waiter+0x6a/0x7e
[    7.068713]  [<ffffffff8105f074>] lock_acquire+0x5b/0x78
[    7.068713]  [<ffffffff81352a9a>] ? get_device_parent+0x98/0x1b0
[    7.068713]  [<ffffffff81560b72>] _raw_spin_lock+0x3c/0x6f
[    7.068713]  [<ffffffff81352a9a>] ? get_device_parent+0x98/0x1b0
[    7.068713]  [<ffffffff81352a9a>] get_device_parent+0x98/0x1b0
[    7.068713]  [<ffffffff8135312e>] device_add+0xf4/0x589
[    7.068713]  [<ffffffff81cff357>] ? drm_core_init+0xca/0xca
[    7.068713]  [<ffffffff8135ad4d>] ? pm_runtime_init+0xfa/0xfe
[    7.068713]  [<ffffffff81cff357>] ? drm_core_init+0xca/0xca
[    7.068713]  [<ffffffff813535d9>] device_register+0x16/0x1a
[    7.068713]  [<ffffffff81224acd>] drm_class_device_register+0x17/0x19
[    7.068713]  [<ffffffff81cff38e>] ttm_init+0x37/0x62
[    7.068713]  [<ffffffff81cdbbca>] do_one_initcall+0x78/0x131
[    7.068713]  [<ffffffff81cdbd77>] kernel_init+0xf4/0x178
[    7.068713]  [<ffffffff81cdb45d>] ? loglevel+0x31/0x31
[    7.068713]  [<ffffffff81562e94>] kernel_thread_helper+0x4/0x10
[    7.068713]  [<ffffffff81cdbc83>] ? do_one_initcall+0x131/0x131
[    7.068713]  [<ffffffff81562e90>] ? gs_change+0x13/0x13
[    7.068713] Code: 49 89 ff 41 89 f5 0f 85 fe 06 00 00 9c 58 66 66 90 66 90 f6 c4 02 0f 84 ee 06 00 00 e8 2b 00 0e 00 31 c0 e9 59 07 00 00 44 89 e8 <4d> 8b 64 c7 08 4d 85 e4 0f 85 04 03 00 00 83 3d 20 7c 18 01 00 
[    7.068713] RIP  [<ffffffff8105e55b>] __lock_acquire.isra.19+0x64/0x7c9
[    7.068713]  RSP <ffff88000006fd10>
[    7.068713] ---[ end trace 6e1803df9f758306 ]---
[    7.068713] Kernel panic - not syncing: Fatal exception

--OXfL5xGRrasGEqWY--
