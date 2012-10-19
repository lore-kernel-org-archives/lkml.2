Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2JSNbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:31:33 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:60441 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753740Ab2JSNba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:31:30 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 1/2] ASoC: Ux500: Fixup complile errors due to merge
Date: Fri, 19 Oct 2012 15:30:26 +0200
Message-ID: <1350653427-28611-1-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

Likely during merge of the below commits ended up breaking compilation:
ASoC: Ux500: Enable ux500 MSP driver for Device Tree
ASoC: ux500_msp_i2s: better use devm functions and fix error return code

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 sound/soc/ux500/ux500_msp_i2s.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index b7c996e..e6ff328 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -692,19 +692,15 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 	if (!msp)
 		return -ENOMEM;
 
-	if (np) {
-		if (!platform_data) {
-			platform_data = devm_kzalloc(&pdev->dev,
-				sizeof(struct msp_i2s_platform_data), GFP_KERNEL);
-			if (!platform_data)
-				ret = -ENOMEM;
-		}
-	} else
+	if (np && !platform_data) {
+		platform_data = devm_kzalloc(&pdev->dev,
+			sizeof(struct msp_i2s_platform_data), GFP_KERNEL);
 		if (!platform_data)
-			ret = -EINVAL;
+			return -ENOMEM;
+	}
 
-	if (ret)
-		goto err_res;
+	if (!platform_data)
+		return -EINVAL;
 
 	dev_dbg(&pdev->dev, "%s: Enter (name: %s, id: %d).\n", __func__,
 		pdev->name, platform_data->id);
-- 
1.7.10

