Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1CYPwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:52:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58682 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1CYPwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:52:04 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: alsa-devel@alsa-project.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Liam Girdwood <lrg@slimlogic.co.uk> (supporter:SOUND - SOC LAYER...
	,commit_signer:6/12=50%),
        Mark Brown <broonie@opensource.wolfsonmicro.com> (supporter:SOUND -
	SOC LAYER...,commit_signer:6/12=50%),
        Jaroslav Kysela <perex@perex.cz> (maintainer:SOUND),
        Takashi Iwai <tiwai@suse.de> (maintainer:SOUND),
        Timur Tabi <timur@freescale.com> (commit_signer:2/12=17%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] ASoC: imx: fix burstsize for DMA
Date: Fri, 25 Mar 2011 16:51:45 +0100
Message-Id: <1301068306-11997-3-git-send-email-w.sang@pengutronix.de>
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

SSI counts in words, the DMA engine in bytes. (Wrong) factor got removed
in bf974a0 (ASoC i.MX: switch to new DMA api).

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 sound/soc/imx/imx-pcm-dma-mx2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/imx/imx-pcm-dma-mx2.c b/sound/soc/imx/imx-pcm-dma-mx2.c
index b2ed764..aab7765 100644
--- a/sound/soc/imx/imx-pcm-dma-mx2.c
+++ b/sound/soc/imx/imx-pcm-dma-mx2.c
@@ -110,12 +110,12 @@ static int imx_ssi_dma_alloc(struct snd_pcm_substream *substream,
 		slave_config.direction = DMA_TO_DEVICE;
 		slave_config.dst_addr = dma_params->dma_addr;
 		slave_config.dst_addr_width = buswidth;
-		slave_config.dst_maxburst = dma_params->burstsize;
+		slave_config.dst_maxburst = dma_params->burstsize * buswidth;
 	} else {
 		slave_config.direction = DMA_FROM_DEVICE;
 		slave_config.src_addr = dma_params->dma_addr;
 		slave_config.src_addr_width = buswidth;
-		slave_config.src_maxburst = dma_params->burstsize;
+		slave_config.src_maxburst = dma_params->burstsize * buswidth;
 	}
 
 	ret = dmaengine_slave_config(iprtd->dma_chan, &slave_config);
-- 
1.7.2.5

