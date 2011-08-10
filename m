Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1HJXof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:44:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49105 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1HJXnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:43:53 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        stable@kernel.org
Subject: [PATCH 1/3] alarmtimers: Avoid possible null pointer traversal
Date: Wed, 10 Aug 2011 16:43:34 -0700
Message-Id: <1313019816-32519-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1313019816-32519-1-git-send-email-john.stultz@linaro.org>
References: <1313019816-32519-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't check if old_setting is non null before assigning it, so
correct this.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: stable@kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 59f369f..1dee3f6 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -479,11 +479,8 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 	if (!rtcdev)
 		return -ENOTSUPP;
 
-	/* Save old values */
-	old_setting->it_interval =
-			ktime_to_timespec(timr->it.alarmtimer.period);
-	old_setting->it_value =
-			ktime_to_timespec(timr->it.alarmtimer.node.expires);
+	if (old_setting)
+		alarm_timer_get(timr, old_setting);
 
 	/* If the timer was already set, cancel it */
 	alarm_cancel(&timr->it.alarmtimer);
-- 
1.7.3.2.146.gca209

