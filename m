Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2DTTcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:32:42 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48190 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2DTTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:32:40 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 2/4] alarmtimer: Provide accessor to alarmtimer rtc device
Date: Fri, 20 Apr 2012 12:31:45 -0700
Message-Id: <1334950307-403-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1334950307-403-1-git-send-email-john.stultz@linaro.org>
References: <1334950307-403-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042019-4242-0000-0000-000001692CDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Android alarm interface provides a settime call that sets both
the alarmtimer RTC device and CLOCK_REALTIME to the same value.

Since there may be multiple rtc devices, provide a hook to access the
one the alarmtimer infrastructure is using.

CC: Colin Cross <ccross@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/alarmtimer.h |    3 +++
 kernel/time/alarmtimer.c   |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/alarmtimer.h b/include/linux/alarmtimer.h
index 975009e..96c5c24 100644
--- a/include/linux/alarmtimer.h
+++ b/include/linux/alarmtimer.h
@@ -76,4 +76,7 @@ static inline int alarmtimer_callback_running(struct alarm *timer)
 }
 
 
+/* Provide way to access the rtc device being used by alarmtimers */
+struct rtc_device *alarmtimer_get_rtcdev(void);
+
 #endif
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 8a538c55..aa27d39 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -59,7 +59,7 @@ static DEFINE_SPINLOCK(rtcdev_lock);
  * If one has not already been chosen, it checks to see if a
  * functional rtc device is available.
  */
-static struct rtc_device *alarmtimer_get_rtcdev(void)
+struct rtc_device *alarmtimer_get_rtcdev(void)
 {
 	unsigned long flags;
 	struct rtc_device *ret;
@@ -115,7 +115,7 @@ static void alarmtimer_rtc_interface_remove(void)
 	class_interface_unregister(&alarmtimer_rtc_interface);
 }
 #else
-static inline struct rtc_device *alarmtimer_get_rtcdev(void)
+struct rtc_device *alarmtimer_get_rtcdev(void)
 {
 	return NULL;
 }
-- 
1.7.3.2.146.gca209

