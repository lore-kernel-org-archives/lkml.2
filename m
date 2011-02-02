Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1BBWDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:03:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:50096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826Ab1BBWDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:03:46 -0500
Date: Wed, 2 Feb 2011 22:03:28 GMT
From: tip-bot for Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, richardcochran@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, richardcochran@gmail.com, tglx@linutronix.de
In-Reply-To: <20110201134419.487708516@linutronix.de>
References: <20110201134419.487708516@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timer: Update comment
Message-ID: <tip-0061748dd2400d0bcd4d49d258db5d7b5d106ca0@git.kernel.org>
Git-Commit-ID: 0061748dd2400d0bcd4d49d258db5d7b5d106ca0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:03:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0061748dd2400d0bcd4d49d258db5d7b5d106ca0
Gitweb:     http://git.kernel.org/tip/0061748dd2400d0bcd4d49d258db5d7b5d106ca0
Author:     Richard Cochran <richardcochran@gmail.com>
AuthorDate: Tue, 1 Feb 2011 13:52:15 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:18 +0100

posix-timer: Update comment

Pick the cleanup to the comment in posix-timers.c from Richards all in
one conversion patch.

Originally-from: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20110201134419.487708516@linutronix.de>
---
 kernel/posix-timers.c |   25 +++++++------------------
 1 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index ad154df..a3fdfd4 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
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
