Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab3AIPwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:52:41 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:55494
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932072Ab3AIPwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:52:40 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <s.hauer@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] staging: ipu-di: Change DI address info to dev_dbg
Date: Wed, 9 Jan 2013 13:52:30 -0200
Message-ID: <1357746750-28675-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when ipuv3 is probed we have:

imx-ipuv3 40000000.ipu: DI0 base: 0x5e040000 remapped to a08aa000
imx-ipuv3 40000000.ipu: DI1 base: 0x5e048000 remapped to a08ac000
imx-ipuv3 40000000.ipu: IPUv3EX probed

The DI base address and the remapped address are more interesting for debug 
purposes, so mark this message as dev_dbg instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-di.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-di.c b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
index 67d974f..ec340da 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-di.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-di.c
@@ -677,7 +677,7 @@ int ipu_di_init(struct ipu_soc *ipu, struct device *dev, int id,
 		goto failed_clk_register;
 	}
 
-	dev_info(dev, "DI%d base: 0x%08lx remapped to %p\n",
+	dev_dbg(dev, "DI%d base: 0x%08lx remapped to %p\n",
 			id, base, di->base);
 	di->inuse = false;
 	di->ipu = ipu;
-- 
1.7.9.5


