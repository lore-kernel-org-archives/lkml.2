Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1HJXDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:03:00 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50419 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab1HJXCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:02:48 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sebastian Reichel <sre@debian.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3/4] rtc: rtc-twl: Remove lockdep related local_irq_enable()
Date: Wed, 10 Aug 2011 16:01:57 -0700
Message-Id: <1313017318-789-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1313017318-789-1-git-send-email-john.stultz@linaro.org>
References: <1313017318-789-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Reichel <sre@debian.org>

Now that the irq is properly threaded (due to it needing i2c access)
we should also remove the local_irq_enable() call in twl_rtc_interrupt.
Testing this with Pandaboard, the RTC is still working.

Cc: Thomas Gleixner <tglx@linutronix.de>
[Reworked commit message -jstultz]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-twl.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 1963cdd..9677bbc 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -362,14 +362,6 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 	int res;
 	u8 rd_reg;
 
-#ifdef CONFIG_LOCKDEP
-	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
-	 * we don't want and can't tolerate.  Although it might be
-	 * friendlier not to borrow this thread context...
-	 */
-	local_irq_enable();
-#endif
-
 	res = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
-- 
1.7.3.2.146.gca209

