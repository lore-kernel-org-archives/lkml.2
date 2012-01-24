Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab2AXR77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:59:59 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40264 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2AXR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:59:58 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John Stultz <john.stultz@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] nohz: Remove update_ts_time_stat from tick_nohz_start_idle
Date: Tue, 24 Jan 2012 18:59:42 +0100
Message-Id: <1327427984-23282-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

There is no reason to call update_ts_time_stat from tick_nohz_start_idle
anymore (after e0e37c20 sched: Eliminate the ts->idle_lastupdate field)
when we updated idle_lastupdate unconditionally.

We haven't set idle_active yet and do not provide last_update_time so
the whole call end up being just 2 wasted branches.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7656642..85a67e8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -186,8 +186,6 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 
 	now = ktime_get();
 
-	update_ts_time_stats(cpu, ts, now, NULL);
-
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
 	sched_clock_idle_sleep_event();
-- 
1.7.5.4

