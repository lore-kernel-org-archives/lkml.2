Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2LNBYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:24:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:63230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab2LNBYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:24:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,276,1355126400"; 
   d="log'?scan'208";a="261939541"
Date: Fri, 14 Dec 2012 09:24:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [cgroup/hotplug] INFO: possible circular locking dependency detected
Message-ID: <20121214012436.GA25481@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got this lockdep warning and the first bad commit is
d206e09036d6201f90b2719484c8a59526c46125 ("Merge branch 'for-3.8' of
git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup")

[    1.969480] 
[    1.969686] ======================================================
[    1.970200] [ INFO: possible circular locking dependency detected ]
[    1.970200] 3.7.0-05910-g6be35c7 #1 Not tainted
[    1.970200] -------------------------------------------------------
[    1.970200] swapper/0/1 is trying to acquire lock:
[    1.970200]  (cgroup_mutex){+.+...}, at: [<81068053>] cgroup_lock+0xf/0x11
[    1.970200] 
[    1.970200] but task is already holding lock:
[    1.970200]  (cpu_hotplug.lock){+.+.+.}, at: [<8102674b>] cpu_hotplug_begin+0x1d/0x40
[    1.970200] 
[    1.970200] which lock already depends on the new lock.
[    1.970200] 
[    1.970200] 

Thanks,
Fengguang

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bay-3448-2012-12-13-11-57-42-3.7.0-05910-g6be35c7-1"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-05910-g6be35c7 (kbuild@inn) (gcc version 4.7.1 (Debian 4.7.1-6) ) #1 SMP Thu Dec 13 11:45:37 CST 2012
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [800fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [8008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x01ffa000-0x01ffffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 129072(98%)
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
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13cffa1, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat 81383540, node_mem_map 8dd3f200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3939 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 60958 pages, LIFO batch:15
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
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @8dd27000 s26432 r0 d22720 u49152
[    0.000000] pcpu-alloc: s26432 r0 d22720 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:dd2cfa1, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dd29780
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64897
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=linus/master log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-12-13-11-49-05-linus:master:6be35c7-6be35c7-i386-randconfig-i207-5-bay BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-i207/6be35c7/vmlinuz-3.7.0-05910-g6be35c7
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524144 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 216124k/262136k available (2321k kernel code, 45512k reserved, 1296k data, 288k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff7fe000   (1776 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x81389000 - 0x813d1000   ( 288 kB)
[    0.000000]       .data : 0x8124448c - 0x813885c0   (1296 kB)
[    0.000000]       .text : 0x81000000 - 0x8124448c   (2321 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=8d802000 soft=8d804000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
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
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
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
[    0.000000] tsc: Detected 2992.556 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5985.11 BogoMIPS (lpj=29925560)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] Security Framework initialized
[    0.020000] AppArmor: AppArmor initialized
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Initializing cgroup subsys debug
[    0.020000] Initializing cgroup subsys memory
[    0.020000] Initializing cgroup subsys perf_event
[    0.020000] mce: CPU supports 10 MCE banks
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift: 6
[    0.020475] Freeing SMP alternatives: 12k freed
[    0.024828] ACPI: Core revision 20121018
[    0.030729] Getting VERSION: 50014
[    0.031222] Getting VERSION: 50014
[    0.031704] Getting ID: 0
[    0.032087] Getting ID: f000000
[    0.032534] Getting LVT0: 8700
[    0.032970] Getting LVT1: 8400
[    0.033399] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.034224] enabled ExtINT on CPU#0
[    0.035852] ENABLING IO-APIC IRQs
[    0.036323] init IO_APIC IRQs
[    0.036740]  apic 2 pin 0 not connected
[    0.037307] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.038415] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.039517] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.040024] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.041121] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.042216] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.043314] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.044411] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.045505] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.046595] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.047712] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.048825] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.050023] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.051138] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.052254] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.053371]  apic 2 pin 16 not connected
[    0.053909]  apic 2 pin 17 not connected
[    0.054451]  apic 2 pin 18 not connected
[    0.054988]  apic 2 pin 19 not connected
[    0.055530]  apic 2 pin 20 not connected
[    0.056067]  apic 2 pin 21 not connected
[    0.056609]  apic 2 pin 22 not connected
[    0.057154]  apic 2 pin 23 not connected
[    0.057854] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.059060] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.061205] Using local APIC timer interrupts.
[    0.061205] calibrating APIC timer ...
[    0.070000] ... lapic delta = 6249939
[    0.070000] ... PM-Timer delta = 357950
[    0.070000] ... PM-Timer result ok
[    0.070000] ..... delta 6249939
[    0.070000] ..... mult: 268432836
[    0.070000] ..... calibration result: 9999902
[    0.070000] ..... CPU clock speed is 2992.4498 MHz.
[    0.070000] ..... host bus clock speed is 999.9902 MHz.
[    0.070000] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.070000] SMP alternatives: lockdep: fixing up alternatives
[    0.070000] CPU 1 irqstacks, hard=8d860000 soft=8d862000
[    0.070000] smpboot: Booting Node   0, Processors  #1 OK
[    0.020000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:dd38fa1, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.100147] Brought up 2 CPUs
[    0.100044] KVM setup async PF for cpu 1
[    0.100044] kvm-stealtime: cpu 1, msr dd35780
[    0.101721] ----------------
[    0.102121] | NMI testsuite:
[    0.102527] --------------------
[    0.102979]   remote IPI:  ok  |
[    0.130188]    local IPI:  ok  |
[    0.190014] --------------------
[    0.190495] Good, all   2 testcases passed! |
[    0.191087] ---------------------------------
[    0.191689] smpboot: Total of 2 processors activated (11970.22 BogoMIPS)
[    0.192925] CPU0 attaching sched-domain:
[    0.193514]  domain 0: span 0-1 level CPU
[    0.194079]   groups: 0 1
[    0.194521] CPU1 attaching sched-domain:
[    0.195060]  domain 0: span 0-1 level CPU
[    0.195638]   groups: 1 0
[    0.197760] NET: Registered protocol family 16
[    0.280355] ACPI: bus type pci registered
[    0.281157] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.282024] PCI: Using configuration type 1 for base access
[    0.284391] ACPI: Added _OSI(Module Device)
[    0.284974] ACPI: Added _OSI(Processor Device)
[    0.285621] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.286261] ACPI: Added _OSI(Processor Aggregator Device)
[    0.288800] ACPI: EC: Look up EC in DSDT
[    0.297969] ACPI: Interpreter enabled
[    0.298488] ACPI: (supports S0 S5)
[    0.299016] ACPI: Using IOAPIC for interrupt routing
[    0.311871] ACPI: No dock devices found.
[    0.312425] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.313758] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.314681] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.316491] PCI host bridge to bus 0000:00
[    0.317055] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.317800] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.318641] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.319481] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.320006] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.321031] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.322247] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.323650] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.326211] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.327758] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.329071] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.330019] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.331171] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.334285] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.336123] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.341676] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.342752] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.344210] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.345641] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.349353] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.350194] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.351417] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.354488] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.355985] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.357331] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.361785] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.363270] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.364610] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.368721] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.370322] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.371674] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.375768] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.377250] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.378589] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.382674] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.384160] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.385501] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.389612] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.390682] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.392021] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.396078] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.397249] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.400791] pci_bus 0000:00: on NUMA node 0
[    0.401412] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.404877]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.432029] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.433147] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.434253] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.435357] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.436457] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.437555] PCI: Using ACPI for IRQ routing
[    0.438136] PCI: pci_cache_line_size set to 64 bytes
[    0.439144] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.439975] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.440701] Switching to clocksource kvm-clock
[    0.441987] AppArmor: AppArmor Filesystem Enabled
[    0.442675] pnp: PnP ACPI init
[    0.443128] ACPI: bus type pnp registered
[    0.443757] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.444966] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.445939] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.447068] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.448034] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.448034] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.448908] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.450027] pnp 00:03: [dma 2]
[    0.450507] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.451558] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.452766] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.453796] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.454932] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.456406] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.457708] pnp: PnP ACPI: found 7 devices
[    0.458288] ACPI: ACPI bus type pnp unregistered
[    0.458917] PnPBIOS: Disabled
[    0.494613] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.495394] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.496151] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.497006] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.497944] NET: Registered protocol family 2
[    0.499027] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.500080] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.501247] TCP: Hash tables configured (established 2048 bind 2048)
[    0.502182] TCP: reno registered
[    0.502639] UDP hash table entries: 128 (order: 1, 10240 bytes)
[    0.503480] UDP-Lite hash table entries: 128 (order: 1, 10240 bytes)
[    0.504498] NET: Registered protocol family 1
[    0.505197] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.506015] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.506824] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.507699] pci 0000:00:02.0: Boot video device
[    0.508432] PCI: CLS 0 bytes, default 64
[    0.509211] Unpacking initramfs...
[    1.442767] Freeing initrd memory: 25284k freed
[    1.455380] Initializing RT-Tester: OK
[    1.455962] audit: initializing netlink socket (disabled)
[    1.456749] type=2000 audit(1355371048.450:1): initialized
[    1.472758] msgmni has been set to 471
[    1.473752] cryptomgr_test (33) used greatest stack depth: 6740 bytes left
[    1.475130] alg: No test for stdrng (krng)
[    1.477128] isapnp: Scanning for PnP cards...
[    1.839960] isapnp: No Plug & Play device found
[    1.877610] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.901073] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.904169] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.906442] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.907198] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.907926] cpuidle: using governor ladder
[    1.908517] ledtrig-cpu: registered to indicate activity on CPUs
[    1.910645] 
[    1.910645] printing PIC contents
[    1.911322] ... PIC  IMR: ffff
[    1.911746] ... PIC  IRR: 1013
[    1.912177] ... PIC  ISR: 0000
[    1.912610] ... PIC ELCR: 0c00
[    1.913101] printing local APIC contents on CPU#0/0:
[    1.913816] ... APIC ID:      00000000 (0)
[    1.914381] ... APIC VERSION: 00050014
[    1.914900] ... APIC TASKPRI: 00000000 (00)
[    1.915474] ... APIC PROCPRI: 00000000
[    1.915991] ... APIC LDR: 01000000
[    1.916466] ... APIC DFR: ffffffff
[    1.916945] ... APIC SPIV: 000001ff
[    1.917425] ... APIC ISR field:
[    1.917863] 0000000000000000000000000000000000000000000000000000000000000000
[    1.918997] ... APIC TMR field:
[    1.919437] 0000000000000000000000000000000000000000000000000000000000000000
[    1.920037] ... APIC IRR field:
[    1.920037] 0000000000000000000000000000000000000000000000000000000000008000
[    1.920037] ... APIC ESR: 00000000
[    1.920037] ... APIC ICR: 000008fd
[    1.920037] ... APIC ICR2: 02000000
[    1.920037] ... APIC LVTT: 000000ef
[    1.920037] ... APIC LVTPC: 00010000
[    1.920037] ... APIC LVT0: 00010700
[    1.920037] ... APIC LVT1: 00000400
[    1.920037] ... APIC LVTERR: 000000fe
[    1.920037] ... APIC TMICT: 00097f51
[    1.920037] ... APIC TMCCT: 00000000
[    1.920037] ... APIC TDCR: 00000003
[    1.920037] 
[    1.927850] number of MP IRQ sources: 15.
[    1.928408] number of IO-APIC #2 registers: 24.
[    1.929021] testing the IO APIC.......................
[    1.929741] IO APIC #2......
[    1.930153] .... register #00: 00000000
[    1.930677] .......    : physical APIC id: 00
[    1.931268] .......    : Delivery Type: 0
[    1.931808] .......    : LTS          : 0
[    1.932354] .... register #01: 00170011
[    1.932875] .......     : max redirection entries: 17
[    1.933558] .......     : PRQ implemented: 0
[    1.934136] .......     : IO APIC version: 11
[    1.934728] .... register #02: 00000000
[    1.935253] .......     : arbitration: 00
[    1.935795] .... IRQ redirection table:
[    1.936320]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    1.937067]  00 00  1    0    0   0   0    0    0    00
[    1.937808]  01 03  0    0    0   0   0    1    1    31
[    1.938554]  02 03  0    0    0   0   0    1    1    30
[    1.939294]  03 03  0    0    0   0   0    1    1    33
[    1.940057]  04 03  1    0    0   0   0    1    1    34
[    1.940784]  05 03  1    1    0   0   0    1    1    35
[    1.941520]  06 03  0    0    0   0   0    1    1    36
[    1.942259]  07 03  0    0    0   0   0    1    1    37
[    1.942994]  08 03  0    0    0   0   0    1    1    38
[    1.943734]  09 03  0    1    0   0   0    1    1    39
[    1.944475]  0a 03  1    1    0   0   0    1    1    3A
[    1.945217]  0b 03  1    1    0   0   0    1    1    3B
[    1.945952]  0c 03  0    0    0   0   0    1    1    3C
[    1.946695]  0d 03  0    0    0   0   0    1    1    3D
[    1.947435]  0e 03  0    0    0   0   0    1    1    3E
[    1.948171]  0f 03  0    0    0   0   0    1    1    3F
[    1.948907]  10 00  1    0    0   0   0    0    0    00
[    1.949649]  11 00  1    0    0   0   0    0    0    00
[    1.950413]  12 00  1    0    0   0   0    0    0    00
[    1.951147]  13 00  1    0    0   0   0    0    0    00
[    1.951887]  14 00  1    0    0   0   0    0    0    00
[    1.952629]  15 00  1    0    0   0   0    0    0    00
[    1.953370]  16 00  1    0    0   0   0    0    0    00
[    1.954109]  17 00  1    0    0   0   0    0    0    00
[    1.954841] IRQ to pin mappings:
[    1.955294] IRQ0 -> 0:2
[    1.955673] IRQ1 -> 0:1
[    1.956052] IRQ3 -> 0:3
[    1.956434] IRQ4 -> 0:4
[    1.956812] IRQ5 -> 0:5
[    1.957195] IRQ6 -> 0:6
[    1.957574] IRQ7 -> 0:7
[    1.957952] IRQ8 -> 0:8
[    1.958337] IRQ9 -> 0:9
[    1.958716] IRQ10 -> 0:10
[    1.959119] IRQ11 -> 0:11
[    1.959525] IRQ12 -> 0:12
[    1.959927] IRQ13 -> 0:13
[    1.960356] IRQ14 -> 0:14
[    1.960759] IRQ15 -> 0:15
[    1.961166] .................................... done.
[    1.961861] Using IPI No-Shortcut mode
[    1.962842] IMA: No TPM chip found, activating TPM-bypass!
[    1.966208] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.968515] Unregister pv shared memory for cpu 0
[    1.969480] 
[    1.969686] ======================================================
[    1.970200] [ INFO: possible circular locking dependency detected ]
[    1.970200] 3.7.0-05910-g6be35c7 #1 Not tainted
[    1.970200] -------------------------------------------------------
[    1.970200] swapper/0/1 is trying to acquire lock:
[    1.970200]  (cgroup_mutex){+.+...}, at: [<81068053>] cgroup_lock+0xf/0x11
[    1.970200] 
[    1.970200] but task is already holding lock:
[    1.970200]  (cpu_hotplug.lock){+.+.+.}, at: [<8102674b>] cpu_hotplug_begin+0x1d/0x40
[    1.970200] 
[    1.970200] which lock already depends on the new lock.
[    1.970200] 
[    1.970200] 
[    1.970200] the existing dependency chain (in reverse order) is:
[    1.970200] 
-> #2 (cpu_hotplug.lock){+.+.+.}:
[    1.970200]        [<8105d2c3>] __lock_acquire+0x7d9/0x8a5
[    1.970200]        [<8105d797>] lock_acquire+0x80/0x9b
[    1.970200]        [<8123c9a2>] mutex_lock_nested+0x5b/0x2a3
[    1.970200]        [<8102674b>] cpu_hotplug_begin+0x1d/0x40
[    1.970200]        [<81236ac0>] cpu_up+0x43/0x132
[    1.970200]        [<8139bfe4>] smp_init+0x38/0x86
[    1.970200]        [<8122d238>] kernel_init+0x90/0x274
[    1.970200]        [<81243597>] ret_from_kernel_thread+0x1b/0x28
[    1.970200] 
-> #1 (cpu_add_remove_lock){+.+.+.}:
[    1.970200]        [<8105d2c3>] __lock_acquire+0x7d9/0x8a5
[    1.970200]        [<8105d797>] lock_acquire+0x80/0x9b
[    1.970200]        [<8123c9a2>] mutex_lock_nested+0x5b/0x2a3
[    1.970200]        [<8102682a>] cpu_maps_update_begin+0xf/0x11
[    1.970200]        [<8122db8e>] register_cpu_notifier+0xc/0x27
[    1.970200]        [<8122e2a7>] mem_cgroup_css_alloc+0x1a8/0x2b9
[    1.970200]        [<8139c8ae>] cgroup_init_subsys+0x92/0x117
[    1.970200]        [<8139cb4f>] cgroup_init+0x3f/0x105
[    1.970200]        [<813899d1>] start_kernel+0x35d/0x38f
[    1.970200]        [<813892d4>] i386_start_kernel+0x8a/0x8f
[    1.970200] 
-> #0 (cgroup_mutex){+.+...}:
[    1.970200]        [<8105aed5>] validate_chain.isra.26+0x785/0xcb1
[    1.970200]        [<8105d2c3>] __lock_acquire+0x7d9/0x8a5
[    1.970200]        [<8105d797>] lock_acquire+0x80/0x9b
[    1.970200]        [<8123c9a2>] mutex_lock_nested+0x5b/0x2a3
[    1.970200]        [<81068053>] cgroup_lock+0xf/0x11
[    1.970200]        [<8106dd1e>] cpuset_update_active_cpus+0x10/0xea
[    1.970200]        [<8104465c>] cpuset_cpu_inactive+0x18/0x37
[    1.970200]        [<81241887>] notifier_call_chain+0x25/0x46
[    1.970200]        [<8103de1c>] __raw_notifier_call_chain+0x19/0x1e
[    1.970200]        [<810266ff>] __cpu_notify+0x1f/0x39
[    1.970200]        [<8122d9c0>] _cpu_down.constprop.2+0x5a/0x1dc
[    1.970200]        [<8122db56>] cpu_down+0x14/0x21
[    1.970200]        [<8122d500>] _debug_hotplug_cpu+0x34/0x8a
[    1.970200]        [<8138db56>] debug_hotplug_cpu+0xc/0x10
[    1.970200]        [<81001098>] do_one_initcall+0x7f/0x133
[    1.970200]        [<8122d2bc>] kernel_init+0x114/0x274
[    1.970200]        [<81243597>] ret_from_kernel_thread+0x1b/0x28
[    1.970200] 
[    1.970200] other info that might help us debug this:
[    1.970200] 
[    1.970200] Chain exists of:
  cgroup_mutex --> cpu_add_remove_lock --> cpu_hotplug.lock

[    1.970200]  Possible unsafe locking scenario:
[    1.970200] 
[    1.970200]        CPU0                    CPU1
[    1.970200]        ----                    ----
[    1.970200]   lock(cpu_hotplug.lock);
[    1.970200]                                lock(cpu_add_remove_lock);
[    1.970200]                                lock(cpu_hotplug.lock);
[    1.970200]   lock(cgroup_mutex);
[    1.970200] 
[    1.970200]  *** DEADLOCK ***
[    1.970200] 
[    1.970200] 3 locks held by swapper/0/1:
[    1.970200]  #0:  (x86_cpu_hotplug_driver_mutex){+.+...}, at: [<81016c61>] cpu_hotplug_driver_lock+0xf/0x11
[    1.970200]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<8102682a>] cpu_maps_update_begin+0xf/0x11
[    1.970200]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<8102674b>] cpu_hotplug_begin+0x1d/0x40
[    1.970200] 
[    1.970200] stack backtrace:
[    1.970200] Pid: 1, comm: swapper/0 Not tainted 3.7.0-05910-g6be35c7 #1
[    1.970200] Call Trace:
[    1.970200]  [<8123996a>] print_circular_bug+0x23a/0x244
[    1.970200]  [<8105aed5>] validate_chain.isra.26+0x785/0xcb1
[    1.970200]  [<81050014>] ? proc_sched_show_task+0x1a0/0x115f
[    1.970200]  [<8105d2c3>] __lock_acquire+0x7d9/0x8a5
[    1.970200]  [<8105d797>] lock_acquire+0x80/0x9b
[    1.970200]  [<81068053>] ? cgroup_lock+0xf/0x11
[    1.970200]  [<8123c9a2>] mutex_lock_nested+0x5b/0x2a3
[    1.970200]  [<81068053>] ? cgroup_lock+0xf/0x11
[    1.970200]  [<81068053>] cgroup_lock+0xf/0x11
[    1.970200]  [<8106dd1e>] cpuset_update_active_cpus+0x10/0xea
[    1.970200]  [<81237173>] ? workqueue_cpu_down_callback+0x59/0x6a
[    1.970200]  [<810352f6>] ? keep_working+0x23/0x23
[    1.970200]  [<8104465c>] cpuset_cpu_inactive+0x18/0x37
[    1.970200]  [<81241887>] notifier_call_chain+0x25/0x46
[    1.970200]  [<8103de1c>] __raw_notifier_call_chain+0x19/0x1e
[    1.970200]  [<810266ff>] __cpu_notify+0x1f/0x39
[    1.970200]  [<8122d9c0>] _cpu_down.constprop.2+0x5a/0x1dc
[    1.970200]  [<8122db56>] cpu_down+0x14/0x21
[    1.970200]  [<8122d500>] _debug_hotplug_cpu+0x34/0x8a
[    1.970200]  [<813af466>] ? tcp_fastopen_init+0x2b/0x40
[    1.970200]  [<8138db4a>] ? topology_init+0x31/0x31
[    1.970200]  [<8138db56>] debug_hotplug_cpu+0xc/0x10
[    1.970200]  [<81001098>] do_one_initcall+0x7f/0x133
[    1.970200]  [<8122d2bc>] kernel_init+0x114/0x274
[    1.970200]  [<81389455>] ? do_early_param+0x7a/0x7a
[    1.970200]  [<81243597>] ret_from_kernel_thread+0x1b/0x28
[    1.970200]  [<8122d1a8>] ? rest_init+0xbc/0xbc
[    2.040785] CPU0 attaching NULL sched-domain.
[    2.041353] CPU1 attaching NULL sched-domain.
[    2.041963] CPU1 attaching NULL sched-domain.
[    2.044118] CPU 0 is now offline
[    2.045052] Freeing unused kernel memory: 288k freed
[    2.046264] Write protecting the kernel text: 2324k
[    2.046932] Testing CPA: Reverting 81000000-81245000
[    2.047800] Testing CPA: write protecting again
[    2.048795] Write protecting the kernel read-only data: 1084k
[    2.049573] Testing CPA: undo 81245000-81354000
[    2.050244] Testing CPA: write protecting again
modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

[    2.197356] plymouthd (68) used greatest stack depth: 6708 bytes left
modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

mountall: Event failed
modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

[    2.450193] tsc: Refined TSC clocksource calibration: 2992.495 MHz
modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

mount: unknown filesystem type 'devpts'
mountall: mount /dev/pts [1638] terminated with status 32
mountall: Filesystem could not be mounted: /dev/pts
mountall: Skipping mounting /dev/pts since Plymouth is not available
[    7.779368] initctl (1660) used greatest stack depth: 6516 bytes left
[    7.800547] stop (1666) used greatest stack depth: 6244 bytes left
[    8.995744] init: Failed to create pty - disabling logging for job
[    8.996782] init: Temporary process spawn error: No such file or directory
[    9.004202] init: Failed to create pty - disabling logging for job
[    9.005225] init: Temporary process spawn error: No such file or directory
[    9.021597] init: Failed to create pty - disabling logging for job
[    9.022637] init: Temporary process spawn error: No such file or directory
[    9.029910] init: udev-fallback-graphics main process (1760) terminated with status 1
[    9.051049] init: Failed to create pty - disabling logging for job
[    9.052080] init: Temporary process spawn error: No such file or directory
[    9.072382] init: plymouth-splash main process (1766) terminated with status 1
[    9.073894] init: Failed to create pty - disabling logging for job
[    9.074876] init: Temporary process spawn error: No such file or directory
[    9.107218] ip (1770) used greatest stack depth: 5820 bytes left
[    9.179966] init: Failed to create pty - disabling logging for job
[    9.181029] init: Temporary process spawn error: No such file or directory
[    9.238765] init: Failed to create pty - disabling logging for job
[    9.239789] init: Temporary process spawn error: No such file or directory
[    9.298953] init: Failed to create pty - disabling logging for job
[    9.299977] init: Temporary process spawn error: No such file or directory
[    9.320454] init: networking main process (1764) terminated with status 1
[    9.420952] init: Failed to create pty - disabling logging for job
[    9.421979] init: Temporary process spawn error: No such file or directory
modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

[    9.439358] init: Failed to create pty - disabling logging for job
[    9.450365] init: Temporary process spawn error: No such file or directory
modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

[    9.463845] init: Failed to create pty - disabling logging for job
[    9.464842] init: Temporary process spawn error: No such file or directory
modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

Kernel tests: Boot OK!
Kernel tests: Boot OK!
[    9.555382] init: Failed to create pty - disabling logging for job
[    9.556415] init: Temporary process spawn error: No such file or directory
Trinity v1.0  Dave Jones <davej@redhat.com> 2012
No idea what syscall (get_robust_list) is.
[    9.584050] init: Failed to create pty - disabling logging for job
[    9.585058] init: Temporary process spawn error: No such file or directory
modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.7.0-05910-g6be35c7/modules.dep: No such file or directory


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="6be35c7-bisect.log"

git checkout d3594ea2b343fbbabaaebeb4ce4e1f29e88ab6b3

2012-12-14-07:07:45 d3594ea2b343fbbabaaebeb4ce4e1f29e88ab6b3 compiling
/home/wfg/linux

2012-12-14-07:08:56 detecting boot state 3.7.0-rc7-bisect-00005-gd3594ea #65 1.23...................................................OK 4...OK .5OK 6.OK 7OK .OK 8OK 910OK .11...............................................OK .12.......OK 13OK 14OK 15OK 1617OK 18................................................OK 19.......OK 20OK 21OK .OK 2223OK .24OK 25..............................................OK  SUCCESS
bisect: good commit d3594ea2b343fbbabaaebeb4ce4e1f29e88ab6b3
git bisect start 6be35c700f742e911ecedd07fcc43d4439922334 d3594ea2b343fbbabaaebeb4ce4e1f29e88ab6b3 --
Bisecting: 2982 revisions left to test after this (roughly 12 steps)
[d07e43d70eef15a44a2c328a913d8d633a90e088] Merge branch 'omap-serial' of git://git.linaro.org/people/rmk/linux-arm
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-07:14:14 d07e43d70eef15a44a2c328a913d8d633a90e088 compiling
/home/wfg/linux

2012-12-14-07:15:30 detecting boot state 3.7.0-bisect-02914-gd07e43d #66 1..............................................2.........OK .OK 3OK 4OK .OK 5OK 6...............................................OK .7.......OK .OK 8OK 910OK 11OK 1213.OK .14............................................OK 15........OK .OK 1617OK .OK 1819.OK .OK 20............................................OK .21.......OK  SUCCESS
Bisecting: 1490 revisions left to test after this (roughly 11 steps)
[e8ad1a8fab6f550aba1f1fe7ba26749ff5460751] Merge branch 'master' of git://1984.lsi.us.es/nf-next
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-07:20:34 e8ad1a8fab6f550aba1f1fe7ba26749ff5460751 compiling
/home/wfg/linux

2012-12-14-07:21:51 detecting boot state 3.7.0-rc7-bisect-01563-ge8ad1a8 #67 .123.4....5........................................6.......OK .7..OK .OK 8OK 910OK .OK 1112......OK 13....................................OK 14........OK 15..OK .OK 16OK 17OK 18OK .19OK 20......OK .21...................................OK .OK 22.......OK .23..OK .OK 24OK  SUCCESS
Bisecting: 720 revisions left to test after this (roughly 10 steps)
[d01e4afdbb65e030fd6f1f96c30a558e2eb0f279] Merge tag 'cleanup' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-07:25:48 d01e4afdbb65e030fd6f1f96c30a558e2eb0f279 compiling
/home/wfg/linux

2012-12-14-07:27:18 detecting boot state 3.7.0-bisect-339885-gd01e4af #68 ...... TEST FAILURE
Bisecting: 374 revisions left to test after this (roughly 9 steps)
[b1286f4e9ac14c8973140b338b4d3c5691264d3b] Merge branch 'for-linus' of git://git.linaro.org/people/rmk/linux-arm
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-07:27:27 b1286f4e9ac14c8973140b338b4d3c5691264d3b compiling
/home/wfg/linux

2012-12-14-07:28:29 detecting boot state 3.7.0-bisect-339510-gb1286f4 #69 ............................12..3 TEST FAILURE
Bisecting: 204 revisions left to test after this (roughly 8 steps)
[22a40fd9a60388aec8106b0baffc8f59f83bb1b4] Merge tag 'dlm-3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-07:29:10 22a40fd9a60388aec8106b0baffc8f59f83bb1b4 compiling
/home/wfg/linux

2012-12-14-07:29:56 detecting boot state 3.7.0-bisect-03109-g22a40fd #70 ............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................12.................3 TEST FAILURE
Bisecting: 77 revisions left to test after this (roughly 7 steps)
[50851c6248e1a13c45d97c41f6ebcf716093aa5e] Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-07:42:42 50851c6248e1a13c45d97c41f6ebcf716093aa5e compiling
/home/wfg/linux

2012-12-14-07:43:40 detecting boot state 3.7.0-bisect-03031-g50851c6 #71 ...1..2........................................OK .3...............................OK .OK 45............................OK .6.................................................................................................................................................................OK .....................................................................................................................................................7...............................................................OK .OK 8...OK 9.........................................................OK 1011..OK .OK 12...OK 13.........................................................OK .14..OK .15.........................................................OK .16..OK .OK 1718..OK 1920....................................................OK .21..OK .OK 2223.OK  SUCCESS
Bisecting: 38 revisions left to test after this (roughly 5 steps)
[b48c6a80a0f7584056f768268fc12b87745a393f] cgroup: trivial cleanup for cgroup_init/load_subsys()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-07:59:12 b48c6a80a0f7584056f768268fc12b87745a393f compiling
/home/wfg/linux

2012-12-14-08:00:34 detecting boot state 3.7.0-rc4-bisect-00041-gb48c6a8 #72 .....................................................OK 12..OK .3........................................................OK .OK 4..OK 5OK .6..OK 78....................................................OK .9..OK 1011...OK 1213..OK 1415................................................OK .16.OK .OK 17....OK 1819.OK .OK 2021................................................OK .22.OK .23....OK 2425.OK .OK  SUCCESS
Bisecting: 19 revisions left to test after this (roughly 4 steps)
[666b0ebe2b04e69583c279becf27a653ba4a894c] netprio_cgroup: implement netprio[_set]_prio() helpers
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-08:07:05 666b0ebe2b04e69583c279becf27a653ba4a894c compiling
/home/wfg/linux

2012-12-14-08:07:58 detecting boot state 3.7.0-rc4-bisect-00060-g666b0eb #73 ........12....3..45...6................................................OK 78..OK 9OK 1011.OK .12OK 13..OK .14...............................................OK .OK 1516.OK .17OK 1819.OK .OK 2021..OK .22...........................................OK 23OK 24...OK 25..OK 26OK .OK 27..OK 28OK 29...OK  SUCCESS
Bisecting: 10 revisions left to test after this (roughly 3 steps)
[15ef4ffaa797034d5ff82844daf8f595d7c6d53c] cgroup: update Documentation/cgroups/00-INDEX
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-08:12:16 15ef4ffaa797034d5ff82844daf8f595d7c6d53c compiling
/home/wfg/linux

2012-12-14-08:13:02 detecting boot state 3.7.0-rc4-bisect-00069-g15ef4ff #74 .12......345..67...8..........................................OK .OK 910......OK 11OK 12OK 13.OK .14OK 15..OK .OK 16...........................................OK 17OK 18......OK .OK 19OK 2021..OK .22.OK 23OK .24..OK 25.......................................OK .OK 2627.....OK .OK  SUCCESS
Bisecting: 4 revisions left to test after this (roughly 3 steps)
[fef3ff2eb777e76cfa5ae67591982d902c17139c] Merge branch 'for-3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-08:17:06 fef3ff2eb777e76cfa5ae67591982d902c17139c compiling
/home/wfg/linux

2012-12-14-08:18:23 detecting boot state 3.7.0-bisect-03037-gfef3ff2 #75 ...1..23....4..................................5OK 6......OK 7OK 8OK 910..OK .11.OK 12OK .13..OK .14.......................................OK .15.OK .16...OK .17OK 18OK .19OK .OK 20.OK .21OK 22...OK .23......................................OK .24.OK .25...OK .OK  SUCCESS
Bisecting: 2 revisions left to test after this (roughly 1 step)
[a3de56bdb980c63b01662cac05d430db60ff4374] fs/dlm: remove CONFIG_EXPERIMENTAL
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-08:22:09 a3de56bdb980c63b01662cac05d430db60ff4374 compiling
/home/wfg/linux

2012-12-14-08:23:29 detecting boot state 3.7.0-rc3-bisect-00002-ga3de56b #76 ..12....3.................................4.OK .5.......OK .6OK 7.OK 8...OK .OK 9OK 1011...OK 12..............................OK .13.OK .14...........OK .OK 1516OK .17....OK 18OK .19..OK 20OK .21..............................OK 22.OK .23............OK 24OK .25OK  SUCCESS
Bisecting: 1 revision left to test after this (roughly 1 step)
[da8c66638ae684c99abcb30e89d2803402e7ca20] dlm: fix lvb invalidation conditions
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-08:27:16 da8c66638ae684c99abcb30e89d2803402e7ca20 compiling
/home/wfg/linux

2012-12-14-08:27:59 detecting boot state 3.7.0-rc3-bisect #77 ......1..2............3.4.5......6.78910.............................OK .11.OK 12................OK 1314OK 15...OK .16.OK .17OK .18.OK 19OK 20..........................OK .21.OK .22...............OK .OK 23OK .24...OK 25.OK .26.OK 27..OK 28OK 29..........................OK .30.OK .31...............OK  SUCCESS
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[d206e09036d6201f90b2719484c8a59526c46125] Merge branch 'for-3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2012-12-14-08:32:24 d206e09036d6201f90b2719484c8a59526c46125 compiling
/home/wfg/linux

2012-12-14-08:33:39 detecting boot state 3.7.0-bisect-03105-gd206e09 #78 1..2.3..... TEST FAILURE
d206e09036d6201f90b2719484c8a59526c46125 is the first bad commit
bisect run success

========= linux-next =========

2012-12-14-08:34:00 cf89d08cff5638e627776ef637d13618d1c5c6f1 compiling
/home/wfg/linux

2012-12-14-08:35:20 detecting boot state 3.7.0-bisect-next-20121213 #79 .1..2.34.......5 TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:25: main: $BISECT_TEST $KBUILD_OUTPUT

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.7.0 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
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
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
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
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
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
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_GENERIC_KERNEL_THREAD=y
CONFIG_GENERIC_KERNEL_EXECVE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_WANT_INTEL_MID is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_X86_L1_CACHE_SHIFT=5
# CONFIG_X86_PPRO_FENCE is not set
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
# CONFIG_DMI is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_INJECT=m
CONFIG_VM86=y
CONFIG_TOSHIBA=m
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
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
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
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
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
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
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
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=m
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=m
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
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
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=m
CONFIG_SCx200HR_TIMER=m
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
# CONFIG_IPV6_PRIVACY is not set
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=m
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=m
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
# CONFIG_L2TP_V3 is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=m
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=m
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_6LOWPAN is not set
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_ATM is not set
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=m
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=m
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=m
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
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=m
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_TCPPROBE=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
CONFIG_BT_WILINK=m
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
# CONFIG_MAC80211_MPL_DEBUG is not set
# CONFIG_MAC80211_MPATH_DEBUG is not set
CONFIG_MAC80211_MHWMP_DEBUG=y
CONFIG_MAC80211_MESH_SYNC_DEBUG=y
# CONFIG_MAC80211_TDLS_DEBUG is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
CONFIG_NFC_NCI=m
# CONFIG_NFC_HCI is not set
CONFIG_NFC_LLCP=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
CONFIG_NFC_WILINK=m

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
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_CMA is not set

#
# Bus devices
#
CONFIG_OMAP_OCP2SCP=m
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_SPI=m
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=m
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m

#
# Altera FPGA firmware download module
#
CONFIG_INTEL_MEI=m
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
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=m
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set

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
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

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
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=m
CONFIG_MOUSE_SYNAPTICS_USB=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=m
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=m
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
# CONFIG_INPUT_AD714X_SPI is not set
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_GPIO_TILT_POLLED=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_DA9052_ONKEY=m
CONFIG_INPUT_ADXL34X=m
# CONFIG_INPUT_ADXL34X_SPI is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
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
CONFIG_NOZOMI=m
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set

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
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=m
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=m
# CONFIG_RTC is not set
CONFIG_GEN_RTC=m
# CONFIG_GEN_RTC_X is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=m
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XILINX=m
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=m
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
# CONFIG_PPS_CLIENT_GPIO is not set

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
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_DA9052=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=m

#
# I2C GPIO expanders:
#

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m
CONFIG_GPIO_AMD8111=m
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=m
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MCP23S08=m
CONFIG_GPIO_MC33880=m
CONFIG_GPIO_74X164=m

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
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set
# CONFIG_HDQ_MASTER_OMAP is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_GPIO=m
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_ADCXX=m
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=m
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_GPIO_FAN=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_FAIR_SHARE=y
CONFIG_STEP_WISE=y
CONFIG_USER_SPACE=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_DA9052_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=m
CONFIG_SC520_WDT=m
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_IE6XX_WDT=m
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=m
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
CONFIG_RDC321X_WDT=m
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=m
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=m
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
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
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_RTSX_PCI=m
CONFIG_HTC_PASIC3=m
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=m
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_LCD_S6E63M0=m
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_DA9052=m
CONFIG_BACKLIGHT_APPLE=m
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_SOUND is not set

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
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=m
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=m
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_KEYTOUCH=m
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=m
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=m
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=m
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=m
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=m
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_HYPERV_MOUSE=m
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

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
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_DEBUG=y

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
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set

#
# USB Physical Layer drivers
#
CONFIG_OMAP_USB2=m
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_ATM is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=m
CONFIG_MMC_REALTEK_PCI=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_DELL_NETBOOKS=m
CONFIG_LEDS_MC13783=m
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
# CONFIG_INFINIBAND_USER_MAD is not set
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_NES=m
CONFIG_INFINIBAND_NES_DEBUG=y
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
CONFIG_INTEL_IOATDMA=m
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
# CONFIG_HYPERV_UTILS is not set
# CONFIG_HYPERV_BALLOON is not set
CONFIG_STAGING=y
CONFIG_SLICOSS=m
CONFIG_USBIP_CORE=m
# CONFIG_USBIP_VHCI_HCD is not set
CONFIG_USBIP_HOST=m
CONFIG_USBIP_DEBUG=y
CONFIG_ECHO=m
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
CONFIG_COMEDI_ISA_DRIVERS=y
# CONFIG_COMEDI_ACL7225B is not set
CONFIG_COMEDI_PCL711=m
CONFIG_COMEDI_PCL724=m
CONFIG_COMEDI_PCL725=m
# CONFIG_COMEDI_PCL726 is not set
# CONFIG_COMEDI_PCL730 is not set
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
# CONFIG_COMEDI_PCL818 is not set
CONFIG_COMEDI_PCM3724=m
# CONFIG_COMEDI_PCM3730 is not set
CONFIG_COMEDI_AMPLC_DIO200_ISA=m
# CONFIG_COMEDI_AMPLC_PC236_ISA is not set
CONFIG_COMEDI_AMPLC_PC263_ISA=m
# CONFIG_COMEDI_RTI800 is not set
CONFIG_COMEDI_RTI802=m
CONFIG_COMEDI_DAS16M1=m
CONFIG_COMEDI_DAS08_ISA=m
# CONFIG_COMEDI_DAS16 is not set
CONFIG_COMEDI_DAS800=m
CONFIG_COMEDI_DAS1800=m
# CONFIG_COMEDI_DAS6402 is not set
# CONFIG_COMEDI_DT2801 is not set
# CONFIG_COMEDI_DT2811 is not set
CONFIG_COMEDI_DT2814=m
# CONFIG_COMEDI_DT2815 is not set
# CONFIG_COMEDI_DT2817 is not set
CONFIG_COMEDI_DT282X=m
CONFIG_COMEDI_DMM32AT=m
# CONFIG_COMEDI_FL512 is not set
CONFIG_COMEDI_AIO_AIO12_8=m
# CONFIG_COMEDI_AIO_IIRO_16 is not set
# CONFIG_COMEDI_C6XDIGIO is not set
# CONFIG_COMEDI_MPC624 is not set
# CONFIG_COMEDI_ADQ12B is not set
# CONFIG_COMEDI_NI_AT_A2150 is not set
CONFIG_COMEDI_NI_AT_AO=m
# CONFIG_COMEDI_NI_ATMIO is not set
# CONFIG_COMEDI_NI_ATMIO16D is not set
# CONFIG_COMEDI_PCMAD is not set
CONFIG_COMEDI_PCMDA12=m
# CONFIG_COMEDI_PCMMIO is not set
# CONFIG_COMEDI_PCMUIO is not set
# CONFIG_COMEDI_MULTIQ3 is not set
CONFIG_COMEDI_POC=m
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_AMPLC_PC263=m
CONFIG_COMEDI_DAS08=m
# CONFIG_ASUS_OLED is not set
CONFIG_TRANZPORT=m
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#
CONFIG_IIO_ST_HWMON=m
CONFIG_IIO_SW_RING=m

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16203 is not set
# CONFIG_ADIS16204 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADIS16220 is not set
# CONFIG_ADIS16240 is not set
CONFIG_KXSD9=m
# CONFIG_LIS3L02DQ is not set
CONFIG_SCA3000=m

#
# Analog to digital converters
#
CONFIG_AD7606=m
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD7780 is not set
# CONFIG_AD7816 is not set
CONFIG_AD7192=m
CONFIG_ADT7410=m
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
# CONFIG_ADT7316_SPI is not set

#
# Capacitance to digital converters
#

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
# CONFIG_AD9832 is not set
CONFIG_AD9834=m
# CONFIG_AD9850 is not set
# CONFIG_AD9852 is not set
CONFIG_AD9910=m
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set

#
# Network Analyzer, Impedance Converters
#

#
# Inertial measurement units
#
CONFIG_ADIS16400=m

#
# Light sensors
#

#
# Magnetometer sensors
#

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=m
CONFIG_ADE7758=m
CONFIG_ADE7759=m
CONFIG_ADE7854=m
CONFIG_ADE7854_SPI=m

#
# Resolver to digital converters
#
CONFIG_AD2S90=m
CONFIG_AD2S1200=m
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
# CONFIG_IIO_GPIO_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=m
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZSMALLOC=m
CONFIG_CRYSTALHD=m
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_CSR_WIFI is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
# CONFIG_SB105X is not set
# CONFIG_FIREWIRE_SERIAL is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=m
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_FUJITSU_TABLET=m
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
CONFIG_ACPI_WMI=m
CONFIG_MSI_WMI=m
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=m
CONFIG_IBM_RTL=m
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_SAMSUNG_Q10=m
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
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_HID_SENSOR_ACCEL_3D is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
# CONFIG_AD7266 is not set
CONFIG_AD7298=m
CONFIG_AD7791=m
# CONFIG_AD7793 is not set
CONFIG_AD7476=m
# CONFIG_AD7887 is not set

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
CONFIG_AD5380=m
CONFIG_AD5421=m
# CONFIG_AD5624R_SPI is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
CONFIG_AD5504=m
CONFIG_AD5755=m
CONFIG_AD5764=m
CONFIG_AD5791=m
# CONFIG_AD5686 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16136=m
CONFIG_HID_SENSOR_GYRO_3D=m

#
# Inertial measurement units
#
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_HID_SENSOR_ALS is not set

#
# Magnetometer sensors
#
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
# CONFIG_SERIAL_IPOCTAL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

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
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
# CONFIG_NFS_V3 is not set
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_SUNRPC_DEBUG=y
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
# CONFIG_IMA_APPRAISE is not set
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=m

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
# CONFIG_CRYPTO_CTS is not set
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
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VHOST_NET=m
CONFIG_LGUEST=m
# CONFIG_BINARY_PRINTF is not set

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
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--tKW2IUtsqtDRztdT--
