Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2GUIiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 04:38:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47522 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2GUIiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 04:38:06 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] pinctrl/pinctrl-u300: remove unneeded devm_kfree call
Date: Sat, 21 Jul 2012 14:22:58 +0545
Message-Id: <1342859878-12631-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the allocated memory will be destroyed at the driver unload time,
automatically if driver uses the devm_ functions, so no need of
doing devm_kfree at the error path

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/pinctrl/pinctrl-u300.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index a7ad8c1..309f5b9 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1121,10 +1121,8 @@ static int __devinit u300_pmx_probe(struct platform_device *pdev)
 	upmx->dev = &pdev->dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENOENT;
-		goto out_no_resource;
-	}
+	if (!res)
+		return -ENOENT;
 	upmx->phybase = res->start;
 	upmx->physize = resource_size(res);
 
@@ -1165,8 +1163,6 @@ out_no_remap:
 	platform_set_drvdata(pdev, NULL);
 out_no_memregion:
 	release_mem_region(upmx->phybase, upmx->physize);
-out_no_resource:
-	devm_kfree(&pdev->dev, upmx);
 	return ret;
 }
 
-- 
1.7.9.5

