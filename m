Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1LAQAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:00:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab1LAQAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:00:43 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] nohz: Remove update_ts_time_stat from tick_nohz_start_idle
Date: Thu,  1 Dec 2011 17:00:22 +0100
Message-Id: <1322755222-6951-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to call update_ts_time_stat from tick_nohz_start_idle
anymore (after e0e37c20 sched: Eliminate the ts->idle_lastupdate field)
when we updated idle_lastupdate unconditionally.

We haven't set idle_active yet and do not provide last_update_time so
the whole call end up being just 2 wasted branches.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4042064..be3cab0 100644
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
1.7.7.3

