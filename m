Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757Ab2EIPJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:09:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab2EIPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:09:25 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH 4/9 v3] mmc: sh_mobile_sdhi: prepare for conversion to the shdma base library
Date: Wed,  9 May 2012 17:09:16 +0200
Message-Id: <1336576161-27082-5-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:uyUlZuJnI3q0Z+nhwCHDN90RU2YVgRUlhlCCOafe9F/
 jtFxYwwkhbe6O481PEGr2dSVy7/DOHIWZc1fxux8ZY+ZBOCQDa
 pDpMcN54i/Pp7eBpEeALhRkmBrovldtQ7J497nrx9bTPAEwXYw
 lCzxpBpVWEN7qzGWP4TNgxstSCzPPKE8gKrPuLyRsHGWzfE2Tm
 PTrSAE8ConxyjDAn9SHbvoM+yMmrB/2EUlO5aokK4fLWV1bWek
 VIMInEImlSIXh4+HH0P4yztu0yWAb1bGStaHf5O85xxZSjKhhq
 NbxoPwpNoFBNewBJxlb4Jo3wU0i/ptDRnAW/s5K5ABiUMu8XJW
 T8ih+KxJKdPqUE32+xyk3wdPVcep2puzzrq1bXoH2pfW3OyRiK
 TLo51PllR+B9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/sh_mobile_sdhi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sh_mobile_sdhi.c b/drivers/mmc/host/sh_mobile_sdhi.c
index 934b68e..b8d7004 100644
--- a/drivers/mmc/host/sh_mobile_sdhi.c
+++ b/drivers/mmc/host/sh_mobile_sdhi.c
@@ -145,10 +145,10 @@ static int __devinit sh_mobile_sdhi_probe(struct platform_device *pdev)
 		mmc_data->cd_gpio = p->cd_gpio;
 
 		if (p->dma_slave_tx > 0 && p->dma_slave_rx > 0) {
-			priv->param_tx.slave_id = p->dma_slave_tx;
-			priv->param_rx.slave_id = p->dma_slave_rx;
-			priv->dma_priv.chan_priv_tx = &priv->param_tx;
-			priv->dma_priv.chan_priv_rx = &priv->param_rx;
+			priv->param_tx.shdma_slave.slave_id = p->dma_slave_tx;
+			priv->param_rx.shdma_slave.slave_id = p->dma_slave_rx;
+			priv->dma_priv.chan_priv_tx = &priv->param_tx.shdma_slave;
+			priv->dma_priv.chan_priv_rx = &priv->param_rx.shdma_slave;
 			priv->dma_priv.alignment_shift = 1; /* 2-byte alignment */
 			mmc_data->dma = &priv->dma_priv;
 		}
-- 
1.7.2.5

