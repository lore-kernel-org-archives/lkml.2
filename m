Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2ILLrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:47:13 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:56643 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab2ILLrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:47:07 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: [PATCH 08/11] ASoC: OMAP: mcbsp, mcpdm, dmic: Let omap-pcm to pick the dma_type
Date: Wed, 12 Sep 2012 14:47:04 +0300
Message-Id: <1347450427-27627-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap-pcm can figure out the correct dma_type based on the stream's format.
In this way we can get rid of the plat/dma.h include from these drivers.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/omap/omap-dmic.c  | 2 --
 sound/soc/omap/omap-mcbsp.c | 3 ---
 sound/soc/omap/omap-mcpdm.c | 3 ---
 3 files changed, 8 deletions(-)

diff --git a/sound/soc/omap/omap-dmic.c b/sound/soc/omap/omap-dmic.c
index 60b7b8c..df0ff24 100644
--- a/sound/soc/omap/omap-dmic.c
+++ b/sound/soc/omap/omap-dmic.c
@@ -33,7 +33,6 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/of_device.h>
-#include <plat/dma.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -63,7 +62,6 @@ struct omap_dmic {
  */
 static struct omap_pcm_dma_data omap_dmic_dai_dma_params = {
 	.name		= "DMIC capture",
-	.data_type	= OMAP_DMA_DATA_TYPE_S32,
 };
 
 static inline void omap_dmic_write(struct omap_dmic *dmic, u16 reg, u32 val)
diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index 5b3bacc..a230646 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -34,7 +34,6 @@
 #include <sound/initval.h>
 #include <sound/soc.h>
 
-#include <plat/dma.h>
 #include <plat/mcbsp.h>
 #include "mcbsp.h"
 #include "omap-mcbsp.h"
@@ -234,11 +233,9 @@ static int omap_mcbsp_dai_hw_params(struct snd_pcm_substream *substream,
 
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
-		dma_data->data_type = OMAP_DMA_DATA_TYPE_S16;
 		wlen = 16;
 		break;
 	case SNDRV_PCM_FORMAT_S32_LE:
-		dma_data->data_type = OMAP_DMA_DATA_TYPE_S32;
 		wlen = 32;
 		break;
 	default:
diff --git a/sound/soc/omap/omap-mcpdm.c b/sound/soc/omap/omap-mcpdm.c
index 36648e0..c1b4935 100644
--- a/sound/soc/omap/omap-mcpdm.c
+++ b/sound/soc/omap/omap-mcpdm.c
@@ -40,7 +40,6 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 
-#include <plat/dma.h>
 #include "omap-mcpdm.h"
 #include "omap-pcm.h"
 
@@ -70,11 +69,9 @@ struct omap_mcpdm {
 static struct omap_pcm_dma_data omap_mcpdm_dai_dma_params[] = {
 	{
 		.name = "Audio playback",
-		.data_type = OMAP_DMA_DATA_TYPE_S32,
 	},
 	{
 		.name = "Audio capture",
-		.data_type = OMAP_DMA_DATA_TYPE_S32,
 	},
 };
 
-- 
1.7.12

