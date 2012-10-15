Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2JONNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:13:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47594 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2JONNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:13:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] ASoC: ux500_msp_i2s: Fix devm_* and return code merge error
Date: Mon, 15 Oct 2012 14:13:26 +0100
Message-Id: <1350306806-5688-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350306806-5688-1-git-send-email-lee.jones@linaro.org>
References: <1350306806-5688-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ux500_msp_i2s patches clashed with:

b18e93a493626c1446f9788ebd5844d008bbf71c
ASoC: ux500_msp_i2s: better use devm functions and fix error return code

... leaving the driver uncompilable. This patch fixes the
issues encountered.

Cc: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_i2s.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index b7c996e..a26c6bf 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -18,6 +18,7 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 #include <linux/of.h>
 
 #include <mach/hardware.h>
@@ -697,14 +698,11 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			platform_data = devm_kzalloc(&pdev->dev,
 				sizeof(struct msp_i2s_platform_data), GFP_KERNEL);
 			if (!platform_data)
-				ret = -ENOMEM;
+				return -ENOMEM;
 		}
 	} else
 		if (!platform_data)
-			ret = -EINVAL;
-
-	if (ret)
-		goto err_res;
+			return -EINVAL;
 
 	dev_dbg(&pdev->dev, "%s: Enter (name: %s, id: %d).\n", __func__,
 		pdev->name, platform_data->id);
-- 
1.7.9.5

