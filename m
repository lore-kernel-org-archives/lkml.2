Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762347Ab2KAVio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:38:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759632Ab2KAVim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:38:42 -0400
Date: Thu, 1 Nov 2012 14:38:17 -0700
From: tip-bot for Chuansheng Liu <chuansheng.liu@intel.com>
Message-ID: <tip-b8f61116c1ce342804a0897b0a80eb4df5f19453@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, chuansheng.liu@intel.com
In-Reply-To: <1351098455.15558.1421.camel@cliu38-desktop-build>
References: <1351098455.15558.1421.camel@cliu38-desktop-build>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick: Correct the comments for tick_sched_timer(
 )
Git-Commit-ID: b8f61116c1ce342804a0897b0a80eb4df5f19453
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Nov 2012 14:38:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8f61116c1ce342804a0897b0a80eb4df5f19453
Gitweb:     http://git.kernel.org/tip/b8f61116c1ce342804a0897b0a80eb4df5f19453
Author:     Chuansheng Liu <chuansheng.liu@intel.com>
AuthorDate: Thu, 25 Oct 2012 01:07:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 1 Nov 2012 12:13:59 +0100

tick: Correct the comments for tick_sched_timer()

In the comments of function tick_sched_timer(), the sentence
"timer->base->cpu_base->lock held" is not right.

In function __run_hrtimer(), before call timer->function(),
the cpu_base->lock has been unlocked.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Cc: fei.li@intel.com
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1351098455.15558.1421.camel@cliu38-desktop-build
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 766d4c4..77729cc 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -809,7 +809,7 @@ void tick_check_idle(int cpu)
 #ifdef CONFIG_HIGH_RES_TIMERS
 /*
  * We rearm the timer until we get disabled by the idle code.
- * Called with interrupts disabled and timer->base->cpu_base->lock held.
+ * Called with interrupts disabled.
  */
 static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 {
