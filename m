Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab2IRDNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:13:12 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51150 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab2IRDNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:13:10 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@google.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] alarmtimer: Remove unused helpers & defines
Date: Mon, 17 Sep 2012 23:12:54 -0400
Message-Id: <1347937975-34169-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347937975-34169-1-git-send-email-john.stultz@linaro.org>
References: <1347937975-34169-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12091803-8974-0000-0000-00000DEE6AAD
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00175089; UDB=6.00039653; UTC=2012-09-18
 03:13:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is using these alarmtimer state helpers, so yank them.

Cc: Arve Hjønnevåg <arve@google.com>
Cc: Colin Cross <ccross@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/alarmtimer.h |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/include/linux/alarmtimer.h b/include/linux/alarmtimer.h
index f122c9f..9069694 100644
--- a/include/linux/alarmtimer.h
+++ b/include/linux/alarmtimer.h
@@ -21,7 +21,6 @@ enum alarmtimer_restart {
 
 #define ALARMTIMER_STATE_INACTIVE	0x00
 #define ALARMTIMER_STATE_ENQUEUED	0x01
-#define ALARMTIMER_STATE_CALLBACK	0x02
 
 /**
  * struct alarm - Alarm timer structure
@@ -50,33 +49,6 @@ int alarm_cancel(struct alarm *alarm);
 
 u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval);
 
-/*
- * A alarmtimer is active, when it is enqueued into timerqueue or the
- * callback function is running.
- */
-static inline int alarmtimer_active(const struct alarm *timer)
-{
-	return timer->state != ALARMTIMER_STATE_INACTIVE;
-}
-
-/*
- * Helper function to check, whether the timer is on one of the queues
- */
-static inline int alarmtimer_is_queued(struct alarm *timer)
-{
-	return timer->state & ALARMTIMER_STATE_ENQUEUED;
-}
-
-/*
- * Helper function to check, whether the timer is running the callback
- * function
- */
-static inline int alarmtimer_callback_running(struct alarm *timer)
-{
-	return timer->state & ALARMTIMER_STATE_CALLBACK;
-}
-
-
 /* Provide way to access the rtc device being used by alarmtimers */
 struct rtc_device *alarmtimer_get_rtcdev(void);
 
-- 
1.7.9.5

