Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab0CWQWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:22:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:53099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066Ab0CWQWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:22:13 -0400
Date: Tue, 23 Mar 2010 16:21:54 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1268968769-19209-2-git-send-email-johnstul@us.ibm.com>
References: <1268968769-19209-2-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ntp: Remove tickadj
Message-ID: <tip-3d0205bd1383aa3cac93c209b7c7d03b27930195@git.kernel.org>
Git-Commit-ID: 3d0205bd1383aa3cac93c209b7c7d03b27930195
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Mar 2010 16:21:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d0205bd1383aa3cac93c209b7c7d03b27930195
Gitweb:     http://git.kernel.org/tip/3d0205bd1383aa3cac93c209b7c7d03b27930195
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Thu, 18 Mar 2010 20:19:28 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 23 Mar 2010 17:19:38 +0100

ntp: Remove tickadj

There are zero users of tickadj. So remove it.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1268968769-19209-2-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
