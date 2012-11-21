Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2KUElQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:41:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59523 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2KUElP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:41:15 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/2] extcon: max77693: Fix uninitialised variable warning
Date: Wed, 21 Nov 2012 10:04:57 +0530
Message-Id: <1353472498-5793-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Hi Chanwoo,

Please merge this patch with the previous one titled
"extcon: max77693: Use devm_kzalloc"
---
 drivers/extcon/extcon-max77693.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 3c29bb7..1da4ad4 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -672,9 +672,10 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 						info->max77693->muic,
 						&max77693_muic_regmap_config);
 		if (IS_ERR(info->max77693->regmap_muic)) {
+			ret = PTR_ERR(info->max77693->regmap_muic);
 			dev_err(max77693->dev,
 				"failed to allocate register map: %d\n", ret);
-			return PTR_ERR(info->max77693->regmap_muic);
+			return ret;
 		}
 	}
 	platform_set_drvdata(pdev, info);
-- 
1.7.4.1

