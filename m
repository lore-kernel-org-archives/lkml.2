Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935175Ab2JYLEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:04:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21672 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934386Ab2JYLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:04:19 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-91-50891cb1075d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001cdb2a0$58c17f80$0a447e80$%han@samsung.com>
In-reply-to: <001001cdb2a0$58c17f80$0a447e80$%han@samsung.com>
Subject: [PATCH 2/3] backlight: hp680_bl: add missing __devexit macros for
 remove
Date: Thu, 25 Oct 2012 20:04:17 +0900
Message-id: <001101cdb2a0$7a51dff0$6ef59fd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2yoFiqa8gwXpqqSuWkk7J8877xPgAAA1Rg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd1NMp0BBhsWsFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M1zO6mQveclRMftTC1MC4mb2LkZNDQsBEYnPTMzYIW0ziwr31
	QDYXh5DAIkaJxeenMUM4s5kkZs3cxQRSxSagJvHly2GwbhGBCInmGbOAijg4mAV8JDbP0gQJ
	CwnYSuy7eRCshFPATmJz5xtmEFtYIFji47LZrCA2i4CqxOGtR8FG8gLVX+1+xQxhC0r8mHyP
	BcRmFtCSWL/zOBOELS+xec1bsFUSAuoSj/7qgpgiAkYS85erQVSISOx78Y5xAqPQLCSDZiEZ
	NAvJoFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7iZ1I7GFc2WBxiFOBgVOLh
	PeDRESDEmlhWXJl7iFGCg1lJhHf7e6AQb0piZVVqUX58UWlOavEhRmkOFiVx3maPlAAhgfTE
	ktTs1NSC1CKYLBMHp1QD41zxqyJSr3MX2ThLdIu4a2/df0bMk2PTiU2Xz1vP+JiY/tAmo6rs
	KZfoiS9XZ/nubT+nF6U5abYpx1aJUImNUicUT92YU1BbU7PcZsGasLQbxw2aCoNm6Qi1HPC5
	79bcV3qRKSLCU19i0s+Zk4SD/2z3deAUrqg5uehoin/Bd4np2Q+LOgX3K7EUZyQaajEXFScC
	AAEBj9FeAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __devexit macros is added to remove function. The macros
moves the remove function to devexit section.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/hp680_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 191fbed..31d3a1f 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -124,7 +124,7 @@ static int __devinit hp680bl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int hp680bl_remove(struct platform_device *pdev)
+static int __devexit hp680bl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 
@@ -139,7 +139,7 @@ static int hp680bl_remove(struct platform_device *pdev)
 
 static struct platform_driver hp680bl_driver = {
 	.probe		= hp680bl_probe,
-	.remove		= hp680bl_remove,
+	.remove		= __devexit_p(hp680bl_remove),
 	.suspend	= hp680bl_suspend,
 	.resume		= hp680bl_resume,
 	.driver		= {
-- 
1.7.1


