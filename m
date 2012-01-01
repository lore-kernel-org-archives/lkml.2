Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab2AAD1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 22:27:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52577 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2AAD1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 22:27:53 -0500
From: Richard Zhao <richard.zhao@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, eric.miao@linaro.org, patches@linaro.org,
        Richard Zhao <richard.zhao@linaro.org>
Subject: [PATCH] dma/imx-sdma: add wmb before enable/run a channel
Date: Sun,  1 Jan 2012 11:27:40 +0800
Message-Id: <1325388460-20678-1-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_alloc_coherent memory may be bufferable. We need to add
nececcary memory barrier.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
---
 drivers/dma/imx-sdma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 2ebb2bc..8cd9492 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -403,6 +403,7 @@ static int sdma_run_channel(struct sdma_channel *sdmac)
 
 	init_completion(&sdmac->done);
 
+	wmb();
 	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
 
 	ret = wait_for_completion_timeout(&sdmac->done, HZ);
@@ -809,6 +810,7 @@ out:
 
 static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
 {
+	wmb();
 	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
 }
 
-- 
1.7.4.1

