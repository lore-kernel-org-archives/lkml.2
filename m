Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1HJXCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:02:49 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49419 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab1HJXCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:02:47 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Willy Tarreau <w@1wt.eu>,
        stable@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/4] rtc: Fix RTC PIE frequency limit
Date: Wed, 10 Aug 2011 16:01:58 -0700
Message-Id: <1313017318-789-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1313017318-789-1-git-send-email-john.stultz@linaro.org>
References: <1313017318-789-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas earlier submitted a fix to limit the RTC PIE freq, but
picked 5000Hz out of the air. Willy noticed that we should
instead use the 8192Hz max from the rtc man documentation.

Cc: Willy Tarreau <w@1wt.eu>
Cc: stable@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/interface.c |    2 +-
 include/linux/rtc.h     |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 3195dbd..eb4c883 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -708,7 +708,7 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 	int err = 0;
 	unsigned long flags;
 
-	if (freq <= 0 || freq > 5000)
+	if (freq <= 0 || freq > RTC_MAX_FREQ)
 		return -EINVAL;
 retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index b27ebea..93f4d03 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -97,6 +97,9 @@ struct rtc_pll_info {
 #define RTC_AF 0x20	/* Alarm interrupt */
 #define RTC_UF 0x10	/* Update interrupt for 1Hz RTC */
 
+
+#define RTC_MAX_FREQ	8192
+
 #ifdef __KERNEL__
 
 #include <linux/types.h>
-- 
1.7.3.2.146.gca209

