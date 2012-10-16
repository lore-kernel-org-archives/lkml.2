Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2JPHYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:24:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15180 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2JPHYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:24:16 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-5a-507d0b9e71f4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Mike Rapoport'" <mike@compulab.co.il>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: da903x_bl: use dev_get_drvdata() instead of
 platform_get_drvdata()
Date: Tue, 16 Oct 2012 16:24:14 +0900
Message-id: <007001cdab6f$3ec74a20$bc55de60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rbz6U8GVeWndjSN6sqtQ8g0kPFw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd153LUBBhubzCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGlUOPWAsucVZsnfqeuYFxHkcXIyeHhICJxKKnv9khbDGJC/fW
	s4HYQgLTGSUWfACKcwHZs5kkHm/eAFbEJqAm8eXLYTBbRCBConnGLGYQm1mgVOJx31kmEFtY
	IEFi4amPLCA2i4CqxOK/y8CG8grYSlxqb2GGsAUlfky+xwLRqyWxfudxJghbXmLzmrdANRxA
	B6lLPPqrC7FKT+LZmmusECUiEvtevGOcwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxgsPymfQOxlUNFocYBTgYlXh4M5xrAoRYE8uKK3MPMUpwMCuJ8HpM
	BArxpiRWVqUW5ccXleakFh9ilOZgURLnbfZICRASSE8sSc1OTS1ILYLJMnFwSjUwTl0WHRha
	a1524trT1eG91f9941qY3yYIFFrofnePYpZn2mdSMPdyhsLnqkbv+pDrUTrsV72NBRp0e5Xb
	8rK+awhyxL3TL06fe2lLlNOt6Y+Cum+IFU1tvTNBnu+Y/MGYFjmF1pUi23JyPzTM93tus0+y
	LnZDgupUo1PlnyZkeq5IzVh0U0CJpTgj0VCLuag4EQBWY34xRwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_get_drvdata() can be used instead of platform_get_drvdata()
to make the code smaller.
 
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Mike Rapoport <mike@compulab.co.il>
---
 drivers/video/backlight/da903x_bl.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 573c7ec..6891754 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -164,15 +164,14 @@ static int da903x_backlight_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int da903x_backlight_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
+
 	return da903x_backlight_set(bl, 0);
 }
 
 static int da903x_backlight_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	backlight_update_status(bl);
 	return 0;
-- 
1.7.1


