Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2IXH5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:57:23 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:51214 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755216Ab2IXH5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:57:16 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 2/2] ARM: SAMSUNG: dma-ops: Fix dmaengine_prep_dma_cyclic() parameter list
Date: Mon, 24 Sep 2012 10:58:05 +0300
Message-Id: <1348473485-5081-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348473485-5081-1-git-send-email-peter.ujfalusi@ti.com>
References: <20120924133923.130c4db72aa8105cb5647d7a@canb.auug.org.au>
 <1348473485-5081-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new flags parameter for the function.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/plat-samsung/dma-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/plat-samsung/dma-ops.c b/arch/arm/plat-samsung/dma-ops.c
index c38d754..d088afa 100644
--- a/arch/arm/plat-samsung/dma-ops.c
+++ b/arch/arm/plat-samsung/dma-ops.c
@@ -91,7 +91,8 @@ static int samsung_dmadev_prepare(unsigned ch,
 		break;
 	case DMA_CYCLIC:
 		desc = dmaengine_prep_dma_cyclic(chan, param->buf,
-			param->len, param->period, param->direction);
+			param->len, param->period, param->direction,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 		break;
 	default:
 		dev_err(&chan->dev->device, "unsupported format\n");
-- 
1.7.12

