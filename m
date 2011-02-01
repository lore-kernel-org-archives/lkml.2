Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1BANwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:30 -0500
Received: from www.tglx.de ([62.245.132.106]:47340 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab1BANw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:26 -0500
Message-Id: <20110201134419.294620613@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 19/28] posix-timers: Remove CLOCK_DISPATCH leftovers
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-timers-remove-clock-dispatch-leftovers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users gone. Remove the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-timers.c |   22 ----------------------
 1 file changed, 22 deletions(-)

Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -167,28 +167,6 @@ static inline void unlock_timer(struct k
 	spin_unlock_irqrestore(&timr->it_lock, flags);
 }
 
-/*
- * Call the k_clock hook function if non-null, or the default function.
- */
-#define CLOCK_DISPATCH(clock, call, arglist) \
- 	((clock) < 0 ? posix_cpu_##call arglist : \
- 	 (posix_clocks[clock].call != NULL \
- 	  ? (*posix_clocks[clock].call) arglist : common_##call arglist))
-
-/*
- * Return nonzero if we know a priori this clockid_t value is bogus.
- */
-static inline int invalid_clockid(const clockid_t which_clock)
-{
-	if (which_clock < 0)	/* CPU clock, posix_cpu_* will check it */
-		return 0;
-	if ((unsigned) which_clock >= MAX_CLOCKS)
-		return 1;
-	if (posix_clocks[which_clock].clock_getres != NULL)
-		return 0;
-	return 1;
-}
-
 /* Get clock_realtime */
 static int posix_clock_realtime_get(clockid_t which_clock, struct timespec *tp)
 {


