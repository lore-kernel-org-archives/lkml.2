Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab1BANwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:52:02 -0500
Received: from www.tglx.de ([62.245.132.106]:47222 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108Ab1BANv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:58 -0500
Message-Id: <20110201134418.422446502@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 10/28] posix-cpu-timers: Remove the stub nanosleep functions
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-cpu-timers-use-default-nsleep-notsup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLOCK_THREAD_CPUTIME_ID implements stub functions for nanosleep and
nanosleep_restart, which return -EINVAL. That return value is
wrong. The correct return value is -ENOTSUP.

Remove the stubs and let the new dispatch code return the correct
error code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-cpu-timers.c |   11 -----------
 1 file changed, 11 deletions(-)

Index: linux-2.6-tip/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-cpu-timers.c
+++ linux-2.6-tip/kernel/posix-cpu-timers.c
@@ -1586,15 +1586,6 @@ static int thread_cpu_timer_create(struc
 	timer->it_clock = THREAD_CLOCK;
 	return posix_cpu_timer_create(timer);
 }
-static int thread_cpu_nsleep(const clockid_t which_clock, int flags,
-			      struct timespec *rqtp, struct timespec __user *rmtp)
-{
-	return -EINVAL;
-}
-static long thread_cpu_nsleep_restart(struct restart_block *restart_block)
-{
-	return -EINVAL;
-}
 
 struct k_clock clock_posix_cpu = {
 	.clock_getres	= posix_cpu_clock_getres,
@@ -1623,8 +1614,6 @@ static __init int init_posix_cpu_timers(
 		.clock_get	= thread_cpu_clock_get,
 		.clock_set	= do_posix_clock_nosettime,
 		.timer_create	= thread_cpu_timer_create,
-		.nsleep		= thread_cpu_nsleep,
-		.nsleep_restart	= thread_cpu_nsleep_restart,
 	};
 	struct timespec ts;
 


