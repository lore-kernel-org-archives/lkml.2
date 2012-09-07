Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2IGC3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:29:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:28036 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327Ab2IGC3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:29:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,382,1344236400"; 
   d="scan'208";a="219143886"
Date: Fri, 7 Sep 2012 10:29:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tomas Hlavacek <tmshlvck@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: tty: WARNING at drivers/base/core.c:196 device_release()
Message-ID: <20120907022928.GA14646@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tomas,

FYI, this commit triggers a boot time warning.

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git tty-next
head:   6915c0e487c822e2436683e14302c0b8a6155cc7
commit: 6915c0e487c822e2436683e14302c0b8a6155cc7 [1/1] tty: uartclk value from serial_core exposed to sysfs

[    1.882306]  [<c11ddeff>] ? put_device+0xf/0x20
[    1.883140]  [<c11ddeff>] put_device+0xf/0x20
[    1.884821]  [<c11c4736>] tty_unregister_device+0x26/0x50

[    1.875434] PM: Removing info for No Bus:ttyS0
[    1.876344] ------------[ cut here ]------------
[    1.876762] WARNING: at /c/kernel-tests/src/stable/drivers/base/core.c:196 device_release+0x6e/0x80()
[    1.877550] Device 'ttyS0' does not have a release() function, it is broken and must be fixed.
[    1.878247] Modules linked in:
[    1.878552] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc3-00189-g6915c0e #176
[    1.879209] Call Trace:
[    1.879419]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    1.879861]  [<c11de0ee>] ? device_release+0x6e/0x80
[    1.880268]  [<c11de0ee>] ? device_release+0x6e/0x80
[    1.880682]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    1.881090]  [<c11de0ee>] device_release+0x6e/0x80
[    1.881479]  [<c1164e86>] kobject_cleanup+0x36/0x80
[    1.881942]  [<c1164f05>] kobject_put+0x25/0x60
[    1.882306]  [<c11ddeff>] ? put_device+0xf/0x20
[    1.882746]  [<c11deccc>] ? device_del+0x12c/0x160
[    1.883140]  [<c11ddeff>] put_device+0xf/0x20
[    1.883551]  [<c11ded36>] device_unregister+0x36/0x50
[    1.883963]  [<c11ded7d>] device_destroy+0x2d/0x40
[    1.884346]  [<c11dde40>] ? class_dir_child_ns_type+0x10/0x10
[    1.884821]  [<c11c4736>] tty_unregister_device+0x26/0x50
[    1.885314]  [<c11d0472>] uart_remove_one_port+0x82/0xf0
[    1.885830]  [<c11d44bd>] serial8250_register_8250_port+0x6d/0x280
[    1.886321]  [<c1250c37>] ? check_name+0x2f/0x2f
[    1.886711]  [<c1250d9d>] serial_pnp_probe+0x166/0x1ff
[    1.887126]  [<c11bf0f7>] pnp_device_probe+0x57/0xc0
[    1.887592]  [<c11e187b>] driver_probe_device+0xdb/0x2e0
[    1.888020]  [<c11e1b11>] __driver_attach+0x91/0xa0
[    1.888403]  [<c11e1a80>] ? driver_probe_device+0x2e0/0x2e0
[    1.888864]  [<c11dfe78>] bus_for_each_dev+0x38/0x70
[    1.889269]  [<c11e1319>] driver_attach+0x19/0x20
[    1.889721]  [<c11e1a80>] ? driver_probe_device+0x2e0/0x2e0
[    1.890157]  [<c11e0ec6>] bus_add_driver+0xd6/0x240
[    1.890567]  [<c11bef00>] ? pnp_device_detach+0x40/0x40
[    1.890982]  [<c11e20d5>] driver_register+0x65/0x160
[    1.891381]  [<c11e2ebb>] ? platform_driver_register+0x3b/0x40
[    1.891877]  [<c13becdd>] ? early_serial_setup+0xd2/0xd2
[    1.892295]  [<c11beeb7>] pnp_register_driver+0x17/0x20
[    1.892724]  [<c13becea>] serial8250_pnp_init+0xd/0xf
[    1.893185]  [<c1001202>] do_one_initcall+0x112/0x160
[    1.893605]  [<c139fa5a>] kernel_init+0xf7/0x18e
[    1.893987]  [<c139f423>] ? do_early_param+0x7a/0x7a
[    1.894394]  [<c139f963>] ? start_kernel+0x324/0x324
[    1.894818]  [<c12697b6>] kernel_thread_helper+0x6/0xd

Thanks,
Fengguang

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-fat-29234-2012-09-07-00-50-52-3.6.0-rc3-00189-g6915c0e-176"

[    0.000000] Linux version 3.6.0-rc3-00189-g6915c0e (kbuild@kbuild) (gcc version 4.7.1 (Debian 4.7.1-6) ) #176 SMP PREEMPT Fri Sep 7 00:37:17 CST 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
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
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [c00fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x01fbd000-0x01ffffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128328(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00010000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c1399cc0, node_mem_map cdcbf280
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
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 332 pages/cpu @cda27000 s1337408 r0 d22464 u1359872
[    0.000000] pcpu-alloc: s1337408 r0 d22464 u1359872 alloc=332*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr da29a00
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64769
[    0.000000] Kernel command line: trinity=2m hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=tty/tty-next log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-09-07-00-37-59-tty:tty-next:6915c0e-6915c0e-i386-randconfig-k921-5-fat BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-k921/6915c0e/vmlinuz-3.6.0-rc3-00189-g6915c0e
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 211880k/262136k available (2472k kernel code, 49756k reserved, 1232k data, 1580k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc139f000 - 0xc152a000   (1580 kB)
[    0.000000]       .data : 0xc126a053 - 0xc139e200   (1232 kB)
[    0.000000]       .text : 0xc1000000 - 0xc126a053   (2472 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=cd402000 soft=cd404000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
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
[    0.000000] ODEBUG: 9 of 9 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3200.334 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.010510] Calibrating delay loop (skipped), value calculated using timer frequency.. 6400.66 BogoMIPS (lpj=32003340)
[    0.011408] pid_max: default: 32768 minimum: 301
[    0.011868] Security Framework initialized
[    0.012218] AppArmor: AppArmor disabled by boot time parameter
[    0.012707] Yama: becoming mindful.
[    0.013034] Mount-cache hash table entries: 512
[    0.013950] mce: CPU supports 10 MCE banks
[    0.014303] mce: unknown CPU type - not enabling MCE support
[    0.014786] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014786] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014786] tlb_flushall_shift is 0xffffffff
[    0.021777] ACPI: Core revision 20120711
[    0.024497] Getting VERSION: 50014
[    0.024798] Getting VERSION: 50014
[    0.025092] Getting ID: 0
[    0.025371] Getting ID: f000000
[    0.025644] Getting LVT0: 8700
[    0.025906] Getting LVT1: 8400
[    0.026168] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.026715] enabled ExtINT on CPU#0
[    0.027785] ENABLING IO-APIC IRQs
[    0.028071] init IO_APIC IRQs
[    0.028330]  apic 2 pin 0 not connected
[    0.028663] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.029338] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.030019] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.030697] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.031372] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.032039] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.032713] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.033386] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.034054] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.034726] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.035411] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.036094] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.036781] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.037517] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.038199] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.038923]  apic 2 pin 16 not connected
[    0.039300]  apic 2 pin 17 not connected
[    0.040003]  apic 2 pin 18 not connected
[    0.040334]  apic 2 pin 19 not connected
[    0.040676]  apic 2 pin 20 not connected
[    0.041006]  apic 2 pin 21 not connected
[    0.041337]  apic 2 pin 22 not connected
[    0.041717]  apic 2 pin 23 not connected
[    0.042183] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.042825] smpboot: CPU0: GenuineIntel Common KVM processor stepping 01
[    0.043584] Using local APIC timer interrupts.
[    0.043584] calibrating APIC timer ...
[    0.050000] ... lapic delta = 6250335
[    0.050000] ... PM-Timer delta = 357974
[    0.050000] ... PM-Timer result ok
[    0.050000] ..... delta 6250335
[    0.050000] ..... mult: 268449844
[    0.050000] ..... calibration result: 10000536
[    0.050000] ..... CPU clock speed is 3200.2834 MHz.
[    0.050000] ..... host bus clock speed is 1000.0536 MHz.
[    0.050000] Performance Events: 
[    0.110030] SMP alternatives: lockdep: fixing up alternatives
[    0.110976] CPU 1 irqstacks, hard=cd498000 soft=cd49a000
[    0.111736] smpboot: Booting Node   0, Processors  #1 OK
[    0.020000] Initializing CPU#1
[    0.020000] masked ExtINT on CPU#1
[    0.270258] KVM setup async PF for cpu 1
[    0.270262] Brought up 2 CPUs
[    0.270264] smpboot: Total of 2 processors activated (12801.33 BogoMIPS)
[    0.270457] kvm-stealtime: cpu 1, msr db75a00
[    0.271887] CPU0 attaching sched-domain:
[    0.272209]  domain 0: span 0-1 level CPU
[    0.272535]   groups: 0 (cpu_power = 1023) 1
[    0.272930] CPU1 attaching sched-domain:
[    0.273249]  domain 0: span 0-1 level CPU
[    0.273588]   groups: 1 0 (cpu_power = 1023)
[    0.274986] devtmpfs: initialized
[    0.275348] device: 'platform': device_add
[    0.275709] PM: Adding info for No Bus:platform
[    0.276108] bus: 'platform': registered
[    0.276421] bus: 'cpu': registered
[    0.276694] device: 'cpu': device_add
[    0.277026] PM: Adding info for No Bus:cpu
[    0.277643] EVM: security.capability
[    0.278034] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.278665] NET: Registered protocol family 16
[    0.279086] device class 'bdi': registering
[    0.279485] device class 'pci_bus': registering
[    0.279876] bus: 'pci': registered
[    0.280006] device class 'tty': registering
[    0.280371] bus: 'spi': registered
[    0.280655] device class 'spi_master': registering
[    0.281204] ACPI: bus type pci registered
[    0.281651] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.282176] PCI: Using configuration type 1 for base access
[    0.282669] device: 'cpu0': device_add
[    0.282985] bus: 'cpu': add device cpu0
[    0.283321] PM: Adding info for cpu:cpu0
[    0.283679] device: 'cpu1': device_add
[    0.283995] bus: 'cpu': add device cpu1
[    0.284323] PM: Adding info for cpu:cpu1
[    0.285178] device: 'default': device_add
[    0.285541] PM: Adding info for No Bus:default
[    0.286282] bio: create slab <bio-0> at 0
[    0.286649] device class 'block': registering
[    0.287315] ACPI: Added _OSI(Module Device)
[    0.287656] ACPI: Added _OSI(Processor Device)
[    0.288108] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.288479] ACPI: Added _OSI(Processor Aggregator Device)
[    0.290833] ACPI: EC: Look up EC in DSDT
[    0.295760] ACPI: Interpreter enabled
[    0.296074] ACPI: (supports S0 S3 S5)
[    0.296443] ACPI: Using IOAPIC for interrupt routing
[    0.296870] bus: 'acpi': registered
[    0.297161] bus: 'acpi': add driver power
[    0.297523] device: 'LNXSYSTM:00': device_add
[    0.297889] bus: 'acpi': add device LNXSYSTM:00
[    0.298271] PM: Adding info for acpi:LNXSYSTM:00
[    0.298743] device: 'device:00': device_add
[    0.299126] bus: 'acpi': add device device:00
[    0.299501] PM: Adding info for acpi:device:00
[    0.300005] device: 'PNP0A03:00': device_add
[    0.300362] bus: 'acpi': add device PNP0A03:00
[    0.300741] PM: Adding info for acpi:PNP0A03:00
[    0.301707] device: 'device:01': device_add
[    0.302060] bus: 'acpi': add device device:01
[    0.302414] PM: Adding info for acpi:device:01
[    0.302827] device: 'device:02': device_add
[    0.303166] bus: 'acpi': add device device:02
[    0.303540] PM: Adding info for acpi:device:02
[    0.303974] device: 'PNP0B00:00': device_add
[    0.304317] bus: 'acpi': add device PNP0B00:00
[    0.304680] PM: Adding info for acpi:PNP0B00:00
[    0.305139] device: 'PNP0303:00': device_add
[    0.305497] bus: 'acpi': add device PNP0303:00
[    0.305858] PM: Adding info for acpi:PNP0303:00
[    0.306338] device: 'PNP0F13:00': device_add
[    0.306678] bus: 'acpi': add device PNP0F13:00
[    0.307044] PM: Adding info for acpi:PNP0F13:00
[    0.307524] device: 'PNP0700:00': device_add
[    0.307896] bus: 'acpi': add device PNP0700:00
[    0.308263] PM: Adding info for acpi:PNP0700:00
[    0.308781] device: 'PNP0400:00': device_add
[    0.309143] bus: 'acpi': add device PNP0400:00
[    0.309526] PM: Adding info for acpi:PNP0400:00
[    0.310149] device: 'PNP0501:00': device_add
[    0.310505] bus: 'acpi': add device PNP0501:00
[    0.310887] PM: Adding info for acpi:PNP0501:00
[    0.311368] device: 'device:03': device_add
[    0.311718] bus: 'acpi': add device device:03
[    0.312123] PM: Adding info for acpi:device:03
[    0.312568] device: 'device:04': device_add
[    0.312932] bus: 'acpi': add device device:04
[    0.313311] PM: Adding info for acpi:device:04
[    0.313738] device: 'device:05': device_add
[    0.314103] bus: 'acpi': add device device:05
[    0.314473] PM: Adding info for acpi:device:05
[    0.314917] device: 'device:06': device_add
[    0.315266] bus: 'acpi': add device device:06
[    0.315634] PM: Adding info for acpi:device:06
[    0.316081] device: 'device:07': device_add
[    0.316431] bus: 'acpi': add device device:07
[    0.316811] PM: Adding info for acpi:device:07
[    0.317265] device: 'device:08': device_add
[    0.317615] bus: 'acpi': add device device:08
[    0.318080] PM: Adding info for acpi:device:08
[    0.318497] device: 'device:09': device_add
[    0.318837] bus: 'acpi': add device device:09
[    0.319221] PM: Adding info for acpi:device:09
[    0.319651] device: 'device:0a': device_add
[    0.320006] bus: 'acpi': add device device:0a
[    0.320381] PM: Adding info for acpi:device:0a
[    0.320811] device: 'device:0b': device_add
[    0.321174] bus: 'acpi': add device device:0b
[    0.321541] PM: Adding info for acpi:device:0b
[    0.321992] device: 'device:0c': device_add
[    0.322333] bus: 'acpi': add device device:0c
[    0.322691] PM: Adding info for acpi:device:0c
[    0.323113] device: 'device:0d': device_add
[    0.323461] bus: 'acpi': add device device:0d
[    0.323858] PM: Adding info for acpi:device:0d
[    0.324281] device: 'device:0e': device_add
[    0.324620] bus: 'acpi': add device device:0e
[    0.324990] PM: Adding info for acpi:device:0e
[    0.325424] device: 'device:0f': device_add
[    0.325775] bus: 'acpi': add device device:0f
[    0.326175] PM: Adding info for acpi:device:0f
[    0.326634] device: 'device:10': device_add
[    0.326990] bus: 'acpi': add device device:10
[    0.327365] PM: Adding info for acpi:device:10
[    0.327815] device: 'device:11': device_add
[    0.328157] bus: 'acpi': add device device:11
[    0.328509] PM: Adding info for acpi:device:11
[    0.328940] device: 'device:12': device_add
[    0.329293] bus: 'acpi': add device device:12
[    0.329665] PM: Adding info for acpi:device:12
[    0.330073] device: 'device:13': device_add
[    0.330432] bus: 'acpi': add device device:13
[    0.330834] PM: Adding info for acpi:device:13
[    0.331267] device: 'device:14': device_add
[    0.331619] bus: 'acpi': add device device:14
[    0.332024] PM: Adding info for acpi:device:14
[    0.332456] device: 'device:15': device_add
[    0.332811] bus: 'acpi': add device device:15
[    0.333181] PM: Adding info for acpi:device:15
[    0.333619] device: 'device:16': device_add
[    0.333983] bus: 'acpi': add device device:16
[    0.334340] PM: Adding info for acpi:device:16
[    0.334768] device: 'device:17': device_add
[    0.335101] bus: 'acpi': add device device:17
[    0.335466] PM: Adding info for acpi:device:17
[    0.335909] device: 'device:18': device_add
[    0.336247] bus: 'acpi': add device device:18
[    0.336613] PM: Adding info for acpi:device:18
[    0.337053] device: 'device:19': device_add
[    0.337405] bus: 'acpi': add device device:19
[    0.337788] PM: Adding info for acpi:device:19
[    0.338202] device: 'device:1a': device_add
[    0.338540] bus: 'acpi': add device device:1a
[    0.338905] PM: Adding info for acpi:device:1a
[    0.339331] device: 'device:1b': device_add
[    0.339672] bus: 'acpi': add device device:1b
[    0.340023] PM: Adding info for acpi:device:1b
[    0.340444] device: 'device:1c': device_add
[    0.340796] bus: 'acpi': add device device:1c
[    0.341162] PM: Adding info for acpi:device:1c
[    0.341594] device: 'device:1d': device_add
[    0.341996] bus: 'acpi': add device device:1d
[    0.342366] PM: Adding info for acpi:device:1d
[    0.342803] device: 'device:1e': device_add
[    0.343154] bus: 'acpi': add device device:1e
[    0.343538] PM: Adding info for acpi:device:1e
[    0.343981] device: 'device:1f': device_add
[    0.344331] bus: 'acpi': add device device:1f
[    0.344706] PM: Adding info for acpi:device:1f
[    0.345163] device: 'device:20': device_add
[    0.345515] bus: 'acpi': add device device:20
[    0.345935] PM: Adding info for acpi:device:20
[    0.346370] device: 'device:21': device_add
[    0.346771] bus: 'acpi': add device device:21
[    0.347150] PM: Adding info for acpi:device:21
[    0.347589] device: 'device:22': device_add
[    0.347992] bus: 'acpi': add device device:22
[    0.348362] PM: Adding info for acpi:device:22
[    0.348983] device: 'PNP0103:00': device_add
[    0.349340] bus: 'acpi': add device PNP0103:00
[    0.350022] PM: Adding info for acpi:PNP0103:00
[    0.350559] device: 'PNP0C0F:00': device_add
[    0.350906] bus: 'acpi': add device PNP0C0F:00
[    0.351277] PM: Adding info for acpi:PNP0C0F:00
[    0.351864] device: 'PNP0C0F:01': device_add
[    0.352224] bus: 'acpi': add device PNP0C0F:01
[    0.352586] PM: Adding info for acpi:PNP0C0F:01
[    0.353104] device: 'PNP0C0F:02': device_add
[    0.353459] bus: 'acpi': add device PNP0C0F:02
[    0.353850] PM: Adding info for acpi:PNP0C0F:02
[    0.354364] device: 'PNP0C0F:03': device_add
[    0.354710] bus: 'acpi': add device PNP0C0F:03
[    0.355078] PM: Adding info for acpi:PNP0C0F:03
[    0.355591] device: 'PNP0C0F:04': device_add
[    0.355968] bus: 'acpi': add device PNP0C0F:04
[    0.356334] PM: Adding info for acpi:PNP0C0F:04
[    0.356796] device: 'LNXCPU:00': device_add
[    0.357139] bus: 'acpi': add device LNXCPU:00
[    0.357519] PM: Adding info for acpi:LNXCPU:00
[    0.358017] device: 'LNXCPU:01': device_add
[    0.358366] bus: 'acpi': add device LNXCPU:01
[    0.358733] PM: Adding info for acpi:LNXCPU:01
[    0.359172] device: 'device:23': device_add
[    0.359521] bus: 'acpi': add device device:23
[    0.360014] PM: Adding info for acpi:device:23
[    0.360410] device: 'LNXPWRBN:00': device_add
[    0.360770] bus: 'acpi': add device LNXPWRBN:00
[    0.361167] PM: Adding info for acpi:LNXPWRBN:00
[    0.361705] bus: 'acpi': add driver ec
[    0.362058] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.362793] bus: 'acpi': add driver pci_root
[    0.363177] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    0.363854] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    0.364530] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.365067] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.366017] device: 'pci0000:00': device_add
[    0.366371] PM: Adding info for No Bus:pci0000:00
[    0.366741] device: '0000:00': device_add
[    0.367093] PM: Adding info for No Bus:0000:00
[    0.367465] PCI host bridge to bus 0000:00
[    0.367790] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.368429] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.368864] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.369362] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.369950] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.370003] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.370575] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.371275] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.372148] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.374204] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.375570] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.376333] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.376925] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.377645] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.379075] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.380825] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.385364] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.386363] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.387170] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.388263] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.391871] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.392791] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.393497] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.396342] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.397197] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.398255] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.402321] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.403153] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.404207] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.408318] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.409174] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.410329] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.414455] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.415394] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.416442] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.420477] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.421331] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.422424] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.426486] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.427338] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.428388] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.432615] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.433298] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.436137] pci_bus 0000:00: on NUMA node 0
[    0.436499] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.438175]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.438791] device: '0000:00:00.0': device_add
[    0.440182] bus: 'pci': add device 0000:00:00.0
[    0.440604] PM: Adding info for pci:0000:00:00.0
[    0.441025] device: '0000:00:01.0': device_add
[    0.442287] bus: 'pci': add device 0000:00:01.0
[    0.442697] PM: Adding info for pci:0000:00:01.0
[    0.443091] device: '0000:00:01.1': device_add
[    0.444334] bus: 'pci': add device 0000:00:01.1
[    0.444744] PM: Adding info for pci:0000:00:01.1
[    0.445137] device: '0000:00:01.3': device_add
[    0.446380] bus: 'pci': add device 0000:00:01.3
[    0.446776] PM: Adding info for pci:0000:00:01.3
[    0.447154] device: '0000:00:02.0': device_add
[    0.448390] bus: 'pci': add device 0000:00:02.0
[    0.448788] PM: Adding info for pci:0000:00:02.0
[    0.449172] device: '0000:00:03.0': device_add
[    0.450451] bus: 'pci': add device 0000:00:03.0
[    0.450847] PM: Adding info for pci:0000:00:03.0
[    0.451223] device: '0000:00:04.0': device_add
[    0.452456] bus: 'pci': add device 0000:00:04.0
[    0.452871] PM: Adding info for pci:0000:00:04.0
[    0.453259] device: '0000:00:05.0': device_add
[    0.454509] bus: 'pci': add device 0000:00:05.0
[    0.454925] PM: Adding info for pci:0000:00:05.0
[    0.455311] device: '0000:00:06.0': device_add
[    0.456542] bus: 'pci': add device 0000:00:06.0
[    0.456949] PM: Adding info for pci:0000:00:06.0
[    0.457333] device: '0000:00:07.0': device_add
[    0.458622] bus: 'pci': add device 0000:00:07.0
[    0.459038] PM: Adding info for pci:0000:00:07.0
[    0.459427] device: '0000:00:08.0': device_add
[    0.460796] bus: 'pci': add device 0000:00:08.0
[    0.461213] PM: Adding info for pci:0000:00:08.0
[    0.461600] device: '0000:00:09.0': device_add
[    0.462828] bus: 'pci': add device 0000:00:09.0
[    0.463230] PM: Adding info for pci:0000:00:09.0
[    0.463617] device: '0000:00:0a.0': device_add
[    0.464859] bus: 'pci': add device 0000:00:0a.0
[    0.465253] PM: Adding info for pci:0000:00:0a.0
[    0.465640] device: '0000:00:0b.0': device_add
[    0.466872] bus: 'pci': add device 0000:00:0b.0
[    0.467267] PM: Adding info for pci:0000:00:0b.0
[    0.467656] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    0.468225] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    0.468875] bus: 'acpi': add driver pci_link
[    0.469246] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    0.469956] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    0.470089] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.470661] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    0.471217] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    0.471855] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    0.472532] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    0.473233] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.473790] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    0.474350] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    0.474936] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    0.475617] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    0.476301] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.476863] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    0.477513] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    0.478090] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    0.478746] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    0.480074] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.480609] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    0.481164] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    0.481761] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    0.482434] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    0.483103] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.483613] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    0.484180] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    0.484797] bus: 'pnp': registered
[    0.485096] device class 'misc': registering
[    0.485477] device: 'vga_arbiter': device_add
[    0.486144] PM: Adding info for No Bus:vga_arbiter
[    0.486596] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.487273] vgaarb: loaded
[    0.487500] vgaarb: bridge control possible 0000:00:02.0
[    0.487972] bus: 'spi': add driver ezx-pcap
[    0.488353] bus: 'serio': registered
[    0.488655] device class 'input': registering
[    0.489035] device class 'rtc': registering
[    0.489386] device class 'power_supply': registering
[    0.489806] device class 'watchdog': registering
[    0.490011] device class 'devfreq': registering
[    0.490389] PCI: Using ACPI for IRQ routing
[    0.490739] PCI: pci_cache_line_size set to 64 bytes
[    0.491378] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.491878] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.492373] device class 'net': registering
[    0.492755] device: 'lo': device_add
[    0.493131] PM: Adding info for No Bus:lo
[    0.493681] Switching to clocksource hpet
[    0.494168] bus: 'pnp': add driver system
[    0.494501] pnp: PnP ACPI init
[    0.494763] device: 'pnp0': device_add
[    0.495080] PM: Adding info for No Bus:pnp0
[    0.495415] ACPI: bus type pnp registered
[    0.495785] pnp 00:00: [bus 00-ff]
[    0.496060] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.496384] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.496768] pnp 00:00: [io  0x0d00-0xffff window]
[    0.497154] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.497661] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.498094] device: '00:00': device_add
[    0.498448] bus: 'pnp': add device 00:00
[    0.498785] PM: Adding info for pnp:00:00
[    0.499125] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.499736] pnp 00:01: [io  0x0070-0x0071]
[    0.499736] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.499736] pnp 00:01: [irq 8]
[    0.499736] pnp 00:01: [io  0x0072-0x0077]
[    0.499736] device: '00:01': device_add
[    0.499736] bus: 'pnp': add device 00:01
[    0.499736] PM: Adding info for pnp:00:01
[    0.499736] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.499736] pnp 00:02: [io  0x0060]
[    0.499736] pnp 00:02: [io  0x0064]
[    0.499736] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.500295] pnp 00:02: [irq 1]
[    0.500560] device: '00:02': device_add
[    0.500894] bus: 'pnp': add device 00:02
[    0.501233] PM: Adding info for pnp:00:02
[    0.501574] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.502153] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.502822] pnp 00:03: [irq 12]
[    0.503099] device: '00:03': device_add
[    0.503423] bus: 'pnp': add device 00:03
[    0.503785] PM: Adding info for pnp:00:03
[    0.504110] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.504674] pnp 00:04: [io  0x03f2-0x03f5]
[    0.505011] pnp 00:04: [io  0x03f7]
[    0.505302] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.506013] pnp 00:04: [irq 6]
[    0.506259] pnp 00:04: [dma 2]
[    0.506534] device: '00:04': device_add
[    0.506868] bus: 'pnp': add device 00:04
[    0.507206] PM: Adding info for pnp:00:04
[    0.507555] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.508140] pnp 00:05: [io  0x0378-0x037f]
[    0.508473] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.509122] pnp 00:05: [irq 7]
[    0.509376] device: '00:05': device_add
[    0.509722] bus: 'pnp': add device 00:05
[    0.510055] PM: Adding info for pnp:00:05
[    0.510381] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.510965] pnp 00:06: [io  0x03f8-0x03ff]
[    0.511309] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.511968] pnp 00:06: [irq 4]
[    0.512218] device: '00:06': device_add
[    0.512550] bus: 'pnp': add device 00:06
[    0.512924] PM: Adding info for pnp:00:06
[    0.513262] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.514084] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.514503] device: '00:07': device_add
[    0.514869] bus: 'pnp': add device 00:07
[    0.515208] PM: Adding info for pnp:00:07
[    0.515554] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.516366] pnp: PnP ACPI: found 8 devices
[    0.516718] ACPI: ACPI bus type pnp unregistered
[    0.517119] device class 'mem': registering
[    0.517474] device: 'mem': device_add
[    0.517944] PM: Adding info for No Bus:mem
[    0.518302] device: 'kmem': device_add
[    0.518783] PM: Adding info for No Bus:kmem
[    0.519151] device: 'null': device_add
[    0.519711] PM: Adding info for No Bus:null
[    0.520079] device: 'port': device_add
[    0.520633] PM: Adding info for No Bus:port
[    0.521013] device: 'zero': device_add
[    0.521604] PM: Adding info for No Bus:zero
[    0.522012] device: 'full': device_add
[    0.522538] PM: Adding info for No Bus:full
[    0.522908] device: 'random': device_add
[    0.523461] PM: Adding info for No Bus:random
[    0.523910] device: 'urandom': device_add
[    0.524367] PM: Adding info for No Bus:urandom
[    0.524756] device: 'kmsg': device_add
[    0.525158] PM: Adding info for No Bus:kmsg
[    0.525660] device: 'tty': device_add
[    0.526119] PM: Adding info for No Bus:tty
[    0.526472] device: 'console': device_add
[    0.526909] PM: Adding info for No Bus:console
[    0.527283] device class 'thermal': registering
[    0.562345] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.562806] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.563257] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.563767] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.564306] NET: Registered protocol family 1
[    0.564692] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.565186] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.565737] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.566266] pci 0000:00:02.0: Boot video device
[    0.566723] PCI: CLS 0 bytes, default 64
[    0.567177] Unpacking initramfs...
[    1.270430] debug: unmapping init [mem 0xce73f000-0xcffeffff]
[    1.271189] Registering platform device 'pcspkr'. Parent at platform
[    1.271712] device: 'pcspkr': device_add
[    1.272046] bus: 'platform': add device pcspkr
[    1.272436] PM: Adding info for platform:pcspkr
[    1.273111] bus: 'clocksource': registered
[    1.273463] device: 'clocksource': device_add
[    1.273871] PM: Adding info for No Bus:clocksource
[    1.274266] device: 'clocksource0': device_add
[    1.274664] bus: 'clocksource': add device clocksource0
[    1.275127] PM: Adding info for clocksource:clocksource0
[    1.275622] bus: 'platform': add driver alarmtimer
[    1.276153] Registering platform device 'alarmtimer'. Parent at platform
[    1.276711] device: 'alarmtimer': device_add
[    1.277064] bus: 'platform': add device alarmtimer
[    1.277461] PM: Adding info for platform:alarmtimer
[    1.277876] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    1.278597] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    1.279287] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    1.279865] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    1.280549] bus: 'rttest': registered
[    1.280858] device: 'rttest': device_add
[    1.281191] PM: Adding info for No Bus:rttest
[    1.281792] device: 'rttest0': device_add
[    1.282162] bus: 'rttest': add device rttest0
[    1.282638] PM: Adding info for rttest:rttest0
[    1.283116] device: 'rttest1': device_add
[    1.283453] bus: 'rttest': add device rttest1
[    1.283837] PM: Adding info for rttest:rttest1
[    1.284295] device: 'rttest2': device_add
[    1.284642] bus: 'rttest': add device rttest2
[    1.285014] PM: Adding info for rttest:rttest2
[    1.285483] device: 'rttest3': device_add
[    1.285898] bus: 'rttest': add device rttest3
[    1.286280] PM: Adding info for rttest:rttest3
[    1.286753] device: 'rttest4': device_add
[    1.287123] bus: 'rttest': add device rttest4
[    1.287530] PM: Adding info for rttest:rttest4
[    1.288014] device: 'rttest5': device_add
[    1.288362] bus: 'rttest': add device rttest5
[    1.288741] PM: Adding info for rttest:rttest5
[    1.289204] device: 'rttest6': device_add
[    1.289558] bus: 'rttest': add device rttest6
[    1.289921] PM: Adding info for rttest:rttest6
[    1.290368] device: 'rttest7': device_add
[    1.290727] bus: 'rttest': add device rttest7
[    1.291116] PM: Adding info for rttest:rttest7
[    1.291497] Initializing RT-Tester: OK
[    1.291849] audit: initializing netlink socket (disabled)
[    1.292304] type=2000 audit(1346950247.280:1): initialized
[    1.299524] Kprobe smoke test started
[    1.525788] Kprobe smoke test passed successfully
[    1.526638] bus: 'event_source': registered
[    1.527154] device: 'breakpoint': device_add
[    1.527593] bus: 'event_source': add device breakpoint
[    1.528022] PM: Adding info for event_source:breakpoint
[    1.528452] device: 'software': device_add
[    1.528810] bus: 'event_source': add device software
[    1.529229] PM: Adding info for event_source:software
[    1.533879] msgmni has been set to 413
[    1.535594] alg: No test for stdrng (krng)
[    1.536102] device class 'bsg': registering
[    1.536466] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.537077] io scheduler noop registered (default)
[    1.537474] start plist test
[    1.539687] end plist test
[    1.540358] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    1.540802] crc32: self tests passed, processed 225944 bytes in 207570 nsec
[    1.541793] crc32c: CRC_LE_BITS = 32
[    1.542274] crc32c: self tests passed, processed 225944 bytes in 118750 nsec
[    1.543246] bus: 'acpi': add driver ac
[    1.543681] bus: 'acpi': add driver button
[    1.544042] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    1.544728] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    1.545418] device: 'input0': device_add
[    1.545890] PM: Adding info for No Bus:input0
[    1.546276] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.546923] ACPI: Power Button [PWRF]
[    1.547243] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    1.547823] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    1.548424] bus: 'acpi': add driver fan
[    1.548794] bus: 'acpi': add driver processor
[    1.549235] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[    1.549922] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[    1.550763] device: 'cooling_device0': device_add
[    1.551180] PM: Adding info for No Bus:cooling_device0
[    1.551639] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[    1.552175] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[    1.552776] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[    1.553440] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[    1.554336] device: 'cooling_device1': device_add
[    1.554849] PM: Adding info for No Bus:cooling_device1
[    1.555276] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[    1.555916] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[    1.559696] bus: 'acpi': add driver container
[    1.561770] bus: 'acpi': add driver thermal
[    1.562199] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.562764] bus: 'acpi': add driver battery
[    1.563180] Registering platform device 'serial8250'. Parent at platform
[    1.563732] device: 'serial8250': device_add
[    1.564071] bus: 'platform': add device serial8250
[    1.564463] PM: Adding info for platform:serial8250

[    1.866749] device: 'ttyS0': device_add
[    1.867256] PM: Adding info for No Bus:ttyS0
[    1.867674] device: 'ttyS1': device_add
[    1.868196] PM: Adding info for No Bus:ttyS1
[    1.868620] device: 'ttyS2': device_add
[    1.869105] PM: Adding info for No Bus:ttyS2
[    1.869554] device: 'ttyS3': device_add
[    1.870003] PM: Adding info for No Bus:ttyS3
[    1.870375] bus: 'platform': add driver serial8250
[    1.870779] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    1.871505] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    1.872181] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    1.872759] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    1.873436] bus: 'pnp': add driver serial
[    1.873798] bus: 'pnp': driver_probe_device: matched device 00:06 with driver serial
[    1.874405] bus: 'pnp': really_probe: probing driver serial with device 00:06
[    1.875078] device: 'ttyS0': device_unregister
[    1.875434] PM: Removing info for No Bus:ttyS0
[    1.876344] ------------[ cut here ]------------
[    1.876762] WARNING: at /c/kernel-tests/src/stable/drivers/base/core.c:196 device_release+0x6e/0x80()
[    1.877550] Device 'ttyS0' does not have a release() function, it is broken and must be fixed.
[    1.878247] Modules linked in:
[    1.878552] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc3-00189-g6915c0e #176
[    1.879209] Call Trace:
[    1.879419]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    1.879861]  [<c11de0ee>] ? device_release+0x6e/0x80
[    1.880268]  [<c11de0ee>] ? device_release+0x6e/0x80
[    1.880682]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    1.881090]  [<c11de0ee>] device_release+0x6e/0x80
[    1.881479]  [<c1164e86>] kobject_cleanup+0x36/0x80
[    1.881942]  [<c1164f05>] kobject_put+0x25/0x60
[    1.882306]  [<c11ddeff>] ? put_device+0xf/0x20
[    1.882746]  [<c11deccc>] ? device_del+0x12c/0x160
[    1.883140]  [<c11ddeff>] put_device+0xf/0x20
[    1.883551]  [<c11ded36>] device_unregister+0x36/0x50
[    1.883963]  [<c11ded7d>] device_destroy+0x2d/0x40
[    1.884346]  [<c11dde40>] ? class_dir_child_ns_type+0x10/0x10
[    1.884821]  [<c11c4736>] tty_unregister_device+0x26/0x50
[    1.885314]  [<c11d0472>] uart_remove_one_port+0x82/0xf0
[    1.885830]  [<c11d44bd>] serial8250_register_8250_port+0x6d/0x280
[    1.886321]  [<c1250c37>] ? check_name+0x2f/0x2f
[    1.886711]  [<c1250d9d>] serial_pnp_probe+0x166/0x1ff
[    1.887126]  [<c11bf0f7>] pnp_device_probe+0x57/0xc0
[    1.887592]  [<c11e187b>] driver_probe_device+0xdb/0x2e0
[    1.888020]  [<c11e1b11>] __driver_attach+0x91/0xa0
[    1.888403]  [<c11e1a80>] ? driver_probe_device+0x2e0/0x2e0
[    1.888864]  [<c11dfe78>] bus_for_each_dev+0x38/0x70
[    1.889269]  [<c11e1319>] driver_attach+0x19/0x20
[    1.889721]  [<c11e1a80>] ? driver_probe_device+0x2e0/0x2e0
[    1.890157]  [<c11e0ec6>] bus_add_driver+0xd6/0x240
[    1.890567]  [<c11bef00>] ? pnp_device_detach+0x40/0x40
[    1.890982]  [<c11e20d5>] driver_register+0x65/0x160
[    1.891381]  [<c11e2ebb>] ? platform_driver_register+0x3b/0x40
[    1.891877]  [<c13becdd>] ? early_serial_setup+0xd2/0xd2
[    1.892295]  [<c11beeb7>] pnp_register_driver+0x17/0x20
[    1.892724]  [<c13becea>] serial8250_pnp_init+0xd/0xf
[    1.893185]  [<c1001202>] do_one_initcall+0x112/0x160
[    1.893605]  [<c139fa5a>] kernel_init+0xf7/0x18e
[    1.893987]  [<c139f423>] ? do_early_param+0x7a/0x7a
[    1.894394]  [<c139f963>] ? start_kernel+0x324/0x324
[    1.894818]  [<c12697b6>] kernel_thread_helper+0x6/0xd
[    1.895321] ---[ end trace 78fd85ae6d011309 ]---
[    1.916971] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.917488] device: 'ttyS0': device_add
[    1.917946] PM: Adding info for No Bus:ttyS0
[    1.918317] driver: '00:06': driver_bound: bound to device 'serial'
[    1.918921] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[    1.919479] bus: 'pci': add driver serial
[    1.919975] device: 'ttyprintk': device_add
[    1.920395] PM: Adding info for No Bus:ttyprintk
[    1.920793] bus: 'pnp': add driver tpm_tis
[    1.921164] bus: 'pnp': add driver i8042 kbd
[    1.921529] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 kbd
[    1.922149] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:02
[    1.922749] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    1.923267] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd
[    1.923857] bus: 'pnp': add driver i8042 aux
[    1.924200] bus: 'pnp': driver_probe_device: matched device 00:03 with driver i8042 aux
[    1.924838] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03
[    1.925528] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    1.926119] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 aux
[    1.926796] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.927465] Registering platform device 'i8042'. Parent at platform
[    1.928034] device: 'i8042': device_add
[    1.928356] bus: 'platform': add device i8042
[    1.928761] PM: Adding info for platform:i8042
[    1.929134] bus: 'platform': add driver i8042
[    1.929514] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    1.930172] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    1.931386] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.931871] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.932313] device: 'serio0': device_add
[    1.932713] bus: 'serio': add device serio0
[    1.933114] PM: Adding info for serio:serio0
[    1.933500] device: 'serio1': device_add
[    1.933830] bus: 'serio': add device serio1
[    1.934236] PM: Adding info for serio:serio1
[    1.934621] driver: 'i8042': driver_bound: bound to device 'i8042'
[    1.935154] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    1.935835] bus: 'serio': add driver atkbd
[    1.936196] cpuidle: using governor ladder
[    1.936684] 
[    1.936684] printing PIC contents
[    1.937112] ... PIC  IMR: ffff
[    1.937364] ... PIC  IRR: 1013
[    1.937625] ... PIC  ISR: 0000
[    1.937880] ... PIC ELCR: 0c00
[    1.938178] printing local APIC contents on CPU#0/0:
[    1.938598] ... APIC ID:      00000000 (0)
[    1.938935] ... APIC VERSION: 00050014
[    1.939245] ... APIC TASKPRI: 00000000 (00)
[    1.939593] ... APIC PROCPRI: 00000000
[    1.939902] ... APIC LDR: 01000000
[    1.940183] ... APIC DFR: ffffffff
[    1.940464] ... APIC SPIV: 000001ff
[    1.940753] ... APIC ISR field:
[    1.941063] 0000000000000000000000000000000000000000000000000000000000000000
[    1.941751] ... APIC TMR field:
[    1.942013] 0000000000000000000000000000000000000000000000000000000000000000
[    1.942787] ... APIC IRR field:
[    1.943051] 0000000000000000000000000000000000000000000000000000000000000000
[    1.943747] ... APIC ESR: 00000000
[    1.944032] ... APIC ICR: 000008fd
[    1.944312] ... APIC ICR2: 02000000
[    1.944606] ... APIC LVTT: 000200ef
[    1.944895] ... APIC LVTPC: 00010000
[    1.945191] ... APIC LVT0: 00010700
[    1.945483] ... APIC LVT1: 00000400
[    1.945734] ... APIC LVTERR: 000000fe
[    1.945734] ... APIC TMICT: 00098989
[    1.945734] ... APIC TMCCT: 0008d8c9
[    1.945734] ... APIC TDCR: 00000003
[    1.945734] 
[    1.947152] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    1.947870] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    1.948854] device: 'input1': device_add
[    1.949298] PM: Adding info for No Bus:input1
[    1.949703] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.950451] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    1.950949] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    1.951567] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    1.952181] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    1.952985] number of MP IRQ sources: 15.
[    1.953440] atkbd: probe of serio1 rejects match -19
[    1.953840] number of IO-APIC #2 registers: 24.
[    1.954192] testing the IO APIC.......................
[    1.954629] IO APIC #2......
[    1.954856] .... register #00: 00000000
[    1.955206] .......    : physical APIC id: 00
[    1.955569] .......    : Delivery Type: 0
[    1.955980] .......    : LTS          : 0
[    1.956293] .... register #01: 00170011
[    1.956675] .......     : max redirection entries: 17
[    1.957155] .......     : PRQ implemented: 0
[    1.957504] .......     : IO APIC version: 11
[    1.957856] .... register #02: 00000000
[    1.958166] .......     : arbitration: 00
[    1.958494] .... IRQ redirection table:
[    1.958805]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    1.959284]  00 00  1    0    0   0   0    0    0    00
[    1.959757]  01 03  0    0    0   0   0    1    1    31
[    1.960197]  02 03  0    0    0   0   0    1    1    30
[    1.960700]  03 03  1    0    0   0   0    1    1    33
[    1.961172]  04 03  1    0    0   0   0    1    1    34
[    1.961624]  05 03  1    1    0   0   0    1    1    35
[    1.962047]  06 03  1    0    0   0   0    1    1    36
[    1.962468]  07 03  1    0    0   0   0    1    1    37
[    1.962918]  08 03  1    0    0   0   0    1    1    38
[    1.963401]  09 03  0    1    0   0   0    1    1    39
[    1.963853]  0a 03  1    1    0   0   0    1    1    3A
[    1.964276]  0b 03  1    1    0   0   0    1    1    3B
[    1.964860]  0c 03  0    0    0   0   0    1    1    3C
[    1.965378]  0d 03  1    0    0   0   0    1    1    3D
[    1.965922]  0e 03  1    0    0   0   0    1    1    3E
[    1.966429]  0f 03  1    0    0   0   0    1    1    3F
[    1.966866]  10 00  1    0    0   0   0    0    0    00
[    1.967341]  11 00  1    0    0   0   0    0    0    00
[    1.967787]  12 00  1    0    0   0   0    0    0    00
[    1.968209]  13 00  1    0    0   0   0    0    0    00
[    1.968811]  14 00  1    0    0   0   0    0    0    00
[    1.969283]  15 00  1    0    0   0   0    0    0    00
[    1.969727]  16 00  1    0    0   0   0    0    0    00
[    1.970173]  17 00  1    0    0   0   0    0    0    00
[    1.970610] IRQ to pin mappings:
[    1.970864] IRQ0 -> 0:2
[    1.971137] IRQ1 -> 0:1
[    1.971354] IRQ3 -> 0:3
[    1.971601] IRQ4 -> 0:4
[    1.971819] IRQ5 -> 0:5
[    1.972038] IRQ6 -> 0:6
[    1.972256] IRQ7 -> 0:7
[    1.972569] IRQ8 -> 0:8
[    1.972812] IRQ9 -> 0:9
[    1.973119] IRQ10 -> 0:10
[    1.973362] IRQ11 -> 0:11
[    1.973609] IRQ12 -> 0:12
[    1.973851] IRQ13 -> 0:13
[    1.974094] IRQ14 -> 0:14
[    1.974335] IRQ15 -> 0:15
[    1.974641] .................................... done.
[    1.975102] Using IPI No-Shortcut mode
[    1.975428] device: 'cpu_dma_latency': device_add
[    1.975961] PM: Adding info for No Bus:cpu_dma_latency
[    1.976388] device: 'network_latency': device_add
[    1.976887] PM: Adding info for No Bus:network_latency
[    1.977365] device: 'network_throughput': device_add
[    1.977797] PM: Adding info for No Bus:network_throughput
[    1.978267] registered taskstats version 1
[    1.980342] ------------[ cut here ]------------
[    1.981036] WARNING: at /c/kernel-tests/src/stable/drivers/tty/tty_io.c:1420 tty_init_dev+0x184/0x1a0()
[    1.981833] tty_init_dev: ttyS driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    1.982704] Modules linked in:
[    1.983001] Pid: 48, comm: modprobe Tainted: G        W    3.6.0-rc3-00189-g6915c0e #176
[    1.983649] Call Trace:
[    1.983845]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    1.984256]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    1.984752]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    1.985189]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    1.985600]  [<c11c6904>] tty_init_dev+0x184/0x1a0
[    1.986073]  [<c102bff2>] ? console_device+0x42/0x50
[    1.986462]  [<c11c7254>] tty_open+0x454/0x4e0
[    1.986846]  [<c10d5c2d>] chrdev_open+0x6d/0x1a0
[    1.987263]  [<c10cfe58>] do_dentry_open+0x1d8/0x290
[    1.987676]  [<c10dc564>] ? __inode_permission+0x34/0x80
[    1.988084]  [<c10d5bc0>] ? cdev_put+0x10/0x10
[    1.988428]  [<c10cff3d>] finish_open+0x2d/0x40
[    1.988979]  [<c10df48b>] do_last+0x63b/0xc30
[    1.989332]  [<c10dc5c1>] ? inode_permission+0x11/0x50
[    1.989751]  [<c10dc652>] ? link_path_walk+0x52/0x740
[    1.990158]  [<c10dcff1>] ? path_init+0x1e1/0x460
[    1.990541]  [<c10dfb18>] path_openat+0x98/0x3d0
[    1.990915]  [<c1054001>] ? sched_clock_cpu+0xf1/0x1a0
[    1.991332]  [<c10e002c>] do_filp_open+0x2c/0x80
[    1.991710]  [<c10eb927>] ? alloc_fd+0x97/0xe0
[    1.992071]  [<c10d0fb0>] do_sys_open+0xe0/0x1b0
[    1.992457]  [<c1042fc6>] ? task_work_run+0x36/0x80
[    1.992874]  [<c10d10ad>] sys_open+0x2d/0x40
[    1.993260]  [<c1269218>] sysenter_do_call+0x12/0x33
[    1.993668]  [<c103007b>] ? tasklet_kill+0x2b/0x60
[    1.994039] ---[ end trace 78fd85ae6d01130b ]---
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

[    1.997103] ------------[ cut here ]------------
[    1.997495] WARNING: at /c/kernel-tests/src/stable/drivers/tty/tty_io.c:1420 tty_init_dev+0x184/0x1a0()
[    1.998305] tty_init_dev: ttyS driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    1.999151] Modules linked in:
[    1.999404] Pid: 50, comm: modprobe Tainted: G        W    3.6.0-rc3-00189-g6915c0e #176
[    2.000048] Call Trace:
[    2.000244]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    2.000859]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.001295]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.001700]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    2.002092]  [<c11c6904>] tty_init_dev+0x184/0x1a0
[    2.002465]  [<c102bff2>] ? console_device+0x42/0x50
[    2.002877]  [<c11c7254>] tty_open+0x454/0x4e0
[    2.003274]  [<c10d5c2d>] chrdev_open+0x6d/0x1a0
[    2.003657]  [<c11366ac>] ? security_file_open+0x6c/0x70
[    2.004068]  [<c10cfe58>] do_dentry_open+0x1d8/0x290
[    2.004537]  [<c10dc564>] ? __inode_permission+0x34/0x80
[    2.005087]  [<c10d5bc0>] ? cdev_put+0x10/0x10
[    2.005445]  [<c10cff3d>] finish_open+0x2d/0x40
[    2.005916]  [<c10df48b>] do_last+0x63b/0xc30
[    2.006269]  [<c10dc5c1>] ? inode_permission+0x11/0x50
[    2.006688]  [<c10dc652>] ? link_path_walk+0x52/0x740
[    2.007100]  [<c10dcff1>] ? path_init+0x1e1/0x460
[    2.007480]  [<c10dfb18>] path_openat+0x98/0x3d0
[    2.007856]  [<c1054001>] ? sched_clock_cpu+0xf1/0x1a0
[    2.008268]  [<c10e002c>] do_filp_open+0x2c/0x80
[    2.008684]  [<c10eb927>] ? alloc_fd+0x97/0xe0
[    2.009092]  [<c10d0fb0>] do_sys_open+0xe0/0x1b0
[    2.009459]  [<c1042fc6>] ? task_work_run+0x36/0x80
[    2.009939]  [<c10d10ad>] sys_open+0x2d/0x40
[    2.010271]  [<c1269218>] sysenter_do_call+0x12/0x33
[    2.010759]  [<c103007b>] ? tasklet_kill+0x2b/0x60
[    2.011177] ---[ end trace 78fd85ae6d01130c ]---
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

[    2.012960] Key type encrypted registered
[    2.014524] ------------[ cut here ]------------
[    2.014908] WARNING: at /c/kernel-tests/src/stable/drivers/tty/tty_io.c:1420 tty_init_dev+0x184/0x1a0()
[    2.015855] tty_init_dev: ttyS driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    2.016768] Modules linked in:
[    2.017104] Pid: 54, comm: modprobe Tainted: G        W    3.6.0-rc3-00189-g6915c0e #176
[    2.017782] Call Trace:
[    2.017980]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    2.018387]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.018773]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.019207]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    2.019630]  [<c11c6904>] tty_init_dev+0x184/0x1a0
[    2.020004]  [<c102bff2>] ? console_device+0x42/0x50
[    2.020388]  [<c11c7254>] tty_open+0x454/0x4e0
[    2.020850]  [<c10d5c2d>] chrdev_open+0x6d/0x1a0
[    2.021304]  [<c11366ac>] ? security_file_open+0x6c/0x70
[    2.021768]  [<c10cfe58>] do_dentry_open+0x1d8/0x290
[    2.022169]  [<c10dc564>] ? __inode_permission+0x34/0x80
[    2.022631]  [<c10d5bc0>] ? cdev_put+0x10/0x10
[    2.023023]  [<c10cff3d>] finish_open+0x2d/0x40
[    2.023390]  [<c10df48b>] do_last+0x63b/0xc30
[    2.023783]  [<c10dc5c1>] ? inode_permission+0x11/0x50
[    2.024229]  [<c10dc652>] ? link_path_walk+0x52/0x740
[    2.024702]  [<c10dcff1>] ? path_init+0x1e1/0x460
[    2.025085]  [<c10dfb18>] path_openat+0x98/0x3d0
[    2.025458]  [<c1054001>] ? sched_clock_cpu+0xf1/0x1a0
[    2.026032]  [<c10e002c>] do_filp_open+0x2c/0x80
[    2.026414]  [<c10eb927>] ? alloc_fd+0x97/0xe0
[    2.026808]  [<c10d0fb0>] do_sys_open+0xe0/0x1b0
[    2.027215]  [<c1042fc6>] ? task_work_run+0x36/0x80
[    2.027621]  [<c10d10ad>] sys_open+0x2d/0x40
[    2.027957]  [<c1269218>] sysenter_do_call+0x12/0x33
[    2.028343]  [<c103007b>] ? tasklet_kill+0x2b/0x60
[    2.028870] ---[ end trace 78fd85ae6d01130d ]---
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

[    2.031720] ------------[ cut here ]------------
[    2.032092] WARNING: at /c/kernel-tests/src/stable/drivers/tty/tty_io.c:1420 tty_init_dev+0x184/0x1a0()
[    2.033010] tty_init_dev: ttyS driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    2.033814] Modules linked in:
[    2.034094] Pid: 56, comm: modprobe Tainted: G        W    3.6.0-rc3-00189-g6915c0e #176
[    2.034767] Call Trace:
[    2.035016]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    2.035433]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.035934]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.036321]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    2.036835]  [<c11c6904>] tty_init_dev+0x184/0x1a0
[    2.037303]  [<c102bff2>] ? console_device+0x42/0x50
[    2.037709]  [<c11c7254>] tty_open+0x454/0x4e0
[    2.038068]  [<c10d5c2d>] chrdev_open+0x6d/0x1a0
[    2.038441]  [<c11366ac>] ? security_file_open+0x6c/0x70
[    2.038873]  [<c10cfe58>] do_dentry_open+0x1d8/0x290
[    2.039350]  [<c10dc564>] ? __inode_permission+0x34/0x80
[    2.039814]  [<c10d5bc0>] ? cdev_put+0x10/0x10
[    2.040172]  [<c10cff3d>] finish_open+0x2d/0x40
[    2.040573]  [<c10df48b>] do_last+0x63b/0xc30
[    2.041010]  [<c10dc5c1>] ? inode_permission+0x11/0x50
[    2.041419]  [<c10dc652>] ? link_path_walk+0x52/0x740
[    2.041839]  [<c10dcff1>] ? path_init+0x1e1/0x460
[    2.042203]  [<c10dfb18>] path_openat+0x98/0x3d0
[    2.042588]  [<c1054001>] ? sched_clock_cpu+0xf1/0x1a0
[    2.043033]  [<c10e002c>] do_filp_open+0x2c/0x80
[    2.043397]  [<c10eb927>] ? alloc_fd+0x97/0xe0
[    2.043765]  [<c10d0fb0>] do_sys_open+0xe0/0x1b0
[    2.044122]  [<c1042fc6>] ? task_work_run+0x36/0x80
[    2.044613]  [<c10d10ad>] sys_open+0x2d/0x40
[    2.045073]  [<c1269218>] sysenter_do_call+0x12/0x33
[    2.045478]  [<c103007b>] ? tasklet_kill+0x2b/0x60
[    2.046005] ---[ end trace 78fd85ae6d01130e ]---
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

[    2.047679] IMA: No TPM chip found, activating TPM-bypass!
[    2.048973] ------------[ cut here ]------------
[    2.049352] WARNING: at /c/kernel-tests/src/stable/drivers/tty/tty_io.c:1420 tty_init_dev+0x184/0x1a0()
[    2.050123] tty_init_dev: ttyS driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    2.050919] Modules linked in:
[    2.051208] Pid: 1, comm: swapper/0 Tainted: G        W    3.6.0-rc3-00189-g6915c0e #176
[    2.051924] Call Trace:
[    2.052119]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    2.052701]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.053186]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.053622]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    2.054031]  [<c11c6904>] tty_init_dev+0x184/0x1a0
[    2.054418]  [<c102bff2>] ? console_device+0x42/0x50
[    2.054823]  [<c11c7254>] tty_open+0x454/0x4e0
[    2.055185]  [<c10d5c2d>] chrdev_open+0x6d/0x1a0
[    2.055589]  [<c11366ac>] ? security_file_open+0x6c/0x70
[    2.056128]  [<c10cfe58>] do_dentry_open+0x1d8/0x290
[    2.056569]  [<c10dc564>] ? __inode_permission+0x34/0x80
[    2.057076]  [<c10d5bc0>] ? cdev_put+0x10/0x10
[    2.057432]  [<c10cff3d>] finish_open+0x2d/0x40
[    2.057811]  [<c10df48b>] do_last+0x63b/0xc30
[    2.058152]  [<c10dc5c1>] ? inode_permission+0x11/0x50
[    2.058557]  [<c10dc652>] ? link_path_walk+0x52/0x740
[    2.058946]  [<c10dcff1>] ? path_init+0x1e1/0x460
[    2.059366]  [<c10dfb18>] path_openat+0x98/0x3d0
[    2.059751]  [<c1054001>] ? sched_clock_cpu+0xf1/0x1a0
[    2.060148]  [<c10e002c>] do_filp_open+0x2c/0x80
[    2.060584]  [<c10eb927>] ? alloc_fd+0x97/0xe0
[    2.061077]  [<c10d0fb0>] do_sys_open+0xe0/0x1b0
[    2.061449]  [<c11d8b33>] ? get_random_bytes+0x23/0x30
[    2.061867]  [<c10d10ad>] sys_open+0x2d/0x40
[    2.062279]  [<c139fa89>] kernel_init+0x126/0x18e
[    2.062673]  [<c139f423>] ? do_early_param+0x7a/0x7a
[    2.063114]  [<c139f963>] ? start_kernel+0x324/0x324
[    2.063525]  [<c12697b6>] kernel_thread_helper+0x6/0xd
[    2.063927] ---[ end trace 78fd85ae6d01130f ]---
[    2.064535] debug: unmapping init [mem 0xc139f000-0xc1529fff]
[    2.071878] ------------[ cut here ]------------
[    2.072252] WARNING: at /c/kernel-tests/src/stable/drivers/tty/tty_io.c:1420 tty_init_dev+0x184/0x1a0()
[    2.073158] tty_init_dev: ttyS driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    2.073956] Modules linked in:
[    2.074210] Pid: 62, comm: modprobe Tainted: G        W    3.6.0-rc3-00189-g6915c0e #176
[    2.074855] Call Trace:
[    2.075109]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    2.075546]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.076064]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.076460]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    2.076993]  [<c11c6904>] tty_init_dev+0x184/0x1a0
[    2.077384]  [<c102bff2>] ? console_device+0x42/0x50
[    2.077816]  [<c11c7254>] tty_open+0x454/0x4e0
[    2.078241]  [<c10d5c2d>] chrdev_open+0x6d/0x1a0
[    2.078650]  [<c11366ac>] ? security_file_open+0x6c/0x70
[    2.079111]  [<c10cfe58>] do_dentry_open+0x1d8/0x290
[    2.079521]  [<c10dc564>] ? __inode_permission+0x34/0x80
[    2.079940]  [<c10d5bc0>] ? cdev_put+0x10/0x10
[    2.080286]  [<c10cff3d>] finish_open+0x2d/0x40
[    2.080728]  [<c10df48b>] do_last+0x63b/0xc30
[    2.081100]  [<c10dc5c1>] ? inode_permission+0x11/0x50
[    2.081522]  [<c10dc652>] ? link_path_walk+0x52/0x740
[    2.081919]  [<c10dcff1>] ? path_init+0x1e1/0x460
[    2.082281]  [<c10dfb18>] path_openat+0x98/0x3d0
[    2.082668]  [<c1054001>] ? sched_clock_cpu+0xf1/0x1a0
[    2.083116]  [<c10e002c>] do_filp_open+0x2c/0x80
[    2.083476]  [<c10eb927>] ? alloc_fd+0x97/0xe0
[    2.083850]  [<c10d0fb0>] do_sys_open+0xe0/0x1b0
[    2.084208]  [<c1042fc6>] ? task_work_run+0x36/0x80
[    2.084672]  [<c10d10ad>] sys_open+0x2d/0x40
[    2.085061]  [<c1269218>] sysenter_do_call+0x12/0x33
[    2.085462]  [<c103007b>] ? tasklet_kill+0x2b/0x60
[    2.085956] ---[ end trace 78fd85ae6d011310 ]---
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

[    2.088559] ------------[ cut here ]------------
[    2.088943] WARNING: at /c/kernel-tests/src/stable/drivers/tty/tty_io.c:1420 tty_init_dev+0x184/0x1a0()
[    2.089752] tty_init_dev: ttyS driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    2.090592] Modules linked in:
[    2.090846] Pid: 64, comm: modprobe Tainted: G        W    3.6.0-rc3-00189-g6915c0e #176
[    2.091538] Call Trace:
[    2.091738]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    2.092147]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.092628]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.093146]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    2.093559]  [<c11c6904>] tty_init_dev+0x184/0x1a0
[    2.093946]  [<c102bff2>] ? console_device+0x42/0x50
[    2.094415]  [<c11c7254>] tty_open+0x454/0x4e0
[    2.094809]  [<c10d5c2d>] chrdev_open+0x6d/0x1a0
[    2.095215]  [<c11366ac>] ? security_file_open+0x6c/0x70
[    2.095653]  [<c10cfe58>] do_dentry_open+0x1d8/0x290
[    2.096125]  [<c10dc564>] ? __inode_permission+0x34/0x80
[    2.096631]  [<c10d5bc0>] ? cdev_put+0x10/0x10
[    2.097049]  [<c10cff3d>] finish_open+0x2d/0x40
[    2.097408]  [<c10df48b>] do_last+0x63b/0xc30
[    2.097774]  [<c10dc5c1>] ? inode_permission+0x11/0x50
[    2.098172]  [<c10dc652>] ? link_path_walk+0x52/0x740
[    2.098587]  [<c10dcff1>] ? path_init+0x1e1/0x460
[    2.098951]  [<c10dfb18>] path_openat+0x98/0x3d0
[    2.099365]  [<c1054001>] ? sched_clock_cpu+0xf1/0x1a0
[    2.099790]  [<c10e002c>] do_filp_open+0x2c/0x80
[    2.100149]  [<c10eb927>] ? alloc_fd+0x97/0xe0
[    2.100566]  [<c10d0fb0>] do_sys_open+0xe0/0x1b0
[    2.101043]  [<c1042fc6>] ? task_work_run+0x36/0x80
[    2.101434]  [<c10d10ad>] sys_open+0x2d/0x40
[    2.101815]  [<c1269218>] sysenter_do_call+0x12/0x33
[    2.102215]  [<c103007b>] ? tasklet_kill+0x2b/0x60
[    2.102604] ---[ end trace 78fd85ae6d011311 ]---
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

[    2.106049] ------------[ cut here ]------------
[    2.106447] WARNING: at /c/kernel-tests/src/stable/drivers/tty/tty_io.c:1420 tty_init_dev+0x184/0x1a0()
[    2.107240] tty_init_dev: ttyS driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    2.108056] Modules linked in:
[    2.108322] Pid: 67, comm: modprobe Tainted: G        W    3.6.0-rc3-00189-g6915c0e #176
[    2.109086] Call Trace:
[    2.109294]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    2.109727]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.110194]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.110647]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    2.111105]  [<c11c6904>] tty_init_dev+0x184/0x1a0
[    2.111544]  [<c102bff2>] ? console_device+0x42/0x50
[    2.111946]  [<c11c7254>] tty_open+0x454/0x4e0
[    2.112309]  [<c10d5c2d>] chrdev_open+0x6d/0x1a0
[    2.112858]  [<c11366ac>] ? security_file_open+0x6c/0x70
[    2.113371]  [<c10cfe58>] do_dentry_open+0x1d8/0x290
[    2.113861]  [<c10dc564>] ? __inode_permission+0x34/0x80
[    2.114269]  [<c10d5bc0>] ? cdev_put+0x10/0x10
[    2.114716]  [<c10cff3d>] finish_open+0x2d/0x40
[    2.115090]  [<c10df48b>] do_last+0x63b/0xc30
[    2.115430]  [<c10dc5c1>] ? inode_permission+0x11/0x50
[    2.115976]  [<c10dc652>] ? link_path_walk+0x52/0x740
[    2.116372]  [<c10dcff1>] ? path_init+0x1e1/0x460
[    2.116860]  [<c10dfb18>] path_openat+0x98/0x3d0
[    2.117280]  [<c1054001>] ? sched_clock_cpu+0xf1/0x1a0
[    2.117699]  [<c10e002c>] do_filp_open+0x2c/0x80
[    2.118071]  [<c10eb927>] ? alloc_fd+0x97/0xe0
[    2.118433]  [<c10d0fb0>] do_sys_open+0xe0/0x1b0
[    2.118814]  [<c1042fc6>] ? task_work_run+0x36/0x80
[    2.119211]  [<c10d10ad>] sys_open+0x2d/0x40
[    2.119566]  [<c1269218>] sysenter_do_call+0x12/0x33
[    2.119952]  [<c103007b>] ? tasklet_kill+0x2b/0x60
[    2.120325] ---[ end trace 78fd85ae6d011312 ]---
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

[    2.122731] ------------[ cut here ]------------
[    2.123149] WARNING: at /c/kernel-tests/src/stable/drivers/tty/tty_io.c:1420 tty_init_dev+0x184/0x1a0()
[    2.123936] tty_init_dev: ttyS driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    2.124869] Modules linked in:
[    2.125166] Pid: 71, comm: modprobe Tainted: G        W    3.6.0-rc3-00189-g6915c0e #176
[    2.125865] Call Trace:
[    2.126106]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    2.126575]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.126981]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.127393]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    2.127807]  [<c11c6904>] tty_init_dev+0x184/0x1a0
[    2.128197]  [<c102bff2>] ? console_device+0x42/0x50
[    2.128768]  [<c11c7254>] tty_open+0x454/0x4e0
[    2.129260]  [<c10d5c2d>] chrdev_open+0x6d/0x1a0
[    2.129669]  [<c11366ac>] ? security_file_open+0x6c/0x70
[    2.130109]  [<c10cfe58>] do_dentry_open+0x1d8/0x290
[    2.130544]  [<c10dc564>] ? __inode_permission+0x34/0x80
[    2.131003]  [<c10d5bc0>] ? cdev_put+0x10/0x10
[    2.131362]  [<c10cff3d>] finish_open+0x2d/0x40
[    2.131780]  [<c10df48b>] do_last+0x63b/0xc30
[    2.132135]  [<c10dc5c1>] ? inode_permission+0x11/0x50
[    2.132659]  [<c10dc652>] ? link_path_walk+0x52/0x740
[    2.133157]  [<c10dcff1>] ? path_init+0x1e1/0x460
[    2.133544]  [<c10dfb18>] path_openat+0x98/0x3d0
[    2.133917]  [<c1054001>] ? sched_clock_cpu+0xf1/0x1a0
[    2.134329]  [<c10e002c>] do_filp_open+0x2c/0x80
[    2.134707]  [<c10eb927>] ? alloc_fd+0x97/0xe0
[    2.135070]  [<c10d0fb0>] do_sys_open+0xe0/0x1b0
[    2.135442]  [<c1042fc6>] ? task_work_run+0x36/0x80
[    2.135941]  [<c10d10ad>] sys_open+0x2d/0x40
[    2.136292]  [<c1269218>] sysenter_do_call+0x12/0x33
[    2.136728]  [<c103007b>] ? tasklet_kill+0x2b/0x60
[    2.137168] ---[ end trace 78fd85ae6d011313 ]---
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

[    2.140752] ------------[ cut here ]------------
[    2.141192] WARNING: at /c/kernel-tests/src/stable/drivers/tty/tty_io.c:1420 tty_init_dev+0x184/0x1a0()
[    2.141971] tty_init_dev: ttyS driver does not set tty->port. This will crash the kernel later. Fix the driver!
[    2.142840] Modules linked in:
[    2.143106] Pid: 81, comm: modprobe Tainted: G        W    3.6.0-rc3-00189-g6915c0e #176
[    2.143756] Call Trace:
[    2.143960]  [<c1028e1f>] warn_slowpath_common+0x5f/0x80
[    2.144384]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.145028]  [<c11c6904>] ? tty_init_dev+0x184/0x1a0
[    2.145419]  [<c1028ebe>] warn_slowpath_fmt+0x2e/0x30
[    2.145964]  [<c11c6904>] tty_init_dev+0x184/0x1a0
[    2.146341]  [<c102bff2>] ? console_device+0x42/0x50
[    2.146756]  [<c11c7254>] tty_open+0x454/0x4e0
[    2.147136]  [<c10d5c2d>] chrdev_open+0x6d/0x1a0
[    2.147520]  [<c11366ac>] ? security_file_open+0x6c/0x70
[    2.147944]  [<c10cfe58>] do_dentry_open+0x1d8/0x290
[    2.148333]  [<c10dc564>] ? __inode_permission+0x34/0x80
[    2.148880]  [<c10d5bc0>] ? cdev_put+0x10/0x10
[    2.149319]  [<c10cff3d>] finish_open+0x2d/0x40
[    2.149693]  [<c10df48b>] do_last+0x63b/0xc30
[    2.150048]  [<c10dc5c1>] ? inode_permission+0x11/0x50
[    2.150462]  [<c10dc652>] ? link_path_walk+0x52/0x740
[    2.150875]  [<c10dcff1>] ? path_init+0x1e1/0x460
[    2.151258]  [<c10dfb18>] path_openat+0x98/0x3d0
[    2.151637]  [<c1054001>] ? sched_clock_cpu+0xf1/0x1a0
[    2.152053]  [<c10e002c>] do_filp_open+0x2c/0x80
[    2.152427]  [<c10eb927>] ? alloc_fd+0x97/0xe0
[    2.152817]  [<c10d0fb0>] do_sys_open+0xe0/0x1b0
[    2.153268]  [<c1042fc6>] ? task_work_run+0x36/0x80
[    2.153672]  [<c10d10ad>] sys_open+0x2d/0x40
[    2.154003]  [<c1269218>] sysenter_do_call+0x12/0x33
[    2.154388]  [<c103007b>] ? tasklet_kill+0x2b/0x60
[    2.154787] ---[ end trace 78fd85ae6d011314 ]---
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc3-00189-g6915c0e/modules.dep: No such file or directory

General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[    2.191486] Unregister pv shared memory for cpu 1
[    2.191976] Unregister pv shared memory for cpu 0
[    2.192517] serio serio1: shutdown
[    2.192807] atkbd serio0: shutdown
[    2.193117] i8042 i8042: shutdown
[    2.193456] pnp 00:07: shutdown
[    2.193713] serial 00:06: shutdown
[    2.193985] pnp 00:05: shutdown
[    2.194238] pnp 00:04: shutdown
[    2.194504] i8042 aux 00:03: shutdown
[    2.194796] i8042 kbd 00:02: shutdown
[    2.195132] pnp 00:01: shutdown
[    2.195385] pnp 00:00: shutdown
[    2.195645] pci 0000:00:0b.0: shutdown
[    2.196115] pci 0000:00:0a.0: shutdown
[    2.196420] pci 0000:00:09.0: shutdown
[    2.196779] pci 0000:00:08.0: shutdown
[    2.197104] pci 0000:00:07.0: shutdown
[    2.197420] pci 0000:00:06.0: shutdown
[    2.197737] pci 0000:00:05.0: shutdown
[    2.198052] pci 0000:00:04.0: shutdown
[    2.198367] pci 0000:00:03.0: shutdown
[    2.198692] pci 0000:00:02.0: shutdown
[    2.199074] pci 0000:00:01.3: shutdown
[    2.199387] pci 0000:00:01.1: shutdown
[    2.199705] pci 0000:00:01.0: shutdown
[    2.200018] pci 0000:00:00.0: shutdown
[    2.200417] Restarting system.
[    2.200731] reboot: machine restart

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc3-00189-g6915c0e"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc3 Kernel Configuration
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
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
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
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
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
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
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
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
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
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
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_WANT_INTEL_MID=y
# CONFIG_X86_MDFLD is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_PARAVIRT_DEBUG is not set
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
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
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
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_EFI is not set
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
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
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
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
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
# CONFIG_ACPI_BGRT is not set
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
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=m
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
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
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_NET_DSA=m
# CONFIG_NET_DSA_TAG_DSA is not set
# CONFIG_NET_DSA_TAG_EDSA is not set
# CONFIG_NET_DSA_TAG_TRAILER is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=m
CONFIG_WAN_ROUTER=m
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_DEBUG is not set
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
CONFIG_CAN=m
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_MCP251X is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
# CONFIG_CAN_SJA1000_PLATFORM is not set
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set
CONFIG_CAN_SOFTING=m
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=m
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_NET_9P=m
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_NFC=m
CONFIG_NFC_NCI=m
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y
CONFIG_NFC_LLCP=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_WILINK is not set

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
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_SPI=m
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_CMA is not set
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
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=m
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_TI_DAC7512=m
CONFIG_VMWARE_BALLOON=m
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m

#
# Altera FPGA firmware download module
#
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_MII is not set
CONFIG_NET_TEAM=m
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=m
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
# CONFIG_MDIO_BITBANG is not set
CONFIG_MICREL_KS8995MA=m
# CONFIG_PPP is not set
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_RTL8180 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
CONFIG_B43=m
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
# CONFIG_B43_SDIO is not set
CONFIG_B43_PIO=y
# CONFIG_B43_PHY_N is not set
CONFIG_B43_PHY_LP=y
# CONFIG_B43_PHY_HT is not set
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMFMAC is not set
CONFIG_HOSTAP=m
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_LIBERTAS=m
# CONFIG_LIBERTAS_SDIO is not set
CONFIG_LIBERTAS_SPI=m
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_MESH=y
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=m
# CONFIG_MWIFIEX_SDIO is not set
# CONFIG_MWIFIEX_PCIE is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
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
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=m
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
# CONFIG_KEYBOARD_STMPE is not set
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
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=m
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_FUJITSU=m
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_PCAP=m
CONFIG_TOUCHSCREEN_STMPE=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
# CONFIG_INPUT_AD714X_SPI is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_GPIO_TILT_POLLED=m
CONFIG_INPUT_WISTRON_BTNS=m
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_PCAP=m
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
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
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=m
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=m
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XILINX=m
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
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
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_STMPE is not set

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
CONFIG_GPIO_MAX7301=m
CONFIG_GPIO_MCP23S08=m
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=m

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=m
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_ADS7871=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_RDC321X_WDT is not set
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=m
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=m
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

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
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
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
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_ABX500_CORE is not set
CONFIG_EZX_PCAP=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set

#
# Media drivers
#

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
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
CONFIG_SND_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m
# CONFIG_SND_SOC_ALL_CODECS is not set
CONFIG_SND_SIMPLE_CARD=m
# CONFIG_SOUND_PRIME is not set

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
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_OT200 is not set
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
CONFIG_LEDS_TRIGGER_TRANSIENT=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_MCE_INJ=m
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
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
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=m
CONFIG_RTC_DRV_PCF2123=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=m
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_PCAP is not set
CONFIG_RTC_DRV_MC13XXX=m
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
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_ECHO=m
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_8255 is not set
# CONFIG_R8187SE is not set
# CONFIG_RTLLIB is not set
# CONFIG_VT6655 is not set
# CONFIG_DX_SEP is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_PHONE=m
# CONFIG_PHONE_IXJ is not set
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

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
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
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
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_LOGFS=m
CONFIG_CRAMFS=m
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
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
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=m
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
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
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
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
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_KSTRTOX=m
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
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
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_YAMA=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_EVM=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
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
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
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
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=m

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
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_586 is not set
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
CONFIG_CRYPTO_USER_API_SKCIPHER=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VHOST_NET=m
CONFIG_LGUEST=m
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
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--gBBFr7Ir9EOA20Yy--
