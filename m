Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1DLOiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:01 -0400
Received: from kroah.org ([198.145.64.141]:57519 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab1DLOh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:51 2011
Message-Id: <20110412143551.567004558@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [034/105] ASoC: imx: set watermarks for mx2-dma
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 2c4cf17a52f04fbe929977252d5b8ab81d2c6e9b upstream.

They got accidently removed by f0fba2a (ASoC: multi-component - ASoC
Multi-Component Support). Reintroduce them and get rid of the
superfluous defines because the fiq-driver has its own hardcoded values.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/imx/imx-pcm-dma-mx2.c |    5 +++++
 sound/soc/imx/imx-ssi.h         |    3 ---
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/sound/soc/imx/imx-pcm-dma-mx2.c
+++ b/sound/soc/imx/imx-pcm-dma-mx2.c
@@ -303,6 +303,11 @@ static struct snd_soc_platform_driver im
 
 static int __devinit imx_soc_platform_probe(struct platform_device *pdev)
 {
+	struct imx_ssi *ssi = platform_get_drvdata(pdev);
+
+	ssi->dma_params_tx.burstsize = 6;
+	ssi->dma_params_rx.burstsize = 4;
+
 	return snd_soc_register_platform(&pdev->dev, &imx_soc_platform_mx2);
 }
 
--- a/sound/soc/imx/imx-ssi.h
+++ b/sound/soc/imx/imx-ssi.h
@@ -234,7 +234,4 @@ void imx_pcm_free(struct snd_pcm *pcm);
  */
 #define IMX_SSI_DMABUF_SIZE	(64 * 1024)
 
-#define DMA_RXFIFO_BURST      0x4
-#define DMA_TXFIFO_BURST      0x6
-
 #endif /* _IMX_SSI_H */


