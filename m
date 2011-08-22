Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1HVOWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:22:49 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:21425
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983Ab1HVOWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:22:47 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <kernel-janitors@vger.kernel.org>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <grant.likely@secretlab.ca>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <julia@diku.dk>
Subject: [PATCH] [v2] sound/soc/fsl/fsl_dma.c: add missing of_node_put
Date: Mon, 22 Aug 2011 09:22:41 -0500
Message-ID: <1314022961-27513-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_parse_phandle increments the reference count of np, so this should be
decremented before trying the next possibility.

Since we don't actually use np, we can decrement the reference count
immediately.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Timur Tabi <timur@freescale.com>
---
 sound/soc/fsl/fsl_dma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
index 6680c0b..b300f4b 100644
--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -877,10 +877,12 @@ static struct device_node *find_ssi_node(struct device_node *dma_channel_np)
 		 * assume that device_node pointers are a valid comparison.
 		 */
 		np = of_parse_phandle(ssi_np, "fsl,playback-dma", 0);
+		of_node_put(np);
 		if (np == dma_channel_np)
 			return ssi_np;
 
 		np = of_parse_phandle(ssi_np, "fsl,capture-dma", 0);
+		of_node_put(np);
 		if (np == dma_channel_np)
 			return ssi_np;
 	}
-- 
1.7.3.4


