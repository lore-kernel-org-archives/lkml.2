Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2IUB1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 21:27:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33315 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2IUB1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 21:27:09 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-b5-505bc26b8ab1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: platform-lcd: Add support for device tree based
 probe
Date: Fri, 21 Sep 2012 10:27:07 +0900
Message-id: <000e01cd9798$370acbd0$a5206370$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2XmDbORFM7Jw9CSV++7XhUivGJ2g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jQd3sQ9EBBi8/21hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MxzfeMRb85qy439TD3sC4kaOLkYNDQsBE4mpHRhcjJ5ApJnHh
	3nq2LkYuDiGB6YwSHX0PmSCc2UwSKz89YwGpYhNQk/jy5TA7iC0iECHRPGMWM8ggZgEfic2z
	NEHCwgLBEs9aDrOChFkEVCV6HpmBhHkFbCV2bDnADmELSvyYfA9sIrOAlsT6nceZIGx5ic1r
	3jJDnKYu8eivLsQiPYn2VXugykUk9r14xziBUWAWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQn
	peca6hUn5haX5qXrJefnbmIEh+QzqR2MKxssDjEKcDAq8fB2uEQHCLEmlhVX5h5ilOBgVhLh
	fRQDFOJNSaysSi3Kjy8qzUktPsQozcGiJM4r/CkwQEggPbEkNTs1tSC1CCbLxMEp1cDIH+Xx
	L9fcringpUx16XlFBZXZq1z2Oj2onDwzYfeqj9cLGuyae4RqXcQ23rh+UV7jQfGN3/UBilru
	EhxbGb5IZXbOsXTc8+aZWrJ9tsAyL3Ej7Zo67S8ZwqpPGX/P+8r/Laxxsr+54McEwQgn8ynf
	j34Trn94li0znG9Tad1C4fy83QEZt5RYijMSDbWYi4oTAZ8XpYhFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the of_match_table to platform-lcd driver to be
probed when platform-lcd device node is found in the device tree.

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/platform_lcd.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index b667234..574d5ee 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -145,6 +145,14 @@ static SIMPLE_DEV_PM_OPS(platform_lcd_pm_ops, platform_lcd_suspend,
 			platform_lcd_resume);
 #endif
 
+#ifdef CONFIG_OF
+static const struct of_device_id platform_lcd_of_match[] = {
+	{ .compatible = "platform-lcd" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, platform_lcd_of_match);
+#endif
+
 static struct platform_driver platform_lcd_driver = {
 	.driver		= {
 		.name	= "platform-lcd",
@@ -152,6 +160,7 @@ static struct platform_driver platform_lcd_driver = {
 #ifdef CONFIG_PM
 		.pm	= &platform_lcd_pm_ops,
 #endif
+		.of_match_table = of_match_ptr(platform_lcd_of_match),
 	},
 	.probe		= platform_lcd_probe,
 	.remove		= __devexit_p(platform_lcd_remove),
-- 
1.7.1


