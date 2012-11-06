Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2KFXL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:11:57 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:48129 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2KFXL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:11:56 -0500
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org, lars@metafoo.de,
        linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 1/2] drivers/power/jz4740-battery.c: Use devm_kzalloc
Date: Tue,  6 Nov 2012 21:11:11 -0200
Message-Id: <1352243472-14951-2-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352243472-14951-1-git-send-email-marcos.souza.org@gmail.com>
References: <1352243472-14951-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a cleanup.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/power/jz4740-battery.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 8dbc7bf..59900c6 100644
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
@@ -262,24 +262,21 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 
 	jz_battery->irq = platform_get_irq(pdev, 0);
 	if (jz_battery->irq < 0) {
-		ret = jz_battery->irq;
 		dev_err(&pdev->dev, "Failed to get platform irq: %d\n", ret);
-		goto err_free;
+		return jz_battery->irq;
 	}
 
 	jz_battery->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!jz_battery->mem) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform mmio resource\n");
-		goto err_free;
+		return -ENOENT;
 	}
 
 	jz_battery->mem = request_mem_region(jz_battery->mem->start,
 				resource_size(jz_battery->mem),	pdev->name);
 	if (!jz_battery->mem) {
-		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		goto err_free;
+		return -EBUSY;
 	}
 
 	jz_battery->base = ioremap_nocache(jz_battery->mem->start,
@@ -373,8 +370,6 @@ err_iounmap:
 	iounmap(jz_battery->base);
 err_release_mem_region:
 	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
-err_free:
-	kfree(jz_battery);
 	return ret;
 }
 
@@ -396,7 +391,6 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
 
 	iounmap(jz_battery->base);
 	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
-	kfree(jz_battery);
 
 	return 0;
 }
-- 
1.7.9.5

