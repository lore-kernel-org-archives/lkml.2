Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab0GAVn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:43:56 -0400
Received: from kroah.org ([198.145.64.141]:32878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759102Ab0GAVOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:20 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:56 2010
Message-Id: <20100701174256.059190155@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stuart Longland <redhatter@gentoo.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [114/200] ASoC: Update Freescale i.MX SSI driver DMA parameter handling
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Longland <redhatter@gentoo.org>

commit e2b3e622b259e62aa2450a25f1c20cca1bfdc81e upstream.

This updates the i.MX SSI driver to make it compatible with the ASoC tree
following the move of DMA parameters from the DAI to the audio substream
object.

Signed-off-by: Stuart Longland <redhatter@gentoo.org>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/imx/imx-pcm-dma-mx2.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/soc/imx/imx-pcm-dma-mx2.c
+++ b/sound/soc/imx/imx-pcm-dma-mx2.c
@@ -73,7 +73,8 @@ static void snd_imx_dma_err_callback(int
 {
 	struct snd_pcm_substream *substream = data;
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct imx_pcm_dma_params *dma_params = rtd->dai->cpu_dai->dma_data;
+	struct imx_pcm_dma_params *dma_params =
+		snd_soc_dai_get_dma_data(rtd->dai->cpu_dai, substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct imx_pcm_runtime_data *iprtd = runtime->private_data;
 	int ret;
@@ -102,7 +103,7 @@ static int imx_ssi_dma_alloc(struct snd_
 	struct imx_pcm_runtime_data *iprtd = runtime->private_data;
 	int ret;
 
-	dma_params = snd_soc_get_dma_data(rtd->dai->cpu_dai, substream);
+	dma_params = snd_soc_dai_get_dma_data(rtd->dai->cpu_dai, substream);
 
 	iprtd->dma = imx_dma_request_by_prio(DRV_NAME, DMA_PRIO_HIGH);
 	if (iprtd->dma < 0) {
@@ -212,7 +213,7 @@ static int snd_imx_pcm_prepare(struct sn
 	struct imx_pcm_runtime_data *iprtd = runtime->private_data;
 	int err;
 
-	dma_params = snd_soc_get_dma_data(rtd->dai->cpu_dai, substream);
+	dma_params = snd_soc_dai_get_dma_data(rtd->dai->cpu_dai, substream);
 
 	iprtd->substream = substream;
 	iprtd->buf = (unsigned int *)substream->dma_buffer.area;


