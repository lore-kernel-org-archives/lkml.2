Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab0FJL3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:29:32 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49176 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab0FJL3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:29:31 -0400
Date: Thu, 10 Jun 2010 16:58:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Panic on boot on today's tip/master
Message-ID: <20100610112839.GK5878@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I updated my tip/master and rebooted into it, I am seeing a panic on boot.


Here is the ooops message. (x86_64 box)

PCI: MMCONFIG for domain 0000 [bus 00-2e] at [mem 0xd0000000-0xd2efffff] (base 0xd0000000)
PCI: MMCONFIG at [mem 0xd0000000-0xd2efffff] reserved in E820
------------[ cut here ]------------
kernel BUG at lib/ioremap.c:26!
invalid opcode: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.35-rc2-tip-uprobes+ #8 Node1 Processor Card/IBM 3850 M2 / x3950 M2 -[71414RA]-
RIP: 0010:[<ffffffff811a1d25>]  [<ffffffff811a1d25>] ioremap_page_range+0x1c5/0x248
RSP: 0018:ffff88083cd39d80  EFLAGS: 00010286
RAX: 00000000d0180000 RBX: ffffc90003200000 RCX: ffff88083cf99000
RDX: 0000000000000000 RSI: 00000000000001ba RDI: ffffffff817a0c90
RBP: ffff88083cd39de0 R08: 0000000000000004 R09: ffffffff817bf578
R10: ffff88083cf99000 R11: 0000000000000002 R12: ffffc90005f80000
R13: ffffc90003400000 R14: ffffffff817a0c90 R15: ffff88083fc0c0c8
FS:  0000000000000000(0000) GS:ffff880002e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000001fd69a10 CR3: 00000000017a0000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88083cd38000, task ffff88083cd30000)
Stack:
 ffff88083cd39da0 00000000d0000000 ffffc90005f80000 ffffc90005f80000
<0> ffff88083fc07000 8000000000000573 000036fffcf80000 0000000002f00000
<0> ffff88083cdd6aa0 ffffc90003080000 00000000d0000000 00000000d0000000
Call Trace:
 [<ffffffff810262e5>] __ioremap_caller+0x295/0x30e
 [<ffffffff81a583a3>] ? pci_mmcfg_arch_init+0x33/0x9d
 [<ffffffff81a59005>] ? pci_parse_mcfg+0x109/0x130
 [<ffffffff81a582bb>] ? pci_arch_init+0x0/0x69
 [<ffffffff810263fb>] ioremap_nocache+0x17/0x19
 [<ffffffff81a583a3>] pci_mmcfg_arch_init+0x33/0x9d
 [<ffffffff81a58da4>] __pci_mmcfg_init+0x1c0/0x1ea
 [<ffffffff8124057b>] ? device_register+0x1e/0x22
 [<ffffffff81a58de9>] pci_mmcfg_early_init+0xe/0x10
 [<ffffffff81a582d9>] pci_arch_init+0x1e/0x69
 [<ffffffff810001f2>] do_one_initcall+0x57/0x13c
 [<ffffffff81a27934>] kernel_init+0x14c/0x1d6
 [<ffffffff81003954>] kernel_thread_helper+0x4/0x10
 [<ffffffff813625fc>] ? restore_args+0x0/0x30
 [<ffffffff81a277e8>] ? kernel_init+0x0/0x1d6
 [<ffffffff81003950>] ? kernel_thread_helper+0x0/0x10
Code: 89 da 48 c1 ea 09 48 89 c1 81 e2 f8 0f 00 00 48 01 d1 74 49 48 8b 45 a8 48 03 45 d0 48 01 d8 48 25 00 f0 ff ff 48 83 39 00 74 04 <0f> 0b eb fe 48 8b 55 c8 f6 c2 01 74 07 48 23 15 47 aa 6a 00 48                                                                                                           
RIP  [<ffffffff811a1d25>] ioremap_page_range+0x1c5/0x248
 RSP <ffff88083cd39d80>
---[ end trace 4eaa2a86a8e2da22 ]---


$ git log tip_master --pretty=oneline |head -n 10
1e6d1f4ce66b60d7b5046dd0de6693309f61b6fa Merge branch 'linus'
9370a9525e3661295d478de657f53008ba4232c5 Merge branch 'x86/urgent'
c171adb13ab5ccba9525662ca6cc1b6608a846f5 Merge branch 'x86/cpu'
43e9742305bcbcd1d02d6b9f2e5ac2798ae1d5a7 Merge branch 'x86/alternatives'
f88731e3068f9d1392ba71cc9f50f035d26a0d4f x86, alternatives: Use 16-bit numbers for cpufeature index
12d8a961289644d265d8b3e88201878837c3b814 x86, AMD: Extend support to future families
8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0 x86, cacheinfo: Carve out L3 cache slot accessors
d6d4d4205cf4ce4ba13bc320305afbda25303496 x86, xsave: Cleanup return codes in check_for_xstate()
cc7f0a7b3004a4ca0bfef0e1ca79f2e0da6ca1b0 x86, hweight: Fix UML boot crash
a4384df3e24579d6292a1b3b41d500349948f30b x86, irq: Rename gsi_end gsi_top, and fix off by one errors


previously it booted well with commit
a2e42da15c9c72bc7caf9e494d409819babbc9c8

--
Thanks and Regards
Srikar
