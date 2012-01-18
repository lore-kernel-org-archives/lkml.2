Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2ARJOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:14:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51189 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab2ARJO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:14:29 -0500
Date: Wed, 18 Jan 2012 10:14:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 1/2] dma: sh_dma: not all SH DMAC implementations support
 MEMCPY
Message-ID: <Pine.LNX.4.64.1201181012130.28782@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:7c353VRDNm+/BUkt0uY0BqMdARQPNzaNN3mgut0rHlz
 EpUPR1nxVoHUjlK0oTlxgMClaejyBOjNIu/wfJXveAV3Gh27nX
 HA5qcOS0YcLKJvhBkOmsOvsrh03mkolPwhxYGoGY4SUcCFUoJz
 XS7+IwPhl50+ZjiCXcx4s9DRd3E8MC/JBelsuh3mKOwisUhSjC
 PTfpheEDRn9gAy1Zj/+aET0YwsvCY70mMmCmY+fLl9DDxVNJIg
 g4+Jn5FeWinguqCtNs25x4xIFs6RxGCzux5m9pQ3zJlN0ntZVu
 XUvbPNvd2DrJXfbMcJkzaQkYeO7wmurUXxtc79tYQJpHv4t5iI
 JDYSpyJduapcpCPgDsOk5KCw12d8EFJ53qwYetYzFK/W1VhsEX
 xdt/5Hw+AFsMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flag to allow platforms to specify, whether a DMAC instance supports
the MEMCPY operation. To avoid regressions, preserve the current default.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/shdma.c    |    3 ++-
 include/linux/sh_dma.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index cabcfe8..e4ed4da 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -1267,7 +1267,8 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&shdev->common.channels);
 
-	dma_cap_set(DMA_MEMCPY, shdev->common.cap_mask);
+	if (!pdata->slave_only)
+		dma_cap_set(DMA_MEMCPY, shdev->common.cap_mask);
 	if (pdata->slave && pdata->slave_num)
 		dma_cap_set(DMA_SLAVE, shdev->common.cap_mask);
 
diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index e11e171..db637b9 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -70,6 +70,7 @@ struct sh_dmae_pdata {
 	unsigned int needs_tend_set:1;
 	unsigned int no_dmars:1;
 	unsigned int chclr_present:1;
+	unsigned int slave_only:1;
 };
 
 /* DMA register */
-- 
1.7.2.5

