Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1LRQ1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 11:27:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab1LRQ1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 11:27:21 -0500
Date: Sun, 18 Dec 2011 17:27:15 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH resend] nohz: Remove update_ts_time_stat from
 tick_nohz_start_idle
Message-ID: <20111218162715.GA25717@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to call update_ts_time_stat from tick_nohz_start_idle
anymore (after e0e37c20 sched: Eliminate the ts->idle_lastupdate field)
when we updated idle_lastupdate unconditionally.

We haven't set idle_active yet and do not provide last_update_time so
the whole call end up being just 2 wasted branches.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
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
