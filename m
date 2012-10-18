Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2JRXlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:41:36 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56212 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2JRXld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:41:33 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: lars@metafoo.de, cbou@mail.ru, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 1/4] Use devm_kzalloc instead of kzalloc/kfree
Date: Thu, 18 Oct 2012 20:41:01 -0300
Message-Id: <1350603664-18148-2-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com>
References: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This does not chnange the rationale, just a cleanup

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/power/jz4740-battery.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 8dbc7bf..72f6335 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -252,7 +252,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	jz_battery = kzalloc(sizeof(*jz_battery), GFP_KERNEL);
+	jz_battery = devm_kzalloc(&pdev->dev, sizeof(*jz_battery), GFP_KERNEL);
 	if (!jz_battery) {
 		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
 		return -ENOMEM;
@@ -264,14 +264,14 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 	if (jz_battery->irq < 0) {
 		ret = jz_battery->irq;
 		dev_err(&pdev->dev, "Failed to get platform irq: %d\n", ret);
-		goto err_free;
+		goto err;
 	}
 
 	jz_battery->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!jz_battery->mem) {
 		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform mmio resource\n");
-		goto err_free;
+		goto err;
 	}
 
 	jz_battery->mem = request_mem_region(jz_battery->mem->start,
@@ -279,7 +279,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 	if (!jz_battery->mem) {
 		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		goto err_free;
+		goto err;
 	}
 
 	jz_battery->base = ioremap_nocache(jz_battery->mem->start,
@@ -373,8 +373,7 @@ err_iounmap:
 	iounmap(jz_battery->base);
 err_release_mem_region:
 	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
-err_free:
-	kfree(jz_battery);
+err:
 	return ret;
 }
 
@@ -396,7 +395,6 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
 
 	iounmap(jz_battery->base);
 	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
-	kfree(jz_battery);
 
 	return 0;
 }
-- 
1.7.9.5

