Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2GJDRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 23:17:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47327 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab2GJDRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 23:17:05 -0400
MIME-Version: 1.0
In-Reply-To: <CANuKePntggbPrY7=eq-+AHzqcPG4Y6UGnP+9B57Gs2xNLeCR_A@mail.gmail.com>
References: <CANuKePntggbPrY7=eq-+AHzqcPG4Y6UGnP+9B57Gs2xNLeCR_A@mail.gmail.com>
Date: Tue, 10 Jul 2012 11:17:03 +0800
Message-ID: <CANuKePnXeKLuf5MoBhuHS_kqVvFTYTCN=Qs1j7YLVj7wohA0Pw@mail.gmail.com>
Subject: Re: why Linux kernel will update BIOS's interrupt remapping table
 base address ? why does Linux Kernel create a new table instead of the one
 that BIOS provided ?
From: Lin-Bao Zhang <2004.zhang@gmail.com>
To: flyboy@gmail.com, yinghai@kernel.org, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for this thing , we have known that , we can append "x2apic_phys" to
tell linux kernel we support x2apic physical mode.
but I found that x2apic_phys is not enough .we still found panic info
in RHEL6.2(2.6.32) kernel,but on linux kernel-3.4.4 ,no this issue
again.  any comment for this bug ?

Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 24 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20090903
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 20776 entries in 82 pages
DMAR: Host address width 40
DMAR: DRHD base: 0x000000ace00000 flags: 0x0
IOMMU ace00000: ver 1:0 cap c90780106f0462 ecap f0207e
DMAR: DRHD base: 0x000000a8000000 flags: 0x1
IOMMU a8000000: ver 1:0 cap c90780106f0462 ecap f0207e
DMAR: RMRR base: 0x0000007f7ee000 end: 0x0000007f7effff
DMAR: RMRR base: 0x0000007f7e7000 end: 0x0000007f7ecfff
DMAR: RMRR base: 0x0000007f61e000 end: 0x0000007f61ffff
DMAR: ATSR flags: 0x0
DMAR: ATSR flags: 0x0
IOAPIC id 10 under DRHD base 0xace00000
IOAPIC id 8 under DRHD base 0xa8000000
IOAPIC id 0 under DRHD base 0xa8000000
Enabled IRQ remapping in x2apic modef
NMI: IOCK error (debug interrupt?)
CPU 0
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.32-220.el6.x86_64 #1 HP ProLiant DL980 G7
RIP: 0010:[<ffffffff8100f937>]  [<ffffffff8100f937>]
mask_and_ack_8259A+0x57/0x110
RSP: 0018:ffff880045603f08  EFLAGS: 00000046
RAX: 00000000000000ff RBX: 000000000000ffff RCX: 00000000000001c0
RDX: 0000000000000082 RSI: ffffffff81a83240 RDI: ffffffff81dd65e0
RBP: ffff880045603f28 R08: ffff88086c42e000 R09: ffff88086c42fe30
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000082 R14: ffff88086c42fd88 R15: 0000000000015e40
FS:  0000000000000000(0000) GS:ffff880045600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001a85000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88086c42e000, task ffff88e7ecdc4040)
Stack:
 0000000000000046 ffffffff81a83240 ffffffff81a832ac 0000000000000000
<0> ffff880045603f58 ffffffff810dc3ca ffffffff8100c24c 0000000000000000
<0> 0000000000000030 0000000000000000 ffff880045603f78 ffffffff8100df09
Call Trace:
 <IRQ>
 [<ffffffff810dc3ca>] handle_level_irq+0x3a/0x130
 [<ffffffff8100c24c>] ? call_softirq+0x1c/0x30
 [<ffffffff8100df09>] handle_irq+0x49/0xa0
 [<ffffffff814f4d0c>] do_IRQ+0x6c/0xf0
 [<ffffffff8100ba53>] ret_from_intr+0x0/0x11
 <EOI>
 [<ffffffff81c303ec>] ? enable_IR_x2apic+0x18a/0x221
 [<ffffffff81c2e189>] native_smp_prepareus+0x143/0x389
 [<ffffffff81c1f740>] kernel_init+0x112/0x2f9
 [<ffffffff8100c14a>] child_rip+0xa/0x20
 [<ffffffff81c1f62e>] ? kernel_init+0x0/0x2f9
 [<ffffffff8100c140>] ? child_rip+0x0/0x20
Code: e8 ef f8 4d 00 49 89 c5 8b 05 16 f7 a7 00 85 c3 75 42 09 c3 89
1d 0a f7 a7 00 41 f6 c4 08 75 6d e4 21 0f b6 05 fb f6 a7 00 e6 21 <41>
8d 44 24 60 e6 20 4c 89 ee 48 c7 c7 e0 65 dd 81 e8 23 fa 4d
NMI: IOCK error (debug interrupt?)
CPU 0
Modules linked in:
