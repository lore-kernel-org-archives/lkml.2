Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2FPRpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 13:45:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46262 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab2FPRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 13:45:44 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] pinctrl/pinctrl-u300: remove devm_kfree at driver unload
Date: Sat, 16 Jun 2012 23:15:37 +0530
Message-Id: <1339868737-5945-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the memory allocated by devm_kzalloc is automatically
freed at the driver detach side, so no neeed of calling
devm_kfree

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/pinctrl/pinctrl-u300.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 05d0299..13e7a3e 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1183,7 +1183,6 @@ static int __devexit u300_pmx_remove(struct platform_device *pdev)
 	iounmap(upmx->virtbase);
 	release_mem_region(upmx->phybase, upmx->physize);
 	platform_set_drvdata(pdev, NULL);
-	devm_kfree(&pdev->dev, upmx);
 
 	return 0;
 }
-- 
1.7.9.5

