Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1BUX6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:58:05 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43789 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab1BUXzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:55:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        rtc-linux@googlegroups.com
Subject: [PATCH 10/10] RTC: Fix up rtc.txt documentation to reflect changes to generic rtc layer
Date: Mon, 21 Feb 2011 15:55:38 -0800
Message-Id: <1298332538-31216-11-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the genric RTC layer handles much of the RTC functionality,
the rtc.txt documentation needs to be updated to remove outdated information.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: rtc-linux@googlegroups.com
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 Documentation/rtc.txt |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index 9104c10..2501604 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -178,38 +178,29 @@ RTC class framework, but can't be supported by the older driver.
 	setting the longer alarm time and enabling its IRQ using a single
 	request (using the same model as EFI firmware).
 
-    *	RTC_UIE_ON, RTC_UIE_OFF ... if the RTC offers IRQs, it probably
-	also offers update IRQs whenever the "seconds" counter changes.
-	If needed, the RTC framework can emulate this mechanism.
+    *	RTC_UIE_ON, RTC_UIE_OFF ... if the RTC offers IRQs, the RTC framework
+	will emulate this mechanism.
 
-    *	RTC_PIE_ON, RTC_PIE_OFF, RTC_IRQP_SET, RTC_IRQP_READ ... another
-	feature often accessible with an IRQ line is a periodic IRQ, issued
-	at settable frequencies (usually 2^N Hz).
+    *	RTC_PIE_ON, RTC_PIE_OFF, RTC_IRQP_SET, RTC_IRQP_READ ... these icotls
+	are emulated via a kernel hrtimer.
 
 In many cases, the RTC alarm can be a system wake event, used to force
 Linux out of a low power sleep state (or hibernation) back to a fully
 operational state.  For example, a system could enter a deep power saving
 state until it's time to execute some scheduled tasks.
 
-Note that many of these ioctls need not actually be implemented by your
-driver.  The common rtc-dev interface handles many of these nicely if your
-driver returns ENOIOCTLCMD.  Some common examples:
+Note that many of these ioctls are handled by the common rtc-dev interface.
+Some common examples:
 
     *	RTC_RD_TIME, RTC_SET_TIME: the read_time/set_time functions will be
 	called with appropriate values.
 
-    *	RTC_ALM_SET, RTC_ALM_READ, RTC_WKALM_SET, RTC_WKALM_RD: the
-	set_alarm/read_alarm functions will be called.
+    *	RTC_ALM_SET, RTC_ALM_READ, RTC_WKALM_SET, RTC_WKALM_RD: gets or sets
+	the alarm rtc_timer. May call the set_alarm driver function.
 
-    *	RTC_IRQP_SET, RTC_IRQP_READ: the irq_set_freq function will be called
-	to set the frequency while the framework will handle the read for you
-	since the frequency is stored in the irq_freq member of the rtc_device
-	structure.  Your driver needs to initialize the irq_freq member during
-	init.  Make sure you check the requested frequency is in range of your
-	hardware in the irq_set_freq function.  If it isn't, return -EINVAL.  If
-	you cannot actually change the frequency, do not define irq_set_freq.
+    *	RTC_IRQP_SET, RTC_IRQP_READ: These are emulated by the generic code.
 
-    *	RTC_PIE_ON, RTC_PIE_OFF: the irq_set_state function will be called.
+    *	RTC_PIE_ON, RTC_PIE_OFF: These are also emulated by the generic code.
 
 If all else fails, check out the rtc-test.c driver!
 
-- 
1.7.3.2.146.gca209

