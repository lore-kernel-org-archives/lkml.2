Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2FRRon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:44:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33424 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2FRRom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:44:42 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/2] pinctrl/pinctrl-tegra: remove IS_ERR checking of pmx->pctl
Date: Mon, 18 Jun 2012 23:14:31 +0530
Message-Id: <1340041471-30122-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinctrl_register returns a pointer of struct type struct pinctrl_dev,
if successfully registered to pinctrl subsystem, otherwise returns
NULL, and there wont' be any pointers which are not dereferencible.

They are not type of pointer addresses but are kind of error
codes rather actual addresses, but are a kind of return
codes of functions returning integer types.

return -ENODEV if device registration fails.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/pinctrl/pinctrl-tegra.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index 07228b1..ae52e4e 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -745,9 +745,9 @@ int __devinit tegra_pinctrl_probe(struct platform_device *pdev,
 	}
 
 	pmx->pctl = pinctrl_register(&tegra_pinctrl_desc, &pdev->dev, pmx);
-	if (IS_ERR(pmx->pctl)) {
+	if (!pmx->pctl) {
 		dev_err(&pdev->dev, "Couldn't register pinctrl driver\n");
-		return PTR_ERR(pmx->pctl);
+		return -ENODEV;
 	}
 
 	pinctrl_add_gpio_range(pmx->pctl, &tegra_pinctrl_gpio_range);
-- 
1.7.9.5

