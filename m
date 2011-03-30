Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab1C3QOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:14:48 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:38571 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736Ab1C3QOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:14:46 -0400
Date: Wed, 30 Mar 2011 18:12:01 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/rtc/rtc-jz4740.c: fix error check
Message-ID: <20110330181201.29e473bf@absol.kitzblitz>
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

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
Untested.

 drivers/rtc/rtc-jz4740.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index b647363..ba91bc6 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -220,12 +220,13 @@ static int __devinit jz4740_rtc_probe(struct platform_device *pdev)
 	if (!rtc)
 		return -ENOMEM;
 
-	rtc->irq = platform_get_irq(pdev, 0);
-	if (rtc->irq < 0) {
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0) {
 		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform irq\n");
 		goto err_free;
 	}
+	rtc->irq = ret;
 
 	rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!rtc->mem) {
-- 
1.7.3.4
