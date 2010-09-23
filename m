Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0IWKNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:13:47 -0400
Received: from isomail2.amdocs.com ([193.43.244.89]:33155 "EHLO
	isomail2.amdocs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0IWKNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:13:46 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2010 06:13:45 EDT
From: James Dingwall <james.dingwall@amdocs.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Sep 2010 11:04:21 +0100
Subject: Re: PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just after the boot
Thread-Topic: Re: PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just after
 the boot
Thread-Index: ActbBrFQRLxRr7otT6CQVQeRBMawqg==
Message-ID: <3B7AEC3C7FCC864282DFAC9A56A7BA363D814756E7@UKLNDMAIL1.corp.amdocs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
x-tm-as-product-ver: SMEX-8.0.0.4125-6.500.1024-17660.006
x-tm-as-result: No--46.057300-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, I don't have the original mail to reply to)

I was experiencing the same immediate crash with a null pointer dereference (log below) on boot with 2.6.35.5.  Reverting fb412a178502dc498430723b082a932f797e4763 also resolved the problem for me.

If my .config or other information about my setup will help let me know.

James


Linux version 2.6.35.5 (root@behemoth) (gcc version 4.4.3 (Gentoo 4.4.3-r2 p1.2) ) #6 SMP Wed Sep 22 10:19:10 BST 2010
Command line: root=/dev/ram0 init=/linuxrc ramdisk=8192 real_root=/dev/xvda1 udev doscsi dolvm dodmraid
ACPI in unprivileged domain disabled
BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 00000000000a0000 (usable)
 Xen: 00000000000a0000 - 0000000000100000 (reserved)
 Xen: 0000000000100000 - 0000000020000000 (usable)
NX (Execute Disable) protection: active
DMI not present or invalid.
No AGP bridge found
last_pfn = 0x20000 max_arch_pfn = 0x400000000
init_memory_mapping: 0000000000000000-0000000020000000
RAMDISK: 01713000 - 01f20000
No NUMA configuration found
Faking a node at 0000000000000000-0000000020000000
Initmem setup node 0 0000000000000000-0000000020000000
  NODE_DATA [00000000016f24c0 - 00000000016f74bf]
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000001 -> 0x000000a0
    0: 0x00000100 -> 0x00020000
SMP: Allowing 1 CPUs, 0 hotplug CPUs
No local APIC present
APIC: disable apic facility
APIC: switched to apic NOOP
Allocating PCI resources starting at 20000000 (gap: 20000000:e0000000)
Booting paravirtualized kernel on Xen
Xen version: 4.0.0 (preserve-AD)
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 27 pages/cpu @ffff880002068000 s81856 r8192 d20544 u110592
pcpu-alloc: s81856 r8192 d20544 u110592 alloc=27*4096
pcpu-alloc: [0] 0
Xen: using vcpu_info placement
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 129183
Policy zone: DMA32
Kernel command line: root=/dev/ram0 init=/linuxrc ramdisk=8192 real_root=/dev/xvda1 udev doscsi dolvm dodmraid
PID hash table entries: 2048 (order: 2, 16384 bytes)
Checking aperture...
No AGP bridge found
Subtract (37 early reservations)
  #1 [0002023000 - 0002038000]  XEN PAGETABLES
  #2 [0001000000 - 00016f2484]   TEXT DATA BSS
  #3 [0001713000 - 0001f20000]         RAMDISK
  #4 [0001f20000 - 0002023000]  XEN START INFO
  #5 [0000001000 - 0000003000]      TRAMPOLINE
  #6 [0000100000 - 00001ea000]         PGTABLE
  #7 [00016f24c0 - 00016f74c0]       NODE_DATA
  #8 [00016f74c0 - 00016f84c0]         BOOTMEM
  #9 [0000003000 - 0000003040]         BOOTMEM
  #10 [00016f9000 - 00016fa000]         BOOTMEM
  #11 [00016fa000 - 00016fb000]         BOOTMEM
  #12 [00016fb000 - 00016fc000]         BOOTMEM
  #13 [00016fc000 - 00016fd000]         BOOTMEM
  #14 [00016fd000 - 00016fe000]         BOOTMEM
  #15 [00016fe000 - 00016ff000]         BOOTMEM
  #16 [0002a00000 - 0003100000]        MEMMAP 0
  #17 [0002038000 - 0002050000]         BOOTMEM
  #18 [0002050000 - 0002068000]         BOOTMEM
  #19 [00016ff000 - 0001700000]         BOOTMEM
  #20 [0001700000 - 0001701000]         BOOTMEM
  #21 [0001701000 - 0001702000]         BOOTMEM
  #22 [00016f84c0 - 00016f85a0]         BOOTMEM
  #23 [00016f85c0 - 00016f8628]         BOOTMEM
  #24 [00016f8640 - 00016f86a8]         BOOTMEM
  #25 [00016f86c0 - 00016f8728]         BOOTMEM
  #26 [00016f8740 - 00016f879b]         BOOTMEM
  #27 [00016f87c0 - 00016f881b]         BOOTMEM
  #28 [0002068000 - 0002083000]         BOOTMEM
  #29 [00016f8840 - 00016f8848]         BOOTMEM
  #30 [00016f8880 - 00016f8888]         BOOTMEM
  #31 [00016f88c0 - 00016f88c4]         BOOTMEM
  #32 [00016f8900 - 00016f8908]         BOOTMEM
  #33 [00016f8940 - 00016f8a40]         BOOTMEM
  #34 [00016f8a40 - 00016f8a88]         BOOTMEM
  #35 [00016f8ac0 - 00016f8b08]         BOOTMEM
  #36 [0001702000 - 0001706000]         BOOTMEM
Memory: 498928k/524288k available (3822k kernel code, 388k absent, 24972k reserved, 2017k data, 540k init)
Hierarchical RCU implementation.
        RCU-based detection of stalled CPUs is disabled.
        Verbose stalled-CPUs detection is disabled.
NR_IRQS:4352 nr_irqs:256
Console: colour dummy device 80x25
console [tty0] enabled
console [hvc0] enabled
installing Xen timer for CPU 0
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
PGD 0
Oops: 0010 [#1] SMP
last sysfs file:
CPU 0
Modules linked in:

Pid: 0, comm: swapper Not tainted 2.6.35.5 #6 /
RIP: e030:[<0000000000000000>]  [<(null)>] (null)
RSP: e02b:ffffffff8151dd70  EFLAGS: 00010046
RAX: ffffffff816d6180 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff8151dd88 R08: ffff88001fc016a0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8153f200
R13: 0000000000000000 R14: 00000000ffffffda R15: ffffffff8153f264
FS:  0000000000000000(0000) GS:ffff880002068000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001541000 CR4: 0000000000000660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff8151c000, task ffffffff81549020)
Stack:
 ffffffff81067804 0000000000000000 ffff88001fc04e40 ffffffff8151dda8
<0> ffffffff810677e4 0000000000000040 ffffffff8153f200 ffffffff8151ddf8
<0> ffffffff81066cc7 0000000000000001 0000000000000200 ffffffff8100599f
Call Trace:
 [<ffffffff81067804>] ? default_enable+0x1a/0x28
 [<ffffffff810677e4>] default_startup+0x19/0x1f
 [<ffffffff81066cc7>] __setup_irq+0x186/0x2c1
 [<ffffffff8100599f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff810056c0>] ? xen_timer_interrupt+0x0/0x17b
 [<ffffffff81066ee4>] request_threaded_irq+0xe2/0x129
 [<ffffffff81067b90>] ? handle_percpu_irq+0x0/0x69
 [<ffffffff812603bb>] bind_virq_to_irqhandler+0x18a/0x1b7
 [<ffffffff81217d26>] ? kvasprintf+0x5e/0x6e
 [<ffffffff810056c0>] ? xen_timer_interrupt+0x0/0x17b
 [<ffffffff8100567c>] xen_setup_timer+0x59/0x9d
 [<ffffffff815ce759>] xen_time_init+0xa1/0xad
 [<ffffffff815cef4e>] x86_late_time_init+0xa/0x11
 [<ffffffff815cad01>] start_kernel+0x35a/0x3d2
 [<ffffffff815ca2c8>] x86_64_start_reservations+0xb3/0xb7
 [<ffffffff815cdbfc>] xen_start_kernel+0x52b/0x52f
Code:  Bad RIP value.
RIP  [<(null)>] (null)
 RSP <ffffffff8151dd70>
CR2: 0000000000000000
---[ end trace a7919e7f17c0a725 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Pid: 0, comm: swapper Tainted: G      D     2.6.35.5 #6
Call Trace:
 [<ffffffff813b6bd1>] panic+0x86/0xfa
 [<ffffffff810059b2>] ? check_events+0x12/0x20
 [<ffffffff8103e375>] do_exit+0x6d/0x6e8
 [<ffffffff813b8e8a>] ? _raw_spin_unlock_irqrestore+0x19/0x1c
 [<ffffffff8103bd78>] ? kmsg_dump+0x126/0x140
 [<ffffffff8100bad9>] oops_end+0x97/0x9c
 [<ffffffff810290a9>] no_context+0x1f7/0x206
 [<ffffffff81005361>] ? xen_force_evtchn_callback+0xd/0xf
 [<ffffffff810059b2>] ? check_events+0x12/0x20
 [<ffffffff81029237>] __bad_area_nosemaphore+0x17f/0x1a2
 [<ffffffff8100599f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff81029268>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81029532>] do_page_fault+0x168/0x30d
 [<ffffffff8100599f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff813b94b5>] page_fault+0x25/0x30
 [<ffffffff81067804>] ? default_enable+0x1a/0x28
 [<ffffffff810677e4>] default_startup+0x19/0x1f
 [<ffffffff81066cc7>] __setup_irq+0x186/0x2c1
 [<ffffffff8100599f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff810056c0>] ? xen_timer_interrupt+0x0/0x17b
 [<ffffffff81066ee4>] request_threaded_irq+0xe2/0x129
 [<ffffffff81067b90>] ? handle_percpu_irq+0x0/0x69
 [<ffffffff812603bb>] bind_virq_to_irqhandler+0x18a/0x1b7
 [<ffffffff81217d26>] ? kvasprintf+0x5e/0x6e
 [<ffffffff810056c0>] ? xen_timer_interrupt+0x0/0x17b
 [<ffffffff8100567c>] xen_setup_timer+0x59/0x9d
 [<ffffffff815ce759>] xen_time_init+0xa1/0xad
 [<ffffffff815cef4e>] x86_late_time_init+0xa/0x11
 [<ffffffff815cad01>] start_kernel+0x35a/0x3d2
 [<ffffffff815ca2c8>] x86_64_start_reservations+0xb3/0xb7
 [<ffffffff815cdbfc>] xen_start_kernel+0x52b/0x52f

This message and the information contained herein is proprietary and confidential and subject to the Amdocs policy statement,
you may review at http://www.amdocs.com/email_disclaimer.asp

