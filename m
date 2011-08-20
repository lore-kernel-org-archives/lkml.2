Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1HTHX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 03:23:56 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56933 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab1HTHXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 03:23:52 -0400
From: Julia Lawall <julia@diku.dk>
To: Timur Tabi <timur@freescale.com>
Cc: kernel-janitors@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] sound/soc/fsl/fsl_dma.c: add missing of_node_put
Date: Sat, 20 Aug 2011 09:23:45 +0200
Message-Id: <1313825025-17590-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

of_parse_phandle increments the reference count of np, so this should be
decremented before trying the next possibility.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1,e2;
@@

*e = of_parse_phandle(...)
... when != of_node_put(e)
    when != true e == NULL
    when != e2 = e
e = e1
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/soc/fsl/fsl_dma.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
index 0efc04a..b33271b 100644
--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -880,10 +880,12 @@ static struct device_node *find_ssi_node(struct device_node *dma_channel_np)
 		np = of_parse_phandle(ssi_np, "fsl,playback-dma", 0);
 		if (np == dma_channel_np)
 			return ssi_np;
+		of_node_put(np);
 
 		np = of_parse_phandle(ssi_np, "fsl,capture-dma", 0);
 		if (np == dma_channel_np)
 			return ssi_np;
+		of_node_put(np);
 	}
 
 	return NULL;

