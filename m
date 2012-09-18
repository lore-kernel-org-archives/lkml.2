Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab2IRDN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:13:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51153 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627Ab2IRDNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:13:12 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@google.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] alarmtimer: Rename alarmtimer_remove to alarmtimer_dequeue
Date: Mon, 17 Sep 2012 23:12:55 -0400
Message-Id: <1347937975-34169-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347937975-34169-1-git-send-email-john.stultz@linaro.org>
References: <1347937975-34169-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12091803-8974-0000-0000-00000DEE6AAE
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00175089; UDB=6.00039653; UTC=2012-09-18
 03:13:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that alarmtimer_remove has been simplified, change
its name to _dequeue to better match its paired _enqueue
function.

Cc: Arve Hjønnevåg <arve@google.com>
Cc: Colin Cross <ccross@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 8c763ac..d14f833 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -142,7 +142,7 @@ static void alarmtimer_enqueue(struct alarm_base *base, struct alarm *alarm)
 }
 
 /**
- * alarmtimer_remove - Removes an alarm timer from an alarm_base timerqueue
+ * alarmtimer_dequeue - Removes an alarm timer from an alarm_base timerqueue
  * @base: pointer to the base where the timer is running
  * @alarm: pointer to alarm being removed
  *
@@ -150,7 +150,7 @@ static void alarmtimer_enqueue(struct alarm_base *base, struct alarm *alarm)
  *
  * Must hold base->lock when calling.
  */
-static void alarmtimer_remove(struct alarm_base *base, struct alarm *alarm)
+static void alarmtimer_dequeue(struct alarm_base *base, struct alarm *alarm)
 {
 	if (!(alarm->state & ALARMTIMER_STATE_ENQUEUED))
 		return;
@@ -178,7 +178,7 @@ static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
 	int restart = ALARMTIMER_NORESTART;
 
 	spin_lock_irqsave(&base->lock, flags);
-	alarmtimer_remove(base, alarm);
+	alarmtimer_dequeue(base, alarm);
 	spin_unlock_irqrestore(&base->lock, flags);
 
 	if (alarm->function)
@@ -332,7 +332,7 @@ int alarm_try_to_cancel(struct alarm *alarm)
 	spin_lock_irqsave(&base->lock, flags);
 	ret = hrtimer_try_to_cancel(&alarm->timer);
 	if (ret >= 0)
-		alarmtimer_remove(base, alarm);
+		alarmtimer_dequeue(base, alarm);
 	spin_unlock_irqrestore(&base->lock, flags);
 	return ret;
 }
-- 
1.7.9.5

