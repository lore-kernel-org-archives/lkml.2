Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab2AAOjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 09:39:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37761 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab2AAOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 09:38:47 -0500
From: Richard Zhao <richard.zhao@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, eric.miao@linaro.org, patches@linaro.org,
        Richard Zhao <richard.zhao@linaro.org>
Subject: [PATCH v2 1/2] dma/imx-sdma: let sdma_run_channel call sdma_enable_channel
Date: Sun,  1 Jan 2012 22:38:11 +0800
Message-Id: <1325428692-11473-2-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1325428692-11473-1-git-send-email-richard.zhao@linaro.org>
References: <1325428692-11473-1-git-send-email-richard.zhao@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let all enable channel code call sdma_enable_channel.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
---
 drivers/dma/imx-sdma.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 2ebb2bc..f8e87b5 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -392,6 +392,11 @@ static int sdma_config_ownership(struct sdma_channel *sdmac,
 	return 0;
 }
 
+static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
+{
+	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
+}
+
 /*
  * sdma_run_channel - run a channel and wait till it's done
  */
@@ -403,7 +408,7 @@ static int sdma_run_channel(struct sdma_channel *sdmac)
 
 	init_completion(&sdmac->done);
 
-	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
+	sdma_enable_channel(sdma, channel);
 
 	ret = wait_for_completion_timeout(&sdmac->done, HZ);
 
@@ -807,11 +812,6 @@ out:
 	return ret;
 }
 
-static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
-{
-	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
-}
-
 static dma_cookie_t sdma_assign_cookie(struct sdma_channel *sdmac)
 {
 	dma_cookie_t cookie = sdmac->chan.cookie;
-- 
1.7.4.1

