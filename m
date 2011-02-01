Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab1BANvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:51:16 -0500
Received: from www.tglx.de ([62.245.132.106]:47089 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909Ab1BANvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:15 -0500
Message-Id: <20110201134417.643486574@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 02/28] posix-timers: Define nanosleep not supported error
	separate
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline;
	filename=posix-clocks-splitout-nanosleep-notsup-error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the conditional nanosleep not supported error value outside of
do_posix_clock_nonanosleep(). Preparatory patch for further cleanups. 

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-timers.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -81,6 +81,14 @@ static DEFINE_SPINLOCK(idr_lock);
 #error "SIGEV_THREAD_ID must not share bit with other SIGEV values!"
 #endif
 
+/*
+ * parisc wants ENOTSUP instead of EOPNOTSUPP
+ */
+#ifndef ENOTSUP
+# define ENANOSLEEP_NOTSUP EOPNOTSUPP
+#else
+# define ENANOSLEEP_NOTSUP ENOTSUP
+#endif
 
 /*
  * The timer ID is turned into a timer address by idr_find().
@@ -937,11 +945,7 @@ EXPORT_SYMBOL_GPL(do_posix_clock_nosetti
 int do_posix_clock_nonanosleep(const clockid_t clock, int flags,
 			       struct timespec *t, struct timespec __user *r)
 {
-#ifndef ENOTSUP
-	return -EOPNOTSUPP;	/* aka ENOTSUP in userland for POSIX */
-#else  /*  parisc does define it separately.  */
-	return -ENOTSUP;
-#endif
+	return -ENANOSLEEP_NOTSUP;
 }
 EXPORT_SYMBOL_GPL(do_posix_clock_nonanosleep);
 


