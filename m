Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1BBVz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:55:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:32771 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab1BBVz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:55:57 -0500
Date: Wed, 2 Feb 2011 21:55:18 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134417.643486574@linutronix.de>
References: <20110201134417.643486574@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Define nanosleep not supported error separate
Message-ID: <tip-65da528d7cc94966cf24d2a1e0837b689159b543@git.kernel.org>
Git-Commit-ID: 65da528d7cc94966cf24d2a1e0837b689159b543
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:55:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65da528d7cc94966cf24d2a1e0837b689159b543
Gitweb:     http://git.kernel.org/tip/65da528d7cc94966cf24d2a1e0837b689159b543
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:01 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:11 +0100

posix-timers: Define nanosleep not supported error separate

Define the conditional nanosleep not supported error value outside of
do_posix_clock_nonanosleep(). Preparatory patch for further cleanups. 

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134417.643486574@linutronix.de>
---
 kernel/posix-timers.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 21b7ca2..89bff37 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
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
@@ -937,11 +945,7 @@ EXPORT_SYMBOL_GPL(do_posix_clock_nosettime);
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
 
