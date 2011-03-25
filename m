Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1CYPwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:52:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58685 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab1CYPwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:52:04 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: alsa-devel@alsa-project.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Liam Girdwood <lrg@slimlogic.co.uk> (supporter:SOUND - SOC LAYER...
	,commit_signer:9/19=47%),
        Mark Brown <broonie@opensource.wolfsonmicro.com> (supporter:SOUND -
	SOC LAYER...,commit_signer:9/19=47%),
        Jaroslav Kysela <perex@perex.cz> (maintainer:SOUND),
        Takashi Iwai <tiwai@suse.de> (maintainer:SOUND),
        Timur Tabi <timur@freescale.com> (commit_signer:2/19=11%),
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de> (commit_signer:2/19=11%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/3] ASoC: imx: remove superfluous code in imx-ssi.c
Date: Fri, 25 Mar 2011 16:51:46 +0100
Message-Id: <1301068306-11997-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1301068306-11997-1-git-send-email-w.sang@pengutronix.de>
References: <1301068306-11997-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking if IMX_SSI_DMA is set and then set it again is useless.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 sound/soc/imx/imx-ssi.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/sound/soc/imx/imx-ssi.c b/sound/soc/imx/imx-ssi.c
index bc92ec6..c331d65 100644
--- a/sound/soc/imx/imx-ssi.c
+++ b/sound/soc/imx/imx-ssi.c
@@ -667,12 +667,6 @@ static int imx_ssi_probe(struct platform_device *pdev)
 	if (res)
 		ssi->dma_params_rx.dma = res->start;
 
-	if ((cpu_is_mx27() || cpu_is_mx21()) &&
-			!(ssi->flags & IMX_SSI_USE_AC97) &&
-			(ssi->flags & IMX_SSI_DMA)) {
-		ssi->flags |= IMX_SSI_DMA;
-	}
-
 	platform_set_drvdata(pdev, ssi);
 
 	ret = snd_soc_register_dai(&pdev->dev, dai);
-- 
1.7.2.5

