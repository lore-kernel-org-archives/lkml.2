Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2JOQ73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:59:29 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58620 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2JOQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:59:25 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/3] tick: Conditionally build nohz specific code in tick handler
Date: Mon, 15 Oct 2012 18:59:14 +0200
Message-Id: <1350320354-17214-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350320354-17214-1-git-send-email-fweisbec@gmail.com>
References: <1350320354-17214-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This optimize a bit the high res tick sched handler.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/time/tick-sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 68a873a..766d4c4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -122,6 +122,7 @@ static void tick_sched_do_timer(ktime_t now)
 
 static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 {
+#ifdef CONFIG_NO_HZ
 	/*
 	 * When we are idle and the tick is stopped, we have to touch
 	 * the watchdog as we might not schedule for a really long
@@ -135,6 +136,7 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 		if (is_idle_task(current))
 			ts->idle_jiffies++;
 	}
+#endif
 	update_process_times(user_mode(regs));
 	profile_tick(CPU_PROFILING);
 }
-- 
1.7.5.4

