Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1EFIeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:34:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50724 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1EFIeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:34:20 -0400
Message-ID: <4DC3B289.5000400@landley.net>
Date: Fri, 06 May 2011 03:34:17 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: qemu-devel <qemu-devel@nongnu.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: "General protection fault" exiting qemu with current linux-git.
References: <4DC34229.4080202@landley.net>
In-Reply-To: <4DC34229.4080202@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 07:34 PM, Rob Landley wrote:
> I'm running current linux-git (5895198c56d131cc696556) and current
> qemu-git (d2d979c628e4b2c4a3c I think) with the attached kernel .config,
> and it gave me a GPF on exit from the emulator.
> 
> I'm not sure which project is responsible, but I thought I'd throw it
> out there...
> 
> Rob

Here it is again with function names in the stack trace:

md: stopping all md devices.
e1000 0000:00:03.0: PCI INT A disabled
Restarting system.
machine restart
general protection fault: fff2 [#1] SMP
last sysfs file: /sys/devices/virtual/cpuid/cpu0/dev
CPU 0
Pid: 667, comm: oneit Not tainted 2.6.39-rc6+ #7 Bochs Bochs
RIP: 0010:[<ffffffff8101cbc7>]  [<ffffffff8101cbc7>]
native_stop_other_cpus+0x77/0x80
RSP: 0018:ffff880006c0be08  EFLAGS: 00000246
RAX: 00000000000000ff RBX: 0000000000000246 RCX: 00000000ffffffff
RDX: ffffffff81020e50 RSI: 00000000000000ff RDI: 00000000000000f0
RBP: ffffffff816ceeb8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0a74726174736572 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000004 R15: 00000000004009e4
FS:  0000000000000000(0000) GS:ffff880007c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000609910 CR3: 0000000007b3b000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
Process oneit (pid: 667, threadinfo ffff880006c0a000, task ffff880007a5cb00)
Stack:
 00000000fee1dead 0000000028121969 0000000001234567 ffffffff8101c4cf
 00000000004009e4 ffffffff8101c214 00000000fee1dead ffffffff81053ae7
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8101c4cf>] ? native_machine_shutdown+0x5f/0x80
 [<ffffffff8101c214>] ? native_machine_restart+0x24/0x40
 [<ffffffff81053ae7>] ? sys_reboot+0x1a7/0x230
 [<ffffffff8103cad1>] ? schedule_tail+0x21/0xa0
 [<ffffffff814860c3>] ? ret_from_fork+0x13/0x80
 [<ffffffff814861bb>] ? system_call_fastpath+0x16/0x1b
Code: 0f 1f 40 00 74 1b 48 89 c3 bf c7 10 00 00 e8 b1 ca 18 00 48 8b 7d
00 f3 48 0f b8 c7 83 f8 01 77 d3 9c 5b fa e8 db 0b 00 00 53 9d <5b> 5d
41 5c c3 0f 1f 40 00 48 83 ec 18 48 8b 05 7d 72 47 00 48
RIP  [<ffffffff8101cbc7>] native_stop_other_cpus+0x77/0x80
 RSP <ffff880006c0be08>
---[ end trace 12a9e2cf16977a27 ]---

