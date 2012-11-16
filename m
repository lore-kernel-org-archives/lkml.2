Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2KPG5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:57:23 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62670 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab2KPG5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:17 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/14] pinctrl: samsung: Update error check for unsigned variables
Date: Fri, 16 Nov 2012 12:20:38 +0530
Message-Id: <1353048646-10935-7-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking '< 0' for unsigned variables always returns false. For error
codes, use IS_ERR_VALUE() instead.

CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/pinctrl/pinctrl-samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 81c9896..3b52c17 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -560,7 +560,7 @@ static int __devinit samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
 	const char *pin_name;
 
 	*npins = of_property_count_strings(cfg_np, "samsung,pins");
-	if (*npins < 0) {
+	if (IS_ERR_VALUE(*npins)) {
 		dev_err(dev, "invalid pin list in %s node", cfg_np->name);
 		return -EINVAL;
 	}
-- 
1.7.4.1

