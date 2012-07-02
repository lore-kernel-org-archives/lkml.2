Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab2GBIka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:40:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab2GBIk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:40:28 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] leds-mc13783: set platform data to NULL at mc13783_led_remove
Date: Mon,  2 Jul 2012 14:10:20 +0530
Message-Id: <1341218420-22377-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the platform_set_drvdata (pdev, NULL) to be set at the remove of the
driver, as we have set the platform data to led at probe.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/leds/leds-mc13783.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
index 4cc6a2e..6515c11 100644
--- a/drivers/leds/leds-mc13783.c
+++ b/drivers/leds/leds-mc13783.c
@@ -372,6 +372,7 @@ static int __devexit mc13783_led_remove(struct platform_device *pdev)
 
 	mc13xxx_unlock(dev);
 
+	platform_set_drvdata(pdev, NULL);
 	kfree(led);
 	return 0;
 }
-- 
1.7.9.5

