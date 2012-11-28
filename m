Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2K1DGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:06:40 -0500
Received: from trent.utfs.org ([94.185.90.103]:44924 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab2K1DGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:06:38 -0500
Date: Tue, 27 Nov 2012 19:06:35 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linuxppc-dev@lists.ozlabs.org, paulus@samba.org
Subject: 3.7-rc7: BUG: MAX_STACK_TRACE_ENTRIES too low!
Message-ID: <alpine.DEB.2.01.1211271824120.7378@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the same thing[0] happened again in 3.7-rc7, after ~20h uptime:

[40007.339487] [sched_delayed] sched: RT throttling activated
[69731.388717] BUG: MAX_STACK_TRACE_ENTRIES too low!
[69731.390371] turning off the locking correctness validator.
[69731.391942] Call Trace:
[69731.393525] [c9a61c10] [c0009064] show_stack+0x70/0x1bc (unreliable)
[69731.395152] [c9a61c50] [c0077460] save_trace+0xfc/0x114
[69731.396735] [c9a61c60] [c007be20] __lock_acquire+0x1568/0x19b8
[69731.398296] [c9a61d00] [c007c2c0] lock_acquire+0x50/0x70
[69731.399857] [c9a61d20] [c0550e28] _raw_spin_lock_irq+0x5c/0x78
[69731.401419] [c9a61d40] [c054fb58] __schedule+0xd8/0x534
[69731.402972] [c9a61da0] [c0550094] _cond_resched+0x50/0x68
[69731.404527] [c9a61db0] [c0479908] dst_gc_task+0xbc/0x258
[69731.406070] [c9a61e40] [c004eeb8] process_one_work+0x1f4/0x49c
[69731.407585] [c9a61e80] [c004f644] worker_thread+0x14c/0x400
[69731.409075] [c9a61eb0] [c0057634] kthread+0xbc/0xc0
[69731.410521] [c9a61f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[...repeated 54 times...]

Anyone knows what this is about?

Thanks,
Christian.

[0] http://lkml.indiana.edu/hypermail/linux/kernel/1211.0/03025.html
-- 
BOFH excuse #235:

The new frame relay network hasn't bedded down the software loop transmitter yet.
