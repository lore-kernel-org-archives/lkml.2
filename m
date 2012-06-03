Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2FCGYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 02:24:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37033 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2FCGYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 02:24:42 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] rtc/rtc-spear: free the config right after the rtc_device_unregister
Date: Sun,  3 Jun 2012 11:54:19 +0530
Message-Id: <1338704660-30921-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the config was freed and its used again at rtc_device_unregister which leads
to a kernel panic. so, do it right after the rtc_device_unregister

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/rtc/rtc-spear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index 1f76320..e278547 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -458,12 +458,12 @@ static int __devexit spear_rtc_remove(struct platform_device *pdev)
 	clk_disable(config->clk);
 	clk_put(config->clk);
 	iounmap(config->ioaddr);
-	kfree(config);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res)
 		release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(config->rtc);
+	kfree(config);
 
 	return 0;
 }
-- 
1.7.9.5

