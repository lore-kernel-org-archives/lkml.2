Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1HJXoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:44:00 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51947 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1HJXnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:43:55 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        stable@kernel.org
Subject: [PATCH 2/3] alarmtimers: Memset itimerspec passed into alarm_timer_get
Date: Wed, 10 Aug 2011 16:43:35 -0700
Message-Id: <1313019816-32519-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1313019816-32519-1-git-send-email-john.stultz@linaro.org>
References: <1313019816-32519-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following common_timer_get, zero out the itimerspec passed in.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: stable@kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 1dee3f6..0e9263f 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -441,6 +441,8 @@ static int alarm_timer_create(struct k_itimer *new_timer)
 static void alarm_timer_get(struct k_itimer *timr,
 				struct itimerspec *cur_setting)
 {
+	memset(cur_setting, 0, sizeof(struct itimerspec));
+
 	cur_setting->it_interval =
 			ktime_to_timespec(timr->it.alarmtimer.period);
 	cur_setting->it_value =
-- 
1.7.3.2.146.gca209

