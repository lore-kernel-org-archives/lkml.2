Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab1BANvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:51:22 -0500
Received: from www.tglx.de ([62.245.132.106]:47100 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910Ab1BANvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:20 -0500
Message-Id: <20110201134417.745627057@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 03/28] posix-timers: Cleanup struct initializers
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-timers-cleanup-struct-initializers-codingstyle.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic. No functional change

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 drivers/char/mmtimer.c    |   14 +++++++-------
 kernel/posix-cpu-timers.c |   24 ++++++++++++------------
 kernel/posix-timers.c     |   38 +++++++++++++++++++-------------------
 3 files changed, 38 insertions(+), 38 deletions(-)

Index: linux-2.6-tip/drivers/char/mmtimer.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/mmtimer.c
+++ linux-2.6-tip/drivers/char/mmtimer.c
@@ -765,13 +765,13 @@ static int sgi_timer_set(struct k_itimer
 
 static struct k_clock sgi_clock = {
 	.res = 0,
-	.clock_set = sgi_clock_set,
-	.clock_get = sgi_clock_get,
-	.timer_create = sgi_timer_create,
-	.nsleep = do_posix_clock_nonanosleep,
-	.timer_set = sgi_timer_set,
-	.timer_del = sgi_timer_del,
-	.timer_get = sgi_timer_get
+	.clock_set	= sgi_clock_set,
+	.clock_get	= sgi_clock_get,
+	.timer_create	= sgi_timer_create,
+	.nsleep		= do_posix_clock_nonanosleep,
+	.timer_set	= sgi_timer_set,
+	.timer_del	= sgi_timer_del,
+	.timer_get	= sgi_timer_get
 };
 
 /**
Index: linux-2.6-tip/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-cpu-timers.c
+++ linux-2.6-tip/kernel/posix-cpu-timers.c
@@ -1607,20 +1607,20 @@ static long thread_cpu_nsleep_restart(st
 static __init int init_posix_cpu_timers(void)
 {
 	struct k_clock process = {
-		.clock_getres = process_cpu_clock_getres,
-		.clock_get = process_cpu_clock_get,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = process_cpu_timer_create,
-		.nsleep = process_cpu_nsleep,
-		.nsleep_restart = process_cpu_nsleep_restart,
+		.clock_getres	= process_cpu_clock_getres,
+		.clock_get	= process_cpu_clock_get,
+		.clock_set	= do_posix_clock_nosettime,
+		.timer_create	= process_cpu_timer_create,
+		.nsleep		= process_cpu_nsleep,
+		.nsleep_restart	= process_cpu_nsleep_restart,
 	};
 	struct k_clock thread = {
-		.clock_getres = thread_cpu_clock_getres,
-		.clock_get = thread_cpu_clock_get,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = thread_cpu_timer_create,
-		.nsleep = thread_cpu_nsleep,
-		.nsleep_restart = thread_cpu_nsleep_restart,
+		.clock_getres	= thread_cpu_clock_getres,
+		.clock_get	= thread_cpu_clock_get,
+		.clock_set	= do_posix_clock_nosettime,
+		.timer_create	= thread_cpu_timer_create,
+		.nsleep		= thread_cpu_nsleep,
+		.nsleep_restart	= thread_cpu_nsleep_restart,
 	};
 	struct timespec ts;
 
Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -281,33 +281,33 @@ static int posix_get_coarse_res(const cl
 static __init int init_posix_timers(void)
 {
 	struct k_clock clock_realtime = {
-		.clock_getres = hrtimer_get_res,
+		.clock_getres	= hrtimer_get_res,
 	};
 	struct k_clock clock_monotonic = {
-		.clock_getres = hrtimer_get_res,
-		.clock_get = posix_ktime_get_ts,
-		.clock_set = do_posix_clock_nosettime,
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_ktime_get_ts,
+		.clock_set	= do_posix_clock_nosettime,
 	};
 	struct k_clock clock_monotonic_raw = {
-		.clock_getres = hrtimer_get_res,
-		.clock_get = posix_get_monotonic_raw,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = no_timer_create,
-		.nsleep = no_nsleep,
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_get_monotonic_raw,
+		.clock_set	= do_posix_clock_nosettime,
+		.timer_create	= no_timer_create,
+		.nsleep		= no_nsleep,
 	};
 	struct k_clock clock_realtime_coarse = {
-		.clock_getres = posix_get_coarse_res,
-		.clock_get = posix_get_realtime_coarse,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = no_timer_create,
-		.nsleep = no_nsleep,
+		.clock_getres	= posix_get_coarse_res,
+		.clock_get	= posix_get_realtime_coarse,
+		.clock_set	= do_posix_clock_nosettime,
+		.timer_create	= no_timer_create,
+		.nsleep		= no_nsleep,
 	};
 	struct k_clock clock_monotonic_coarse = {
-		.clock_getres = posix_get_coarse_res,
-		.clock_get = posix_get_monotonic_coarse,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = no_timer_create,
-		.nsleep = no_nsleep,
+		.clock_getres	= posix_get_coarse_res,
+		.clock_get	= posix_get_monotonic_coarse,
+		.clock_set	= do_posix_clock_nosettime,
+		.timer_create	= no_timer_create,
+		.nsleep		= no_nsleep,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);


