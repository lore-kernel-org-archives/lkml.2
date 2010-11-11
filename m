Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab0KKL0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:26:15 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:13733
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564Ab0KKL0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:26:14 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
From: Li Yang <leoli@freescale.com>
To: <dan.j.williams@intel.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, Li Yang <leoli@freescale.com>
Subject: [PATCH v2] fsldma: add support to 36-bit physical address
Date: Thu, 11 Nov 2010 20:16:29 +0800
Message-ID: <1289477789-10651-1-git-send-email-leoli@freescale.com>
X-Mailer: git-send-email 1.6.6-rc1.GIT
X-OriginalArrivalTime: 11 Nov 2010 11:26:51.0926 (UTC) FILETIME=[565C5B60:01CB8193]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand the dma_mask of fsldma device to 36-bit, indicating that the
DMA engine can deal with 36-bit physical address and does not need
the SWIOTLB to create bounce buffer for it when doing dma_map_*().

Signed-off-by: Li Yang <leoli@freescale.com>
---
Add more detailed commit message

 drivers/dma/fsldma.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index cea08be..8c79b37 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1,7 +1,7 @@
 /*
  * Freescale MPC85xx, MPC83xx DMA Engine support
  *
- * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ * Copyright (C) 2007-2010 Freescale Semiconductor, Inc. All rights reserved.
  *
  * Author:
  *   Zhang Wei <wei.zhang@freescale.com>, Jul 2007
@@ -1338,6 +1338,8 @@ static int __devinit fsldma_of_probe(struct platform_device *op,
 	fdev->common.device_control = fsl_dma_device_control;
 	fdev->common.dev = &op->dev;
 
+	dma_set_mask(&(op->dev), DMA_BIT_MASK(36));
+
 	dev_set_drvdata(&op->dev, fdev);
 
 	/*
-- 
1.6.6-rc1.GIT


