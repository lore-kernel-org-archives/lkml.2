Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595Ab2JXJnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:43:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54814 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934499Ab2JXJnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:43:05 -0400
Date: Wed, 24 Oct 2012 02:41:46 -0700
From: tip-bot for Chuansheng Liu <chuansheng.liu@intel.com>
Message-ID: <tip-351f181f9134d71efd46ddf0c0abca31b58cd79b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, chuansheng.liu@intel.com
In-Reply-To: <1351098455.15558.1421.camel@cliu38-desktop-build>
References: <1351098455.15558.1421.camel@cliu38-desktop-build>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timers, sched:
  Correct the comments for tick_sched_timer()
Git-Commit-ID: 351f181f9134d71efd46ddf0c0abca31b58cd79b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:41:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  351f181f9134d71efd46ddf0c0abca31b58cd79b
Gitweb:     http://git.kernel.org/tip/351f181f9134d71efd46ddf0c0abca31b58cd79b
Author:     Chuansheng Liu <chuansheng.liu@intel.com>
AuthorDate: Thu, 25 Oct 2012 01:07:35 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:16:51 +0200

timers, sched: Correct the comments for tick_sched_timer()

In the comments of function tick_sched_timer(), the sentence
"timer->base->cpu_base->lock held" is not right.

In function __run_hrtimer(), before call timer->function(),
the cpu_base->lock has been unlocked.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Cc: fei.li@intel.com
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1351098455.15558.1421.camel@cliu38-desktop-build
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a402608..2bc73d3 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -794,7 +794,7 @@ void tick_check_idle(int cpu)
 #ifdef CONFIG_HIGH_RES_TIMERS
 /*
  * We rearm the timer until we get disabled by the idle code.
- * Called with interrupts disabled and timer->base->cpu_base->lock held.
+ * Called with interrupts disabled.
  */
 static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 {
