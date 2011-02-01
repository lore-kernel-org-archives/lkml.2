Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1BANxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:53:01 -0500
Received: from www.tglx.de ([62.245.132.106]:47432 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236Ab1BANw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:52:58 -0500
Message-Id: <20110201134419.487708516@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:52:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 21/28] posix-timer: Update comment
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=posix-timer-update-comment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

Pick the cleanup to the comment in posix-timers.c from Richards all in
one conversion patch.

Originally-from: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
---
 kernel/posix-timers.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -102,11 +102,7 @@ static DEFINE_SPINLOCK(idr_lock);
 /*
  * CLOCKs: The POSIX standard calls for a couple of clocks and allows us
  *	    to implement others.  This structure defines the various
- *	    clocks and allows the possibility of adding others.	 We
- *	    provide an interface to add clocks to the table and expect
- *	    the "arch" code to add at least one clock that is high
- *	    resolution.	 Here we define the standard CLOCK_REALTIME as a
- *	    1/HZ resolution clock.
+ *	    clocks.
  *
  * RESOLUTION: Clock resolution is used to round up timer and interval
  *	    times, NOT to report clock times, which are reported with as
@@ -116,20 +112,13 @@ static DEFINE_SPINLOCK(idr_lock);
  *	    necessary code is written.	The standard says we should say
  *	    something about this issue in the documentation...
  *
- * FUNCTIONS: The CLOCKs structure defines possible functions to handle
- *	    various clock functions.  For clocks that use the standard
- *	    system timer code these entries should be NULL.  This will
- *	    allow dispatch without the overhead of indirect function
- *	    calls.  CLOCKS that depend on other sources (e.g. WWV or GPS)
- *	    must supply functions here, even if the function just returns
- *	    ENOSYS.  The standard POSIX timer management code assumes the
- *	    following: 1.) The k_itimer struct (sched.h) is used for the
- *	    timer.  2.) The list, it_lock, it_clock, it_id and it_pid
- *	    fields are not modified by timer code.
+ * FUNCTIONS: The CLOCKs structure defines possible functions to
+ *	    handle various clock functions.
  *
- *          At this time all functions EXCEPT clock_nanosleep can be
- *          redirected by the CLOCKS structure.  Clock_nanosleep is in
- *          there, but the code ignores it.
+ *	    The standard POSIX timer management code assumes the
+ *	    following: 1.) The k_itimer struct (sched.h) is used for
+ *	    the timer.  2.) The list, it_lock, it_clock, it_id and
+ *	    it_pid fields are not modified by timer code.
  *
  * Permissions: It is assumed that the clock_settime() function defined
  *	    for each clock will take care of permission checks.	 Some


