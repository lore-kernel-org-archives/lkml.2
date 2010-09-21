Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab0IUK1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 06:27:42 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:37646
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752967Ab0IUK1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 06:27:41 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2010 06:27:41 EDT
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
From: Li Yang <leoli@freescale.com>
To: dan.j.williams@intel.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Li Yang <leoli@freescale.com>
Subject: [PATCH] fsldma: add support to 36-bit physical address
Date: Tue, 21 Sep 2010 18:57:18 +0800
Message-ID: <1285066638-7473-1-git-send-email-leoli@freescale.com>
X-Mailer: git-send-email 1.6.6-rc1.GIT
X-OriginalArrivalTime: 21 Sep 2010 10:12:33.0578 (UTC) FILETIME=[81E930A0:01CB5975]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/dma/fsldma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index cea08be..9163552 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1,7 +1,7 @@
 /*
  * Freescale MPC85xx, MPC83xx DMA Engine support
  *
- * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ * Copyright (C) 2007-2009 Freescale Semiconductor, Inc. All rights reserved.
  *
  * Author:
  *   Zhang Wei <wei.zhang@freescale.com>, Jul 2007
@@ -1338,6 +1338,7 @@ static int __devinit fsldma_of_probe(struct platform_device *op,
 	fdev->common.device_control = fsl_dma_device_control;
 	fdev->common.dev = &op->dev;
 
+	dma_set_mask(&op->dev, DMA_BIT_MASK(36));
 	dev_set_drvdata(&op->dev, fdev);
 
 	/*
-- 
1.6.6-rc1.GIT


