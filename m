Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab2INMFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:05:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35502 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725Ab2INMFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:05:14 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org, patches@linaro.org,
        Thomas Abraham <thomas.ab@samsung.com>
Subject: [PATCH 1/1] pinctrl: Samsung: Fix return value
Date: Fri, 14 Sep 2012 17:32:04 +0530
Message-Id: <1347624124-27535-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value obtained from of_property_count_strings()
instead of -EINVAL.

Silences the following smatch warning:
drivers/pinctrl/pinctrl-samsung.c:529 samsung_pinctrl_parse_dt_pins()
info: why not propagate '*npins' from of_property_count_strings()
instead of -22?

Cc: Thomas Abraham <thomas.ab@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 8a24223..824fda9 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -526,7 +526,7 @@ static int __init samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
 	*npins = of_property_count_strings(cfg_np, "samsung,pins");
 	if (*npins < 0) {
 		dev_err(dev, "invalid pin list in %s node", cfg_np->name);
-		return -EINVAL;
+		return *npins;
 	}
 
 	*pin_list = devm_kzalloc(dev, *npins * sizeof(**pin_list), GFP_KERNEL);
-- 
1.7.4.1

