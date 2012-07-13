Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2GMIcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:32:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:11043 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab2GMIbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:31:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167617457"
Date: Fri, 13 Jul 2012 16:31:40 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: show_uevent() and general protection fault
Message-ID: <20120713083140.GA19738@localhost>
References: <20120713075907.GA18900@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20120713075907.GA18900@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 13, 2012 at 03:59:07PM +0800, Fengguang Wu wrote:
> Hi all,
> 
> I can reproduce this all the way back to 3.0 kernel.
> 
> show_uevent():
>         /* copy keys to file */
>         for (i = 0; i < env->envp_idx; i++)
>                 count += sprintf(&buf[count], "%s\n", env->envp[i]);
> 
> [   26.602710] warning: process `trinity-child0' used the deprecated sysctl system call with 
> [   32.747503] general protection fault: 0000 [#1] DEBUG_PAGEALLOC
> [   32.748700] CPU 0 
> [   32.748700] Pid: 84, comm: trinity-child0 Not tainted 3.5.0-rc5+ #51 Bochs Bochs
> [   32.748700] RIP: 0010:[<ffffffff8115a5bd>]  [<ffffffff8115a5bd>] strnlen+0xd/0x40
> [   32.748700] RSP: 0018:ffff880005f87d08  EFLAGS: 00010286
> [   32.748700] RAX: ffffffff81404ed8 RBX: ffff880005fa70e0 RCX: fffffffffffffffe
> [   32.748700] RDX: 3a69706361000000 RSI: ffffffffffffffff RDI: 3a69706361000000
> [   32.748700] RBP: ffff880005f87d08 R08: 000000000000ffff R09: 000000000000ffff
> [   32.748700] R10: ffff880006e8b000 R11: ffff88000005ebc0 R12: 3a69706361000000
> [   32.748700] R13: ffff880085fa70df R14: 000000000000ffff R15: 0000000000000000
> [   32.748700] FS:  00007f177a9d2700(0000) GS:ffffffff81457000(0000) knlGS:0000000000000000
> [   32.748700] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   32.748700] CR2: 0000000002f1b000 CR3: 0000000005f84000 CR4: 00000000000006b0
> [   32.748700] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   32.748700] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   32.748700] Process trinity-child0 (pid: 84, threadinfo ffff880005f86000, task ffff880006f6c440)
> [   32.748700] Stack:
> [   32.748700]  ffff880005f87d48 ffffffff8115ba8e ffff880006e8b103 ffff880005fa70e0
> [   32.748700]  ffff880085fa70df ffff880005f87de0 ffffffff813eb7c4 ffffffff813eb7c4
> [   32.748700]  ffff880005f87dc8 ffffffff8115c569 ffff880005f87e08 ffffffff810730eb
> [   32.748700] Call Trace:
> [   32.748700]  [<ffffffff8115ba8e>] string.isra.4+0x3e/0xd0
> [   32.748700]  [<ffffffff8115c569>] vsnprintf+0x219/0x600
> [   32.748700]  [<ffffffff810730eb>] ? __lock_acquire.isra.31+0x3eb/0xb30
> [   32.748700]  [<ffffffff8115cd30>] sprintf+0x40/0x50
> [   32.748700]  [<ffffffff811f0dbe>] show_uevent+0xee/0x120
> [   32.748700]  [<ffffffff811118fe>] ? sysfs_read_file+0x3e/0x1a0
> [   32.748700]  [<ffffffff811f0c8b>] dev_attr_show+0x1b/0x60
> [   32.748700]  [<ffffffff81111946>] ? sysfs_read_file+0x86/0x1a0
> [   32.748700]  [<ffffffff8109d7e8>] ? __get_free_pages+0x18/0x80
> [   32.748700]  [<ffffffff81111972>] sysfs_read_file+0xb2/0x1a0
> [   32.748700]  [<ffffffff810cd14f>] vfs_read+0x9f/0x160
> [   32.748700]  [<ffffffff810cd4c8>] sys_read+0x48/0x90
> [   32.748700]  [<ffffffff812b6637>] system_call_fastpath+0x16/0x1b
> [   32.748700] Code: c0 01 80 38 00 75 f7 48 29 f8 5d c3 31 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 f6 48 8d 4e ff 48 89 e5 74 2a <80> 3f 00 74 25 48 89 f8 31 d2 eb 10 0f 1f 80 00 00 00 00 48 83 
> [   32.748700] RIP  [<ffffffff8115a5bd>] strnlen+0xd/0x40
> [   32.748700]  RSP <ffff880005f87d08>

The same config triggered another (related) bug in another run:

[   21.174694] BUG: unable to handle kernel paging request at ffffffff816d6790
[   21.176021] IP: [<ffffffff8115a220>] strlcpy+0x10/0x70
[   21.176021] PGD 1448067 PUD 144c063 PMD 958c063 PTE 16d6162
[   21.176021] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   21.176021] CPU 0
[   21.176021] Pid: 81, comm: trinity-child0 Not tainted 3.5.0-rc5+ #49 Bochs Bochs
[   21.176021] RIP: 0010:[<ffffffff8115a220>]  [<ffffffff8115a220>] strlcpy+0x10/0x70
[   21.176021] RSP: 0018:ffff880005f29e38  EFLAGS: 00010292
[   21.176021] RAX: ffffffff813601a0 RBX: ffff880000070470 RCX: 2222222222222222
[   21.176021] RDX: 0000000000000008 RSI: ffffffff816d6790 RDI: ffff880005f39000
[   21.176021] RBP: ffff880005f29e58 R08: 2222222222222222 R09: 0000000000000000
[   21.176021] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880005f39000
[   21.176021] R13: ffff880005f30b00 R14: 0000000000001ce5 R15: ffff880000072140
[   21.176021] FS:  00007fbb01ca6700(0000) GS:ffffffff81457000(0000) knlGS:0000000000000000
[   21.176021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   21.176021] CR2: ffffffff816d6790 CR3: 0000000005e9e000 CR4: 00000000000006b0
[   21.176021] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   21.176021] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   21.176021] Process trinity-child0 (pid: 81, threadinfo ffff880005f28000, task ffff880006fa1110)
[   21.176021] Stack:
[   21.176021]  ffffffff811118fe ffff880000070470 ffff880005f39000 ffff880005f30b00
[   21.176021]  ffff880005f29e68 ffffffff81058213 ffff880005f29e88 ffffffff810582d8
[   21.176021]  ffff880005f30b20 ffff880005f29f50 ffff880005f29e98 ffffffff810580d8
[   21.176021] Call Trace:
[   21.176021]  [<ffffffff811118fe>] ? sysfs_read_file+0x3e/0x1a0
[   21.176021]  [<ffffffff81058213>] param_get_string+0x13/0x20
[   21.176021]  [<ffffffff810582d8>] param_attr_show+0x38/0x80
[   21.176021]  [<ffffffff810580d8>] module_attr_show+0x18/0x30
[   21.176021]  [<ffffffff81111972>] sysfs_read_file+0xb2/0x1a0
[   21.176021]  [<ffffffff810cd14f>] vfs_read+0x9f/0x160
[   21.176021]  [<ffffffff810cd4c8>] sys_read+0x48/0x90
[   21.176021]  [<ffffffff812b6637>] system_call_fastpath+0x16/0x1b

Thanks,
Fengguang

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm-xbm-3563-2012-07-11-19-52-46

[    0.000000] Linux version 3.5.0-rc5+ (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #49 Wed Jul 11 19:50:54 CST 2012
[    0.000000] Command line: trinity=10m tree=net-next:master auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-11-19-51-05-net-net-next.master-04c9f41-efc73f4-x86_64-randconfig-net1-1-xbm BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-net1/efc73f4bbc238d4f579fb612c04c8e1dd8a82979/vmlinuz-3.5.0-rc5+
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffd max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffcfff]
[    0.000000]  [mem 0x00000000-0x0fffcfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffcfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128792(98%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: cpu 0, msr 0:145ea81, boot clock
[    0.000000] Zone ranges:
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]
[    0.000000] On node 0 totalpages: 65420
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 6 pages reserved
[    0.000000]   DMA32 zone: 64390 pages, LIFO batch:15
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64390
[    0.000000] Kernel command line: trinity=10m tree=net-next:master auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-11-19-51-05-net-net-next.master-04c9f41-efc73f4-x86_64-randconfig-net1-1-xbm BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-net1/efc73f4bbc238d4f579fb612c04c8e1dd8a82979/vmlinuz-3.5.0-rc5+
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 209684k/262132k available (2789k kernel code, 452k absent, 51996k reserved, 3832k data, 520k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:48 16
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
[    0.000000] hpet clockevent registered
[    0.000000] Detected 3093.196 MHz processor.
[    0.004000] Calibrating delay loop (skipped) preset value.. 6186.39 BogoMIPS (lpj=12372784)
[    0.004019] pid_max: default: 32768 minimum: 301
[    0.005289] Security Framework initialized
[    0.006402] Yama: becoming mindful.
[    0.007360] Mount-cache hash table entries: 256
[    0.008345] mce: CPU supports 10 MCE banks
[    0.009462] MCE: unknown CPU type - not enabling MCE support.
[    0.012011] CPU: GenuineIntel Common KVM processor stepping 01
[    0.017222] ACPI: Core revision 20120320
[    0.020283] Performance Events: 
[    0.021324] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.023201] Getting VERSION: 50014
[    0.024020] Getting VERSION: 50014
[    0.024971] Getting ID: 0
[    0.025695] Getting ID: ff000000
[    0.026549] Getting LVT0: 8700
[    0.027376] Getting LVT1: 8400
[    0.028094] enabled ExtINT on CPU#0
[    0.030677] ENABLING IO-APIC IRQs
[    0.032016] init IO_APIC IRQs
[    0.032851]  apic 2 pin 0 not connected
[    0.033896] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.036042] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.038171] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.040038] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.042140] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.044056] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.046215] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.048037] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.050131] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.052038] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.054165] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.056049] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.058192] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.060038] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.064038] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.066173]  apic 2 pin 16 not connected
[    0.067217]  apic 2 pin 17 not connected
[    0.068009]  apic 2 pin 18 not connected
[    0.069062]  apic 2 pin 19 not connected
[    0.070153]  apic 2 pin 20 not connected
[    0.071192]  apic 2 pin 21 not connected
[    0.072009]  apic 2 pin 22 not connected
[    0.073048]  apic 2 pin 23 not connected
[    0.074259] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076009] Using local APIC timer interrupts.
[    0.076009] calibrating APIC timer ...
[    0.084004] ... lapic delta = 6249981
[    0.084004] ..... delta 6249981
[    0.084004] ..... mult: 268417863
[    0.084004] ..... calibration result: 3999987
[    0.084004] ..... CPU clock speed is 3092.3861 MHz.
[    0.084004] ..... host bus clock speed is 999.3987 MHz.
[    0.084004] ... verify APIC timer
[    0.194227] ... jiffies delta = 25
[    0.195474] ... jiffies result ok
[    0.196233] device: 'platform': device_add
[    0.197730] bus: 'platform': registered
[    0.199129] bus: 'cpu': registered
[    0.200020] device: 'cpu': device_add
[    0.201726] bus: 'virtio': registered
[    0.203102] device class 'regulator': registering
[    0.204085] Registering platform device 'reg-dummy'. Parent at platform
[    0.206489] device: 'reg-dummy': device_add
[    0.208031] bus: 'platform': add device reg-dummy
[    0.209727] bus: 'platform': add driver reg-dummy
[    0.212027] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.215186] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.216037] device: 'regulator.0': device_add
[    0.220070] dummy: 
[    0.220889] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.223384] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.224152] NET: Registered protocol family 16
[    0.228148] device class 'bdi': registering
[    0.229668] device class 'pci_bus': registering
[    0.231378] bus: 'pci': registered
[    0.232021] device: 'rapidio': device_add
[    0.233532] bus: 'rapidio': registered
[    0.234929] device class 'backlight': registering
[    0.236032] device class 'tty': registering
[    0.237561] bus: 'spi': registered
[    0.240019] device class 'spi_master': registering
[    0.241750] bus: 'hsi': registered
[    0.243237] ACPI: bus type pci registered
[    0.244020] device class 'dma': registering
[    0.245749] device class 'dmi': registering
[    0.248028] device: 'id': device_add
[    0.249773] PCI: Using configuration type 1 for base access
[    0.252138] device: 'cpu0': device_add
[    0.253860] bus: 'cpu': add device cpu0
[    0.256888] device: 'default': device_add
[    0.258949] ACPI: Added _OSI(Module Device)
[    0.260023] ACPI: Added _OSI(Processor Device)
[    0.262119] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.264024] ACPI: Added _OSI(Processor Aggregator Device)
[    0.270846] ACPI: EC: Look up EC in DSDT
[    0.277723] ACPI: Interpreter enabled
[    0.279460] ACPI: (supports S0 S5)
[    0.280399] ACPI: Using IOAPIC for interrupt routing
[    0.282701] bus: 'acpi': registered
[    0.284024] bus: 'acpi': add driver power
[    0.285899] device: 'LNXSYSTM:00': device_add
[    0.288032] bus: 'acpi': add device LNXSYSTM:00
[    0.290221] device: 'LNXCPU:00': device_add
[    0.292031] bus: 'acpi': add device LNXCPU:00
[    0.294142] device: 'LNXCPU:01': device_add
[    0.296031] bus: 'acpi': add device LNXCPU:01
[    0.298106] device: 'device:00': device_add
[    0.300032] bus: 'acpi': add device device:00
[    0.302124] device: 'PNP0A03:00': device_add
[    0.304031] bus: 'acpi': add device PNP0A03:00
[    0.306188] device: 'device:01': device_add
[    0.308032] bus: 'acpi': add device device:01
[    0.310156] device: 'device:02': device_add
[    0.312032] bus: 'acpi': add device device:02
[    0.314164] device: 'device:03': device_add
[    0.316032] bus: 'acpi': add device device:03
[    0.318142] device: 'device:04': device_add
[    0.320032] bus: 'acpi': add device device:04
[    0.322152] device: 'device:05': device_add
[    0.324033] bus: 'acpi': add device device:05
[    0.326151] device: 'device:06': device_add
[    0.328033] bus: 'acpi': add device device:06
[    0.330134] device: 'device:07': device_add
[    0.332033] bus: 'acpi': add device device:07
[    0.334170] device: 'device:08': device_add
[    0.336034] bus: 'acpi': add device device:08
[    0.340050] device: 'device:09': device_add
[    0.341970] bus: 'acpi': add device device:09
[    0.344111] device: 'device:0a': device_add
[    0.346035] bus: 'acpi': add device device:0a
[    0.348118] device: 'device:0b': device_add
[    0.350034] bus: 'acpi': add device device:0b
[    0.352119] device: 'device:0c': device_add
[    0.354089] bus: 'acpi': add device device:0c
[    0.356119] device: 'device:0d': device_add
[    0.358058] bus: 'acpi': add device device:0d
[    0.360119] device: 'device:0e': device_add
[    0.362047] bus: 'acpi': add device device:0e
[    0.364125] device: 'device:0f': device_add
[    0.366054] bus: 'acpi': add device device:0f
[    0.368126] device: 'device:10': device_add
[    0.370053] bus: 'acpi': add device device:10
[    0.372120] device: 'device:11': device_add
[    0.374053] bus: 'acpi': add device device:11
[    0.376121] device: 'device:12': device_add
[    0.378047] bus: 'acpi': add device device:12
[    0.380120] device: 'device:13': device_add
[    0.382037] bus: 'acpi': add device device:13
[    0.384120] device: 'device:14': device_add
[    0.386053] bus: 'acpi': add device device:14
[    0.388121] device: 'device:15': device_add
[    0.390042] bus: 'acpi': add device device:15
[    0.392137] device: 'device:16': device_add
[    0.394049] bus: 'acpi': add device device:16
[    0.396141] device: 'device:17': device_add
[    0.398071] bus: 'acpi': add device device:17
[    0.400132] device: 'device:18': device_add
[    0.402049] bus: 'acpi': add device device:18
[    0.404122] device: 'device:19': device_add
[    0.406045] bus: 'acpi': add device device:19
[    0.408131] device: 'device:1a': device_add
[    0.410059] bus: 'acpi': add device device:1a
[    0.412123] device: 'device:1b': device_add
[    0.414131] bus: 'acpi': add device device:1b
[    0.416122] device: 'device:1c': device_add
[    0.418069] bus: 'acpi': add device device:1c
[    0.420122] device: 'device:1d': device_add
[    0.422061] bus: 'acpi': add device device:1d
[    0.424128] device: 'device:1e': device_add
[    0.426110] bus: 'acpi': add device device:1e
[    0.428123] device: 'device:1f': device_add
[    0.430090] bus: 'acpi': add device device:1f
[    0.432164] device: 'device:20': device_add
[    0.434139] bus: 'acpi': add device device:20
[    0.436114] device: 'device:21': device_add
[    0.438085] bus: 'acpi': add device device:21
[    0.440108] device: 'PNP0B00:00': device_add
[    0.442101] bus: 'acpi': add device PNP0B00:00
[    0.444167] device: 'PNP0303:00': device_add
[    0.446178] bus: 'acpi': add device PNP0303:00
[    0.448142] device: 'PNP0F13:00': device_add
[    0.452041] bus: 'acpi': add device PNP0F13:00
[    0.454176] device: 'PNP0700:00': device_add
[    0.456041] bus: 'acpi': add device PNP0700:00
[    0.459095] device: 'PNP0400:00': device_add
[    0.460042] bus: 'acpi': add device PNP0400:00
[    0.462308] device: 'PNP0501:00': device_add
[    0.464042] bus: 'acpi': add device PNP0501:00
[    0.466273] device: 'device:22': device_add
[    0.468043] bus: 'acpi': add device device:22
[    0.472054] device: 'PNP0103:00': device_add
[    0.474053] bus: 'acpi': add device PNP0103:00
[    0.476271] device: 'PNP0C0F:00': device_add
[    0.478234] bus: 'acpi': add device PNP0C0F:00
[    0.480224] device: 'PNP0C0F:01': device_add
[    0.482203] bus: 'acpi': add device PNP0C0F:01
[    0.484224] device: 'PNP0C0F:02': device_add
[    0.486189] bus: 'acpi': add device PNP0C0F:02
[    0.488248] device: 'PNP0C0F:03': device_add
[    0.490220] bus: 'acpi': add device PNP0C0F:03
[    0.492132] device: 'device:23': device_add
[    0.494120] bus: 'acpi': add device device:23
[    0.496101] device: 'LNXPWRBN:00': device_add
[    0.497649] bus: 'acpi': add device LNXPWRBN:00
[    0.500380] bus: 'acpi': add driver ec
[    0.501793] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.504037] bus: 'acpi': add driver pci_root
[    0.505553] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    0.508036] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    0.512064] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.514270] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.516038] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.520038] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.522928] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.524038] PCI: root bus 00: using default resources
[    0.528043] device: 'pci0000:00': device_add
[    0.529578] device: '0000:00': device_add
[    0.531034] PCI host bridge to bus 0000:00
[    0.532040] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.534265] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.536040] pci_bus 0000:00: scanning bus
[    0.537556] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.540046] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0xa
[    0.542883] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.544944] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.548587] pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
[    0.552125] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.555005] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x145
[    0.556061] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.558670] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.560125] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x10
[    0.564250] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.570054] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
[    0.577350] pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
[    0.596157] pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pref]
[    0.598867] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.601086] pci 0000:00:03.0: reg 10: [mem 0xf2020000-0xf203ffff]
[    0.605016] pci 0000:00:03.0: reg 14: [io  0xc040-0xc07f]
[    0.612990] pci 0000:00:03.0: reg 30: [mem 0xf2040000-0xf2047fff pref]
[    0.615599] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.616215] pci 0000:00:04.0: reg 10: [mem 0xf2048000-0xf204800f]
[    0.621404] pci_bus 0000:00: fixups for bus
[    0.622893] pci_bus 0000:00: bus scan returning with max=00
[    0.624050] pci_bus 0000:00: on NUMA node 0
[    0.625610] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.629336]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.632061] device: '0000:00:00.0': device_add
[    0.634670] bus: 'pci': add device 0000:00:00.0
[    0.636140] device: '0000:00:01.0': device_add
[    0.638593] bus: 'pci': add device 0000:00:01.0
[    0.640079] device: '0000:00:01.1': device_add
[    0.642741] bus: 'pci': add device 0000:00:01.1
[    0.644082] device: '0000:00:01.3': device_add
[    0.648963] bus: 'pci': add device 0000:00:01.3
[    0.651102] device: '0000:00:02.0': device_add
[    0.652952] bus: 'pci': add device 0000:00:02.0
[    0.656096] device: '0000:00:03.0': device_add
[    0.659025] bus: 'pci': add device 0000:00:03.0
[    0.660103] device: '0000:00:04.0': device_add
[    0.664523] bus: 'pci': add device 0000:00:04.0
[    0.666630] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    0.668055] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    0.672134] bus: 'acpi': add driver pci_link
[    0.674137] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    0.676047] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    0.680192] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.684853] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    0.688050] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    0.692053] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    0.695835] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    0.696134] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.700852] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    0.704051] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    0.708053] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    0.712049] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    0.716135] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.719014] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    0.720052] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    0.724054] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    0.728050] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    0.732135] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.736248] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    0.739341] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    0.740095] bus: 'pnp': registered
[    0.744071] bus: 'platform': add driver da9052-regulator
[    0.746513] bus: 'platform': add driver wm831x-buckv
[    0.748063] bus: 'platform': add driver wm831x-buckp
[    0.750389] bus: 'platform': add driver wm831x-boostp
[    0.752063] bus: 'platform': add driver wm831x-epe
[    0.756080] bus: 'platform': add driver wm831x-isink
[    0.758319] bus: 'platform': add driver wm831x-ldo
[    0.760063] bus: 'platform': add driver wm831x-aldo
[    0.762271] bus: 'platform': add driver wm831x-alive-ldo
[    0.764070] device class 'misc': registering
[    0.766105] bus: 'spi': add driver wm831x
[    0.768064] bus: 'spi': add driver ezx-pcap
[    0.769973] bus: 'spi': add driver da9052
[    0.772079] bus: 'serio': registered
[    0.773745] bus: 'gameport': registered
[    0.776053] device class 'input': registering
[    0.778045] device class 'rtc': registering
[    0.780070] device class 'power_supply': registering
[    0.782323] device class 'hwmon': registering
[    0.784066] device class 'watchdog': registering
[    0.786175] device class 'leds': registering
[    0.788070] PCI: Using ACPI for IRQ routing
[    0.789967] PCI: pci_cache_line_size set to 64 bytes
[    0.792130] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.796064] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.800057] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.803744] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.804058] pci 0000:00:01.1: BAR 4: reserving [io  0xc000-0xc00f flags 0x40101] (d=0, p=0)
[    0.808103] pci 0000:00:02.0: BAR 0: reserving [mem 0xf0000000-0xf1ffffff flags 0x42208] (d=0, p=0)
[    0.812065] pci 0000:00:02.0: BAR 1: reserving [mem 0xf2000000-0xf2000fff flags 0x40200] (d=0, p=0)
[    0.816085] pci 0000:00:03.0: BAR 0: reserving [mem 0xf2020000-0xf203ffff flags 0x40200] (d=0, p=0)
[    0.820059] pci 0000:00:03.0: BAR 1: reserving [io  0xc040-0xc07f flags 0x40101] (d=0, p=0)
[    0.824083] pci 0000:00:04.0: BAR 0: reserving [mem 0xf2048000-0xf204800f flags 0x40200] (d=0, p=0)
[    0.828229] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    0.832068] e820: reserve RAM buffer [mem 0x0fffd000-0x0fffffff]
[    0.836086] device class 'net': registering
[    0.838099] device: 'lo': device_add
[    0.840671] Switching to clocksource kvm-clock
[    0.842999] FS-Cache: Loaded
[    0.844052] bus: 'pnp': add driver system
[    0.844052] pnp: PnP ACPI init
[    0.845054] device: 'pnp0': device_add
[    0.846763] ACPI: bus type pnp registered
[    0.848701] pnp 00:00: [bus 00-ff]
[    0.850246] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.852165] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.854283] pnp 00:00: [io  0x0d00-0xffff window]
[    0.856447] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.858881] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.861413] device: '00:00': device_add
[    0.863250] bus: 'pnp': add device 00:00
[    0.865141] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.868385] pnp 00:01: [io  0x0070-0x0071]
[    0.870295] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.873956] pnp 00:01: [irq 8]
[    0.875359] pnp 00:01: [io  0x0072-0x0077]
[    0.877297] device: '00:01': device_add
[    0.879127] bus: 'pnp': add device 00:01
[    0.880997] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.884036] pnp 00:02: [io  0x0060]
[    0.885637] pnp 00:02: [io  0x0064]
[    0.887231] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.890873] pnp 00:02: [irq 1]
[    0.892379] device: '00:02': device_add
[    0.894201] bus: 'pnp': add device 00:02
[    0.896043] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.899021] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.902754] pnp 00:03: [irq 12]
[    0.904262] device: '00:03': device_add
[    0.906136] bus: 'pnp': add device 00:03
[    0.907979] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.911038] pnp 00:04: [io  0x03f2-0x03f5]
[    0.912973] pnp 00:04: [io  0x03f7]
[    0.914572] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.918219] pnp 00:04: [irq 6]
[    0.919629] pnp 00:04: [dma 2]
[    0.921126] device: '00:04': device_add
[    0.922984] bus: 'pnp': add device 00:04
[    0.924870] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.927938] pnp 00:05: [io  0x0378-0x037f]
[    0.929851] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.933485] pnp 00:05: [irq 7]
[    0.934886] device: '00:05': device_add
[    0.936779] bus: 'pnp': add device 00:05
[    0.938585] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.941660] pnp 00:06: [io  0x03f8-0x03ff]
[    0.943536] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.947198] pnp 00:06: [irq 4]
[    0.948680] device: '00:06': device_add
[    0.950514] bus: 'pnp': add device 00:06
[    0.952435] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.955524] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.957763] device: '00:07': device_add
[    0.959597] bus: 'pnp': add device 00:07
[    0.961459] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.964679] pnp: PnP ACPI: found 8 devices
[    0.966553] ACPI: ACPI bus type pnp unregistered
[    0.968683] bus: 'pci': add driver Intel MID DMA
[    0.970820] device class 'mem': registering
[    0.972798] device: 'mem': device_add
[    0.974513] device: 'kmem': device_add
[    0.976324] device: 'null': device_add
[    0.978066] device: 'port': device_add
[    0.979840] device: 'zero': device_add
[    0.981669] device: 'full': device_add
[    0.983411] device: 'random': device_add
[    0.985266] device: 'urandom': device_add
[    0.987104] device: 'kmsg': device_add
[    0.988888] device: 'oldmem': device_add
[    0.990701] device: 'tty': device_add
[    0.992470] device: 'console': device_add
[    0.994317] device class 'firmware': registering
[    0.996479] device class 'thermal': registering
[    0.998591] bus: 'ssb': registered
[    1.000261] bus: 'bcma': registered
[    1.001901] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.004479] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    1.007418] NET: Registered protocol family 1
[    1.009503] pci 0000:00:00.0: calling quirk_natoma+0x0/0x2b
[    1.012115] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.014793] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x90
[    1.017752] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.020449] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x2e
[    1.023231] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.026101] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x9b
[    1.028819] pci 0000:00:02.0: Boot video device
[    1.030880] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x165
[    1.033829] PCI: CLS 0 bytes, default 64
[    1.035857] Unpacking initramfs...
[    2.310244] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.335857] DMA-API: preallocated 32768 debug entries
[    2.338251] DMA-API: debugging enabled by kernel config
[    2.342835] microcode: no support for this CPU vendor
[    2.345259] cryptomgr_test (13) used greatest stack depth: 6376 bytes left
[    2.348240] cryptomgr_test (15) used greatest stack depth: 5880 bytes left
[    2.353638] bus: 'clocksource': registered
[    2.355121] device: 'clocksource': device_add
[    2.356845] device: 'clocksource0': device_add
[    2.358429] bus: 'clocksource': add device clocksource0
[    2.360420] bus: 'platform': add driver alarmtimer
[    2.362257] Registering platform device 'alarmtimer'. Parent at platform
[    2.365345] device: 'alarmtimer': device_add
[    2.367281] bus: 'platform': add device alarmtimer
[    2.369565] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    2.373661] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    2.377526] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    2.380808] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    2.384715] bus: 'event_source': registered
[    2.386649] device: 'breakpoint': device_add
[    2.388688] bus: 'event_source': add device breakpoint
[    2.391080] device: 'software': device_add
[    2.393074] bus: 'event_source': add device software
[    2.399929] VFS: Disk quotas dquot_6.5.2
[    2.401933] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.405118] msgmni has been set to 409
[    2.407113] cryptomgr_test (29) used greatest stack depth: 5864 bytes left
[    2.412403] alg: No test for fcrypt (fcrypt-generic)
[    2.417035] cryptomgr_test (50) used greatest stack depth: 5672 bytes left
[    2.420525] alg: No test for stdrng (krng)
[    2.432798] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    2.435720] list_sort_test: start testing list_sort()
[    2.438451] bus: 'acpi': add driver button
[    2.440536] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    2.444430] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    2.448147] device: 'input0': device_add
[    2.450048] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.453682] ACPI: Power Button [PWRF]
[    2.455466] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    2.458690] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    2.462195] bus: 'acpi': add driver smbus_hc
[    2.464345] bus: 'acpi': add driver sbs
[    2.466173] bus: 'virtio': add driver virtio_balloon
[    2.468610] bus: 'platform': add driver reg-virt-consumer
[    2.471109] bus: 'platform': add driver reg-userspace-consumer
[    2.473917] bus: 'spi': add driver tps6524x
[    2.475915] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.478872] Registering platform device 'serial8250'. Parent at platform
[    2.482154] device: 'serial8250': device_add
[    2.484249] bus: 'platform': add device serial8250
[    2.515757] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.518433] device: 'ttyS0': device_add
[    2.520401] device: 'ttyS1': device_add
[    2.521976] device: 'ttyS2': device_add
[    2.523541] device: 'ttyS3': device_add
[    2.525064] bus: 'platform': add driver serial8250
[    2.527107] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    2.530987] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    2.535270] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    2.537990] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    2.540977] bus: 'pci': add driver serial
[    2.542534] enter max3107 init
[    2.543637] bus: 'spi': add driver max3107
[    2.545403] bus: 'pci': add driver HSU serial
[    2.547069] device: 'ttyprintk': device_add
[    2.548733] device class 'virtio-ports': registering
[    2.550547] bus: 'virtio': add driver virtio_console
[    2.552540] device class 'printer': registering
[    2.554194] lp: driver loaded but no devices found
[    2.556058] smapi::smapi_init, ERROR invalid usSmapiID
[    2.557921] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    2.561347] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    2.563997] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    2.566312] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    2.569605] Hangcheck: Using getrawmonotonic().
[    2.571267] bus: 'pnp': add driver tpm_tis
[    2.572974] bus: 'pci': add driver pciPTI
[    2.574461] bus: 'pci': add driver IOC4
[    2.575897] device class 'enclosure': registering
[    2.577668] bus: 'platform': add driver cs5535-mfgpt
[    2.579430] device class 'iLO': registering
[    2.581030] bus: 'pci': add driver hpilo
[    2.582534] bus: 'spi': add driver dac7512
[    2.584076] bus: 'spi': add driver 93xx46
[    2.585534] bus: 'platform': add driver sm501
[    2.587087] bus: 'pci': add driver sm501
[    2.588615] bus: 'pci': add driver lpc_sch
[    2.590089] bus: 'pci': add driver lpc_ich
[    2.591584] bus: 'pci': add driver RDC321x Southbridge
[    2.593529] bus: 'pci': add driver janz-cmodio
[    2.595127] bus: 'pci': add driver cs5535-mfd
[    2.596800] bus: 'spi': add driver tle62x0
[    2.598278] bus: 'platform': add driver pch-spi
[    2.599933] bus: 'pci': add driver pch_spi
[    2.601572] bus: 'hsi': add driver hsi_char
[    2.603066] HSI/SSI char device loaded
[    2.604512] I2O subsystem v1.325
[    2.605681] i2o: max drivers = 8
[    2.606844] bus: 'i2o': registered
[    2.608228] bus: 'i2o': add driver exec-osm
[    2.609748] bus: 'pci': add driver PCI_I2O
[    2.611221] I2O Configuration OSM v1.323
[    2.612791] bus: 'i2o': add driver config-osm
[    2.614364] I2O Bus Adapter OSM v1.317
[    2.615715] bus: 'i2o': add driver bus-osm
[    2.617287] I2O ProcFS OSM v1.316
[    2.618485] bus: 'i2o': add driver proc-osm
[    2.620102] bus: 'i2o': remove driver proc-osm
[    2.621747] driver: 'proc-osm': driver_release
[    2.623393] bus: 'pci': add driver nosy
[    2.624955] device class 'uio': registering
[    2.626493] bus: 'pci': add driver hilscher
[    2.628196] bus: 'platform': add driver uio_pdrv_genirq
[    2.630118] bus: 'pci': add driver aectc
[    2.631688] bus: 'pci': add driver sercos3
[    2.633338] bus: 'pnp': add driver i8042 kbd
[    2.634895] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 kbd
[    2.637911] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:02
[    2.640677] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    2.643051] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd
[    2.645698] bus: 'pnp': add driver i8042 aux
[    2.647227] bus: 'pnp': driver_probe_device: matched device 00:03 with driver i8042 aux
[    2.650185] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03
[    2.652935] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    2.655236] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 aux
[    2.657889] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.660916] Registering platform device 'i8042'. Parent at platform
[    2.663233] device: 'i8042': device_add
[    2.664761] bus: 'platform': add device i8042
[    2.666333] bus: 'platform': add driver i8042
[    2.667967] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    2.670914] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    2.675039] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.676974] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.678782] driver: 'i8042': driver_bound: bound to device 'i8042'
[    2.681130] device: 'serio0': device_add
[    2.682572] bus: 'serio': add device serio0
[    2.684205] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    2.686754] parkbd: no such parport
[    2.688165] bus: 'platform': add driver altera_ps2
[    2.689923] device: 'serio1': device_add
[    2.691411] bus: 'serio': add device serio1
[    2.693099] bus: 'pci': add driver Emu10k1_gameport
[    2.694851] bus: 'pci': add driver FM801_gameport
[    2.696670] bus: 'pnp': add driver ns558
[    2.814335] device: 'event0': device_add
[    2.815944] bus: 'serio': add driver atkbd
[    2.817534] bus: 'serio': add driver lkkbd
[    2.819007] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    2.821987] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    2.824770] bus: 'serio': add driver newtonkbd
[    2.826451] bus: 'platform': add driver omap4-keypad
[    2.829040] device: 'input1': device_add
[    2.830526] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.833724] bus: 'platform': add driver opencores-kbd
[    2.835527] bus: 'serio': add driver stowaway
[    2.837249] bus: 'serio': add driver xtkbd
[    2.838734] bus: 'serio': add driver sermouse
[    2.840438] device: 'event1': device_add
[    2.841995] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    2.844390] bus: 'serio': add driver vsxxxaa
[    2.845940] bus: 'gameport': add driver adi
[    2.847457] bus: 'gameport': add driver cobra
[    2.849174] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    2.851638] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    2.854640] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    2.857375] bus: 'gameport': add driver grip_mp
[    2.858991] bus: 'gameport': add driver guillemot
[    2.861154] atkbd: probe of serio1 rejects match -19
[    2.862989] bus: 'gameport': add driver interact
[    2.864813] bus: 'gameport': add driver joydump
[    2.866447] bus: 'serio': add driver magellan
[    2.868177] bus: 'gameport': add driver sidewinder
[    2.869914] bus: 'serio': add driver spaceorb
[    2.871622] bus: 'serio': add driver stinger
[    2.873301] bus: 'gameport': add driver tmdc
[    2.874844] bus: 'serio': add driver twidjoy
[    2.876560] bus: 'serio': add driver warrior
[    2.878112] bus: 'serio': add driver zhenhua
[    2.879669] bus: 'spi': add driver ad7879
[    2.881252] bus: 'serio': add driver hampshire
[    2.882926] bus: 'serio': add driver gunze
[    2.884560] bus: 'serio': add driver elo
[    2.885990] bus: 'serio': add driver touchit213
[    2.887653] bus: 'serio': add driver tsc40
[    2.889270] bus: 'spi': add driver tsc2005
[    2.890745] bus: 'platform': add driver rtc-bq4802
[    2.892637] bus: 'pnp': add driver rtc_cmos
[    2.894125] bus: 'pnp': driver_probe_device: matched device 00:01 with driver rtc_cmos
[    2.897047] bus: 'pnp': really_probe: probing driver rtc_cmos with device 00:01
[    2.900190] rtc (null): alarm rollover: day
[    2.901919] device: 'rtc0': device_add
[    2.903324] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    2.905813] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    2.908314] driver: '00:01': driver_bound: bound to device 'rtc_cmos'
[    2.910598] bus: 'pnp': really_probe: bound device 00:01 to driver rtc_cmos
[    2.913257] bus: 'platform': add driver rtc-ds1286
[    2.914983] bus: 'spi': add driver rtc-ds1390
[    2.916703] bus: 'platform': add driver ds1511
[    2.918289] bus: 'platform': add driver rtc-ds1553
[    2.920130] bus: 'spi': add driver ds3234
[    2.921585] bus: 'spi': add driver rtc-m41t93
[    2.923150] bus: 'platform': add driver rtc-m48t35
[    2.925009] bus: 'platform': add driver rtc-m48t59
[    2.926734] bus: 'spi': add driver rtc-pcf2123
[    2.928455] bus: 'platform': add driver rtc-rp5c01
[    2.930170] bus: 'platform': remove driver rtc-rp5c01
[    2.932217] driver: 'rtc-rp5c01': driver_release
[    2.933867] bus: 'spi': add driver rtc-rs5c348
[    2.935460] bus: 'platform': add driver rtc-test
[    2.937343] Registering platform device 'rtc-test.0'. Parent at platform
[    2.939859] device: 'rtc-test.0': device_add
[    2.941478] bus: 'platform': add device rtc-test.0
[    2.943282] bus: 'platform': driver_probe_device: matched device rtc-test.0 with driver rtc-test
[    2.946596] bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.0
[    2.949655] device: 'rtc1': device_add
[    2.951037] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    2.953383] driver: 'rtc-test.0': driver_bound: bound to device 'rtc-test'
[    2.955981] bus: 'platform': really_probe: bound device rtc-test.0 to driver rtc-test
[    2.958824] Registering platform device 'rtc-test.1'. Parent at platform
[    2.961378] device: 'rtc-test.1': device_add
[    2.962961] bus: 'platform': add device rtc-test.1
[    2.964834] bus: 'platform': driver_probe_device: matched device rtc-test.1 with driver rtc-test
[    2.967982] bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.1
[    2.970952] device: 'rtc2': device_add
[    2.972536] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    2.974724] driver: 'rtc-test.1': driver_bound: bound to device 'rtc-test'
[    2.977279] bus: 'platform': really_probe: bound device rtc-test.1 to driver rtc-test
[    2.980169] Driver for 1-wire Dallas network protocol.
[    2.982014] bus: 'w1': registered
[    2.983209] bus: 'w1': add driver w1_master_driver
[    2.985055] bus: 'w1': add driver w1_slave_driver
[    2.986740] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.989006] bus: 'platform': add driver ds1wm
[    2.990645] bus: 'platform': add driver pda-power
[    2.992594] device: 'test_ac': device_add
[    2.994078] power_supply test_ac: power_supply_changed
[    2.995983] device: 'test_battery': device_add
[    2.997669] power_supply test_ac: power_supply_changed_work
[    2.999652] power_supply test_ac: power_supply_update_gen_leds 1
[    3.002016] power_supply test_battery: power_supply_changed
[    3.004218] bus: 'platform': add driver ds2781-battery
[    3.006071] bus: 'platform': add driver max8903-charger
[    3.008041] power_supply test_battery: power_supply_changed_work
[    3.010204] power_supply test_battery: power_supply_update_bat_leds 2
[    3.012914] bus: 'spi': add driver lm70
[    3.014301] bus: 'spi': add driver max1111
[    3.015921] bus: 'pci': add driver via686a
[    3.017496] bus: 'platform': add driver wm831x-hwmon
[    3.019261] bus: 'pci': add driver pcwd_pci
[    3.020915] bus: 'pci': add driver wdt_pci
[    3.022512] acquirewdt: WDT driver for Acquire single board computer initialising
[    3.025269] bus: 'platform': add driver acquirewdt
[    3.026981] Registering platform device 'acquirewdt'. Parent at platform
[    3.029484] device: 'acquirewdt': device_add
[    3.031017] bus: 'platform': add device acquirewdt
[    3.032908] bus: 'platform': driver_probe_device: matched device acquirewdt with driver acquirewdt
[    3.036194] bus: 'platform': really_probe: probing driver acquirewdt with device acquirewdt
[    3.039155] acquirewdt: I/O address 0x0043 already in use
[    3.041224] acquirewdt: probe of acquirewdt failed with error -5
[    3.043354] advantechwdt: WDT driver for Advantech single board computer initialising
[    3.046245] bus: 'platform': add driver advantechwdt
[    3.048181] Registering platform device 'advantechwdt'. Parent at platform
[    3.050610] device: 'advantechwdt': device_add
[    3.052433] bus: 'platform': add device advantechwdt
[    3.054228] bus: 'platform': driver_probe_device: matched device advantechwdt with driver advantechwdt
[    3.057666] bus: 'platform': really_probe: probing driver advantechwdt with device advantechwdt
[    3.060891] device: 'watchdog': device_add
[    3.062469] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[    3.064815] driver: 'advantechwdt': driver_bound: bound to device 'advantechwdt'
[    3.067422] bus: 'platform': really_probe: bound device advantechwdt to driver advantechwdt
[    3.070534] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    3.072773] bus: 'platform': add driver SP5100 TCO timer
[    3.074706] Registering platform device 'SP5100 TCO timer'. Parent at platform
[    3.077405] device: 'SP5100 TCO timer': device_add
[    3.079108] bus: 'platform': add device SP5100 TCO timer
[    3.081181] bus: 'platform': driver_probe_device: matched device SP5100 TCO timer with driver SP5100 TCO timer
[    3.084888] bus: 'platform': really_probe: probing driver SP5100 TCO timer with device SP5100 TCO timer
[    3.088337] SP5100 TCO timer: probe of SP5100 TCO timer rejects match -19
[    3.090738] bus: 'platform': add driver geodewdt
[    3.092591] Registering platform device 'geodewdt'. Parent at platform
[    3.094931] device: 'geodewdt': device_add
[    3.096537] bus: 'platform': add device geodewdt
[    3.098200] bus: 'platform': driver_probe_device: matched device geodewdt with driver geodewdt
[    3.101359] bus: 'platform': really_probe: probing driver geodewdt with device geodewdt
[    3.104324] geodewdt: No timers were available
[    3.105915] geodewdt: probe of geodewdt rejects match -19
[    3.107904] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[    3.110323] eurotechwdt: can't misc_register on minor=130
[    3.112521] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[    3.115302] wafer5823wdt: I/O address 0x0443 already in use
[    3.117415] bus: 'pci': add driver i6300ESB timer
[    3.119108] bus: 'pci': driver_probe_device: matched device 0000:00:04.0 with driver i6300ESB timer
[    3.122490] bus: 'pci': really_probe: probing driver i6300ESB timer with device 0000:00:04.0
[    3.125616] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    3.128061] i6300esb: cannot register miscdev on minor=130 (err=-16)
[    3.130347] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[    3.132833] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    3.134805] bus: 'platform': add driver iTCO_wdt
[    3.136607] iTCO_vendor_support: vendor-support=0
[    3.138266] sbc60xxwdt: I/O address 0x0443 already in use
[    3.140311] sbc8360: failed to register misc device
[    3.142269] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
[    3.146277] smsc37b787_wdt: Unable to register miscdev on minor 130
[    3.148650] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    3.150822] w83697hf_wdt: watchdog not found at address 0x2e
[    3.153017] w83697hf_wdt: No W83697HF/HG could be found
[    3.154868] w83977f_wdt: driver v1.00
[    3.156314] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[    3.158643] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    3.160904] machzwd: no ZF-Logic found
[    3.162242] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
[    3.164693] bus: 'platform': add driver da9052-watchdog
[    3.166582] bus: 'platform': add driver wm831x-watchdog
[    3.168655] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[    3.171623] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[    3.174558] device: 'watchdog1': device_add
[    3.176233] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=1)
[    3.180260] bus: 'platform': add driver leds-ot200
[    3.181995] bus: 'platform': add driver da9052-leds
[    3.183901] bus: 'platform': add driver wm831x-status
[    3.185799] bus: 'spi': add driver dac124s085
[    3.187615] EFI Variables Facility v0.08 2004-May-17
[    3.189548] cs5535-clockevt: Could not allocate MFPGT timer
[    3.191532] bus: 'acpi': add driver cmpc_keys
[    3.193260] bus: 'acpi': add driver cmpc
[    3.194706] bus: 'acpi': add driver cmpc_tablet
[    3.196510] bus: 'acpi': add driver cmpc_accel
[    3.198131] hdaps: supported laptop not found!
[    3.199722] hdaps: driver init failed (ret=-19)!
[    3.201617] fujitsu_tablet: Unknown (using defaults)
[    3.203371] bus: 'acpi': add driver fujitsu-tablet
[    3.205248] bus: 'pci': add driver intel ips
[    3.206808] device class 'extcon': registering
[    3.208587] bus: 'vme': registered
[    3.209842] oprofile: using timer interrupt.
[    3.211571] 
[    3.211571] printing PIC contents
[    3.213449] ... PIC  IMR: ffff
[    3.214568] ... PIC  IRR: 1113
[    3.215683] ... PIC  ISR: 0000
[    3.216936] ... PIC ELCR: 0c00
[    3.218046] printing local APIC contents on CPU#0/0:
[    3.219885] ... APIC ID:      00000000 (0)
[    3.220916] ... APIC VERSION: 00050014
[    3.220916] ... APIC TASKPRI: 00000000 (00)
[    3.220916] ... APIC PROCPRI: 00000000
[    3.220916] ... APIC LDR: 01000000
[    3.220916] ... APIC DFR: ffffffff
[    3.220916] ... APIC SPIV: 000001ff
[    3.220916] ... APIC ISR field:
[    3.220916] 0000000000000000000000000000000000000000000000000000000000000000
[    3.220916] ... APIC TMR field:
[    3.220916] 0000000000000000000000000000000000000000000000000000000000000000
[    3.220916] ... APIC IRR field:
[    3.220916] 0000000000000000000000000000000000000000000000000000000000008000
[    3.220916] ... APIC ESR: 00000000
[    3.220916] ... APIC ICR: 00000831
[    3.220916] ... APIC ICR2: 01000000
[    3.220916] ... APIC LVTT: 000000ef
[    3.220916] ... APIC LVTPC: 00010000
[    3.220916] ... APIC LVT0: 00010700
[    3.220916] ... APIC LVT1: 00000400
[    3.220916] ... APIC LVTERR: 000000fe
[    3.220916] ... APIC TMICT: 0002f041
[    3.220916] ... APIC TMCCT: 00000000
[    3.220916] ... APIC TDCR: 00000003
[    3.220916] 
[    3.257105] number of MP IRQ sources: 15.
[    3.258532] number of IO-APIC #2 registers: 24.
[    3.260264] testing the IO APIC.......................
[    3.262220] 
[    3.262783] IO APIC #2......
[    3.263878] .... register #00: 00000000
[    3.265332] .......    : physical APIC id: 00
[    3.266874] .......    : Delivery Type: 0
[    3.268445] .......    : LTS          : 0
[    3.269874] .... register #01: 00170011
[    3.271234] .......     : max redirection entries: 17
[    3.273250] .......     : PRQ implemented: 0
[    3.274779] .......     : IO APIC version: 11
[    3.276494] .... register #02: 00000000
[    3.277859] .......     : arbitration: 00
[    3.279275] .... IRQ redirection table:
[    3.280784]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    3.282730]  00 00  1    0    0   0   0    0    0    00
[    3.284768]  01 01  0    0    0   0   0    1    1    31
[    3.286685]  02 01  0    0    0   0   0    1    1    30
[    3.288740]  03 01  0    0    0   0   0    1    1    33
[    3.290702]  04 01  1    0    0   0   0    1    1    34
[    3.292876]  05 01  1    1    0   0   0    1    1    35
[    3.294803]  06 01  0    0    0   0   0    1    1    36
[    3.296869]  07 01  0    0    0   0   0    1    1    37
[    3.298795]  08 01  0    0    0   0   0    1    1    38
[    3.300871]  09 01  0    1    0   0   0    1    1    39
[    3.302857]  0a 01  1    1    0   0   0    1    1    3A
[    3.304925]  0b 01  1    1    0   0   0    1    1    3B
[    3.307019]  0c 01  0    0    0   0   0    1    1    3C
[    3.309582]  0d 01  0    0    0   0   0    1    1    3D
[    3.311958]  0e 01  0    0    0   0   0    1    1    3E
[    3.313994]  0f 01  0    0    0   0   0    1    1    3F
[    3.315972]  10 00  1    0    0   0   0    0    0    00
[    3.317976]  11 00  1    0    0   0   0    0    0    00
[    3.319955]  12 00  1    0    0   0   0    0    0    00
[    3.322098]  13 00  1    0    0   0   0    0    0    00
[    3.324144]  14 00  1    0    0   0   0    0    0    00
[    3.326061]  15 00  1    0    0   0   0    0    0    00
[    3.328106]  16 00  1    0    0   0   0    0    0    00
[    3.330023]  17 00  1    0    0   0   0    0    0    00
[    3.331990] IRQ to pin mappings:
[    3.333300] IRQ0 -> 0:2
[    3.334280] IRQ1 -> 0:1
[    3.335251] IRQ3 -> 0:3
[    3.336366] IRQ4 -> 0:4
[    3.337342] IRQ5 -> 0:5
[    3.338319] IRQ6 -> 0:6
[    3.339290] IRQ7 -> 0:7
[    3.340391] IRQ8 -> 0:8
[    3.341363] IRQ9 -> 0:9
[    3.342335] IRQ10 -> 0:10
[    3.343365] IRQ11 -> 0:11
[    3.344583] IRQ12 -> 0:12
[    3.345623] IRQ13 -> 0:13
[    3.346649] IRQ14 -> 0:14
[    3.347677] IRQ15 -> 0:15
[    3.348856] .................................... done.
[    3.350739] Refined TSC clocksource calibration: 3092.974 MHz.
[    3.353080] device: 'cpu_dma_latency': device_add
[    3.354784] device: 'network_latency': device_add
[    3.356622] device: 'network_throughput': device_add
[    3.358552] IMA: No TPM chip found, activating TPM-bypass!
[    3.361345] bus: 'platform': add driver charger-manager
[    3.363297] bus: 'platform': add driver ie6xx_wdt
[    3.365120] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.367215] EDD information not available.
[    3.369680] debug: unmapping init [mem 0xffffffff81679000-0xffffffff816fafff]
[    3.392648] hostname (61) used greatest stack depth: 5360 bytes left
[    3.399332] mount (62) used greatest stack depth: 5264 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   21.174694] BUG: unable to handle kernel paging request at ffffffff816d6790
[   21.176021] IP: [<ffffffff8115a220>] strlcpy+0x10/0x70
[   21.176021] PGD 1448067 PUD 144c063 PMD 958c063 PTE 16d6162
[   21.176021] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   21.176021] CPU 0 
[   21.176021] Pid: 81, comm: trinity-child0 Not tainted 3.5.0-rc5+ #49 Bochs Bochs
[   21.176021] RIP: 0010:[<ffffffff8115a220>]  [<ffffffff8115a220>] strlcpy+0x10/0x70
[   21.176021] RSP: 0018:ffff880005f29e38  EFLAGS: 00010292
[   21.176021] RAX: ffffffff813601a0 RBX: ffff880000070470 RCX: 2222222222222222
[   21.176021] RDX: 0000000000000008 RSI: ffffffff816d6790 RDI: ffff880005f39000
[   21.176021] RBP: ffff880005f29e58 R08: 2222222222222222 R09: 0000000000000000
[   21.176021] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880005f39000
[   21.176021] R13: ffff880005f30b00 R14: 0000000000001ce5 R15: ffff880000072140
[   21.176021] FS:  00007fbb01ca6700(0000) GS:ffffffff81457000(0000) knlGS:0000000000000000
[   21.176021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   21.176021] CR2: ffffffff816d6790 CR3: 0000000005e9e000 CR4: 00000000000006b0
[   21.176021] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   21.176021] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   21.176021] Process trinity-child0 (pid: 81, threadinfo ffff880005f28000, task ffff880006fa1110)
[   21.176021] Stack:
[   21.176021]  ffffffff811118fe ffff880000070470 ffff880005f39000 ffff880005f30b00
[   21.176021]  ffff880005f29e68 ffffffff81058213 ffff880005f29e88 ffffffff810582d8
[   21.176021]  ffff880005f30b20 ffff880005f29f50 ffff880005f29e98 ffffffff810580d8
[   21.176021] Call Trace:
[   21.176021]  [<ffffffff811118fe>] ? sysfs_read_file+0x3e/0x1a0
[   21.176021]  [<ffffffff81058213>] param_get_string+0x13/0x20
[   21.176021]  [<ffffffff810582d8>] param_attr_show+0x38/0x80
[   21.176021]  [<ffffffff810580d8>] module_attr_show+0x18/0x30
[   21.176021]  [<ffffffff81111972>] sysfs_read_file+0xb2/0x1a0
[   21.176021]  [<ffffffff810cd14f>] vfs_read+0x9f/0x160
[   21.176021]  [<ffffffff810cd4c8>] sys_read+0x48/0x90
[   21.176021]  [<ffffffff812b6637>] system_call_fastpath+0x16/0x1b
[   21.176021] Code: 44 00 00 0f b6 16 80 fa 01 88 11 48 83 de ff 48 83 c1 01 4c 39 c1 75 eb 5d c3 90 55 48 89 e5 41 55 41 54 49 89 fc 53 48 83 ec 08 <80> 3e 00 74 48 48 89 f0 0f 1f 84 00 00 00 00 00 48 83 c0 01 80 
[   21.176021] RIP  [<ffffffff8115a220>] strlcpy+0x10/0x70
[   21.176021]  RSP <ffff880005f29e38>
[   21.176021] CR2: ffffffff816d6790
[   21.176021] ---[ end trace 922009029d2c7ad6 ]---
[   21.176021] BUG: sleeping function called from invalid context at /c/kernel-tests/net/include/linux/kernel.h:199
[   21.176021] in_atomic(): 0, irqs_disabled(): 1, pid: 81, name: trinity-child0
[   21.176021] INFO: lockdep is turned off.
[   21.176021] Pid: 81, comm: trinity-child0 Tainted: G      D      3.5.0-rc5+ #49
[   21.176021] Call Trace:
[   21.176021]  [<ffffffff81065b70>] __might_sleep+0xf0/0x120
[   21.176021]  [<ffffffff81077aa3>] exit_robust_list+0x63/0x1d0
[   21.176021]  [<ffffffff8115ac24>] ? timerqueue_del+0x34/0x90
[   21.176021]  [<ffffffff8103c74c>] mm_release+0x15c/0x170
[   21.176021]  [<ffffffff81041cb1>] exit_mm+0x21/0x110
[   21.176021]  [<ffffffff81043901>] do_exit+0xe1/0x7f0
[   21.176021]  [<ffffffff8104156c>] ? kmsg_dump+0xfc/0x120
[   21.176021]  [<ffffffff81041490>] ? kmsg_dump+0x20/0x120
[   21.176021]  [<ffffffff810059c7>] oops_end+0xa7/0xf0
[   21.176021]  [<ffffffff812aa4d5>] no_context+0x24b/0x276
[   21.176021]  [<ffffffff81024783>] ? kernel_map_pages+0x113/0x1e0
[   21.176021]  [<ffffffff812aa6c3>] __bad_area_nosemaphore+0x1c3/0x1e2
[   21.176021]  [<ffffffff812a9d66>] ? pte_offset_kernel+0x10/0x3d
[   21.176021]  [<ffffffff812aa6f0>] bad_area_nosemaphore+0xe/0x10
[   21.176021]  [<ffffffff8102173c>] do_page_fault+0x30c/0x4e0
[   21.176021]  [<ffffffff810730eb>] ? __lock_acquire.isra.31+0x3eb/0xb30
[   21.176021]  [<ffffffff810095c3>] ? sched_clock+0x13/0x20
[   21.176021]  [<ffffffff810662f5>] ? sched_clock_local.constprop.2+0x15/0x80
[   21.176021]  [<ffffffff81066405>] ? sched_clock_cpu+0x75/0xd0
[   21.176021]  [<ffffffff812b6085>] page_fault+0x25/0x30
[   21.176021]  [<ffffffff8115a220>] ? strlcpy+0x10/0x70
[   21.176021]  [<ffffffff811118fe>] ? sysfs_read_file+0x3e/0x1a0
[   21.176021]  [<ffffffff81058213>] param_get_string+0x13/0x20
[   21.176021]  [<ffffffff810582d8>] param_attr_show+0x38/0x80
[   21.176021]  [<ffffffff810580d8>] module_attr_show+0x18/0x30
[   21.176021]  [<ffffffff81111972>] sysfs_read_file+0xb2/0x1a0
[   21.176021]  [<ffffffff810cd14f>] vfs_read+0x9f/0x160
[   21.176021]  [<ffffffff810cd4c8>] sys_read+0x48/0x90
[   21.176021]  [<ffffffff812b6637>] system_call_fastpath+0x16/0x1b
[   21.336229] trinity-child0 (81) used greatest stack depth: 4792 bytes left
[   21.343716] warning: process `trinity-child0' used the deprecated sysctl system call with 

--ReaqsoxgOBHFXBhH
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_HOTPLUG is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
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
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
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
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_MCE_INJECT is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
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
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
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
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
# CONFIG_X86_PM_TIMER is not set
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
CONFIG_ACPI_APEI_EINJ=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

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
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
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
CONFIG_BQL=y

#
# Network testing
#
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
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
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
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
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
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_PHANTOM is not set
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
CONFIG_HP_ILO=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#

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
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_OMAP4=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
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
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
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
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX3107=y
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
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
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_MANAGER=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
CONFIG_SP5100_TCO=y
CONFIG_GEODE_WDT=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
CONFIG_EUROTECH_WDT=y
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_ABX500_CORE=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_CS5535=y
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_VX855 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_WM831X=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_RC_CORE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
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

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=y
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_WM831X is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_PCAP is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_BALLOON=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
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
# CONFIG_VME_CA91CX42 is not set
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
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
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
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
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_STRESS=y
CONFIG_IOMMU_LEAK=y
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
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
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
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_DDR=y

--ReaqsoxgOBHFXBhH--
