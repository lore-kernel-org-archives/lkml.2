Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2AZO5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:57:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab2AZO4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:56:36 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 4/7 v2] mmc: sh_mobile_sdhi: prepare for conversion to simple DMA
Date: Thu, 26 Jan 2012 15:56:21 +0100
Message-Id: <1327589784-4287-5-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:To4rLSoisX9wYbT8dXedOF5++5fJaWGkzhvLsQhbrWU
 n909zzFXdJj1XHE1OR71GEAWV32yHZWz4qDvN9RazLw99Lv482
 xQY9udAuXwc13+Ypz9MXSO8z83ETXWbzWuk4ecMtS83ZcMUzD7
 jJcUPs0SWMe7Chm0HxWXkWaP8rzWvhxY2MD71WWrnITyiAii8X
 xIXL33bR5Apd50Z9AD5MuBCuWHNiRkjXVu7ONega5h/bUFppND
 oLUTx65EAftuC/iext3fz5sbEFA1pn3w39WMThHoq5NQs9UB0M
 M4BLCpOLIy4u1d9hhiHNewHZ/84V/N1ox12D91+RjMs3MnSWmN
 FLq/DF+F+149ys0dY/gMtZOqE/KdLXlPh39rD8M8tHZbm7ggFn
 JArBZawwKRATA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/mmc/host/sh_mobile_sdhi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sh_mobile_sdhi.c b/drivers/mmc/host/sh_mobile_sdhi.c
index f91c3aa..2c3a9d3 100644
--- a/drivers/mmc/host/sh_mobile_sdhi.c
+++ b/drivers/mmc/host/sh_mobile_sdhi.c
@@ -130,10 +130,10 @@ static int __devinit sh_mobile_sdhi_probe(struct platform_device *pdev)
 		mmc_data->cd_gpio = p->cd_gpio;
 
 		if (p->dma_slave_tx > 0 && p->dma_slave_rx > 0) {
-			priv->param_tx.slave_id = p->dma_slave_tx;
-			priv->param_rx.slave_id = p->dma_slave_rx;
-			priv->dma_priv.chan_priv_tx = &priv->param_tx;
-			priv->dma_priv.chan_priv_rx = &priv->param_rx;
+			priv->param_tx.simple_slave.slave_id = p->dma_slave_tx;
+			priv->param_rx.simple_slave.slave_id = p->dma_slave_rx;
+			priv->dma_priv.chan_priv_tx = &priv->param_tx.simple_slave;
+			priv->dma_priv.chan_priv_rx = &priv->param_rx.simple_slave;
 			priv->dma_priv.alignment_shift = 1; /* 2-byte alignment */
 			mmc_data->dma = &priv->dma_priv;
 		}
-- 
1.7.2.5

