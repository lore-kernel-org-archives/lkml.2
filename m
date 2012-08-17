Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2HQGZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 02:25:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:57278 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab2HQGZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 02:25:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,783,1336374000"; 
   d="scan'208";a="203339253"
Date: Fri, 17 Aug 2012 14:24:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: WARNING at btrfs_alloc_free_block()
Message-ID: <20120817062458.GA29187@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got this warning when doing writeback tests. It happens quite often
in 3.6.0-rc1 as well as in 3.5.0.

[  644.273874] btrfs: block rsv returned -28
[  644.278161] ------------[ cut here ]------------
[  644.283050] WARNING: at /c/wfg/tip/fs/btrfs/extent-tree.c:6330 btrfs_alloc_free_block+0xd6/0x28b()
[  644.292468] Hardware name: X7DW3
[  644.295950] Modules linked in:
[  644.299330] Pid: 10214, comm: btrfs-transacti Not tainted 3.6.0-rc1+ #4
[  644.306201] Call Trace:
[  644.308916]  [<ffffffff810697ee>] warn_slowpath_common+0x83/0x9c
[  644.315183]  [<ffffffff81069821>] warn_slowpath_null+0x1a/0x1c
[  644.321274]  [<ffffffff8133246f>] btrfs_alloc_free_block+0xd6/0x28b
[  644.327796]  [<ffffffff81141973>] ? kfree+0x55/0x101
[  644.333020]  [<ffffffff813218ac>] __btrfs_cow_block+0x118/0x43d
[  644.339196]  [<ffffffff8133c00e>] ? btrfs_buffer_uptodate+0x49/0x5f
[  644.345717]  [<ffffffff81321d17>] btrfs_cow_block+0x146/0x1ac
[  644.351722]  [<ffffffff81367396>] ? btrfs_set_lock_blocking_rw+0xa9/0xf7
[  644.358677]  [<ffffffff813253a6>] btrfs_search_slot+0x2e1/0x784
[  644.364853]  [<ffffffff8133753f>] btrfs_del_csums+0xee/0x2e2
[  644.370772]  [<ffffffff8132cedd>] __btrfs_free_extent+0x5b3/0x60b
[  644.377129]  [<ffffffff81330c5d>] run_clustered_refs+0x79b/0x85f
[  644.383390]  [<ffffffff81330fb3>] btrfs_run_delayed_refs+0x292/0x3ed
[  644.390001]  [<ffffffff8197c2eb>] ? mutex_unlock+0xe/0x10
[  644.395658]  [<ffffffff81352284>] ? btrfs_run_ordered_operations+0x1a4/0x1b3
[  644.402966]  [<ffffffff813400b6>] btrfs_commit_transaction+0x94/0x995
[  644.409664]  [<ffffffff8108a996>] ? __init_waitqueue_head+0x33/0x33
[  644.416185]  [<ffffffff8107757a>] ? usleep_range+0x42/0x42
[  644.421931]  [<ffffffff8133a0bc>] transaction_kthread+0xec/0x1b3
[  644.428192]  [<ffffffff81339fd0>] ? cleaner_kthread+0xe8/0xe8
[  644.434195]  [<ffffffff8108a09b>] kthread+0x8b/0x93
[  644.439333]  [<ffffffff819863c4>] kernel_thread_helper+0x4/0x10
[  644.445509]  [<ffffffff8197e7dd>] ? retint_restore_args+0x13/0x13
[  644.451857]  [<ffffffff8108a010>] ? __init_kthread_worker+0x39/0x39
[  644.458379]  [<ffffffff819863c0>] ? gs_change+0x13/0x13
[  644.463861] ---[ end trace 10c6b128620d1b3b ]---
[  644.468767] btrfs: block rsv returned -28
[  644.473041] ------------[ cut here ]------------
[  644.477917] WARNING: at /c/wfg/tip/fs/btrfs/extent-tree.c:6330 btrfs_alloc_free_block+0xd6/0x28b()
[  644.487339] Hardware name: X7DW3
[  644.490828] Modules linked in:
[  644.494214] Pid: 10214, comm: btrfs-transacti Tainted: G        W    3.6.0-rc1+ #4
[  644.502254] Call Trace:
[  644.504957]  [<ffffffff810697ee>] warn_slowpath_common+0x83/0x9c
[  644.511221]  [<ffffffff81069821>] warn_slowpath_null+0x1a/0x1c
[  644.517314]  [<ffffffff8133246f>] btrfs_alloc_free_block+0xd6/0x28b
[  644.523833]  [<ffffffff81141973>] ? kfree+0x55/0x101
[  644.529057]  [<ffffffff813218ac>] __btrfs_cow_block+0x118/0x43d
[  644.535235]  [<ffffffff8133c00e>] ? btrfs_buffer_uptodate+0x49/0x5f
[  644.541756]  [<ffffffff81321d17>] btrfs_cow_block+0x146/0x1ac
[  644.547761]  [<ffffffff81367396>] ? btrfs_set_lock_blocking_rw+0xa9/0xf7
[  644.554714]  [<ffffffff813253a6>] btrfs_search_slot+0x2e1/0x784
[  644.560892]  [<ffffffff8133753f>] btrfs_del_csums+0xee/0x2e2
[  644.566811]  [<ffffffff8132cedd>] __btrfs_free_extent+0x5b3/0x60b
[  644.573168]  [<ffffffff81330c5d>] run_clustered_refs+0x79b/0x85f
[  644.579439]  [<ffffffff81330fb3>] btrfs_run_delayed_refs+0x292/0x3ed
[  644.586057]  [<ffffffff8197c2eb>] ? mutex_unlock+0xe/0x10
[  644.591712]  [<ffffffff81352284>] ? btrfs_run_ordered_operations+0x1a4/0x1b3
[  644.599016]  [<ffffffff813400b6>] btrfs_commit_transaction+0x94/0x995
[  644.605709]  [<ffffffff8108a996>] ? __init_waitqueue_head+0x33/0x33
[  644.612233]  [<ffffffff8107757a>] ? usleep_range+0x42/0x42
[  644.617979]  [<ffffffff8133a0bc>] transaction_kthread+0xec/0x1b3
[  644.624239]  [<ffffffff81339fd0>] ? cleaner_kthread+0xe8/0xe8
[  644.630241]  [<ffffffff8108a09b>] kthread+0x8b/0x93
[  644.635378]  [<ffffffff819863c4>] kernel_thread_helper+0x4/0x10
[  644.641555]  [<ffffffff8197e7dd>] ? retint_restore_args+0x13/0x13
[  644.647905]  [<ffffffff8108a010>] ? __init_kthread_worker+0x39/0x39
[  644.654428]  [<ffffffff819863c0>] ? gs_change+0x13/0x13
[  644.659910] ---[ end trace 10c6b128620d1b3c ]---
[  651.834616] use_block_rsv: 2039 callbacks suppressed

Thanks,
Fengguang

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="seriallog.lkp-st02"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc1+ (wfg@bee) (gcc version 4.7.1 (Debian 4.7.1-5) ) #4 SMP Fri Aug 17 01:01:52 CST 2012
[    0.000000] Command line: BOOT_IMAGE=x86_64/vmlinuz-3.5.0 run=/home/wfg/ioless-balance_dirty_pages/main-loop.sh log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal netconsole=6667@192.168.1.58:/eth1,6666@192.168.1.1/00:1b:21:11:78:3e ip=192.168.1.58:192.168.1.1:192.168.1.1:255.255.255.0:lkp-st02-x8664:eth1:none nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009b3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009b400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000cc000-0x00000000000d7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfefffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cff00000-0x00000000cff0bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cff0c000-0x00000000cff0cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cff0d000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Supermicro X7DW3/X7DWN, BIOS 6.00 09/28/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x230000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00D0000000 mask 3FF0000000 uncachable
[    0.000000]   1 base 00E0000000 mask 3FE0000000 uncachable
[    0.000000]   2 base 0000000000 mask 3E00000000 write-back
[    0.000000]   3 base 0200000000 mask 3FE0000000 write-back
[    0.000000]   4 base 0220000000 mask 3FF0000000 write-back
[    0.000000]   5 base 00CFF80000 mask 3FFFF80000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xcff80000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcff00 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f65f0-0x000f65ff] mapped at [ffff8800000f65f0]
[    0.000000]   mpc: 9e431-9e66d
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcfefffff]
[    0.000000]  [mem 0x00000000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcfefffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xcfefffff @ [mem 0x1f97b000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x22fffffff]
[    0.000000]  [mem 0x100000000-0x22fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x22fffffff @ [mem 0xcfef6000-0xcfefffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 257736(98%)
[    0.000000] ACPI: RSDP 00000000000f65c0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000cff05c78 00074 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000cff0bc4a 000F4 (v03 INTEL  STOAKLEY 06040000 PTL  00000003)
[    0.000000] ACPI: DSDT 00000000cff073f6 047E0 (v01  Intel SEABURG  06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cff0cfc0 00040
[    0.000000] ACPI: TCPA 00000000cff0bd3e 00032 (v01 Intel  STOAKLEY 06040000 LOHR 0000005A)
[    0.000000] ACPI: DMAR 00000000cff0bd70 00108 (v01 Intel  OEMDMAR  06040000 LOHR 00000001)
[    0.000000] ACPI: APIC 00000000cff0be78 000D4 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 00000000cff0bf4c 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cff0bf88 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 00000000cff0bfb0 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000cff07197 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff070f1 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff05cec 01405 (v01  PmRef    CpuPm 00003000 INTL 20050228)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000022fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x22fffffff]
[    0.000000]   NODE_DATA [mem 0x22f7fb000-0x22f7fffff]
[    0.000000]  [ffffea0000000000-ffffea0008bfffff] PMD -> [ffff880226e00000-ffff88022edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x22fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0xcfefffff]
[    0.000000]   node   0: [mem 0x100000000-0x22fffffff]
[    0.000000] On node 0 totalpages: 2096779
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3909 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 831296 pages, LIFO batch:31
[    0.000000]   Normal zone: 19456 pages used for memmap
[    0.000000]   Normal zone: 1225728 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec86000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec86000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec89000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec89000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec86000)
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec89000)
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 00000000000d8000
[    0.000000] PM: Registered nosave memory: 00000000000d8000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 00000000cff0c000
[    0.000000] PM: Registered nosave memory: 00000000cff0c000 - 00000000cff0d000
[    0.000000] PM: Registered nosave memory: 00000000cff0d000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88022f400000 s80704 r8192 d21696 u262144
[    0.000000] pcpu-alloc: s80704 r8192 d21696 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2060933
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=x86_64/vmlinuz-3.5.0 run=/home/wfg/ioless-balance_dirty_pages/main-loop.sh log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal netconsole=6667@192.168.1.58:/eth1,6666@192.168.1.1/00:1b:21:11:78:3e ip=192.168.1.58:192.168.1.1:192.168.1.1:255.255.255.0:lkp-st02-x8664:eth1:none nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8162428k/9175040k available (9770k kernel code, 787924k absent, 224688k reserved, 6054k data, 976k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:4352 nr_irqs:1560 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2666.637 MHz processor
[    0.002005] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.27 BogoMIPS (lpj=2666637)
[    0.004002] pid_max: default: 32768 minimum: 301
[    0.006299] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.011111] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.014351] Mount-cache hash table entries: 256
[    0.015311] Initializing cgroup subsys debug
[    0.016002] Initializing cgroup subsys cpuacct
[    0.017000] Initializing cgroup subsys memory
[    0.018011] Initializing cgroup subsys devices
[    0.019000] Initializing cgroup subsys freezer
[    0.020000] Initializing cgroup subsys blkio
[    0.021039] CPU: Physical Processor ID: 0
[    0.021999] CPU: Processor Core ID: 0
[    0.022999] mce: CPU supports 6 MCE banks
[    0.024004] CPU0: Thermal LVT vector (0xfa) already installed
[    0.025002] process: using mwait in idle threads
[    0.026002] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.026002] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.026002] tlb_flushall_shift is 0xffffffff
[    0.028843] ACPI: Core revision 20120711
[    0.033489] ftrace: allocating 38449 entries in 151 pages
[    0.043079] Getting VERSION: 50014
[    0.043997] Getting VERSION: 50014
[    0.044995] Getting ID: 0
[    0.045995] Getting ID: 0
[    0.046998] enabled ExtINT on CPU#0
[    0.049127] ENABLING IO-APIC IRQs
[    0.049995] init IO_APIC IRQs
[    0.050995]  apic 8 pin 0 not connected
[    0.051999] IOAPIC[0]: Set routing entry (8-1 -> 0x41 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.052999] IOAPIC[0]: Set routing entry (8-2 -> 0x51 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.053998] IOAPIC[0]: Set routing entry (8-3 -> 0x61 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.055001] IOAPIC[0]: Set routing entry (8-4 -> 0x71 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.055996] IOAPIC[0]: Set routing entry (8-5 -> 0x81 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.056996] IOAPIC[0]: Set routing entry (8-6 -> 0x91 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.057996] IOAPIC[0]: Set routing entry (8-7 -> 0xa1 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.058996] IOAPIC[0]: Set routing entry (8-8 -> 0xb1 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.059995] IOAPIC[0]: Set routing entry (8-9 -> 0xc1 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.060995] IOAPIC[0]: Set routing entry (8-10 -> 0xd1 -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.061995] IOAPIC[0]: Set routing entry (8-11 -> 0xe1 -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.062995] IOAPIC[0]: Set routing entry (8-12 -> 0x22 -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.063996] IOAPIC[0]: Set routing entry (8-13 -> 0x42 -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.064995] IOAPIC[0]: Set routing entry (8-14 -> 0x52 -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.065995] IOAPIC[0]: Set routing entry (8-15 -> 0x62 -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.066993]  apic 8 pin 16 not connected
[    0.067991]  apic 8 pin 17 not connected
[    0.068991]  apic 8 pin 18 not connected
[    0.069990]  apic 8 pin 19 not connected
[    0.070990]  apic 8 pin 20 not connected
[    0.071990]  apic 8 pin 21 not connected
[    0.072990]  apic 8 pin 22 not connected
[    0.073990]  apic 8 pin 23 not connected
[    0.074990]  apic 9 pin 0 not connected
[    0.075990]  apic 9 pin 1 not connected
[    0.076989]  apic 9 pin 2 not connected
[    0.077989]  apic 9 pin 3 not connected
[    0.078989]  apic 9 pin 4 not connected
[    0.079989]  apic 9 pin 5 not connected
[    0.080989]  apic 9 pin 6 not connected
[    0.081989]  apic 9 pin 7 not connected
[    0.082988]  apic 9 pin 8 not connected
[    0.083988]  apic 9 pin 9 not connected
[    0.084988]  apic 9 pin 10 not connected
[    0.085988]  apic 9 pin 11 not connected
[    0.086988]  apic 9 pin 12 not connected
[    0.087988]  apic 9 pin 13 not connected
[    0.088988]  apic 9 pin 14 not connected
[    0.089987]  apic 9 pin 15 not connected
[    0.090987]  apic 9 pin 16 not connected
[    0.091987]  apic 9 pin 17 not connected
[    0.092987]  apic 9 pin 18 not connected
[    0.093987]  apic 9 pin 19 not connected
[    0.094987]  apic 9 pin 20 not connected
[    0.095987]  apic 9 pin 21 not connected
[    0.096986]  apic 9 pin 22 not connected
[    0.097986]  apic 9 pin 23 not connected
[    0.098986]  apic 10 pin 0 not connected
[    0.099986]  apic 10 pin 1 not connected
[    0.100986]  apic 10 pin 2 not connected
[    0.101986]  apic 10 pin 3 not connected
[    0.102985]  apic 10 pin 4 not connected
[    0.103985]  apic 10 pin 5 not connected
[    0.104985]  apic 10 pin 6 not connected
[    0.105985]  apic 10 pin 7 not connected
[    0.106985]  apic 10 pin 8 not connected
[    0.107985]  apic 10 pin 9 not connected
[    0.108985]  apic 10 pin 10 not connected
[    0.109984]  apic 10 pin 11 not connected
[    0.110984]  apic 10 pin 12 not connected
[    0.111984]  apic 10 pin 13 not connected
[    0.112984]  apic 10 pin 14 not connected
[    0.113984]  apic 10 pin 15 not connected
[    0.114984]  apic 10 pin 16 not connected
[    0.115983]  apic 10 pin 17 not connected
[    0.116983]  apic 10 pin 18 not connected
[    0.117983]  apic 10 pin 19 not connected
[    0.118983]  apic 10 pin 20 not connected
[    0.119983]  apic 10 pin 21 not connected
[    0.120983]  apic 10 pin 22 not connected
[    0.121983]  apic 10 pin 23 not connected
[    0.123113] ..TIMER: vector=0x51 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.134614] smpboot: CPU0: Genuine Intel(R) CPU                  @ 2.66GHz stepping 0b
[    0.136981] Using local APIC timer interrupts.
[    0.136981] calibrating APIC timer ...
[    0.138978] ... lapic delta = 2083080
[    0.138978] ... PM-Timer delta = 357898
[    0.138978] ... PM-Timer result ok
[    0.138978] ..... delta 2083080
[    0.138978] ..... mult: 89481205
[    0.138978] ..... calibration result: 333292
[    0.138978] ..... CPU clock speed is 2666.0340 MHz.
[    0.138978] ..... host bus clock speed is 333.0292 MHz.
[    0.138992] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.143979] perf_event_intel: PEBS disabled due to CPU errata
[    0.144980] ... version:                2
[    0.145979] ... bit width:              40
[    0.146978] ... generic registers:      2
[    0.147978] ... value mask:             000000ffffffffff
[    0.148978] ... max period:             000000007fffffff
[    0.149978] ... fixed-purpose events:   3
[    0.150978] ... event mask:             0000000700000003
[    0.153259] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.154140] smpboot: Booting Node   0, Processors  #1[    0.002999] masked ExtINT on CPU#1
[    0.002999] CPU1: Thermal LVT vector (0xfa) already installed
 #2[    0.002999] masked ExtINT on CPU#2
[    0.002999] CPU2: Thermal LVT vector (0xfa) already installed
 #3[    0.002999] masked ExtINT on CPU#3
[    0.002999] CPU3: Thermal LVT vector (0xfa) already installed
 #4[    0.002999] masked ExtINT on CPU#4
[    0.002999] CPU4: Thermal LVT vector (0xfa) already installed
 #5[    0.002999] masked ExtINT on CPU#5
[    0.002999] CPU5: Thermal LVT vector (0xfa) already installed
 #6[    0.002999] masked ExtINT on CPU#6
[    0.002999] CPU6: Thermal LVT vector (0xfa) already installed
 #7 OK
[    0.002999] masked ExtINT on CPU#7
[    0.002999] CPU7: Thermal LVT vector (0xfa) already installed
[    0.367995] Brought up 8 CPUs
[    0.368946] smpboot: Total of 8 processors activated (42663.46 BogoMIPS)
[    0.371019] CPU0 attaching sched-domain:
[    0.371950]  domain 0: span 0,2 level MC
[    0.373944]   groups: 0 (cpu_power = 1023) 2
[    0.376628]   domain 1: span 0-7 level CPU
[    0.377943]    groups: 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048)
[    0.385395] CPU1 attaching sched-domain:
[    0.385942]  domain 0: span 1,3 level MC
[    0.387943]   groups: 1 3
[    0.389942]   domain 1: span 0-7 level CPU
[    0.391942]    groups: 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047)
[    0.398941] CPU2 attaching sched-domain:
[    0.399941]  domain 0: span 0,2 level MC
[    0.401939]   groups: 2 0 (cpu_power = 1023)
[    0.405939]   domain 1: span 0-7 level CPU
[    0.407940]    groups: 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048)
[    0.414938] CPU3 attaching sched-domain:
[    0.415939]  domain 0: span 1,3 level MC
[    0.417937]   groups: 3 1
[    0.420385]   domain 1: span 0-7 level CPU
[    0.421936]    groups: 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047)
[    0.429384] CPU4 attaching sched-domain:
[    0.429936]  domain 0: span 4,6 level MC
[    0.431936]   groups: 4 6
[    0.433851]   domain 1: span 0-7 level CPU
[    0.434934]    groups: 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048)
[    0.443375] CPU5 attaching sched-domain:
[    0.443935]  domain 0: span 5,7 level MC
[    0.445933]   groups: 5 7
[    0.447934]   domain 1: span 0-7 level CPU
[    0.449932]    groups: 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048)
[    0.457933] CPU6 attaching sched-domain:
[    0.458931]  domain 0: span 4,6 level MC
[    0.460931]   groups: 6 4
[    0.463614]   domain 1: span 0-7 level CPU
[    0.464930]    groups: 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048)
[    0.472371] CPU7 attaching sched-domain:
[    0.472929]  domain 0: span 5,7 level MC
[    0.474928]   groups: 7 5
[    0.476929]   domain 1: span 0-7 level CPU
[    0.478928]    groups: 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048)
[    0.488047] devtmpfs: initialized
[    0.492437] PM: Registering ACPI NVS region [mem 0xcff0c000-0xcff0cfff] (4096 bytes)
[    0.494286] xor: automatically using best checksumming function:
[    0.504925]    generic_sse:  9884.000 MB/sec
[    0.505955] RTC time: 11:34:40, date: 08/17/12
[    0.506982] NET: Registered protocol family 16
[    0.509509] ACPI: bus type pci registered
[    0.509955] dca service started, version 1.12.1
[    0.510940] PCI: MMCONFIG for domain 0000 [bus 00-09] at [mem 0xe0000000-0xe09fffff] (base 0xe0000000)
[    0.511926] PCI: MMCONFIG at [mem 0xe0000000-0xe09fffff] reserved in E820
[    0.514338] PCI: Using configuration type 1 for base access
[    0.535956] bio: create slab <bio-0> at 0
[    0.553933] raid6: sse2x1    3871 MB/s
[    0.571916] raid6: sse2x2    7347 MB/s
[    0.589917] raid6: sse2x4    8308 MB/s
[    0.590911] raid6: using algorithm sse2x4 (8308 MB/s)
[    0.591911] raid6: using ssse3x2 recovery algorithm
[    0.592928] ACPI: Added _OSI(Module Device)
[    0.593913] ACPI: Added _OSI(Processor Device)
[    0.594911] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.595911] ACPI: Added _OSI(Processor Aggregator Device)
[    0.598121] ACPI: EC: Look up EC in DSDT
[    0.604747] ACPI: Interpreter enabled
[    0.604912] ACPI: (supports S0 S1 S4 S5)
[    0.607912] ACPI: Using IOAPIC for interrupt routing
[    0.616040] ACPI: No dock devices found.
[    0.616911] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.619882] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.622496] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.622908] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.623909] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.624908] pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.625907] pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff] (ignored)
[    0.626907] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff] (ignored)
[    0.627908] PCI: root bus 00: using default resources
[    0.628909] pci_root PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-09] only partially covers this bridge
[    0.629932] PCI host bridge to bus 0000:00
[    0.630910] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.631907] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.632906] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.633906] pci_bus 0000:00: root bus resource [mem 0x00000000-0x3fffffffff]
[    0.634920] pci 0000:00:00.0: [8086:4003] type 00 class 0x060000
[    0.635952] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.636923] pci 0000:00:01.0: [8086:4021] type 01 class 0x060400
[    0.637952] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.638925] pci 0000:00:03.0: [8086:4023] type 01 class 0x060400
[    0.639951] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.640927] pci 0000:00:05.0: [8086:4025] type 01 class 0x060400
[    0.641951] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.642924] pci 0000:00:07.0: [8086:4027] type 01 class 0x060400
[    0.643950] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.644921] pci 0000:00:09.0: [8086:4029] type 01 class 0x060400
[    0.645950] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.646925] pci 0000:00:0f.0: [8086:402f] type 00 class 0x088000
[    0.647912] pci 0000:00:0f.0: reg 10: [mem 0xfe700000-0xfe703fff 64bit]
[    0.648946] pci 0000:00:10.0: [8086:4030] type 00 class 0x060000
[    0.649927] pci 0000:00:10.1: [8086:4030] type 00 class 0x060000
[    0.650927] pci 0000:00:10.2: [8086:4030] type 00 class 0x060000
[    0.651927] pci 0000:00:10.3: [8086:4030] type 00 class 0x060000
[    0.652926] pci 0000:00:10.4: [8086:4030] type 00 class 0x060000
[    0.653929] pci 0000:00:11.0: [8086:4031] type 00 class 0x060000
[    0.654929] pci 0000:00:15.0: [8086:4035] type 00 class 0x060000
[    0.655926] pci 0000:00:15.1: [8086:4035] type 00 class 0x060000
[    0.656932] pci 0000:00:16.0: [8086:4036] type 00 class 0x060000
[    0.657925] pci 0000:00:16.1: [8086:4036] type 00 class 0x060000
[    0.658942] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[    0.659969] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.660925] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.661938] pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
[    0.662934] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.663937] pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
[    0.664930] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.665937] pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
[    0.666940] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.667916] pci 0000:00:1d.7: reg 10: [mem 0xd8704000-0xd87043ff]
[    0.668980] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.669917] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.670956] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.671974] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.672917] pci 0000:00:1f.1: [8086:269e] type 00 class 0x01018a
[    0.673909] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.674906] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.675906] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.676906] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.677906] pci 0000:00:1f.1: reg 20: [io  0x1860-0x186f]
[    0.678934] pci 0000:00:1f.2: [8086:2681] type 00 class 0x010601
[    0.679911] pci 0000:00:1f.2: reg 10: [io  0x18b0-0x18b7]
[    0.680904] pci 0000:00:1f.2: reg 14: [io  0x18a8-0x18ab]
[    0.681904] pci 0000:00:1f.2: reg 18: [io  0x18a0-0x18a7]
[    0.682904] pci 0000:00:1f.2: reg 1c: [io  0x1874-0x1877]
[    0.683904] pci 0000:00:1f.2: reg 20: [io  0x1880-0x189f]
[    0.684904] pci 0000:00:1f.2: reg 24: [mem 0xd8704400-0xd87047ff]
[    0.685931] pci 0000:00:1f.2: PME# supported from D3hot
[    0.686912] pci 0000:00:1f.3: [8086:269b] type 00 class 0x0c0500
[    0.687944] pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
[    0.689958] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
[    0.690908] pci 0000:01:00.0: [1000:0058] type 00 class 0x010000
[    0.691905] pci 0000:01:00.0: reg 10: [io  0x2000-0x20ff]
[    0.692907] pci 0000:01:00.0: reg 14: [mem 0xd8510000-0xd8513fff 64bit]
[    0.693907] pci 0000:01:00.0: reg 1c: [mem 0xd8500000-0xd850ffff 64bit]
[    0.694909] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x001fffff pref]
[    0.695935] pci 0000:01:00.0: supports D1 D2
[    0.696906] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.697897] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.698897] pci 0000:00:01.0:   bridge window [mem 0xd8500000-0xd85fffff]
[    0.699898] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xd81fffff 64bit pref]
[    0.700923] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
[    0.701896] pci 0000:00:03.0: PCI bridge to [bus 02]
[    0.702927] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-ff]
[    0.703896] pci 0000:00:05.0: PCI bridge to [bus 03]
[    0.705922] pci_bus 0000:04: busn_res: [bus 04-07] is inserted under [bus 00-ff]
[    0.706903] pci 0000:04:00.0: [8086:3500] type 01 class 0x060400
[    0.707952] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.708913] pci 0000:04:00.3: [8086:350c] type 01 class 0x060400
[    0.709954] pci 0000:04:00.3: PME# supported from D0 D3hot D3cold
[    0.710907] pci 0000:00:07.0: PCI bridge to [bus 04-07]
[    0.711895] pci 0000:00:07.0:   bridge window [io  0x3000-0x3fff]
[    0.712895] pci 0000:00:07.0:   bridge window [mem 0xd8200000-0xd83fffff]
[    0.713896] pci 0000:00:07.0:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    0.714922] pci_bus 0000:05: busn_res: [bus 05-06] is inserted under [bus 04-07]
[    0.715902] pci 0000:05:00.0: [8086:3510] type 01 class 0x060400
[    0.716957] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.717930] pci 0000:04:00.0: PCI bridge to [bus 05-06]
[    0.718933] pci_bus 0000:06: busn_res: [bus 06] is inserted under [bus 05-06]
[    0.719894] pci 0000:05:00.0: PCI bridge to [bus 06]
[    0.720932] pci_bus 0000:07: busn_res: [bus 07] is inserted under [bus 04-07]
[    0.721904] pci 0000:07:01.0: [8086:107c] type 00 class 0x020000
[    0.722906] pci 0000:07:01.0: reg 10: [mem 0xd8220000-0xd823ffff]
[    0.723899] pci 0000:07:01.0: reg 14: [mem 0xd8200000-0xd821ffff]
[    0.724899] pci 0000:07:01.0: reg 18: [io  0x3000-0x303f]
[    0.725919] pci 0000:07:01.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.726921] pci 0000:07:01.0: PME# supported from D0 D3hot D3cold
[    0.727930] pci 0000:04:00.3: PCI bridge to [bus 07]
[    0.728893] pci 0000:04:00.3:   bridge window [io  0x3000-0x3fff]
[    0.729893] pci 0000:04:00.3:   bridge window [mem 0xd8200000-0xd82fffff]
[    0.730894] pci 0000:04:00.3:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    0.731926] pci_bus 0000:08: busn_res: [bus 08] is inserted under [bus 00-ff]
[    0.732907] pci 0000:08:00.0: [8086:10a7] type 00 class 0x020000
[    0.733900] pci 0000:08:00.0: reg 10: [mem 0xd8420000-0xd843ffff]
[    0.734898] pci 0000:08:00.0: reg 14: [mem 0xd8400000-0xd841ffff]
[    0.735898] pci 0000:08:00.0: reg 18: [io  0x4000-0x401f]
[    0.736897] pci 0000:08:00.0: reg 1c: [mem 0xd8480000-0xd8483fff]
[    0.737911] pci 0000:08:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.738934] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.740908] pci 0000:08:00.1: [8086:10a7] type 00 class 0x020000
[    0.741899] pci 0000:08:00.1: reg 10: [mem 0xd8460000-0xd847ffff]
[    0.742896] pci 0000:08:00.1: reg 14: [mem 0xd8440000-0xd845ffff]
[    0.743896] pci 0000:08:00.1: reg 18: [io  0x4020-0x403f]
[    0.744896] pci 0000:08:00.1: reg 1c: [mem 0xd8484000-0xd8487fff]
[    0.745910] pci 0000:08:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.746933] pci 0000:08:00.1: PME# supported from D0 D3hot D3cold
[    0.747908] pci 0000:00:09.0: PCI bridge to [bus 08]
[    0.748889] pci 0000:00:09.0:   bridge window [io  0x4000-0x4fff]
[    0.749889] pci 0000:00:09.0:   bridge window [mem 0xd8400000-0xd84fffff]
[    0.750890] pci 0000:00:09.0:   bridge window [mem 0xd8900000-0xd89fffff 64bit pref]
[    0.751924] pci_bus 0000:09: busn_res: [bus 09] is inserted under [bus 00-ff]
[    0.752889] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    0.753889] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    0.754889] pci 0000:00:1c.0:   bridge window [mem 0xd8a00000-0xd8bfffff]
[    0.755891] pci 0000:00:1c.0:   bridge window [mem 0xd8c00000-0xd8dfffff 64bit pref]
[    0.756906] pci_bus 0000:0a: busn_res: [bus 0a] is inserted under [bus 00-ff]
[    0.757898] pci 0000:0a:01.0: [1002:515e] type 00 class 0x030000
[    0.758901] pci 0000:0a:01.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    0.759895] pci 0000:0a:01.0: reg 14: [io  0x5000-0x50ff]
[    0.760895] pci 0000:0a:01.0: reg 18: [mem 0xd8600000-0xd860ffff]
[    0.761919] pci 0000:0a:01.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.762914] pci 0000:0a:01.0: supports D1 D2
[    0.763928] pci 0000:00:1e.0: PCI bridge to [bus 0a] (subtractive decode)
[    0.764887] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    0.765887] pci 0000:00:1e.0:   bridge window [mem 0xd8600000-0xd86fffff]
[    0.766889] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    0.767886] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.768885] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0x3fffffffff] (subtractive decode)
[    0.769907] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.771095] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.771953] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.772951] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.773951] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.774926] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7.BMD0._PRT]
[    0.775928] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7.BMD0.BPD0._PRT]
[    0.776954] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7.BMF3._PRT]
[    0.777990] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.778932] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.779972] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.780954]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
[    0.792953] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 14 15), disabled.
[    0.797409] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15), disabled.
[    0.802399] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15), disabled.
[    0.807410] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.812956] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 14 15), disabled.
[    0.818963] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 *11 14 15), disabled.
[    0.824394] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15), disabled.
[    0.829891] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 *11 14 15), disabled.
[    0.835880] vgaarb: device added: PCI:0000:0a:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.836874] vgaarb: loaded
[    0.837874] vgaarb: bridge control possible 0000:0a:01.0
[    0.838947] SCSI subsystem initialized
[    0.839877] ACPI: bus type scsi registered
[    0.840893] libata version 3.00 loaded.
[    0.842886] ACPI: bus type usb registered
[    0.843895] usbcore: registered new interface driver usbfs
[    0.844887] usbcore: registered new interface driver hub
[    0.845886] usbcore: registered new device driver usb
[    0.846895] wmi: Mapper loaded
[    0.847885] Advanced Linux Sound Architecture Driver Version 1.0.25.
[    0.848874] PCI: Using ACPI for IRQ routing
[    0.849875] PCI: pci_cache_line_size set to 64 bytes
[    0.850975] e820: reserve RAM buffer [mem 0x0009b400-0x0009ffff]
[    0.851872] e820: reserve RAM buffer [mem 0xcff00000-0xcfffffff]
[    0.854573] hpet clockevent registered
[    0.854874] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.855873] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.858311] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.865893] Switching to clocksource hpet
[    0.880097] pnp: PnP ACPI init
[    0.883437] ACPI: bus type pnp registered
[    0.888927] pnp 00:00: [bus 00-ff]
[    0.892597] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.897563] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.901922] pnp 00:00: [io  0x0d00-0xffff window]
[    0.906888] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.912548] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.918206] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.923864] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.929524] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.935185] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.940849] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.946512] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.952169] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.957830] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.963489] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.969148] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.974807] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.980466] pnp 00:00: [mem 0xd0000000-0xfebfffff window]
[    0.986230] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.993212] pnp 00:01: [io  0x0010-0x001f]
[    0.997568] pnp 00:01: [io  0x0024-0x0025]
[    1.001928] pnp 00:01: [io  0x0028-0x0029]
[    1.006285] pnp 00:01: [io  0x002c-0x002d]
[    1.010645] pnp 00:01: [io  0x002e-0x002f]
[    1.015005] pnp 00:01: [io  0x0030-0x0031]
[    1.019363] pnp 00:01: [io  0x0034-0x0035]
[    1.023723] pnp 00:01: [io  0x0038-0x0039]
[    1.028082] pnp 00:01: [io  0x003c-0x003d]
[    1.032440] pnp 00:01: [io  0x004e-0x004f]
[    1.036793] pnp 00:01: [io  0x0050-0x0053]
[    1.041153] pnp 00:01: [io  0x0063]
[    1.044903] pnp 00:01: [io  0x0065]
[    1.048656] pnp 00:01: [io  0x0067]
[    1.052409] pnp 00:01: [io  0x0072-0x0077]
[    1.056769] pnp 00:01: [io  0x0080]
[    1.060511] pnp 00:01: [io  0x0090-0x009f]
[    1.064863] pnp 00:01: [io  0x00a4-0x00a5]
[    1.069214] pnp 00:01: [io  0x00a8-0x00a9]
[    1.073572] pnp 00:01: [io  0x00ac-0x00ad]
[    1.077933] pnp 00:01: [io  0x00b0-0x00b5]
[    1.082284] pnp 00:01: [io  0x00b8-0x00b9]
[    1.086642] pnp 00:01: [io  0x00bc-0x00bd]
[    1.091005] pnp 00:01: [io  0x04d0-0x04d1]
[    1.095360] pnp 00:01: [io  0x0295-0x0296]
[    1.099719] pnp 00:01: [io  0x0ca2-0x0ca3]
[    1.104079] pnp 00:01: [io  0x0ca8-0x0caf]
[    1.108431] pnp 00:01: [io  0x0800-0x080f]
[    1.112790] pnp 00:01: [io  0x1000-0x107f]
[    1.117148] pnp 00:01: [io  0x1180-0x11bf]
[    1.121509] pnp 00:01: [io  0xfe00]
[    1.131553] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    1.136604] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    1.141657] pnp 00:01: [mem 0xfec86000-0xfec86fff]
[    1.146715] pnp 00:01: [mem 0xfec89000-0xfec89fff]
[    1.151764] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    1.156817] pnp 00:01: [mem 0xfe000000-0xfe01ffff]
[    1.161868] pnp 00:01: [mem 0xfe600000-0xfe6fffff]
[    1.166912] pnp 00:01: [mem 0xfed20000-0xfed44fff]
[    1.171956] pnp 00:01: [mem 0xfed45000-0xfed8ffff]
[    1.177186] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    1.183364] system 00:01: [io  0x0295-0x0296] has been reserved
[    1.189544] system 00:01: [io  0x0ca2-0x0ca3] has been reserved
[    1.195722] system 00:01: [io  0x0ca8-0x0caf] has been reserved
[    1.201902] system 00:01: [io  0x0800-0x080f] has been reserved
[    1.208081] system 00:01: [io  0x1000-0x107f] has been reserved
[    1.214261] system 00:01: [io  0x1180-0x11bf] has been reserved
[    1.220438] system 00:01: [io  0xfe00] has been reserved
[    1.226013] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    1.232885] system 00:01: [mem 0xfee00000-0xfee0ffff] could not be reserved
[    1.240115] system 00:01: [mem 0xfec86000-0xfec86fff] could not be reserved
[    1.247340] system 00:01: [mem 0xfec89000-0xfec89fff] could not be reserved
[    1.254561] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.261435] system 00:01: [mem 0xfe000000-0xfe01ffff] has been reserved
[    1.268314] system 00:01: [mem 0xfe600000-0xfe6fffff] has been reserved
[    1.275186] system 00:01: [mem 0xfed20000-0xfed44fff] has been reserved
[    1.282058] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.288934] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.296000] pnp 00:02: [io  0x0000-0x001f]
[    1.300363] pnp 00:02: [io  0x0081-0x0091]
[    1.304721] pnp 00:02: [io  0x0093-0x009f]
[    1.309081] pnp 00:02: [io  0x00c0-0x00df]
[    1.313442] pnp 00:02: [dma 4]
[    1.316832] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.323636] pnp 00:03: [io  0x00f0-0x00fe]
[    1.327999] pnp 00:03: [irq 13]
[    1.331475] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.338383] pnp 00:04: [irq 0 disabled]
[    1.342485] pnp 00:04: [irq 8]
[    1.345803] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    1.350929] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.357765] pnp 00:05: [io  0x0070-0x0071]
[    1.362193] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.368988] pnp 00:06: [io  0x0061]
[    1.372809] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.379818] pnp 00:07: [mem 0xff000000-0xffffffff]
[    1.384951] pnp 00:07: Plug and Play ACPI device, IDs INT0800 (active)
[    1.391760] pnp 00:08: [io  0x0060]
[    1.395514] pnp 00:08: [io  0x0064]
[    1.399268] pnp 00:08: [irq 1]
[    1.402667] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    1.410374] pnp 00:09: [irq 12]
[    1.413860] pnp 00:09: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.420959] pnp 00:0a: [io  0x03f8-0x03ff]
[    1.425322] pnp 00:0a: [irq 4]
[    1.428759] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.435856] pnp 00:0b: [io  0x02f8-0x02ff]
[    1.440214] pnp 00:0b: [irq 3]
[    1.443653] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.450861] pnp 00:0c: [io  0x03f0-0x03f5]
[    1.455219] pnp 00:0c: [io  0x03f7]
[    1.458973] pnp 00:0c: [irq 6]
[    1.462291] pnp 00:0c: [dma 2]
[    1.465711] pnp 00:0c: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.472651] pnp: PnP ACPI: found 13 devices
[    1.477094] ACPI: ACPI bus type pnp unregistered
[    1.493012] pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd81fffff pref]
[    1.500704] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.505928] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    1.512281] pci 0000:00:01.0:   bridge window [mem 0xd8500000-0xd85fffff]
[    1.519335] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xd81fffff 64bit pref]
[    1.527543] pci 0000:00:03.0: PCI bridge to [bus 02]
[    1.532773] pci 0000:00:05.0: PCI bridge to [bus 03]
[    1.538000] pci 0000:05:00.0: PCI bridge to [bus 06]
[    1.543236] pci 0000:04:00.0: PCI bridge to [bus 05-06]
[    1.548733] pci 0000:07:01.0: BAR 6: assigned [mem 0xd8800000-0xd881ffff pref]
[    1.556418] pci 0000:04:00.3: PCI bridge to [bus 07]
[    1.561645] pci 0000:04:00.3:   bridge window [io  0x3000-0x3fff]
[    1.567999] pci 0000:04:00.3:   bridge window [mem 0xd8200000-0xd82fffff]
[    1.575054] pci 0000:04:00.3:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.583262] pci 0000:00:07.0: PCI bridge to [bus 04-07]
[    1.588747] pci 0000:00:07.0:   bridge window [io  0x3000-0x3fff]
[    1.595101] pci 0000:00:07.0:   bridge window [mem 0xd8200000-0xd83fffff]
[    1.602145] pci 0000:00:07.0:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.610355] pci 0000:08:00.0: BAR 6: assigned [mem 0xd8900000-0xd891ffff pref]
[    1.618050] pci 0000:08:00.1: BAR 6: assigned [mem 0xd8920000-0xd893ffff pref]
[    1.625735] pci 0000:00:09.0: PCI bridge to [bus 08]
[    1.630961] pci 0000:00:09.0:   bridge window [io  0x4000-0x4fff]
[    1.637314] pci 0000:00:09.0:   bridge window [mem 0xd8400000-0xd84fffff]
[    1.644362] pci 0000:00:09.0:   bridge window [mem 0xd8900000-0xd89fffff 64bit pref]
[    1.652580] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    1.657804] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    1.664166] pci 0000:00:1c.0:   bridge window [mem 0xd8a00000-0xd8bfffff]
[    1.671212] pci 0000:00:1c.0:   bridge window [mem 0xd8c00000-0xd8dfffff 64bit pref]
[    1.679422] pci 0000:0a:01.0: BAR 6: assigned [mem 0xd8620000-0xd863ffff pref]
[    1.687113] pci 0000:00:1e.0: PCI bridge to [bus 0a]
[    1.692340] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    1.698693] pci 0000:00:1e.0:   bridge window [mem 0xd8600000-0xd86fffff]
[    1.705740] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.713970] IOAPIC[2]: Set routing entry (10-0 -> 0x72 -> IRQ 48 Mode:1 Active:1 Dest:255)
[    1.722708] IOAPIC[2]: Set routing entry (10-2 -> 0x82 -> IRQ 50 Mode:1 Active:1 Dest:255)
[    1.731443] IOAPIC[2]: Set routing entry (10-4 -> 0x92 -> IRQ 52 Mode:1 Active:1 Dest:255)
[    1.740179] IOAPIC[2]: Set routing entry (10-6 -> 0xa2 -> IRQ 54 Mode:1 Active:1 Dest:255)
[    1.748925] IOAPIC[2]: Set routing entry (10-8 -> 0xb2 -> IRQ 56 Mode:1 Active:1 Dest:255)
[    1.757666] IOAPIC[0]: Set routing entry (8-16 -> 0xc2 -> IRQ 16 Mode:1 Active:1 Dest:255)
[    1.766404] pci 0000:00:1e.0: setting latency timer to 64
[    1.772065] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.777897] pci_bus 0000:00: resource 5 [mem 0x00000000-0x3fffffffff]
[    1.784596] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.790428] pci_bus 0000:01: resource 1 [mem 0xd8500000-0xd85fffff]
[    1.796955] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xd81fffff 64bit pref]
[    1.804650] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    1.810482] pci_bus 0000:04: resource 1 [mem 0xd8200000-0xd83fffff]
[    1.817013] pci_bus 0000:04: resource 2 [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.824706] pci_bus 0000:07: resource 0 [io  0x3000-0x3fff]
[    1.830538] pci_bus 0000:07: resource 1 [mem 0xd8200000-0xd82fffff]
[    1.837064] pci_bus 0000:07: resource 2 [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.844751] pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
[    1.850583] pci_bus 0000:08: resource 1 [mem 0xd8400000-0xd84fffff]
[    1.857109] pci_bus 0000:08: resource 2 [mem 0xd8900000-0xd89fffff 64bit pref]
[    1.864798] pci_bus 0000:09: resource 0 [io  0x6000-0x6fff]
[    1.870631] pci_bus 0000:09: resource 1 [mem 0xd8a00000-0xd8bfffff]
[    1.877156] pci_bus 0000:09: resource 2 [mem 0xd8c00000-0xd8dfffff 64bit pref]
[    1.884842] pci_bus 0000:0a: resource 0 [io  0x5000-0x5fff]
[    1.890676] pci_bus 0000:0a: resource 1 [mem 0xd8600000-0xd86fffff]
[    1.897202] pci_bus 0000:0a: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.904889] pci_bus 0000:0a: resource 4 [io  0x0000-0xffff]
[    1.910721] pci_bus 0000:0a: resource 5 [mem 0x00000000-0x3fffffffff]
[    1.917464] NET: Registered protocol family 2
[    1.922875] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.934561] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.942521] TCP: Hash tables configured (established 524288 bind 65536)
[    1.949463] TCP: reno registered
[    1.952993] UDP hash table entries: 4096 (order: 6, 393216 bytes)
[    1.959553] UDP-Lite hash table entries: 4096 (order: 6, 393216 bytes)
[    1.966615] NET: Registered protocol family 1
[    1.971371] RPC: Registered named UNIX socket transport module.
[    1.977553] RPC: Registered udp transport module.
[    1.982517] RPC: Registered tcp transport module.
[    1.987482] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.994269] IOAPIC[0]: Set routing entry (8-20 -> 0xd2 -> IRQ 20 Mode:1 Active:1 Dest:255)
[    2.003021] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    2.009549] pci 0000:00:1d.0: Performing full reset
[    2.014708] IOAPIC[0]: Set routing entry (8-21 -> 0xe2 -> IRQ 21 Mode:1 Active:1 Dest:255)
[    2.023436] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    2.029967] pci 0000:00:1d.1: Performing full reset
[    2.035126] IOAPIC[0]: Set routing entry (8-22 -> 0x23 -> IRQ 22 Mode:1 Active:1 Dest:255)
[    2.043864] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    2.050394] pci 0000:00:1d.2: Performing full reset
[    2.055553] IOAPIC[0]: Set routing entry (8-23 -> 0x43 -> IRQ 23 Mode:1 Active:1 Dest:255)
[    2.064336] PCI: CLS mismatch (32 != 64), using 64 bytes
[    2.069907] pci 0000:08:00.0: Disabling L0s
[    2.080703] pci 0000:08:00.1: Disabling L0s
[    2.085151] pci 0000:0a:01.0: Boot video device
[    2.090022] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.096732] software IO TLB [mem 0xcbef6000-0xcfef5fff] (64MB) mapped at [ffff8800cbef6000-ffff8800cfef5fff]
[    2.107962] Simple Boot Flag at 0x41 set to 0x80
[    2.113091] Machine check injector initialized
[    2.119266] microcode: CPU0 sig=0x6fb, pf=0x40, revision=0xb4
[    2.125277] microcode: CPU1 sig=0x6fb, pf=0x40, revision=0xb4
[    2.131289] microcode: CPU2 sig=0x6fb, pf=0x40, revision=0xb4
[    2.137306] microcode: CPU3 sig=0x6fb, pf=0x40, revision=0xb4
[    2.143315] microcode: CPU4 sig=0x6fb, pf=0x40, revision=0xb4
[    2.149330] microcode: CPU5 sig=0x6fb, pf=0x40, revision=0xb4
[    2.155349] microcode: CPU6 sig=0x6fb, pf=0x40, revision=0xb4
[    2.161364] microcode: CPU7 sig=0x6fb, pf=0x40, revision=0xb4
[    2.167462] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.177105] audit: initializing netlink socket (disabled)
[    2.182790] type=2000 audit(1345203279.181:1): initialized
[    2.222406] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.236132] NFS: Registering the id_resolver key type
[    2.241459] Key type id_resolver registered
[    2.245908] Key type id_legacy registered
[    2.250184] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.257311] fuse init (API version 7.19)
[    2.261735] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    2.271873] NILFS version 2 loaded
[    2.276150] Btrfs loaded
[    2.278947] msgmni has been set to 15942
[    2.284156] async_tx: api initialized (async)
[    2.288903] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.296809] io scheduler noop registered
[    2.301009] io scheduler deadline registered
[    2.305545] io scheduler cfq registered (default)
[    2.310847] pcieport 0000:00:1c.0: irq 88 for MSI/MSI-X
[    2.316662] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.323072] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0C:00/input/input0
[    2.332682] ACPI: Power Button [PWRB]
[    2.336701] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.344569] ACPI: Power Button [PWRF]
[    2.357078] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.363228] IOAPIC[2]: Set routing entry (10-9 -> 0x63 -> IRQ 57 Mode:1 Active:1 Dest:255)
[    2.372027] ioatdma 0000:00:0f.0: channel enumeration error
[    2.377870] ioatdma 0000:00:0f.0: Intel(R) I/OAT DMA Engine init failed
[    2.426013] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.453111] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.479949] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.507305] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.533851] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.539928] Initializing Nozomi driver 2.1d
[    2.544971] Non-volatile memory driver v1.3
[    2.549517] intel_rng: FWH not detected
[    2.553703] Linux agpgart interface v0.103
[    2.558132] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    2.567563] Hangcheck: Using getrawmonotonic().
[    2.572420] [drm] Initialized drm 1.1.0 20060810
[    2.577960] Floppy drive(s): fd0 is 1.44M[    2.580956] brd: module loaded
[    2.582715] loop: module loaded
[    2.582955] ACPI Warning: 0x00000000fed1f410-0x00000000fed1f414 SystemMemory conflicts with Region \RCRB 1 (20120711/utaddress-251)
[    2.582959] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.582960] lpc_ich: Resource conflict(s) found affecting iTCO_wdt
[    2.583521] Loading iSCSI transport class v2.0-870.
[    2.584415] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    2.584415] Detecting Adaptec I2O RAID controllers...
[    2.584574] Adaptec aacraid driver 1.2-0[29800]-ms
[    2.584760] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    2.584842] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    2.584998] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.04.00.03-k.
[    2.585151] iscsi: registered transport (qla4xxx)
[    2.585219] QLogic iSCSI HBA Driver
[    2.585303] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    2.585393] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    2.585465] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
[    2.585546] mpt2sas version 13.100.00.00 loaded
[    2.585705] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    2.585995] ahci 0000:00:1f.2: version 3.0
[    2.586019] IOAPIC[0]: Set routing entry (8-17 -> 0x73 -> IRQ 17 Mode:1 Active:1 Dest:255)

[    2.716320] 
[    2.716441] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.716444] ahci 0000:00:1f.2: flags: 64bit ncq pm led pmp slum part 
[    2.716450] ahci 0000:00:1f.2: setting latency timer to 64
[    2.718151] scsi0 : ahci
[    2.718340] scsi1 : ahci
[    2.718513] scsi2 : ahci
[    2.718697] scsi3 : ahci
[    2.718892] scsi4 : ahci
[    2.719093] scsi5 : ahci
[    2.719240] ata1: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704500 irq 17
[    2.719242] ata2: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704580 irq 17
[    2.719244] ata3: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704600 irq 17
[    2.719246] ata4: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704680 irq 17
[    2.719249] ata5: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704700 irq 17
[    2.719251] ata6: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704780 irq 17
[    2.719640] ata_piix 0000:00:1f.1: version 2.13
[    2.719688] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.720426] scsi6 : ata_piix
[    2.720644] scsi7 : ata_piix
[    2.720798] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1860 irq 14
[    2.720800] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1868 irq 15
[    2.720977] ata8: port disabled--ignoring
[    2.723615] tun: Universal TUN/TAP device driver, 1.6
[    2.723616] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.723961] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    2.724100] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    2.724101] Copyright (c) 2007 Atheros Corporation.
[    2.724356] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.12 (June 29, 2012)
[    2.724477] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    2.724541] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    2.724541]   http://www.scyld.com/network/drivers.html
[    2.724731] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    2.724851] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    2.724851] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.724880] IOAPIC[1]: Set routing entry (9-0 -> 0x83 -> IRQ 24 Mode:1 Active:1 Dest:255)
[    2.890495] ata7.00: ATAPI: LITE-ON COMBO SOHC-5236V, R$0G, max UDMA/44
[    2.890498] ata7.00: limited to UDMA/33 due to 40-wire cable
[    2.912292] ata7.00: configured for UDMA/33
[    2.954444] FDC 0 is a post-1991 82077
[    3.024025] ata5: SATA link down (SStatus 0 SControl 300)
[    3.029716] ata3: SATA link down (SStatus 0 SControl 300)
[    3.035402] ata2: SATA link down (SStatus 0 SControl 300)
[    3.041087] ata4: SATA link down (SStatus 0 SControl 300)
[    3.046772] ata6: SATA link down (SStatus 0 SControl 300)
[    3.114021] tsc: Refined TSC clocksource calibration: 2666.761 MHz
[    3.120473] Switching to clocksource tsc
[    3.130171] e1000 0000:07:01.0: eth0: (PCI:66MHz:32-bit) 00:0e:0c:c3:8f:a8
[    3.137313] e1000 0000:07:01.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.144511] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[    3.150602] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    3.156848] igb: Intel(R) Gigabit Ethernet Network Driver - version 4.0.1-k
[    3.164069] igb: Copyright (c) 2007-2012 Intel Corporation.
[    3.170170] igb 0000:08:00.0: irq 89 for MSI/MSI-X
[    3.175228] igb 0000:08:00.0: irq 90 for MSI/MSI-X
[    3.180282] igb 0000:08:00.0: irq 91 for MSI/MSI-X
[    3.185334] igb 0000:08:00.0: irq 92 for MSI/MSI-X
[    3.190397] igb 0000:08:00.0: irq 93 for MSI/MSI-X
[    3.195462] igb 0000:08:00.0: irq 94 for MSI/MSI-X
[    3.200518] igb 0000:08:00.0: irq 95 for MSI/MSI-X
[    3.205580] igb 0000:08:00.0: irq 96 for MSI/MSI-X
[    3.207020] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.208036] ata1.00: ATA-7: Hitachi HDS721616PLA380, P22OAB3A, max UDMA/133
[    3.208038] ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    3.231606] igb 0000:08:00.0: irq 97 for MSI/MSI-X
[    3.231610] ata1.00: configured for UDMA/133
[    3.231758] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72161 P22O PQ: 0 ANSI: 5
[    3.232078] sd 0:0:0:0: [sda] 321672960 512-byte logical blocks: (164 GB/153 GiB)
[    3.232124] sd 0:0:0:0: [sda] Write Protect is off
[    3.232127] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.232147] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.233677] scsi 6:0:0:0: CD-ROM            LITE-ON  COMBO SOHC-5236V R$0G PQ: 0 ANSI: 5
[    3.263493]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.264160] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.473661] igb 0000:08:00.0: Intel(R) Gigabit Ethernet Network Connection
[    3.480796] igb 0000:08:00.0: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:7c:cf:72
[    3.488259] igb 0000:08:00.0: eth1: PBA No: FFFFFF-0FF
[    3.493654] igb 0000:08:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    3.508023] IOAPIC[2]: Set routing entry (10-22 -> 0x64 -> IRQ 70 Mode:1 Active:1 Dest:255)
[    3.517084] igb 0000:08:00.1: irq 98 for MSI/MSI-X
[    3.522138] igb 0000:08:00.1: irq 99 for MSI/MSI-X
[    3.527191] igb 0000:08:00.1: irq 100 for MSI/MSI-X
[    3.532329] igb 0000:08:00.1: irq 101 for MSI/MSI-X
[    3.537471] igb 0000:08:00.1: irq 102 for MSI/MSI-X
[    3.542609] igb 0000:08:00.1: irq 103 for MSI/MSI-X
[    3.547747] igb 0000:08:00.1: irq 104 for MSI/MSI-X
[    3.552886] igb 0000:08:00.1: irq 105 for MSI/MSI-X
[    3.558025] igb 0000:08:00.1: irq 106 for MSI/MSI-X
[    3.728645] igb 0000:08:00.1: Intel(R) Gigabit Ethernet Network Connection
[    3.735777] igb 0000:08:00.1: eth2: (PCIe:2.5Gb/s:Width x4) 00:30:48:7c:cf:73
[    3.743242] igb 0000:08:00.1: eth2: PBA No: FFFFFF-0FF
[    3.748636] igb 0000:08:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    3.756734] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[    3.765026] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    3.771267] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.9.15-k
[    3.779472] ixgbe: Copyright (c) 1999-2012 Intel Corporation.
[    3.785542] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    3.792941] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    3.798982] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    3.805131] sky2: driver version 1.30
[    3.809177] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    3.816452] usbcore: registered new interface driver catc
[    3.822166] usbcore: registered new interface driver kaweth
[    3.827998] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    3.836008] usbcore: registered new interface driver pegasus
[    3.841981] usbcore: registered new interface driver rtl8150
[    3.847956] usbcore: registered new interface driver asix
[    3.853670] usbcore: registered new interface driver cdc_ether
[    3.859822] usbcore: registered new interface driver cdc_eem
[    3.865794] usbcore: registered new interface driver dm9601
[    3.871683] usbcore: registered new interface driver smsc75xx
[    3.877753] usbcore: registered new interface driver smsc95xx
[    3.883812] usbcore: registered new interface driver gl620a
[    3.889695] usbcore: registered new interface driver net1080
[    3.895669] usbcore: registered new interface driver plusb
[    3.901466] usbcore: registered new interface driver rndis_host
[    3.907699] usbcore: registered new interface driver cdc_subset
[    3.913932] usbcore: registered new interface driver zaurus
[    3.919815] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    3.927740] usbcore: registered new interface driver int51x1
[    3.933716] usbcore: registered new interface driver ipheth
[    3.939601] usbcore: registered new interface driver sierra_net
[    3.945831] usbcore: registered new interface driver cdc_ncm
[    3.951748] Fusion MPT base driver 3.04.20
[    3.956097] Copyright (c) 1999-2008 LSI Corporation
[    3.961239] Fusion MPT SPI Host driver 3.04.20
[    3.966029] Fusion MPT FC Host driver 3.04.20
[    3.970711] Fusion MPT SAS Host driver 3.04.20
[    3.975508] mptbase: ioc0: Initiating bringup
[    4.258007] ACPI: Invalid Power Resource to register!
[    4.258008] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[   21.568922] scsi8 : ioc0: LSISAS1068E B3, FwRev=011a0000h, Ports=1, MaxQ=478, IRQ=48
[   21.613251] mptsas: ioc0: add expander: num_phys 25, sas_addr (0x50000d102db8057f)
[   21.722658] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 19, phy 4, sas_addr 0x5000c50005811519
[   21.733997] scsi 8:0:0:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.747174] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 20, phy 5, sas_addr 0x5000c500064a81a1
[   21.749695] sd 8:0:0:0: [sdb] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.751765] sd 8:0:0:0: [sdb] Write Protect is off
[   21.751768] sd 8:0:0:0: [sdb] Mode Sense: b3 00 10 08
[   21.753445] sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   21.787845] scsi 8:0:1:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.793850]  sdb: sdb1 sdb2
[   21.808282] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 21, phy 6, sas_addr 0x5000c500064a80a9
[   21.808569] sd 8:0:1:0: [sdc] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.809916] sd 8:0:0:0: [sdb] Attached SCSI disk
[   21.810621] sd 8:0:1:0: [sdc] Write Protect is off
[   21.810623] sd 8:0:1:0: [sdc] Mode Sense: b3 00 10 08
[   21.841772] sd 8:0:1:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   21.842934] scsi 8:0:2:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.860571] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 22, phy 7, sas_addr 0x5000c500064a8145
[   21.860574] sd 8:0:2:0: [sdd] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.864870] sd 8:0:2:0: [sdd] Write Protect is off
[   21.864872] sd 8:0:2:0: [sdd] Mode Sense: b3 00 10 08
[   21.889990] sd 8:0:2:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   21.890378] scsi 8:0:3:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.907575]  sdc: sdc1 sdc2
[   21.908298] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 23, phy 8, sas_addr 0x5000c500064a3b79
[   21.920769] sd 8:0:3:0: [sde] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.923443] scsi 8:0:4:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.941243] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 25, phy 9, sas_addr 0x5000c500058131f9
[   21.943617] sd 8:0:3:0: [sde] Write Protect is off
[   21.943619] sd 8:0:3:0: [sde] Mode Sense: b3 00 10 08
[   21.943900] sd 8:0:4:0: [sdf] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.969869] sd 8:0:3:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   21.970862] sd 8:0:4:0: [sdf] Write Protect is off
[   21.970864] sd 8:0:4:0: [sdf] Mode Sense: b3 00 10 08
[   21.989235]  sdd: sdd1 sdd2
[   21.989241] scsi 8:0:5:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.989243] sd 8:0:1:0: [sdc] Attached SCSI disk
[   22.005741] sd 8:0:4:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.016207] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 26, phy 10, sas_addr 0x5000c5000647bd39
[   22.023305] sd 8:0:5:0: [sdg] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.035579] sd 8:0:5:0: [sdg] Write Protect is off
[   22.035743] scsi 8:0:6:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.049217] sd 8:0:2:0: [sdd] Attached SCSI disk
[   22.049219]  sde: sde1 sde2
[   22.049253] sd 8:0:5:0: [sdg] Mode Sense: b3 00 10 08
[   22.049256]  sdf: sdf1 sdf2
[   22.050507] sd 8:0:6:0: [sdh] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.050510] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 27, phy 11, sas_addr 0x5000c50005813305
[   22.083838] sd 8:0:5:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.092872] sd 8:0:6:0: [sdh] Write Protect is off
[   22.092877] scsi 8:0:7:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.106517] sd 8:0:6:0: [sdh] Mode Sense: b3 00 10 08
[   22.109051] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 28, phy 12, sas_addr 0x5000c500064abf99
[   22.122066] sd 8:0:3:0: [sde] Attached SCSI disk
[   22.122072] sd 8:0:4:0: [sdf] Attached SCSI disk
[   22.122371] sd 8:0:7:0: [sdi] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.122500] scsi 8:0:8:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.149965] sd 8:0:6:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.150947] sd 8:0:7:0: [sdi] Write Protect is off
[   22.150949] sd 8:0:7:0: [sdi] Mode Sense: b3 00 10 08
[   22.152378] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 29, phy 13, sas_addr 0x5000c500064a7f1d
[   22.154618]  sdg: sdg1 sdg2
[   22.182588] sd 8:0:8:0: [sdj] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.182609] sd 8:0:7:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.185287] scsi 8:0:9:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.214710] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 30, phy 14, sas_addr 0x5000c5000647ecd9
[   22.214735] sd 8:0:8:0: [sdj] Write Protect is off
[   22.214737] sd 8:0:8:0: [sdj] Mode Sense: b3 00 10 08
[   22.214988] sd 8:0:9:0: [sdk] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.216363] sd 8:0:5:0: [sdg] Attached SCSI disk
[   22.216379] sd 8:0:8:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.257259]  sdi: sdi1 sdi2
[   22.257262] sd 8:0:9:0: [sdk] Write Protect is off
[   22.257265] sd 8:0:9:0: [sdk] Mode Sense: b3 00 10 08
[   22.257267]  sdh: sdh1 sdh2
[   22.273754] scsi 8:0:10:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.273774] sd 8:0:9:0: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.301450] sd 8:0:6:0: [sdh] Attached SCSI disk
[   22.302880] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 31, phy 15, sas_addr 0x5000c500064a7935
[   22.305108]  sdj: sdj1 sdj2
[   22.305388] sd 8:0:10:0: [sdl] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.327803] sd 8:0:7:0: [sdi] Attached SCSI disk
[   22.327820] scsi 8:0:11:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.341354]  sdk: sdk1 sdk2
[   22.341357] sd 8:0:10:0: [sdl] Write Protect is off
[   22.341360] sd 8:0:10:0: [sdl] Mode Sense: b3 00 10 08
[   22.354946] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 32, phy 24, sas_addr 0x50000d102db8057e
[   22.354975] sd 8:0:10:0: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.355287] sd 8:0:11:0: [sdm] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.382480] sd 8:0:8:0: [sdj] Attached SCSI disk
[   22.387388] sd 8:0:11:0: [sdm] Write Protect is off
[   22.392557] sd 8:0:11:0: [sdm] Mode Sense: b3 00 10 08
[   22.392569] scsi 8:0:12:0: Enclosure         ADAPTEC  SANbloc S50      T016 PQ: 0 ANSI: 5
[   22.393344] sd 8:0:9:0: [sdk] Attached SCSI disk
[   22.396471]  sdl: sdl1 sdl2
[   22.415626] Fusion MPT misc device (ioctl) driver 3.04.20
[   22.417156] sd 8:0:11:0: [sdm] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.430467] mptctl: Registered with Fusion MPT base driver
[   22.432083] sd 8:0:10:0: [sdl] Attached SCSI disk
[   22.441186] mptctl: /dev/mptctl @ (major,minor=10,220)
[   22.444834]  sdm: sdm1 sdm2
[   22.449695] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   22.456490] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[   22.458115] sd 8:0:11:0: [sdm] Attached SCSI disk
[   22.467772] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   22.473865] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   22.479357] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   22.487225] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   22.496651] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[   22.505395] ehci_hcd 0000:00:1d.7: reset command 0010002 (park)=0 ithresh=1 period=1024 Reset HALT
[   22.518708] ehci_hcd 0000:00:1d.7: debug port 1
[   22.523504] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   22.530553] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[   22.536576] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd8704000
[   22.542500] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   22.557011] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   22.563045] usb usb1: default language 0x0409
[   22.567661] usb usb1: udev 1, busnum 1, minor = 0
[   22.572629] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   22.579675] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   22.587364] usb usb1: Product: EHCI Host Controller
[   22.592503] usb usb1: Manufacturer: Linux 3.6.0-rc1+ ehci_hcd
[   22.598509] usb usb1: SerialNumber: 0000:00:1d.7
[   22.603527] usb usb1: usb_probe_device
[   22.607543] usb usb1: configuration #1 chosen from 1 choice
[   22.613388] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   22.619463] hub 1-0:1.0: usb_probe_interface
[   22.623989] hub 1-0:1.0: usb_probe_interface - got id
[   22.629302] hub 1-0:1.0: USB hub found
[   22.633316] hub 1-0:1.0: 6 ports detected
[   22.637586] hub 1-0:1.0: standalone hub
[   22.641676] hub 1-0:1.0: no power switching (usb 1.0)
[   22.646990] hub 1-0:1.0: individual port over-current protection
[   22.653258] hub 1-0:1.0: power on to power good time: 20ms
[   22.659009] hub 1-0:1.0: local power source is good
[   22.664152] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   22.671413] uhci_hcd: USB Universal Host Controller Interface driver
[   22.678058] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   22.684153] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   22.689645] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   22.697521] uhci_hcd 0000:00:1d.0: detected 2 ports
[   22.702659] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   22.709623] uhci_hcd 0000:00:1d.0: Performing full reset
[   22.715198] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   22.721213] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
[   22.727244] usb usb2: default language 0x0409
[   22.731867] usb usb2: udev 1, busnum 2, minor = 128
[   22.737004] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   22.744048] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   22.751734] usb usb2: Product: UHCI Host Controller
[   22.756873] usb usb2: Manufacturer: Linux 3.6.0-rc1+ uhci_hcd
[   22.762871] usb usb2: SerialNumber: 0000:00:1d.0
[   22.767875] usb usb2: usb_probe_device
[   22.771888] usb usb2: configuration #1 chosen from 1 choice
[   22.777728] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001803 0  ACK POWER sig=j CSC CONNECT
[   22.780014] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   22.780085] hub 2-0:1.0: usb_probe_interface
[   22.780087] hub 2-0:1.0: usb_probe_interface - got id
[   22.780089] hub 2-0:1.0: USB hub found
[   22.780093] hub 2-0:1.0: 2 ports detected
[   22.780094] hub 2-0:1.0: standalone hub
[   22.780095] hub 2-0:1.0: no power switching (usb 1.0)
[   22.780096] hub 2-0:1.0: individual port over-current protection
[   22.780098] hub 2-0:1.0: power on to power good time: 2ms
[   22.780101] hub 2-0:1.0: local power source is good
[   22.780103] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   22.780152] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[   22.780172] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   22.780174] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   22.780179] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   22.780189] uhci_hcd 0000:00:1d.1: detected 2 ports
[   22.780193] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   22.780195] uhci_hcd 0000:00:1d.1: Performing full reset
[   22.780210] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   22.780224] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
[   22.780260] usb usb3: default language 0x0409
[   22.780265] usb usb3: udev 1, busnum 3, minor = 256
[   22.780267] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   22.780269] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   22.780270] usb usb3: Product: UHCI Host Controller
[   22.780272] usb usb3: Manufacturer: Linux 3.6.0-rc1+ uhci_hcd
[   22.780273] usb usb3: SerialNumber: 0000:00:1d.1
[   22.780393] usb usb3: usb_probe_device
[   22.780395] usb usb3: configuration #1 chosen from 1 choice
[   22.780401] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   22.780465] hub 3-0:1.0: usb_probe_interface
[   22.780467] hub 3-0:1.0: usb_probe_interface - got id
[   22.780469] hub 3-0:1.0: USB hub found
[   22.780472] hub 3-0:1.0: 2 ports detected
[   22.780473] hub 3-0:1.0: standalone hub
[   22.780475] hub 3-0:1.0: no power switching (usb 1.0)
[   22.780476] hub 3-0:1.0: individual port over-current protection
[   22.780477] hub 3-0:1.0: power on to power good time: 2ms
[   22.780480] hub 3-0:1.0: local power source is good
[   22.780482] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   22.780535] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[   22.780556] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   22.780559] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   22.780564] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   22.780570] uhci_hcd 0000:00:1d.2: detected 2 ports
[   22.780574] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   22.780575] uhci_hcd 0000:00:1d.2: Performing full reset
[   22.780590] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   22.780607] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
[   22.780638] usb usb4: default language 0x0409
[   22.780643] usb usb4: udev 1, busnum 4, minor = 384
[   22.780645] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   22.780646] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   22.780648] usb usb4: Product: UHCI Host Controller
[   22.780649] usb usb4: Manufacturer: Linux 3.6.0-rc1+ uhci_hcd
[   22.780651] usb usb4: SerialNumber: 0000:00:1d.2
[   22.780760] usb usb4: usb_probe_device
[   22.780762] usb usb4: configuration #1 chosen from 1 choice
[   22.780768] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   22.780826] hub 4-0:1.0: usb_probe_interface
[   22.780828] hub 4-0:1.0: usb_probe_interface - got id
[   22.780829] hub 4-0:1.0: USB hub found
[   22.780833] hub 4-0:1.0: 2 ports detected
[   22.780834] hub 4-0:1.0: standalone hub
[   22.780835] hub 4-0:1.0: no power switching (usb 1.0)
[   22.780836] hub 4-0:1.0: individual port over-current protection
[   22.780838] hub 4-0:1.0: power on to power good time: 2ms
[   22.780841] hub 4-0:1.0: local power source is good
[   22.780842] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   22.780890] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[   22.780951] Initializing USB Mass Storage driver...
[   22.781035] usbcore: registered new interface driver usb-storage
[   22.781035] USB Mass Storage support registered.
[   22.781099] usbcore: registered new interface driver libusual
[   22.781149] usbcore: registered new interface driver ums-alauda
[   22.781199] usbcore: registered new interface driver ums-cypress
[   22.781249] usbcore: registered new interface driver ums-datafab
[   22.781297] usbcore: registered new interface driver ums-freecom
[   22.781345] usbcore: registered new interface driver ums-isd200
[   22.781395] usbcore: registered new interface driver ums-jumpshot
[   22.781446] usbcore: registered new interface driver ums-karma
[   22.781496] usbcore: registered new interface driver ums-onetouch
[   22.781544] usbcore: registered new interface driver ums-sddr09
[   22.781594] usbcore: registered new interface driver ums-sddr55
[   22.781645] usbcore: registered new interface driver ums-usbat
[   22.781753] usbcore: registered new interface driver usbserial
[   22.781807] usbcore: registered new interface driver usbserial_generic
[   22.781854] USB Serial support registered for generic
[   22.781856] usbserial: USB Serial Driver core
[   22.781907] usbcore: registered new interface driver belkin_sa
[   22.781954] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[   22.782010] usbcore: registered new interface driver mct_u232
[   22.782056] USB Serial support registered for MCT U232
[   22.782191] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[   22.782597] i8042: Warning: Keylock active
[   22.880020] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
[   22.880048] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   22.880052] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   22.980015] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   23.033302] serio: i8042 KBD port at 0x60,0x64 irq 1
[   23.033547] mousedev: PS/2 mouse device common for all mice
[   23.034040] rtc_cmos 00:05: RTC can wake from S4
[   23.034229] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[   23.034258] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   23.034363] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   23.034414] iTCO_vendor_support: vendor-support=0
[   23.034550] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   23.034551] md: linear personality registered for level -1
[   23.034552] md: raid0 personality registered for level 0
[   23.034553] md: raid1 personality registered for level 1
[   23.034554] md: raid10 personality registered for level 10
[   23.034555] md: raid6 personality registered for level 6
[   23.034556] md: raid5 personality registered for level 5
[   23.034557] md: raid4 personality registered for level 4
[   23.034558] md: multipath personality registered for level -4
[   23.034559] md: faulty personality registered for level -5
[   23.034724] device-mapper: uevent: version 1.0.3
[   23.034867] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   23.034974] device-mapper: multipath: version 1.5.0 loaded
[   23.034976] device-mapper: multipath round-robin: version 1.0.0 loaded
[   23.034976] device-mapper: multipath queue-length: version 0.1.0 loaded
[   23.034977] device-mapper: multipath service-time: version 0.2.0 loaded
[   23.035148] device-mapper: dm-log-userspace: version 1.1.0 loaded
[   23.035156] cpuidle: using governor ladder
[   23.035157] cpuidle: using governor menu
[   23.035316] usbcore: registered new interface driver usbhid
[   23.035317] usbhid: USB HID core driver
[   23.035585] dell_wmi: No known WMI GUID found
[   23.035586] acer_wmi: Acer Laptop ACPI-WMI Extras
[   23.035593] acer_wmi: No or unsupported WMI interface, unable to load
[   23.035835] oprofile: using NMI interrupt.
[   23.035939] TCP: bic registered
[   23.035940] TCP: cubic registered
[   23.035941] TCP: westwood registered
[   23.035941] TCP: highspeed registered
[   23.035942] TCP: hybla registered
[   23.035943] TCP: htcp registered
[   23.035943] TCP: vegas registered
[   23.035944] TCP: veno registered
[   23.035945] TCP: scalable registered
[   23.035946] TCP: lp registered
[   23.035947] TCP: yeah registered
[   23.035947] TCP: illinois registered
[   23.035948] Initializing XFRM netlink socket
[   23.035954] NET: Registered protocol family 17
[   23.035964] NET: Registered protocol family 15
[   23.035989] Bridge firewalling registered
[   23.036020] Key type dns_resolver registered
[   23.037204] 
[   23.037204] printing PIC contents
[   23.037208] ... PIC  IMR: ffff
[   23.037211] ... PIC  IRR: 0ca0
[   23.037220] ... PIC  ISR: 0000
[   23.037223] ... PIC ELCR: 0ea0
[   23.037227] printing local APIC contents on CPU#0/0:
[   23.037228] ... APIC ID:      00000000 (0)
[   23.037229] ... APIC VERSION: 00050014
[   23.037230] ... APIC TASKPRI: 00000000 (00)
[   23.037230] ... APIC PROCPRI: 00000000
[   23.037231] ... APIC LDR: 01000000
[   23.037232] ... APIC DFR: ffffffff
[   23.037232] ... APIC SPIV: 000001ff
[   23.037233] ... APIC ISR field:
[   23.037236] 0000000000000000000000000000000000000000000000000000000000000000
[   23.037237] ... APIC TMR field:
[   23.037240] 000000000000020000000008000c020002000000000000000004000000000000
[   23.037241] ... APIC IRR field:
[   23.037243] 0000000000000000000000000000000000000000000000000000000000000000
[   23.037244] ... APIC ESR: 00000000
[   23.037245] ... APIC ICR: 00000820
[   23.037245] ... APIC ICR2: 01000000
[   23.037246] ... APIC LVTT: 000000ef
[   23.037246] ... APIC LVTPC: 00000400
[   23.037247] ... APIC LVT0: 00010700
[   23.037247] ... APIC LVT1: 00000400
[   23.037248] ... APIC LVTERR: 000000fe
[   23.037248] ... APIC TMICT: 01972614
[   23.037249] ... APIC TMCCT: 00d680d9
[   23.037249] ... APIC TDCR: 00000003
[   23.037250] 
[   23.037252] number of MP IRQ sources: 15.
[   23.037253] number of IO-APIC #8 registers: 24.
[   23.037253] number of IO-APIC #9 registers: 24.
[   23.037254] number of IO-APIC #10 registers: 24.
[   23.037255] testing the IO APIC.......................
[   23.037262] IO APIC #8......
[   23.037262] .... register #00: 08000000
[   23.037263] .......    : physical APIC id: 08
[   23.037263] .......    : Delivery Type: 0
[   23.037264] .......    : LTS          : 0
[   23.037265] .... register #01: 00170020
[   23.037265] .......     : max redirection entries: 17
[   23.037266] .......     : PRQ implemented: 0
[   23.037266] .......     : IO APIC version: 20
[   23.037267] .... IRQ redirection table:
[   23.037267]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   23.037273]  00 00  1    0    0   0   0    0    0    00
[   23.037278]  01 01  0    0    0   0   0    1    1    41
[   23.037283]  02 FF  0    0    0   0   0    1    1    51
[   23.037288]  03 01  0    0    0   0   0    1    1    61
[   23.037293]  04 01  0    0    0   0   0    1    1    71
[   23.037297]  05 01  0    0    0   0   0    1    1    81
[   23.037302]  06 01  0    0    0   0   0    1    1    91
[   23.037307]  07 01  0    0    0   0   0    1    1    A1
[   23.037312]  08 01  0    0    0   0   0    1    1    B1
[   23.037317]  09 01  0    1    0   0   0    1    1    C1
[   23.037321]  0a 01  0    0    0   0   0    1    1    D1
[   23.037326]  0b 01  0    0    0   0   0    1    1    E1
[   23.037331]  0c 01  1    0    0   0   0    1    1    22
[   23.037336]  0d 01  0    0    0   0   0    1    1    42
[   23.037341]  0e FF  0    0    0   0   0    1    1    52
[   23.037345]  0f 01  0    0    0   0   0    1    1    62
[   23.037350]  10 FF  1    1    0   1   0    1    1    C2
[   23.037356]  11 FF  0    1    0   1   0    1    1    73
[   23.037361]  12 00  1    0    0   0   0    0    0    00
[   23.037365]  13 00  1    0    0   0   0    0    0    00
[   23.037370]  14 FF  0    1    0   1   0    1    1    D2
[   23.037375]  15 FF  0    1    0   1   0    1    1    E2
[   23.037380]  16 FF  0    1    0   1   0    1    1    23
[   23.037385]  17 FF  0    1    0   1   0    1    1    43
[   23.037387] IO APIC #9......
[   23.037388] .... register #00: 09000000
[   23.037388] .......    : physical APIC id: 09
[   23.037389] .......    : Delivery Type: 0
[   23.037389] .......    : LTS          : 0
[   23.037390] .... register #01: 00178020
[   23.037391] .......     : max redirection entries: 17
[   23.037391] .......     : PRQ implemented: 1
[   23.037392] .......     : IO APIC version: 20
[   23.037392] .... register #02: 09000000
[   23.037393] .......     : arbitration: 09
[   23.037393] .... register #03: 00000001
[   23.037394] .......     : Boot DT    : 1
[   23.037394] .... IRQ redirection table:
[   23.037395]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   23.037398]  00 FF  1    1    0   1   0    1    1    83
[   23.037400]  01 00  1    0    0   0   0    0    0    00
[   23.037403]  02 00  1    0    0   0   0    0    0    00
[   23.037406]  03 00  1    0    0   0   0    0    0    00
[   23.037408]  04 00  1    0    0   0   0    0    0    00
[   23.037411]  05 00  1    0    0   0   0    0    0    00
[   23.037414]  06 00  1    0    0   0   0    0    0    00
[   23.037416]  07 00  1    0    0   0   0    0    0    00
[   23.037419]  08 00  1    0    0   0   0    0    0    00
[   23.037422]  09 00  1    0    0   0   0    0    0    00
[   23.037425]  0a 00  1    0    0   0   0    0    0    00
[   23.037427]  0b 00  1    0    0   0   0    0    0    00
[   23.037430]  0c 00  1    0    0   0   0    0    0    00
[   23.037432]  0d 00  1    0    0   0   0    0    0    00
[   23.037435]  0e 00  1    0    0   0   0    0    0    00
[   23.037438]  0f 00  1    0    0   0   0    0    0    00
[   23.037440]  10 00  1    0    0   0   0    0    0    00
[   23.037443]  11 00  1    0    0   0   0    0    0    00
[   23.037446]  12 00  1    0    0   0   0    0    0    00
[   23.037448]  13 00  1    0    0   0   0    0    0    00
[   23.037451]  14 00  1    0    0   0   0    0    0    00
[   23.037454]  15 00  1    0    0   0   0    0    0    00
[   23.037456]  16 00  1    0    0   0   0    0    0    00
[   23.037459]  17 00  1    0    0   0   0    0    0    00
[   23.037461] IO APIC #10......
[   23.037462] .... register #00: 0A000000
[   23.037463] .......    : physical APIC id: 0A
[   23.037463] .......    : Delivery Type: 0
[   23.037464] .......    : LTS          : 0
[   23.037464] .... register #01: 00170020
[   23.037465] .......     : max redirection entries: 17
[   23.037465] .......     : PRQ implemented: 0
[   23.037466] .......     : IO APIC version: 20
[   23.037466] .... register #02: 00000000
[   23.037467] .......     : arbitration: 00
[   23.037467] .... register #03: 00000001
[   23.037468] .......     : Boot DT    : 1
[   23.037468] .... IRQ redirection table:
[   23.037469]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   23.037472]  00 FF  0    1    0   1   0    1    1    72
[   23.037474]  01 00  1    0    0   0   0    0    0    00
[   23.037477]  02 FF  1    1    0   1   0    1    1    82
[   23.037479]  03 00  1    0    0   0   0    0    0    00
[   23.037482]  04 FF  1    1    0   1   0    1    1    92
[   23.037485]  05 00  1    0    0   0   0    0    0    00
[   23.037487]  06 FF  1    1    0   1   0    1    1    A2
[   23.037490]  07 00  1    0    0   0   0    0    0    00
[   23.037492]  08 FF  1    1    0   1   0    1    1    B2
[   23.037495]  09 FF  1    1    0   1   0    1    1    63
[   23.037498]  0a 00  1    0    0   0   0    0    0    00
[   23.037500]  0b 00  1    0    0   0   0    0    0    00
[   23.037503]  0c 00  1    0    0   0   0    0    0    00
[   23.037505]  0d 00  1    0    0   0   0    0    0    00
[   23.037508]  0e 00  1    0    0   0   0    0    0    00
[   23.037510]  0f 00  1    0    0   0   0    0    0    00
[   23.037513]  10 00  1    0    0   0   0    0    0    00
[   23.037516]  11 00  1    0    0   0   0    0    0    00
[   23.037518]  12 00  1    0    0   0   0    0    0    00
[   23.037521]  13 00  1    0    0   0   0    0    0    00
[   23.037523]  14 00  1    0    0   0   0    0    0    00
[   23.037526]  15 00  1    0    0   0   0    0    0    00
[   23.037529]  16 FF  1    1    0   1   0    1    1    64
[   23.037531]  17 00  1    0    0   0   0    0    0    00
[   23.037532] IRQ to pin mappings:
[   23.037534] IRQ0 -> 0:2
[   23.037535] IRQ1 -> 0:1
[   23.037536] IRQ3 -> 0:3
[   23.037537] IRQ4 -> 0:4
[   23.037539] IRQ5 -> 0:5
[   23.037540] IRQ6 -> 0:6
[   23.037541] IRQ7 -> 0:7
[   23.037542] IRQ8 -> 0:8
[   23.037543] IRQ9 -> 0:9
[   23.037545] IRQ10 -> 0:10
[   23.037546] IRQ11 -> 0:11
[   23.037547] IRQ12 -> 0:12
[   23.037548] IRQ13 -> 0:13
[   23.037550] IRQ14 -> 0:14
[   23.037551] IRQ15 -> 0:15
[   23.037552] IRQ16 -> 0:16
[   23.037554] IRQ17 -> 0:17
[   23.037555] IRQ20 -> 0:20
[   23.037556] IRQ21 -> 0:21
[   23.037558] IRQ22 -> 0:22
[   23.037559] IRQ23 -> 0:23
[   23.037560] IRQ24 -> 1:0
[   23.037562] IRQ48 -> 2:0
[   23.037563] IRQ50 -> 2:2
[   23.037564] IRQ52 -> 2:4
[   23.037565] IRQ54 -> 2:6
[   23.037567] IRQ56 -> 2:8
[   23.037568] IRQ57 -> 2:9
[   23.037569] IRQ70 -> 2:22
[   23.037572] .................................... done.
[   23.037794] PM: Hibernation image not present or could not be loaded.
[   23.037814] registered taskstats version 1
[   23.038267]   Magic number: 8:484:580
[   23.038493] pci_bus 0000:01: hash matches
[   23.038531] netpoll: netconsole: local port 6667
[   23.038532] netpoll: netconsole: local IP 192.168.3.78
[   23.038533] netpoll: netconsole: interface 'eth1'
[   23.038534] netpoll: netconsole: remote port 6666
[   23.038534] netpoll: netconsole: remote IP 192.168.1.1
[   23.038536] netpoll: netconsole: remote ethernet address 00:1b:21:11:78:3e
[   23.038537] netpoll: netconsole: device eth1 not up yet, forcing it
[   23.954016] usb usb3: suspend_rh (auto-stop)
[   23.954041] usb usb4: suspend_rh (auto-stop)
[   23.954065] usb usb2: suspend_rh (auto-stop)
[   24.506228] hub 1-0:1.0: port 2: status 0501 change 0001
[   24.611020] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
[   24.616802] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[   24.674278] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[   24.675002] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003801 0  ACK POWER OWNER sig=j CONNECT
[   24.690143] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
[   24.704017] usb usb2: wakeup_rh (auto-start)
[   24.746013] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[   24.755287] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[   24.761039] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[   24.770296] hub 1-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
[   24.880010] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[   24.887873] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   24.893622] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[   24.899194] hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   25.009011] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[   25.114487] igb: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   25.118011] usb 2-2: new full-speed USB device number 2 using uhci_hcd
[   25.134502] console [netcon0] enabled
[   25.138426] netconsole: network logging started
[   25.143245] rtc_cmos 00:05: setting system clock to 2012-08-17 11:35:06 UTC (1345203306)
[   25.163041] IP-Config: Complete:
[   25.166536]      device=eth1, addr=192.168.1.58, mask=255.255.255.0, gw=192.168.1.1
[   25.174661]      host=lkp-st02-x8664, domain=, nis-domain=(none)
[   25.180930]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   25.188137] ALSA device list:
[   25.191370]   No soundcards found.
[   25.195090] md: Waiting for all devices to be available before autodetect
[   25.202146] md: If you don't use raid, use raid=noautodetect
[   25.208335] md: Autodetecting RAID arrays.
[   25.212693] md: Scanned 0 and added 0 devices.
[   25.217398] md: autorun ...
[   25.220447] md: ... autorun DONE.
[   25.238015] usb 2-2: ep0 maxpacket = 8
[   25.259572] usb 2-2: udev 2, busnum 2, minor = 129
[   25.264634] usb 2-2: New USB device found, idVendor=0557, idProduct=8021
[   25.271599] usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   25.279109] usb 2-2: usb_probe_device
[   25.283031] usb 2-2: configuration #1 chosen from 1 choice
[   25.291574] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[   25.297563] hub 2-2:1.0: usb_probe_interface
[   25.302096] hub 2-2:1.0: usb_probe_interface - got id
[   25.307409] hub 2-2:1.0: USB hub found
[   25.312568] hub 2-2:1.0: 4 ports detected
[   25.316838] hub 2-2:1.0: standalone hub
[   25.320937] hub 2-2:1.0: individual port power switching
[   25.326509] hub 2-2:1.0: individual port over-current protection
[   25.332775] hub 2-2:1.0: power on to power good time: 100ms
[   25.341565] hub 2-2:1.0: local power source is good
[   25.346713] hub 2-2:1.0: enabling power on all ports
[   25.456568] hub 2-2:1.0: port 1: status 0301 change 0001
[   25.565012] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[   25.573317] hub 2-2:1.0: state 7 ports 4 chg 0002 evt 0000
[   25.580568] hub 2-2:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
[   25.651569] usb 2-2.1: new low-speed USB device number 3 using uhci_hcd
[   26.229684] VFS: Mounted root (nfs filesystem) on device 0:14.
[   26.235991] devtmpfs: mounted
[   26.239866] Freeing unused kernel memory: 976k freed
[   26.553277] udevd[2222]: starting version 175
[   30.174690] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   30.183486] NFSD: starting 90-second grace period
[   30.659578] usb 2-2.1: khubd timed out on ep0in len=0/64
[   30.668563] usb 2-2.1: uhci_result_common: failed with status 440000
[   30.678563] usb 2-2.1: uhci_result_common: failed with status 440000
[   30.750578] usb 2-2.1: device descriptor read/64, error -71
[   35.858586] usb 2-2.1: khubd timed out on ep0in len=0/64
[   35.867571] usb 2-2.1: uhci_result_common: failed with status 440000
[   35.877572] usb 2-2.1: uhci_result_common: failed with status 440000
[   35.949585] usb 2-2.1: device descriptor read/64, error -71
[   35.986887] md: md0 stopped.
[   36.122586] usb 2-2.1: new low-speed USB device number 4 using uhci_hcd
[   36.209760] md: bind<sdb1>
[   36.212990] md: bind<sdc1>
[   36.216188] md: bind<sdd1>
[   36.219403] md: bind<sde1>
[   36.222605] md: bind<sdf1>
[   36.225790] md: bind<sdg1>
[   36.229000] md: bind<sdh1>
[   36.232198] md: bind<sdi1>
[   36.235395] md: bind<sdj1>
[   36.244880] md: bind<sdk1>
[   36.248071] md: bind<sdl1>
[   36.251260] md: bind<sdm1>
[   36.256455] bio: create slab <bio-1> at 1
[   36.260750] md/raid:md0: device sdm1 operational as raid disk 11
[   36.267020] md/raid:md0: device sdl1 operational as raid disk 10
[   36.273295] md/raid:md0: device sdk1 operational as raid disk 9
[   36.279474] md/raid:md0: device sdj1 operational as raid disk 8
[   36.285650] md/raid:md0: device sdi1 operational as raid disk 7
[   36.291829] md/raid:md0: device sdh1 operational as raid disk 6
[   36.298009] md/raid:md0: device sdg1 operational as raid disk 5
[   36.304188] md/raid:md0: device sdf1 operational as raid disk 4
[   36.310366] md/raid:md0: device sde1 operational as raid disk 3
[   36.316546] md/raid:md0: device sdd1 operational as raid disk 2
[   36.322728] md/raid:md0: device sdc1 operational as raid disk 1
[   36.328905] md/raid:md0: device sdb1 operational as raid disk 0
[   36.336160] md/raid:md0: allocated 12804kB
[   36.340569] md/raid:md0: raid level 5 active with 12 out of 12 devices, algorithm 2
[   36.348694] RAID conf printout:
[   36.352096]  --- level:5 rd:12 wd:12
[   36.355927]  disk 0, o:1, dev:sdb1
[   36.359596]  disk 1, o:1, dev:sdc1
[   36.363259]  disk 2, o:1, dev:sdd1
[   36.366925]  disk 3, o:1, dev:sde1
[   36.370591]  disk 4, o:1, dev:sdf1
[   36.374257]  disk 5, o:1, dev:sdg1
[   36.377915]  disk 6, o:1, dev:sdh1
[   36.381580]  disk 7, o:1, dev:sdi1
[   36.385239]  disk 8, o:1, dev:sdj1
[   36.388909]  disk 9, o:1, dev:sdk1
[   36.392571]  disk 10, o:1, dev:sdl1
[   36.396324]  disk 11, o:1, dev:sdm1
[   36.400117] md0: detected capacity change from 0 to 495030632448
[   36.406809]  md0: unknown partition table
[   36.578801] device fsid 57b2f4c3-38fa-4504-a89a-39f5576c2546 devid 1 transid 4 /dev/md0
[   36.587977] btrfs: disk space caching is enabled
[   41.130605] usb 2-2.1: khubd timed out on ep0in len=0/64
[   41.139578] usb 2-2.1: uhci_result_common: failed with status 440000
[   41.149575] usb 2-2.1: uhci_result_common: failed with status 440000
[   41.221606] usb 2-2.1: device descriptor read/64, error -71
[   46.331761] usb 2-2.1: khubd timed out on ep0in len=0/64
[   46.340733] usb 2-2.1: uhci_result_common: failed with status 440000
[   46.350724] usb 2-2.1: uhci_result_common: failed with status 440000
[   46.422711] usb 2-2.1: device descriptor read/64, error -71
[   46.595618] usb 2-2.1: new low-speed USB device number 5 using uhci_hcd
[   51.603129] usb 2-2.1: khubd timed out on ep0out len=0/0
[   51.813014] usb 2-2.1: uhci_result_common: failed with status 440000
[   52.020027] usb 2-2.1: device not accepting address 5, error -71
[   52.092898] usb 2-2.1: new low-speed USB device number 6 using uhci_hcd
[   57.101379] usb 2-2.1: khubd timed out on ep0out len=0/0
[   57.311256] usb 2-2.1: uhci_result_common: failed with status 440000
[   57.518044] usb 2-2.1: device not accepting address 6, error -71
[   57.526247] hub 2-2:1.0: unable to enumerate USB device on port 1
[   57.533152] hub 2-2:1.0: state 7 ports 4 chg 0000 evt 0002
[  644.273874] btrfs: block rsv returned -28
[  644.278161] ------------[ cut here ]------------
[  644.283050] WARNING: at /c/wfg/tip/fs/btrfs/extent-tree.c:6330 btrfs_alloc_free_block+0xd6/0x28b()
[  644.292468] Hardware name: X7DW3
[  644.295950] Modules linked in:
[  644.299330] Pid: 10214, comm: btrfs-transacti Not tainted 3.6.0-rc1+ #4
[  644.306201] Call Trace:
[  644.308916]  [<ffffffff810697ee>] warn_slowpath_common+0x83/0x9c
[  644.315183]  [<ffffffff81069821>] warn_slowpath_null+0x1a/0x1c
[  644.321274]  [<ffffffff8133246f>] btrfs_alloc_free_block+0xd6/0x28b
[  644.327796]  [<ffffffff81141973>] ? kfree+0x55/0x101
[  644.333020]  [<ffffffff813218ac>] __btrfs_cow_block+0x118/0x43d
[  644.339196]  [<ffffffff8133c00e>] ? btrfs_buffer_uptodate+0x49/0x5f
[  644.345717]  [<ffffffff81321d17>] btrfs_cow_block+0x146/0x1ac
[  644.351722]  [<ffffffff81367396>] ? btrfs_set_lock_blocking_rw+0xa9/0xf7
[  644.358677]  [<ffffffff813253a6>] btrfs_search_slot+0x2e1/0x784
[  644.364853]  [<ffffffff8133753f>] btrfs_del_csums+0xee/0x2e2
[  644.370772]  [<ffffffff8132cedd>] __btrfs_free_extent+0x5b3/0x60b
[  644.377129]  [<ffffffff81330c5d>] run_clustered_refs+0x79b/0x85f
[  644.383390]  [<ffffffff81330fb3>] btrfs_run_delayed_refs+0x292/0x3ed
[  644.390001]  [<ffffffff8197c2eb>] ? mutex_unlock+0xe/0x10
[  644.395658]  [<ffffffff81352284>] ? btrfs_run_ordered_operations+0x1a4/0x1b3
[  644.402966]  [<ffffffff813400b6>] btrfs_commit_transaction+0x94/0x995
[  644.409664]  [<ffffffff8108a996>] ? __init_waitqueue_head+0x33/0x33
[  644.416185]  [<ffffffff8107757a>] ? usleep_range+0x42/0x42
[  644.421931]  [<ffffffff8133a0bc>] transaction_kthread+0xec/0x1b3
[  644.428192]  [<ffffffff81339fd0>] ? cleaner_kthread+0xe8/0xe8
[  644.434195]  [<ffffffff8108a09b>] kthread+0x8b/0x93
[  644.439333]  [<ffffffff819863c4>] kernel_thread_helper+0x4/0x10
[  644.445509]  [<ffffffff8197e7dd>] ? retint_restore_args+0x13/0x13
[  644.451857]  [<ffffffff8108a010>] ? __init_kthread_worker+0x39/0x39
[  644.458379]  [<ffffffff819863c0>] ? gs_change+0x13/0x13
[  644.463861] ---[ end trace 10c6b128620d1b3b ]---
[  644.468767] btrfs: block rsv returned -28
[  644.473041] ------------[ cut here ]------------
[  644.477917] WARNING: at /c/wfg/tip/fs/btrfs/extent-tree.c:6330 btrfs_alloc_free_block+0xd6/0x28b()
[  644.487339] Hardware name: X7DW3
[  644.490828] Modules linked in:
[  644.494214] Pid: 10214, comm: btrfs-transacti Tainted: G        W    3.6.0-rc1+ #4
[  644.502254] Call Trace:
[  644.504957]  [<ffffffff810697ee>] warn_slowpath_common+0x83/0x9c
[  644.511221]  [<ffffffff81069821>] warn_slowpath_null+0x1a/0x1c
[  644.517314]  [<ffffffff8133246f>] btrfs_alloc_free_block+0xd6/0x28b
[  644.523833]  [<ffffffff81141973>] ? kfree+0x55/0x101
[  644.529057]  [<ffffffff813218ac>] __btrfs_cow_block+0x118/0x43d
[  644.535235]  [<ffffffff8133c00e>] ? btrfs_buffer_uptodate+0x49/0x5f
[  644.541756]  [<ffffffff81321d17>] btrfs_cow_block+0x146/0x1ac
[  644.547761]  [<ffffffff81367396>] ? btrfs_set_lock_blocking_rw+0xa9/0xf7
[  644.554714]  [<ffffffff813253a6>] btrfs_search_slot+0x2e1/0x784
[  644.560892]  [<ffffffff8133753f>] btrfs_del_csums+0xee/0x2e2
[  644.566811]  [<ffffffff8132cedd>] __btrfs_free_extent+0x5b3/0x60b
[  644.573168]  [<ffffffff81330c5d>] run_clustered_refs+0x79b/0x85f
[  644.579439]  [<ffffffff81330fb3>] btrfs_run_delayed_refs+0x292/0x3ed
[  644.586057]  [<ffffffff8197c2eb>] ? mutex_unlock+0xe/0x10
[  644.591712]  [<ffffffff81352284>] ? btrfs_run_ordered_operations+0x1a4/0x1b3
[  644.599016]  [<ffffffff813400b6>] btrfs_commit_transaction+0x94/0x995
[  644.605709]  [<ffffffff8108a996>] ? __init_waitqueue_head+0x33/0x33
[  644.612233]  [<ffffffff8107757a>] ? usleep_range+0x42/0x42
[  644.617979]  [<ffffffff8133a0bc>] transaction_kthread+0xec/0x1b3
[  644.624239]  [<ffffffff81339fd0>] ? cleaner_kthread+0xe8/0xe8
[  644.630241]  [<ffffffff8108a09b>] kthread+0x8b/0x93
[  644.635378]  [<ffffffff819863c4>] kernel_thread_helper+0x4/0x10
[  644.641555]  [<ffffffff8197e7dd>] ? retint_restore_args+0x13/0x13
[  644.647905]  [<ffffffff8108a010>] ? __init_kthread_worker+0x39/0x39
[  644.654428]  [<ffffffff819863c0>] ? gs_change+0x13/0x13
[  644.659910] ---[ end trace 10c6b128620d1b3c ]---
[  651.834616] use_block_rsv: 2039 callbacks suppressed
[  651.839855] btrfs: block rsv returned -28
[  651.844131] ------------[ cut here ]------------
[  651.849009] WARNING: at /c/wfg/tip/fs/btrfs/extent-tree.c:6330 btrfs_alloc_free_block+0xd6/0x28b()
[  651.858425] Hardware name: X7DW3
[  651.861907] Modules linked in:
[  651.865288] Pid: 10214, comm: btrfs-transacti Tainted: G        W    3.6.0-rc1+ #4
[  651.873316] Call Trace:
[  651.876025]  [<ffffffff810697ee>] warn_slowpath_common+0x83/0x9c
[  651.882285]  [<ffffffff81069821>] warn_slowpath_null+0x1a/0x1c
[  651.888373]  [<ffffffff8133246f>] btrfs_alloc_free_block+0xd6/0x28b
[  651.894898]  [<ffffffff813581bc>] ? read_extent_buffer_pages+0x1ce/0x25e
[  651.901861]  [<ffffffff813392d0>] ? verify_parent_transid+0x152/0x152
[  651.908557]  [<ffffffff813218ac>] __btrfs_cow_block+0x118/0x43d
[  651.914733]  [<ffffffff8133c00e>] ? btrfs_buffer_uptodate+0x49/0x5f
[  651.921257]  [<ffffffff81321d17>] btrfs_cow_block+0x146/0x1ac
[  651.927259]  [<ffffffff81367396>] ? btrfs_set_lock_blocking_rw+0xa9/0xf7
[  651.934217]  [<ffffffff813253a6>] btrfs_search_slot+0x2e1/0x784
[  651.940391]  [<ffffffff8133753f>] btrfs_del_csums+0xee/0x2e2
[  651.946308]  [<ffffffff8132cedd>] __btrfs_free_extent+0x5b3/0x60b
[  651.952656]  [<ffffffff81330c5d>] run_clustered_refs+0x79b/0x85f
[  651.958919]  [<ffffffff81330fb3>] btrfs_run_delayed_refs+0x292/0x3ed
[  651.965532]  [<ffffffff8197c2eb>] ? mutex_unlock+0xe/0x10
[  651.971185]  [<ffffffff81352284>] ? btrfs_run_ordered_operations+0x1a4/0x1b3
[  651.978489]  [<ffffffff813400b6>] btrfs_commit_transaction+0x94/0x995
[  651.985187]  [<ffffffff8108a996>] ? __init_waitqueue_head+0x33/0x33
[  651.991715]  [<ffffffff8107757a>] ? usleep_range+0x42/0x42
[  651.997458]  [<ffffffff8133a0bc>] transaction_kthread+0xec/0x1b3
[  652.003721]  [<ffffffff81339fd0>] ? cleaner_kthread+0xe8/0xe8
[  652.009723]  [<ffffffff8108a09b>] kthread+0x8b/0x93
[  652.014862]  [<ffffffff819863c4>] kernel_thread_helper+0x4/0x10
[  652.021037]  [<ffffffff8197e7dd>] ? retint_restore_args+0x13/0x13
[  652.027387]  [<ffffffff8108a010>] ? __init_kthread_worker+0x39/0x39
[  652.033915]  [<ffffffff819863c0>] ? gs_change+0x13/0x13
[  652.039391] ---[ end trace 10c6b128620d1b3d ]---
[  652.044488] btrfs: block rsv returned -28
[  652.048762] ------------[ cut here ]------------
[  652.053637] WARNING: at /c/wfg/tip/fs/btrfs/extent-tree.c:6330 btrfs_alloc_free_block+0xd6/0x28b()
[  652.063062] Hardware name: X7DW3
[  652.066548] Modules linked in:
[  652.069933] Pid: 10214, comm: btrfs-transacti Tainted: G        W    3.6.0-rc1+ #4
[  652.077959] Call Trace:
[  652.080663]  [<ffffffff810697ee>] warn_slowpath_common+0x83/0x9c
[  652.086925]  [<ffffffff81069821>] warn_slowpath_null+0x1a/0x1c
[  652.093014]  [<ffffffff8133246f>] btrfs_alloc_free_block+0xd6/0x28b
[  652.099538]  [<ffffffff813581bc>] ? read_extent_buffer_pages+0x1ce/0x25e
[  652.106501]  [<ffffffff813392d0>] ? verify_parent_transid+0x152/0x152
[  652.113196]  [<ffffffff813218ac>] __btrfs_cow_block+0x118/0x43d
[  652.119374]  [<ffffffff8133c00e>] ? btrfs_buffer_uptodate+0x49/0x5f
[  652.125898]  [<ffffffff81321d17>] btrfs_cow_block+0x146/0x1ac
[  652.131910]  [<ffffffff81367396>] ? btrfs_set_lock_blocking_rw+0xa9/0xf7
[  652.138873]  [<ffffffff813253a6>] btrfs_search_slot+0x2e1/0x784
[  652.145050]  [<ffffffff8133753f>] btrfs_del_csums+0xee/0x2e2
[  652.150976]  [<ffffffff8132cedd>] __btrfs_free_extent+0x5b3/0x60b
[  652.157334]  [<ffffffff81330c5d>] run_clustered_refs+0x79b/0x85f
[  652.163595]  [<ffffffff81330fb3>] btrfs_run_delayed_refs+0x292/0x3ed
[  652.170205]  [<ffffffff8197c2eb>] ? mutex_unlock+0xe/0x10
[  652.175864]  [<ffffffff81352284>] ? btrfs_run_ordered_operations+0x1a4/0x1b3
[  652.183172]  [<ffffffff813400b6>] btrfs_commit_transaction+0x94/0x995
[  652.189877]  [<ffffffff8108a996>] ? __init_waitqueue_head+0x33/0x33
[  652.196399]  [<ffffffff8107757a>] ? usleep_range+0x42/0x42
[  652.202143]  [<ffffffff8133a0bc>] transaction_kthread+0xec/0x1b3
[  652.208405]  [<ffffffff81339fd0>] ? cleaner_kthread+0xe8/0xe8
[  652.214408]  [<ffffffff8108a09b>] kthread+0x8b/0x93
[  652.219546]  [<ffffffff819863c4>] kernel_thread_helper+0x4/0x10
[  652.225733]  [<ffffffff8197e7dd>] ? retint_restore_args+0x13/0x13
[  652.232090]  [<ffffffff8108a010>] ? __init_kthread_worker+0x39/0x39
[  652.238620]  [<ffffffff819863c0>] ? gs_change+0x13/0x13
[  652.244102] ---[ end trace 10c6b128620d1b3e ]---
[  657.047217] use_block_rsv: 1592 callbacks suppressed
[  657.052464] btrfs: block rsv returned -28
[  657.056748] ------------[ cut here ]------------
[  657.061622] WARNING: at /c/wfg/tip/fs/btrfs/extent-tree.c:6330 btrfs_alloc_free_block+0xd6/0x28b()
[  657.071041] Hardware name: X7DW3
[  657.074523] Modules linked in:
[  657.077901] Pid: 10214, comm: btrfs-transacti Tainted: G        W    3.6.0-rc1+ #4
[  657.085933] Call Trace:
[  657.088640]  [<ffffffff810697ee>] warn_slowpath_common+0x83/0x9c
[  657.094902]  [<ffffffff81069821>] warn_slowpath_null+0x1a/0x1c
[  657.100988]  [<ffffffff8133246f>] btrfs_alloc_free_block+0xd6/0x28b
[  657.113812]  [<ffffffff813581bc>] ? read_extent_buffer_pages+0x1ce/0x25e
[  657.120776]  [<ffffffff813392d0>] ? verify_parent_transid+0x152/0x152
[  657.127470]  [<ffffffff813218ac>] __btrfs_cow_block+0x118/0x43d
[  657.133647]  [<ffffffff8133c00e>] ? btrfs_buffer_uptodate+0x49/0x5f
[  657.140170]  [<ffffffff81321d17>] btrfs_cow_block+0x146/0x1ac
[  657.146173]  [<ffffffff81367396>] ? btrfs_set_lock_blocking_rw+0xa9/0xf7
[  657.153130]  [<ffffffff813253a6>] btrfs_search_slot+0x2e1/0x784
[  657.159306]  [<ffffffff8132a21e>] lookup_inline_extent_backref+0xcd/0x402
[  657.166348]  [<ffffffff813543ae>] ? set_extent_dirty+0x20/0x22
[  657.172437]  [<ffffffff811416fa>] ? kmem_cache_alloc+0x31/0xf9
[  657.178527]  [<ffffffff8132c9f9>] __btrfs_free_extent+0xcf/0x60b
[  657.184788]  [<ffffffff81330c5d>] run_clustered_refs+0x79b/0x85f
[  657.191053]  [<ffffffff81330fb3>] btrfs_run_delayed_refs+0x292/0x3ed
[  657.197663]  [<ffffffff8197c2eb>] ? mutex_unlock+0xe/0x10
[  657.203328]  [<ffffffff81352284>] ? btrfs_run_ordered_operations+0x1a4/0x1b3
[  657.210630]  [<ffffffff813400b6>] btrfs_commit_transaction+0x94/0x995
[  657.217325]  [<ffffffff8108a996>] ? __init_waitqueue_head+0x33/0x33
[  657.223848]  [<ffffffff8107757a>] ? usleep_range+0x42/0x42
[  657.229592]  [<ffffffff8133a0bc>] transaction_kthread+0xec/0x1b3
[  657.235854]  [<ffffffff81339fd0>] ? cleaner_kthread+0xe8/0xe8
[  657.241858]  [<ffffffff8108a09b>] kthread+0x8b/0x93
[  657.246993]  [<ffffffff819863c4>] kernel_thread_helper+0x4/0x10
[  657.253173]  [<ffffffff8197e7dd>] ? retint_restore_args+0x13/0x13
[  657.259520]  [<ffffffff8108a010>] ? __init_kthread_worker+0x39/0x39
[  657.266041]  [<ffffffff819863c0>] ? gs_change+0x13/0x13
[  657.271524] ---[ end trace 10c6b128620d1b3f ]---
[  657.276731] btrfs: block rsv returned -28
[  657.281012] ------------[ cut here ]------------
[  657.285892] WARNING: at /c/wfg/tip/fs/btrfs/extent-tree.c:6330 btrfs_alloc_free_block+0xd6/0x28b()
[  657.295310] Hardware name: X7DW3
[  657.298792] Modules linked in:
[  657.302181] Pid: 10214, comm: btrfs-transacti Tainted: G        W    3.6.0-rc1+ #4
[  657.310209] Call Trace:
[  657.312916]  [<ffffffff810697ee>] warn_slowpath_common+0x83/0x9c
[  657.319176]  [<ffffffff81069821>] warn_slowpath_null+0x1a/0x1c
[  657.325265]  [<ffffffff8133246f>] btrfs_alloc_free_block+0xd6/0x28b
[  657.331790]  [<ffffffff81357d92>] ? set_extent_buffer_dirty+0x86/0x97
[  657.338488]  [<ffffffff813218ac>] __btrfs_cow_block+0x118/0x43d
[  657.344665]  [<ffffffff8133c00e>] ? btrfs_buffer_uptodate+0x49/0x5f
[  657.351194]  [<ffffffff81321d17>] btrfs_cow_block+0x146/0x1ac
[  657.357196]  [<ffffffff81367396>] ? btrfs_set_lock_blocking_rw+0xa9/0xf7
[  657.364152]  [<ffffffff813253a6>] btrfs_search_slot+0x2e1/0x784
[  657.370329]  [<ffffffff8132a21e>] lookup_inline_extent_backref+0xcd/0x402
[  657.377372]  [<ffffffff813543ae>] ? set_extent_dirty+0x20/0x22
[  657.383469]  [<ffffffff811416fa>] ? kmem_cache_alloc+0x31/0xf9
[  657.389561]  [<ffffffff8132c9f9>] __btrfs_free_extent+0xcf/0x60b
[  657.395830]  [<ffffffff81330c5d>] run_clustered_refs+0x79b/0x85f
[  657.402101]  [<ffffffff81330fb3>] btrfs_run_delayed_refs+0x292/0x3ed
[  657.408714]  [<ffffffff8197c2eb>] ? mutex_unlock+0xe/0x10
[  657.414368]  [<ffffffff81352284>] ? btrfs_run_ordered_operations+0x1a4/0x1b3
[  657.421669]  [<ffffffff813400b6>] btrfs_commit_transaction+0x94/0x995
[  657.428366]  [<ffffffff8108a996>] ? __init_waitqueue_head+0x33/0x33
[  657.434888]  [<ffffffff8107757a>] ? usleep_range+0x42/0x42
[  657.440635]  [<ffffffff8133a0bc>] transaction_kthread+0xec/0x1b3
[  657.446893]  [<ffffffff81339fd0>] ? cleaner_kthread+0xe8/0xe8
[  657.452897]  [<ffffffff8108a09b>] kthread+0x8b/0x93
[  657.458035]  [<ffffffff819863c4>] kernel_thread_helper+0x4/0x10
[  657.464212]  [<ffffffff8197e7dd>] ? retint_restore_args+0x13/0x13
[  657.470560]  [<ffffffff8108a010>] ? __init_kthread_worker+0x39/0x39
[  657.477084]  [<ffffffff819863c0>] ? gs_change+0x13/0x13
[  657.482564] ---[ end trace 10c6b128620d1b40 ]---
[  667.296057] nfsd: last server has exited, flushing export cache
[  669.799488] kvm: exiting hardware virtualization
[  669.804782] sd 8:0:11:0: [sdm] Synchronizing SCSI cache
[  669.810521] sd 8:0:10:0: [sdl] Synchronizing SCSI cache
[  669.816270] sd 8:0:9:0: [sdk] Synchronizing SCSI cache
[  669.821943] sd 8:0:8:0: [sdj] Synchronizing SCSI cache
[  669.827597] sd 8:0:7:0: [sdi] Synchronizing SCSI cache
[  669.833239] sd 8:0:6:0: [sdh] Synchronizing SCSI cache
[  669.838874] sd 8:0:5:0: [sdg] Synchronizing SCSI cache
[  669.844504] sd 8:0:4:0: [sdf] Synchronizing SCSI cache
[  669.850134] sd 8:0:3:0: [sde] Synchronizing SCSI cache
[  669.855751] sd 8:0:2:0: [sdd] Synchronizing SCSI cache
[  669.861375] sd 8:0:1:0: [sdc] Synchronizing SCSI cache
[  669.866998] sd 8:0:0:0: [sdb] Synchronizing SCSI cache
[  669.872695] sd 0:0:0:0: [sda] Synchronizing SCSI cache

--vkogqOf2sHV7VnPd--
