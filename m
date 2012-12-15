Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab2LORn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 12:43:57 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50884 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2LORn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 12:43:56 -0500
Date: Sat, 15 Dec 2012 11:43:52 -0600
From: Rob Landley <rob@landley.net>
Subject: Panic at shutdown in x86-64 3.7 kernel under qemu 1.3.0?
To: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
X-Mailer: Balsa 2.4.11
Message-Id: <1355593432.24099.7@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reasonably vanilla versions of both just did this. No idea why. Just  
did it the once, haven't gotten it to reproduce...

Rob

Restarting system.
reboot: machine restart
general protection fault: fff2 [#1]
CPU 0
Pid: 8542, comm: oneit Not tainted 3.7.0 #1 Bochs Bochs
RIP: 0010:[<ffffffff81013bec>]  [<ffffffff81013bec>]  
lapic_shutdown+0x29/0x2b
RSP: 0018:ffff88000fb57e28  EFLAGS: 00000202
RAX: ffffffff8130e2d0 RBX: 0000000000000202 RCX: 0000000000000000
RDX: ffffffff81322a40 RSI: 00000000000000ff RDI: 00000000000000f0
RBP: 0000000028121969 R08: ffff88000fb57fd8 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff81015721 R12: 00000000fee1dead
R13: 0000000000000000 R14: 0000000000000004 R15: 0000000000425e02
FS:  0000000000000000(0000) GS:ffffffff81304000(0000)  
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000440f11 CR3: 000000000fb53000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
Process oneit (pid: 8542, threadinfo ffff88000fb56000, task  
ffff88000e848f90)
Stack:
  0000000001234567 ffffffff810136cb 0000000028121969 ffffffff810136a8
  0000000001234567 ffffffff8102b451 0000000000000011 0000000000040001
  0000000000000023 0000000000000000 0000000000000006 00000001802a0027
Call Trace:
  [<ffffffff810136cb>] ? native_machine_shutdown+0x9/0x1e
  [<ffffffff810136a8>] ? native_machine_restart+0x20/0x29
  [<ffffffff8102b451>] ? sys_reboot+0x11f/0x14a
  [<ffffffff81029368>] ? __kill_pgrp_info+0x37/0x5f
  [<ffffffff81022622>] ? do_exit+0x61f/0x623
  [<ffffffff81037ce5>] ? schedule_tail+0x20/0x46
  [<ffffffff8122233f>] ? ret_from_fork+0xf/0xb0
  [<ffffffff81222450>] ? system_call_fastpath+0x16/0x1b
Code: c8 c3 48 8b 05 8a cc 31 00 53 f6 c4 02 75 12 83 3d c9 da 38 00 00  
74 13 83 3d d8 ea 38 00 00 75 0a 9c 5b fa e8 3a ff ff ff 53 9d <5b> c3  
48 83 ec 08 eb 02 f3 90 48 8b 05 eb db 31 00 bf 00 03 00
RIP  [<ffffffff81013bec>] lapic_shutdown+0x29/0x2b
  RSP <ffff88000fb57e28>
---[ end trace 0c69c9c16377bd9d ]