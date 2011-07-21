Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1GUStx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:49:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65394 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1GUStv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:49:51 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] nohz: Drop useless call in tick_nohz_start_idle()
Date: Thu, 21 Jul 2011 20:49:36 +0200
Message-Id: <1311274177-23891-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to update_ts_time_stats() there is useless. All
we need is to save the idle entry_time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/time/tick-sched.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..58e1a96 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -185,9 +185,6 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 	ktime_t now;
 
 	now = ktime_get();
-
-	update_ts_time_stats(cpu, ts, now, NULL);
-
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
 	sched_clock_idle_sleep_event();
-- 
1.7.5.4

