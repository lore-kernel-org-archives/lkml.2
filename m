Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2JXIHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:07:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:14282 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412Ab2JXIHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:07:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,639,1344236400"; 
   d="scan'208";a="231520583"
Subject: sched: correct the comments for tick_sched_timer()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, fei.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Oct 2012 01:07:35 +0800
Message-ID: <1351098455.15558.1421.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the comments of function tick_sched_timer(), the sentence
"timer->base->cpu_base->lock held" is not right.

In function __run_hrtimer(), before call timer->function(),
the cpu_base->lock has been unlocked.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
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
-- 
1.7.0.4



