Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1CYPwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:52:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58687 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab1CYPwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:52:06 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: alsa-devel@alsa-project.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Liam Girdwood <lrg@slimlogic.co.uk> (supporter:SOUND - SOC LAYER...
	,commit_signer:6/12=50%,commit_signer:3/4=75%),
        Mark Brown <broonie@opensource.wolfsonmicro.com> (supporter:SOUND -
	SOC LAYER...,commit_signer:6/12=50%,commit_signer:3/4=75%),
        Jaroslav Kysela <perex@perex.cz> (maintainer:SOUND),
        Takashi Iwai <tiwai@suse.de> (maintainer:SOUND),
        Timur Tabi <timur@freescale.com> (commit_signer:2/12=17% 
	,commit_signer:2/4=50%),
        Jarkko Nikula <jhnikula@gmail.com> (commit_signer:1/4=25%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/3] ASoC: imx: set watermarks for mx2-dma
Date: Fri, 25 Mar 2011 16:51:44 +0100
Message-Id: <1301068306-11997-2-git-send-email-w.sang@pengutronix.de>
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

They got accidently removed by f0fba2a (ASoC: multi-component - ASoC
Multi-Component Support). Reintroduce them and get rid of the
superfluous defines because the fiq-driver has its own hardcoded values.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 sound/soc/imx/imx-pcm-dma-mx2.c |    5 +++++
 sound/soc/imx/imx-ssi.h         |    3 ---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/imx/imx-pcm-dma-mx2.c b/sound/soc/imx/imx-pcm-dma-mx2.c
index 671ef8d..b2ed764 100644
--- a/sound/soc/imx/imx-pcm-dma-mx2.c
+++ b/sound/soc/imx/imx-pcm-dma-mx2.c
@@ -303,6 +303,11 @@ static struct snd_soc_platform_driver imx_soc_platform_mx2 = {
 
 static int __devinit imx_soc_platform_probe(struct platform_device *pdev)
 {
+	struct imx_ssi *ssi = platform_get_drvdata(pdev);
+
+	ssi->dma_params_tx.burstsize = 6;
+	ssi->dma_params_rx.burstsize = 4;
+
 	return snd_soc_register_platform(&pdev->dev, &imx_soc_platform_mx2);
 }
 
diff --git a/sound/soc/imx/imx-ssi.h b/sound/soc/imx/imx-ssi.h
index a4406a1..dc8a875 100644
--- a/sound/soc/imx/imx-ssi.h
+++ b/sound/soc/imx/imx-ssi.h
@@ -234,7 +234,4 @@ void imx_pcm_free(struct snd_pcm *pcm);
  */
 #define IMX_SSI_DMABUF_SIZE	(64 * 1024)
 
-#define DMA_RXFIFO_BURST      0x4
-#define DMA_TXFIFO_BURST      0x6
-
 #endif /* _IMX_SSI_H */
-- 
1.7.2.5

