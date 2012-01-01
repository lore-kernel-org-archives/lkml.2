Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab2AAOjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 09:39:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37761 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2AAOiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 09:38:55 -0500
From: Richard Zhao <richard.zhao@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, eric.miao@linaro.org, patches@linaro.org,
        Richard Zhao <richard.zhao@linaro.org>
Subject: [PATCH v2 2/2] dma/imx-sdma: add wmb before enable a channel
Date: Sun,  1 Jan 2012 22:38:12 +0800
Message-Id: <1325428692-11473-3-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1325428692-11473-1-git-send-email-richard.zhao@linaro.org>
References: <1325428692-11473-1-git-send-email-richard.zhao@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_alloc_coherent memory may be bufferable. We need to add
nececcary memory barrier.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
---
 drivers/dma/imx-sdma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index f8e87b5..9301bff 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -394,6 +394,7 @@ static int sdma_config_ownership(struct sdma_channel *sdmac,
 
 static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
 {
+	wmb();
 	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
 }
 
-- 
1.7.4.1

