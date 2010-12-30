Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab0L3RO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 12:14:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51678 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0L3RO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 12:14:56 -0500
Date: Thu, 30 Dec 2010 18:14:53 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: still nfs problems [Was: Linux 2.6.37-rc8]
Message-ID: <20101230171453.GA5787@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I wonder if the nfs-stuff is considered to be solved, because I still
see strange things.

During boot my machine sometimes (approx one out of two times) hangs with
the output pasted below on Sysctl-l.  The irq 

I'm not 100% sure it's related, but at least it seems to hang in
nfs_readdir.  (When the serial irq happend that triggered the sysrq the
program counter was at 0xc014601c, which is fs/nfs/dir.c:647 for me.)

This is on 2.6.37-rc8 plus some patches for machine support on an ARM
machine.

Best regards
Uwe

[ 2700.100000] SysRq : Show State
[ 2700.100000]   task                PC stack   pid father
[ 2700.100000] init          S c0285d80     0     1      0 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c004f268>] (do_wait+0x1a4/0x20c)
[ 2700.100000] [<c004f0c4>] (do_wait+0x0/0x20c) from [<c004f378>] (sys_wait4+0xa8/0xc0)
[ 2700.100000] [<c004f2d0>] (sys_wait4+0x0/0xc0) from [<c0033e80>] (ret_fast_syscall+0x0/0x38)
[ 2700.100000]  r8:c0034088 r7:00000072 r6:00000001 r5:0000001b r4:0140b228
[ 2700.100000] kthreadd      S c0285d80     0     2      0 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c006a30c>] (kthreadd+0x70/0xfc)
[ 2700.100000] [<c006a29c>] (kthreadd+0x0/0xfc) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000] ksoftirqd/0   S c0285d80     0     3      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c0052714>] (run_ksoftirqd+0x5c/0x110)
[ 2700.100000] [<c00526b8>] (run_ksoftirqd+0x0/0x110) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000]  r8:00000000 r7:c00526b8 r6:00000000 r5:c7843f1c r4:c7859fac
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843f1c
[ 2700.100000] kworker/0:0   S c0285d80     0     4      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c006480c>] (worker_thread+0x41c/0x444)
[ 2700.100000] [<c00643f0>] (worker_thread+0x0/0x444) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843edc
[ 2700.100000] kworker/u:0   S c0285d80     0     5      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c006480c>] (worker_thread+0x41c/0x444)
[ 2700.100000] [<c00643f0>] (worker_thread+0x0/0x444) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843edc
[ 2700.100000] watchdog/0    S c0285d80     0     6      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c008b418>] (watchdog+0xc0/0x110)
[ 2700.100000] [<c008b358>] (watchdog+0x0/0x110) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000]  r6:00000000 r5:c7843efc r4:c785ffac
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843efc
[ 2700.100000] khelper       S c0285d80     0     7      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c00657d4>] (rescuer_thread+0x1b8/0x1c4)
[ 2700.100000] [<c006561c>] (rescuer_thread+0x0/0x1c4) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843f1c
[ 2700.100000] sync_supers   S c0285d80     0     8      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c00cd114>] (bdi_sync_supers+0x38/0x50)
[ 2700.100000] [<c00cd0dc>] (bdi_sync_supers+0x0/0x50) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000]  r5:c7843f2c r4:c7895fac
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843f2c
[ 2700.100000] bdi-default   S c0285d80     0     9      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c02864b4>] (schedule_timeout+0x22c/0x27c)
[ 2700.100000] [<c0286288>] (schedule_timeout+0x0/0x27c) from [<c00ce014>] (bdi_forker_thread+0x3a8/0x41c)
[ 2700.100000]  r8:c0363f80 r7:00000000 r6:00000000 r5:c03641e8 r4:00000000
[ 2700.100000] [<c00cdc6c>] (bdi_forker_thread+0x0/0x41c) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843efc
[ 2700.100000] kintegrityd   S c0285d80     0    10      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c00657d4>] (rescuer_thread+0x1b8/0x1c4)
[ 2700.100000] [<c006561c>] (rescuer_thread+0x0/0x1c4) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843e9c
[ 2700.100000] kblockd       S c0285d80     0    11      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c00657d4>] (rescuer_thread+0x1b8/0x1c4)
[ 2700.100000] [<c006561c>] (rescuer_thread+0x0/0x1c4) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843ec4
[ 2700.100000] rpciod        S c0285d80     0    12      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c00657d4>] (rescuer_thread+0x1b8/0x1c4)
[ 2700.100000] [<c006561c>] (rescuer_thread+0x0/0x1c4) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843ebc
[ 2700.100000] kworker/0:1   S c0285d80     0    13      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c006480c>] (worker_thread+0x41c/0x444)
[ 2700.100000] [<c00643f0>] (worker_thread+0x0/0x444) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c785be94
[ 2700.100000] khungtaskd    S c0285d80     0    14      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c02864b4>] (schedule_timeout+0x22c/0x27c)
[ 2700.100000] [<c0286288>] (schedule_timeout+0x0/0x27c) from [<c0286584>] (schedule_timeout_interruptible+0x28/0x2c)
[ 2700.100000]  r8:00000078 r7:00007fe9 r6:000003e9 r5:c034eef0 r4:00000064
[ 2700.100000] [<c028655c>] (schedule_timeout_interruptible+0x0/0x2c) from [<c008ada8>] (watchdog+0x54/0x2e8)
[ 2700.100000] [<c008ad54>] (watchdog+0x0/0x2e8) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843f2c
[ 2700.100000] kswapd0       S c0285d80     0    15      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c00c5ea4>] (kswapd+0x210/0x74c)
[ 2700.100000] [<c00c5c94>] (kswapd+0x0/0x74c) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843f1c
[ 2700.100000] fsnotify_mark S c0285d80     0    16      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c011f884>] (fsnotify_mark_destroy+0x11c/0x144)
[ 2700.100000] [<c011f768>] (fsnotify_mark_destroy+0x0/0x144) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843f34
[ 2700.100000] aio           S c0285d80     0    17      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c00657d4>] (rescuer_thread+0x1b8/0x1c4)
[ 2700.100000] [<c006561c>] (rescuer_thread+0x0/0x1c4) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843edc
[ 2700.100000] nfsiod        S c0285d80     0    18      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c00657d4>] (rescuer_thread+0x1b8/0x1c4)
[ 2700.100000] [<c006561c>] (rescuer_thread+0x0/0x1c4) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843edc
[ 2700.100000] crypto        S c0285d80     0    19      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c00657d4>] (rescuer_thread+0x1b8/0x1c4)
[ 2700.100000] [<c006561c>] (rescuer_thread+0x0/0x1c4) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c7843ee4
[ 2700.100000] kworker/u:1   S c0285d80     0    24      2 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c006480c>] (worker_thread+0x41c/0x444)
[ 2700.100000] [<c00643f0>] (worker_thread+0x0/0x444) from [<c006a294>] (kthread+0x8c/0x94)
[ 2700.100000] [<c006a208>] (kthread+0x0/0x94) from [<c004f4d8>] (do_exit+0x0/0x658)
[ 2700.100000]  r7:00000013 r6:c004f4d8 r5:c006a208 r4:c785de94
[ 2700.100000] rcS           S c0285d80     0    27      1 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c004f268>] (do_wait+0x1a4/0x20c)
[ 2700.100000] [<c004f0c4>] (do_wait+0x0/0x20c) from [<c004f378>] (sys_wait4+0xa8/0xc0)
[ 2700.100000] [<c004f2d0>] (sys_wait4+0x0/0xc0) from [<c0033e80>] (ret_fast_syscall+0x0/0x38)
[ 2700.100000]  r8:c0034088 r7:00000072 r6:ffffffff r5:bee7880c r4:00000000
[ 2700.100000] run-parts     S c0285d80     0    35     27 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c02858c8>] (schedule+0x0/0x534) from [<c004f268>] (do_wait+0x1a4/0x20c)
[ 2700.100000] [<c004f0c4>] (do_wait+0x0/0x20c) from [<c004f378>] (sys_wait4+0xa8/0xc0)
[ 2700.100000] [<c004f2d0>] (sys_wait4+0x0/0xc0) from [<c0033e80>] (ret_fast_syscall+0x0/0x38)
[ 2700.100000]  r8:c0034088 r7:00000072 r6:00000024 r5:bef7dcc4 r4:00000000
[ 2700.100000] S00splashutil R running      0    36     35 0x00000000
[ 2700.100000] Backtrace: 
[ 2700.100000] [<c0037b54>] (dump_backtrace+0x0/0x110) from [<c0037c80>] (show_stack+0x1c/0x20)
[ 2700.100000]  r7:c79cfd64 r6:00000000 r5:c7954600 r4:00000000
[ 2700.100000] [<c0037c64>] (show_stack+0x0/0x20) from [<c0046b78>] (sched_show_task+0xb0/0xcc)
[ 2700.100000] [<c0046ac8>] (sched_show_task+0x0/0xcc) from [<c0046bf0>] (show_state_filter+0x5c/0xc8)
[ 2700.100000]  r5:c7954600 r4:c7954600
[ 2700.100000] [<c0046b94>] (show_state_filter+0x0/0xc8) from [<c01c5c40>] (sysrq_handle_showstate+0x18/0x1c)
[ 2700.100000]  r8:20000093 r7:00000007 r6:00000001 r5:00000074 r4:c036ec5c
[ 2700.100000] [<c01c5c28>] (sysrq_handle_showstate+0x0/0x1c) from [<c01c6040>] (__handle_sysrq+0xe0/0x190)
[ 2700.100000] [<c01c5f60>] (__handle_sysrq+0x0/0x190) from [<c01c62d8>] (handle_sysrq+0x38/0x44)
[ 2700.100000]  r8:c7999000 r7:00000100 r6:c7973640 r5:00010074 r4:c7864300
[ 2700.100000] [<c01c62a0>] (handle_sysrq+0x0/0x44) from [<c01da100>] (pl011_int+0x18c/0x5a4)
[ 2700.100000] [<c01d9f74>] (pl011_int+0x0/0x5a4) from [<c008b8b0>] (handle_IRQ_event+0x7c/0x1a8)
[ 2700.100000] [<c008b834>] (handle_IRQ_event+0x0/0x1a8) from [<c008de5c>] (handle_level_irq+0xc8/0x148)
[ 2700.100000] [<c008dd94>] (handle_level_irq+0x0/0x148) from [<c002d080>] (asm_do_IRQ+0x80/0xa4)
[ 2700.100000]  r7:c74a05a4 r6:c74a0508 r5:00000000 r4:0000002f
[ 2700.100000] [<c002d000>] (asm_do_IRQ+0x0/0xa4) from [<c0033ab8>] (__irq_svc+0x38/0x80)
[ 2700.100000] Exception stack(0xc79cfe88 to 0xc79cfed0)
[ 2700.100000] fe80:                   c74a0508 00000000 c0145d24 c7487e60 00000000 c79cfee8
[ 2700.100000] fea0: c74a0508 c74a05a4 c7487e60 c79cfee8 c74a0508 c79cff4c c79ce000 c79cfed0
[ 2700.100000] fec0: c016ff10 c014601c 60000013 ffffffff
[ 2700.100000]  r5:f5000000 r4:ffffffff
[ 2700.100000] [<c0145f0c>] (nfs_readdir+0x0/0x458) from [<c00fa298>] (vfs_readdir+0x7c/0xb0)
[ 2700.100000] [<c00fa21c>] (vfs_readdir+0x0/0xb0) from [<c00fa3fc>] (sys_getdents+0x70/0xb8)
[ 2700.100000] [<c00fa38c>] (sys_getdents+0x0/0xb8) from [<c0033e80>] (ret_fast_syscall+0x0/0x38)
[ 2700.100000]  r7:0000008d r6:00000000 r5:402ed00c r4:402ed020
[ 2700.100000] Sched Debug Version: v0.09, 2.6.37-rc8-00065-g1cd48e3-dirty #35
[ 2700.100000] now at 2701202.749966 msecs
[ 2700.100000]   .jiffies                                 : 240010
[ 2700.100000]   .sysctl_sched_latency                    : 6.000000
[ 2700.100000]   .sysctl_sched_min_granularity            : 0.750000
[ 2700.100000]   .sysctl_sched_wakeup_granularity         : 1.000000
[ 2700.100000]   .sysctl_sched_child_runs_first           : 0
[ 2700.100000]   .sysctl_sched_features                   : 31855
[ 2700.100000]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[ 2700.100000] 
[ 2700.100000] cpu#0
[ 2700.100000]   .nr_running                    : 1
[ 2700.100000]   .load                          : 1024
[ 2700.100000]   .nr_switches                   : 11875
[ 2700.100000]   .nr_load_updates               : 269696
[ 2700.100000]   .nr_uninterruptible            : 0
[ 2700.100000]   .next_balance                  : 0.000000
[ 2700.100000]   .curr->pid                     : 36
[ 2700.100000]   .clock                         : 2700100.000000
[ 2700.100000]   .cpu_load[0]                   : 1024
[ 2700.100000]   .cpu_load[1]                   : 1024
[ 2700.100000]   .cpu_load[2]                   : 1024
[ 2700.100000]   .cpu_load[3]                   : 1024
[ 2700.100000]   .cpu_load[4]                   : 1024
[ 2700.100000] 
[ 2700.100000] cfs_rq[0]:
[ 2700.100000]   .exec_clock                    : 0.000000
[ 2700.100000]   .MIN_vruntime                  : 0.000001
[ 2700.100000]   .min_vruntime                  : 2695651.938408
[ 2700.100000]   .max_vruntime                  : 0.000001
[ 2700.100000]   .spread                        : 0.000000
[ 2700.100000]   .spread0                       : 0.000000
[ 2700.100000]   .nr_running                    : 1
[ 2700.100000]   .load                          : 1024
[ 2700.100000]   .nr_spread_over                : 0
[ 2700.100000] 
[ 2700.100000] rt_rq[0]:
[ 2700.100000]   .rt_nr_running                 : 0
[ 2700.100000]   .rt_throttled                  : 0
[ 2700.100000]   .rt_time                       : 0.000000
[ 2700.100000]   .rt_runtime                    : 950.000000
[ 2700.100000] 
[ 2700.100000] runnable tasks:
[ 2700.100000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2700.100000] ----------------------------------------------------------------------------------------------------------
[ 2700.100000] R S00splashutils    36   2695651.938408      5397   120               0               0               0.000000               0.000000               0.000000
[ 2700.100000] 
[ 2700.100000] 
[ 2700.100000] Showing all locks held in the system:
[ 2700.100000] 4 locks held by S00splashutils/36:
[ 2700.100000]  #0:  (&sb->s_type->i_mutex_key#8){+.+.+.}, at: [<c00fa268>] vfs_readdir+0x4c/0xb0
[ 2700.100000]  #1:  (&port_lock_key){-.-...}, at: [<c01d9f94>] pl011_int+0x20/0x5a4
[ 2700.100000]  #2:  (sysrq_key_table_lock){-.....}, at: [<c01c5f84>] __handle_sysrq+0x24/0x190
[ 2700.100000]  #3:  (tasklist_lock){.?.+..}, at: [<c007c404>] debug_show_all_locks+0x40/0x1a4
[ 2700.100000] 
[ 2700.100000] =============================================
[ 2700.100000] 


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
