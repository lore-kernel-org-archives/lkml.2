Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1HJXCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:02:44 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49408 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab1HJXCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:02:41 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/4] rtc: rtc-twl: Switch to using threaded irq
Date: Wed, 10 Aug 2011 16:01:56 -0700
Message-Id: <1313017318-789-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1313017318-789-1-git-send-email-john.stultz@linaro.org>
References: <1313017318-789-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilkka Koskinen <ilkka.koskinen@nokia.com>

The driver is accessing to i2c bus in interrupt handler.
Therefore, it should use threaded irq.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Acked-by: Balaji T K <balajitk@ti.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-twl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 9a81f77..1963cdd 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -462,7 +462,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out1;
 
-	ret = request_irq(irq, twl_rtc_interrupt,
+	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
 				IRQF_TRIGGER_RISING,
 				dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
-- 
1.7.3.2.146.gca209

