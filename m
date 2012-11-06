Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2KFXvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:51:21 -0500
Received: from trent.utfs.org ([94.185.90.103]:57777 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab2KFXvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:51:19 -0500
Date: Tue, 6 Nov 2012 15:51:15 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linuxppc-dev@ozlabs.org
Subject: 3.7-rc4: BUG: MAX_STACK_TRACE_ENTRIES too low!
Message-ID: <alpine.DEB.2.01.1211061543400.20449@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after upgrading from 3.6.0-08492-gd43 to 3.7.0-rc4 and running it for a 
day or so, this happened:

[27148.965634] BUG: MAX_STACK_TRACE_ENTRIES too low!
[27148.967356] turning off the locking correctness validator.
[27148.968967] Call Trace:
[27148.970577] [ec633d00] [c0009064] show_stack+0x70/0x1bc (unreliable)
[27148.972229] [ec633d40] [c0077460] save_trace+0xfc/0x114
[27148.973855] [ec633d50] [c0078578] mark_lock+0x1b4/0x678
[27148.975472] [ec633d80] [c007ad70] __lock_acquire+0x4b8/0x19b8
[27148.977098] [ec633e20] [c007c2c0] lock_acquire+0x50/0x70
[27148.978717] [ec633e40] [c004ee88] process_one_work+0x1c4/0x49c
[27148.980302] [ec633e80] [c004f644] worker_thread+0x14c/0x400
[27148.981866] [ec633eb0] [c0057634] kthread+0xbc/0xc0
[27148.983385] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64

The last message is repeated several times, see below. The machine 
(PowerPC G4) is still up & running and no ill behaviour can be seen for
now. I still wonder if this would be a sign for trouble...

Christian.

[27148.984860] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.986259] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.987583] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.988854] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.990086] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.991305] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.992495] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.993668] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.994809] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.995947] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.997070] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.998182] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27148.999282] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.000365] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.001436] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.002450] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.003417] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.004378] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.005324] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.006260] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.007181] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.008087] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.008972] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.009833] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.010656] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.011443] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.012203] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.012935] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.013642] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.014314] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.014951] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.015568] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.016168] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.016744] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.017293] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.017814] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.018313] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.018796] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.019257] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.019701] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.020120] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.020519] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.020900] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.021283] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.021880] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.022275] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.022659] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.023043] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.023427] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.023810] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.024191] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.024573] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.024955] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.025339] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.025723] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
[27149.026106] [ec633f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64

$ zgrep DEBUG /proc/config.gz | grep =y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_SLUB_DEBUG=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUGGER=y

-- 
BOFH excuse #248:

Too much radiation coming from the soil.
