Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2GZKfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:35:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63742 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2GZK3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:29:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/21] ASoC: ux500: Strengthen error checking after memory allocation
Date: Thu, 26 Jul 2012 11:28:37 +0100
Message-Id: <1343298534-13611-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no out-of-memory error checking after attempting
to allocate memory for the ux500_msp or ux500_msp_i2s_drvdata data
structures. Instead we go about populating them regardless. This
patch applies the necessary error checking to prevent a panic.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_dai.c |    3 +++
 sound/soc/ux500/ux500_msp_i2s.c |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 62ac0285..cdbbdaf 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -760,6 +760,9 @@ static int __devinit ux500_msp_drv_probe(struct platform_device *pdev)
 	drvdata = devm_kzalloc(&pdev->dev,
 				sizeof(struct ux500_msp_i2s_drvdata),
 				GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
 	drvdata->fmt = 0;
 	drvdata->slots = 1;
 	drvdata->tx_mask = 0x01;
diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index ee14d2d..4c79850 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -673,6 +673,8 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 
 	*msp_p = devm_kzalloc(&pdev->dev, sizeof(struct ux500_msp), GFP_KERNEL);
 	msp = *msp_p;
+	if (!msp)
+		return -ENOMEM;
 
 	msp->id = platform_data->id;
 	msp->dev = &pdev->dev;
-- 
1.7.9.5

