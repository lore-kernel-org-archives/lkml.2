Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab2ARKXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:23:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55263 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab2ARKWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:22:37 -0500
Date: Wed, 18 Jan 2012 11:22:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org
Subject: [PATCH 4/7] mmc: sh_mobile_sdhi: prepare for conversion to simple
 DMA
In-Reply-To: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
Message-ID: <Pine.LNX.4.64.1201181117170.28782@axis700.grange>
References: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:f4mlKfGOPmUZQ5QQ5HpQ+2RSZBjLhYyssD2iCNf3uC6
 po6/VOcV5YinLJU3fPcSOgkcGJramC/K5+OS0gbA5sLFuWrxvc
 fAApQGawoXQAXbQ8uqR/z6j68g1dY2z5TYWrnDMbSdb4yKuczG
 UfgD5zWmWYxoOyU6G3jnpiuaU08qTfrRZqUdhH5SbzB3dv9ukR
 5+f7g0JEIscrY05mRVQXe99Pez54qkQVaNryeBvlGfMq8XNTLr
 quhYYKGGTJUSsOpEyH/3Sn68fk+jGE0PcQ3CnGlFKUHf6ZD1P9
 YEUQJhqT7aVCZrpu8J904yyLhFpiryRQvWrDxTs/D43bLqd1lC
 nFRLn31ASzlb2hxlROt3t36EwAR0zxTdhn5KSfAkhFns0VkfWE
 PHLgV5umqpDaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/mmc/host/sh_mobile_sdhi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sh_mobile_sdhi.c b/drivers/mmc/host/sh_mobile_sdhi.c
index bf45359..1f6f67a 100644
--- a/drivers/mmc/host/sh_mobile_sdhi.c
+++ b/drivers/mmc/host/sh_mobile_sdhi.c
@@ -142,10 +142,10 @@ static int __devinit sh_mobile_sdhi_probe(struct platform_device *pdev)
 		mmc_data->cd_flags = p->cd_flags;
 
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

