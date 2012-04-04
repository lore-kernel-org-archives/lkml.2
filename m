Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab2DDHCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:02:39 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50632 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2DDHCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:02:38 -0400
Message-ID: <20347.61964.860903.97474@ipc1.ka-ro>
Date: Wed, 4 Apr 2012 09:02:36 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: BUG: sleeping function called from invalid context at /usr/local/src/linux-3.4-rc1/include/linux/freezer.h:46
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit a0acae0e added a might_sleep() to try_to_freeze() in
include/linux/freezer.h.
This leads to the following BUG message each time a process is started
when compiled with CONFIG_DEBUG_ATOMIC_SLEEP=y

|BUG: sleeping function called from invalid context at /usr/local/src/linux-3.4-rc1/include/linux/freezer.h:46
|in_atomic(): 0, irqs_disabled(): 128, pid: 619, name: rc
|no locks held by rc/619.
|irq event stamp: 12235
|hardirqs last  enabled at (12234): [<80334684>] _raw_spin_unlock_irq+0x2c/0x58
|hardirqs last disabled at (12235): [<8000df0c>] ret_fast_syscall+0xc/0x3c
|softirqs last  enabled at (11761): [<80021d00>] __do_softirq+0x140/0x160
|softirqs last disabled at (11754): [<8002221c>] irq_exit+0x60/0xb4
|Backtrace: 
|[<800118b8>] (dump_backtrace+0x0/0x10c) from [<80330b90>] (dump_stack+0x18/0x1c)
| r6:00000000 r5:00000002 r4:9ef66000 r3:9f86bb80
|[<80330b78>] (dump_stack+0x0/0x1c) from [<8003ecb0>] (__might_sleep+0x110/0x130)
|[<8003eba0>] (__might_sleep+0x0/0x130) from [<80010918>] (do_signal+0x8c/0x584)
| r4:9ef67fb0
|[<8001088c>] (do_signal+0x0/0x584) from [<80011340>] (do_notify_resume+0x20/0x64)
|[<80011320>] (do_notify_resume+0x0/0x64) from [<8000df64>] (work_pending+0x24/0x28)
| r4:00000000 r3:00000000

I don't have the slightest idea how this should be fixed.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
