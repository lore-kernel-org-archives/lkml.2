Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1BBWCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:02:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:50057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999Ab1BBWCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:02:50 -0500
Date: Wed, 2 Feb 2011 22:02:38 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134419.294620613@linutronix.de>
References: <20110201134419.294620613@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Remove CLOCK_DISPATCH leftovers
Message-ID: <tip-0aa3975f02ce78f27be3076fbfa3d94ae5a659d5@git.kernel.org>
Git-Commit-ID: 0aa3975f02ce78f27be3076fbfa3d94ae5a659d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:02:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0aa3975f02ce78f27be3076fbfa3d94ae5a659d5
Gitweb:     http://git.kernel.org/tip/0aa3975f02ce78f27be3076fbfa3d94ae5a659d5
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:52:09 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:17 +0100

posix-timers: Remove CLOCK_DISPATCH leftovers

All users gone. Remove the cruft.

Huge thanks to Richard Cochran who tackled that maze first.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134419.294620613@linutronix.de>
---
 kernel/posix-timers.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index ade7dec..ad154df 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -167,28 +167,6 @@ static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
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
