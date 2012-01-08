Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2AHOpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 09:45:10 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:58413
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753777Ab2AHOom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 09:44:42 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Richard Zhao <richard.zhao@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <eric.miao@linaro.org>, <patches@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>
Subject: [PATCH v4 1/2] dma/imx-sdma: let sdma_run_channel call sdma_enable_channel
Date: Sun, 8 Jan 2012 22:44:21 +0800
Message-ID: <1326033862-25351-2-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326033862-25351-1-git-send-email-richard.zhao@linaro.org>
References: <1326033862-25351-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let all enable channel code call sdma_enable_channel.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/dma/imx-sdma.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index f59fd8f..c2bc4f1 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -394,6 +394,11 @@ static int sdma_config_ownership(struct sdma_channel *sdmac,
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
@@ -405,7 +410,7 @@ static int sdma_run_channel(struct sdma_channel *sdmac)
 
 	init_completion(&sdmac->done);
 
-	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
+	sdma_enable_channel(sdma, channel);
 
 	ret = wait_for_completion_timeout(&sdmac->done, HZ);
 
@@ -811,11 +816,6 @@ out:
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
1.7.5.4


