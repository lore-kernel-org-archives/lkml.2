Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1DLOyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:54:12 -0400
Received: from kroah.org ([198.145.64.141]:57523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145Ab1DLOh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:51 2011
Message-Id: <20110412143551.672029527@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [035/105] ASoC: imx: fix burstsize for DMA
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit e1bb31b444668bc957c337d33803db7cb3330745 upstream.

SSI counts in words, the DMA engine in bytes. (Wrong) factor got removed
in bf974a0 (ASoC i.MX: switch to new DMA api).

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/imx/imx-pcm-dma-mx2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/imx/imx-pcm-dma-mx2.c
+++ b/sound/soc/imx/imx-pcm-dma-mx2.c
@@ -110,12 +110,12 @@ static int imx_ssi_dma_alloc(struct snd_
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


