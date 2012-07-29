Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2G2ILu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 04:11:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55508 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2G2ILr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 04:11:47 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] pinctrl-sirf: remove devm_kfree at error path
Date: Sun, 29 Jul 2012 13:56:38 +0545
Message-Id: <1343549498-2217-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the pointers that are allocated with devm_kzalloc will be automatically freed,
at unload time.

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/pinctrl/pinctrl-sirf.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-sirf.c b/drivers/pinctrl/pinctrl-sirf.c
index 2aae8a8..7fca6ce 100644
--- a/drivers/pinctrl/pinctrl-sirf.c
+++ b/drivers/pinctrl/pinctrl-sirf.c
@@ -1217,7 +1217,6 @@ out_no_rsc_remap:
 	iounmap(spmx->gpio_virtbase);
 out_no_gpio_remap:
 	platform_set_drvdata(pdev, NULL);
-	devm_kfree(&pdev->dev, spmx);
 	return ret;
 }
 
-- 
1.7.9.5

