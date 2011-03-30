Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1C3S2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:28:32 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:35521 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab1C3S2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:28:31 -0400
Date: Wed, 30 Mar 2011 20:27:00 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/rtc/rtc-jz4740.c: fix error check v2
Message-ID: <20110330202700.7d8142e8@absol.kitzblitz>
In-Reply-To: <4D935C56.4060903@metafoo.de>
References: <20110330181201.29e473bf@absol.kitzblitz>
	<4D935C56.4060903@metafoo.de>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking 'rtc->irq < 0' doesn't work because 'rtc->irq' is unsigned.

v2: return error code from platform_get_irq() instead of -ENOENT.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/rtc/rtc-jz4740.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index b647363..efd9691 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -220,12 +220,12 @@ static int __devinit jz4740_rtc_probe(struct platform_device *pdev)
 	if (!rtc)
 		return -ENOMEM;
 
-	rtc->irq = platform_get_irq(pdev, 0);
-	if (rtc->irq < 0) {
-		ret = -ENOENT;
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to get platform irq\n");
 		goto err_free;
 	}
+	rtc->irq = ret;
 
 	rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!rtc->mem) {
-- 
1.7.3.4
