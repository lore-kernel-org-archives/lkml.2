Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2KDNC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:02:59 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49060 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2KDNAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:00:05 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 02/13] HW-latency: Fix a lockdep warnning
Date: Sun,  4 Nov 2012 20:59:33 -0500
Message-Id: <1352080784-30839-3-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  150.733088] in_atomic(): 1, irqs_disabled(): 1, pid: 19, name: migration/2
[  150.735456] INFO: lockdep is turned off.
[  150.738903] irq event stamp: 28
[  150.741255] hardirqs last  enabled at (27): [<ffffffff816e6a80>] _raw_spin_unlock_irq+0x30/0x50
[  150.744884] hardirqs last disabled at (28): [<ffffffff816e616f>] _raw_spin_lock_irq+0x1f/0x90
[  150.748505] softirqs last  enabled at (24): [<ffffffff810724a7>] __do_softirq+0x167/0x3d0
[  150.752121] softirqs last disabled at (19): [<ffffffff816f143c>] call_softirq+0x1c/0x30
[  150.755709] Pid: 19, comm: migration/2 Tainted: G        W    3.7.0-rc2+ #2
[  150.759361] Call Trace:
[  150.762952]  [<ffffffff810d53e0>] ? print_irqtrace_events+0xd0/0xe0
[  150.766610]  [<ffffffff810a3b4c>] __might_sleep+0x18c/0x250
[  150.769140]  [<ffffffff816e2ab0>] mutex_lock_nested+0x40/0x390
[  150.772765]  [<ffffffff810d853d>] ? trace_hardirqs_on+0xd/0x10
[  150.776392]  [<ffffffff816e6a80>] ? _raw_spin_unlock_irq+0x30/0x50
[  150.778899]  [<ffffffff81021829>] ? read_tsc+0x9/0x20
[  150.782546]  [<ffffffffa05877e3>] get_freq_sample+0x33/0xd0 [hw_latency_test]
[  150.786249]  [<ffffffff810fac9b>] stop_machine_cpu_stop+0xab/0x110
[  150.789964]  [<ffffffff810fadd6>] cpu_stopper_thread+0xd6/0x1b0
[  150.792528]  [<ffffffff810fabf0>] ? cpu_stop_queue_work+0x80/0x80
[  150.795044]  [<ffffffff8115798e>] ? perf_event_alloc+0x5e/0x4a0
[  150.797572]  [<ffffffff816e4672>] ? __schedule+0x442/0xa00
[  150.800079]  [<ffffffff810fad00>] ? stop_machine_cpu_stop+0x110/0x110
[  150.802512]  [<ffffffff810938fd>] kthread+0xed/0x100
[  150.805825]  [<ffffffff81093810>] ? flush_kthread_worker+0x190/0x190
[  150.808051]  [<ffffffff816f00ec>] ret_from_fork+0x7c/0xb0
[  150.810161]  [<ffffffff81093810>] ? flush_kthread_worker+0x190/0x190

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 drivers/misc/hw_latency_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
index 2aa3a74..e970642 100644
--- a/drivers/misc/hw_latency_test.c
+++ b/drivers/misc/hw_latency_test.c
@@ -149,7 +149,7 @@ static int get_random_bytes_sample(void *unused)
 	u64	sample = 0;
 	int	ret = 1;
 
-	buffer = kzalloc(1024, GFP_KERNEL);
+	buffer = kzalloc(1024, GFP_ATOMIC);
 
 	start = ktime_get();
 	do {
-- 
1.7.12.1

