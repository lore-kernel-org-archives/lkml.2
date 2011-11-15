Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1KOEHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:07:32 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58209 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab1KOEEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:23 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 07/16] ntp: Cleanup timex.h
Date: Mon, 14 Nov 2011 20:03:57 -0800
Message-Id: <1321329846-14755-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-6078-0000-0000-000004657EEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ntp_sycned to ntp.c and mark time_status as static.
Also yank function declaration for non-existant function.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timex.h |   15 ---------------
 kernel/time/ntp.c     |   13 ++++++++++++-
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index aa60fe7..92e01fc 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -234,23 +234,9 @@ struct timex {
 extern unsigned long tick_usec;		/* USER_HZ period (usec) */
 extern unsigned long tick_nsec;		/* ACTHZ          period (nsec) */
 
-/*
- * phase-lock loop variables
- */
-extern int time_status;		/* clock synchronization status bits */
-
 extern void ntp_init(void);
 extern void ntp_clear(void);
 
-/**
- * ntp_synced - Returns 1 if the NTP status is not UNSYNC
- *
- */
-static inline int ntp_synced(void)
-{
-	return !(time_status & STA_UNSYNC);
-}
-
 /* Required to safely shift negative values */
 #define shift_right(x, s) ({	\
 	__typeof__(x) __x = (x);	\
@@ -267,7 +253,6 @@ static inline int ntp_synced(void)
 extern u64 tick_length;
 
 extern void second_overflow(void);
-extern void update_ntp_one_tick(void);
 extern int do_adjtimex(struct timex *);
 extern void hardpps(const struct timespec *, const struct timespec *);
 
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f6117a4..ae7e136 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -49,7 +49,7 @@ static struct hrtimer		leap_timer;
 static int			time_state = TIME_OK;
 
 /* clock status bits:							*/
-int				time_status = STA_UNSYNC;
+static int			time_status = STA_UNSYNC;
 
 /* TAI offset (secs):							*/
 static long			time_tai;
@@ -233,6 +233,17 @@ static inline void pps_fill_timex(struct timex *txc)
 
 #endif /* CONFIG_NTP_PPS */
 
+
+/**
+ * ntp_synced - Returns 1 if the NTP status is not UNSYNC
+ *
+ */
+static inline int ntp_synced(void)
+{
+	return !(time_status & STA_UNSYNC);
+}
+
+
 /*
  * NTP methods:
  */
-- 
1.7.3.2.146.gca209

