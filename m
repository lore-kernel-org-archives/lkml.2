Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab2BOTi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:38:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53078 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2BOTiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:38:51 -0500
Date: Wed, 15 Feb 2012 11:37:41 -0800
From: tip-bot for Michal Hocko <mhocko@suse.cz>
Message-ID: <tip-430ee8819553f66fe00e36f676a45886d76e7e8b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, tglx@linutronix.de, mhocko@suse.cz
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, tglx@linutronix.de, mhocko@suse.cz
In-Reply-To: <1322755222-6951-1-git-send-email-mhocko@suse.cz>
References: <1322755222-6951-1-git-send-email-mhocko@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] nohz:
  Remove update_ts_time_stat from tick_nohz_start_idle
Git-Commit-ID: 430ee8819553f66fe00e36f676a45886d76e7e8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 15 Feb 2012 11:38:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  430ee8819553f66fe00e36f676a45886d76e7e8b
Gitweb:     http://git.kernel.org/tip/430ee8819553f66fe00e36f676a45886d76e7e8b
Author:     Michal Hocko <mhocko@suse.cz>
AuthorDate: Thu, 1 Dec 2011 17:00:22 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 15 Feb 2012 15:23:09 +0100

nohz: Remove update_ts_time_stat from tick_nohz_start_idle

There is no reason to call update_ts_time_stat from tick_nohz_start_idle
anymore (after e0e37c20 sched: Eliminate the ts->idle_lastupdate field)
when we updated idle_lastupdate unconditionally.

We haven't set idle_active yet and do not provide last_update_time so
the whole call end up being just 2 wasted branches.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Link: http://lkml.kernel.org/r/1322755222-6951-1-git-send-email-mhocko@suse.cz
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7656642..8cfffd9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -182,11 +182,7 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 
 static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 {
-	ktime_t now;
-
-	now = ktime_get();
-
-	update_ts_time_stats(cpu, ts, now, NULL);
+	ktime_t now = ktime_get();
 
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
