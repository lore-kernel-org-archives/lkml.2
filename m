Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0CSDTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 23:19:32 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44542 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab0CSDTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:19:31 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] ntp: Remove tickadj
Date: Thu, 18 Mar 2010 20:19:28 -0700
Message-Id: <1268968769-19209-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1268968769-19209-1-git-send-email-johnstul@us.ibm.com>
References: <1268968769-19209-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are zero users of tickadj. So remove it.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 include/linux/timex.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index e2de51e..32d852f 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -232,7 +232,6 @@ struct timex {
  */
 extern unsigned long tick_usec;		/* USER_HZ period (usec) */
 extern unsigned long tick_nsec;		/* ACTHZ          period (nsec) */
-extern int tickadj;			/* amount of adjustment per tick */
 
 /*
  * phase-lock loop variables
@@ -270,9 +269,6 @@ extern void second_overflow(void);
 extern void update_ntp_one_tick(void);
 extern int do_adjtimex(struct timex *);
 
-/* Don't use! Compatibility define for existing users. */
-#define tickadj	(500/HZ ? : 1)
-
 int read_current_timer(unsigned long *timer_val);
 
 /* The clock frequency of the i8253/i8254 PIT */
-- 
1.6.0.4

