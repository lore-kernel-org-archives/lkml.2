Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2FKPZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:25:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49364 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2FKPZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:21 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH 01/14] rtc: ab8500-rtc: IRQF_ONESHOT when requesting a threaded IRQ
Date: Mon, 11 Jun 2012 16:24:54 +0100
Message-Id: <1339428307-3850-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rtc/rtc-ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index 4bcf9ca..b11a2ec 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -422,7 +422,7 @@ static int __devinit ab8500_rtc_probe(struct platform_device *pdev)
 	}
 
 	err = request_threaded_irq(irq, NULL, rtc_alarm_handler,
-		IRQF_NO_SUSPEND, "ab8500-rtc", rtc);
+		IRQF_NO_SUSPEND | IRQF_ONESHOT, "ab8500-rtc", rtc);
 	if (err < 0) {
 		rtc_device_unregister(rtc);
 		return err;
-- 
1.7.9.5

