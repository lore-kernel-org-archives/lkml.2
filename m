Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab2IDSpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:45:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47813 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab2IDSpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:45:08 -0400
Date: Tue, 4 Sep 2012 11:44:49 -0700
From: tip-bot for Charles Wang <muming.wq@taobao.com>
Message-ID: <tip-749c8814f08f12baa4a9c2812a7c6ede7d69507d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        muming.wq@taobao.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        muming.wq@taobao.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1345449754-27130-1-git-send-email-muming.wq@gmail.com>
References: <1345449754-27130-1-git-send-email-muming.wq@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add missing call to calc_load_exit_idle()
Git-Commit-ID: 749c8814f08f12baa4a9c2812a7c6ede7d69507d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 04 Sep 2012 11:44:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  749c8814f08f12baa4a9c2812a7c6ede7d69507d
Gitweb:     http://git.kernel.org/tip/749c8814f08f12baa4a9c2812a7c6ede7d69507d
Author:     Charles Wang <muming.wq@taobao.com>
AuthorDate: Mon, 20 Aug 2012 16:02:33 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Sep 2012 14:30:29 +0200

sched: Add missing call to calc_load_exit_idle()

Azat Khuzhin reported high loadavg in Linux v3.6

After checking the upstream scheduler code, I found Peter's commit:

  5167e8d5417b sched/nohz: Rewrite and fix load-avg computation -- again

not fully applied, missing the call to calc_load_exit_idle().

After that idle exit in sampling window will always be calculated
to non-idle, and the load will be higher than normal.

This patch adds the missing call to calc_load_exit_idle().

Signed-off-by: Charles Wang <muming.wq@taobao.com>
Cc: stable@kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345449754-27130-1-git-send-email-muming.wq@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/time/tick-sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 024540f..3a9e5d5 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -573,6 +573,7 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	tick_do_update_jiffies64(now);
 	update_cpu_load_nohz();
 
+	calc_load_exit_idle();
 	touch_softlockup_watchdog();
 	/*
 	 * Cancel the scheduled timer and restore the tick
