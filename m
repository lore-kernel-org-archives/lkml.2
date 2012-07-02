Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab2GBUbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:31:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63678 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2GBUbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:31:05 -0400
Date: Mon, 2 Jul 2012 22:30:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 0.5/9] dma: move shdma driver to an own directory
In-Reply-To: <Pine.LNX.4.64.1207021936490.15365@axis700.grange>
Message-ID: <Pine.LNX.4.64.1207022228470.15365@axis700.grange>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de> 
 <1336576161-27082-2-git-send-email-g.liakhovetski@gmx.de> 
 <1337055734.16185.5360.camel@vkoul-udesk3>  <Pine.LNX.4.64.1205171912140.10086@axis700.grange>
 <1337933737.1580.8.camel@vkoul-udesk3> <Pine.LNX.4.64.1205251028530.13353@axis700.grange>
 <Pine.LNX.4.64.1206281046320.31813@axis700.grange>
 <Pine.LNX.4.64.1207021936490.15365@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:4+iLoya7GlYcrrz1zGmU8PmL03qjoOGrjmuQ73p6zzI
 A+Ppl12c2aQEBf2g5MhHnzAjUrCrRTVgHEQaNZ4MQbPq2K1thq
 k0XWLaG0Si/Zi/6Nb/Wj0KlCPQHdRYY3+LIKF2zLufyB3jdt6H
 HZW8vyxVVdj9cKP0HqpePuJeSCps+ydX1VXK/OhuJaauoHQI4e
 cwBtVEdJktJ2wNpGOjy1ekQDuYjjz7bquEnqc5zGUnhuVFvEap
 JgcY6VEA81TQpDIpOZZ/WLMpmrJCQPIsypnUNPwmwi4z/xK6gm
 w8ERRBt5aJxPpjvXFleosBKxWzn9oJZTZU/lFxtAGElGIRjRX3
 BBIeIOzwCfqaYULQWvgycEzMpvGHGgS2SYWVEtnniscHYDXXsO
 M8M7pD1RzqcdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shdma driver is going to be split into multiple files. To make this more
convenient move it to an own directory.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Sorry for the "0.5," please, just apply this patch before the whole shdma 
splitting series.

Thanks
Guennadi

 drivers/dma/Makefile         |    2 +-
 drivers/dma/sh/Makefile      |    1 +
 drivers/dma/{ => sh}/shdma.c |    2 +-
 drivers/dma/{ => sh}/shdma.h |    0
 4 files changed, 3 insertions(+), 2 deletions(-)
 create mode 100644 drivers/dma/sh/Makefile
 rename drivers/dma/{ => sh}/shdma.c (99%)
 rename drivers/dma/{ => sh}/shdma.h (100%)

diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 86b795b..59c10e5 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_DW_DMAC) += dw_dmac.o
 obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
 obj-$(CONFIG_MX3_IPU) += ipu/
 obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
-obj-$(CONFIG_SH_DMAE) += shdma.o
+obj-$(CONFIG_SH_DMAE) += sh/
 obj-$(CONFIG_COH901318) += coh901318.o coh901318_lli.o
 obj-$(CONFIG_AMCC_PPC440SPE_ADMA) += ppc4xx/
 obj-$(CONFIG_IMX_SDMA) += imx-sdma.o
diff --git a/drivers/dma/sh/Makefile b/drivers/dma/sh/Makefile
new file mode 100644
index 0000000..ad4981a
--- /dev/null
+++ b/drivers/dma/sh/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SH_DMAE) += shdma.o
diff --git a/drivers/dma/shdma.c b/drivers/dma/sh/shdma.c
similarity index 99%
rename from drivers/dma/shdma.c
rename to drivers/dma/sh/shdma.c
index 19d7a8d..8ab4a1f 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -31,7 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/rculist.h>
 
-#include "dmaengine.h"
+#include "../dmaengine.h"
 #include "shdma.h"
 
 /* DMA descriptor control */
diff --git a/drivers/dma/shdma.h b/drivers/dma/sh/shdma.h
similarity index 100%
rename from drivers/dma/shdma.h
rename to drivers/dma/sh/shdma.h
-- 
1.7.2.5

