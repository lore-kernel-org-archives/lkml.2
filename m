Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab0LIHUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 02:20:32 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:46728 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0LIHUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 02:20:31 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
From: Li Yang <leoli@freescale.com>
To: <dan.j.williams@intel.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] fsldma: fix issue of slow dma
Date: Thu, 9 Dec 2010 16:14:04 +0800
Message-ID: <1291882444-1523-1-git-send-email-leoli@freescale.com>
X-Mailer: git-send-email 1.6.6-rc1.GIT
X-OriginalArrivalTime: 09 Dec 2010 07:21:53.0543 (UTC) FILETIME=[C1021970:01CB9771]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Forrest Shi <b29237@freescale.com>

Fixed fsl dma slow issue by initializing dma mode register with
bandwidth control. It boosts dma performance and should works
with 85xx board.

Signed-off-by: Forrest Shi <b29237@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/dma/fsldma.c |    6 ++++--
 drivers/dma/fsldma.h |    9 ++++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 286c3ac..e5e172d 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -50,9 +50,11 @@ static void dma_init(struct fsldma_chan *chan)
 		 * EIE - Error interrupt enable
 		 * EOSIE - End of segments interrupt enable (basic mode)
 		 * EOLNIE - End of links interrupt enable
+		 * BWC - Bandwidth sharing among channels
 		 */
-		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_EIE
-				| FSL_DMA_MR_EOLNIE | FSL_DMA_MR_EOSIE, 32);
+		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_BWC
+				| FSL_DMA_MR_EIE | FSL_DMA_MR_EOLNIE
+				| FSL_DMA_MR_EOSIE, 32);
 		break;
 	case FSL_DMA_IP_83XX:
 		/* Set the channel to below modes:
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index cb4d6ff..ba9f403 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ * Copyright (C) 2007-2010 Freescale Semiconductor, Inc. All rights reserved.
  *
  * Author:
  *   Zhang Wei <wei.zhang@freescale.com>, Jul 2007
@@ -36,6 +36,13 @@
 #define FSL_DMA_MR_DAHE		0x00002000
 #define FSL_DMA_MR_SAHE		0x00001000
 
+/*
+ * Bandwidth/pause control determines how many bytes a given
+ * channel is allowed to transfer before the DMA engine pauses
+ * the current channel and switches to the next channel
+ */
+#define FSL_DMA_MR_BWC         0x08000000
+
 /* Special MR definition for MPC8349 */
 #define FSL_DMA_MR_EOTIE	0x00000080
 #define FSL_DMA_MR_PRC_RM	0x00000800
-- 
1.6.6-rc1.GIT


