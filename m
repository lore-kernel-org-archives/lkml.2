Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2AMDKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 22:10:50 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:14098 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2AMDKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 22:10:13 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dhc1ahc1bh87h2a8h668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Richard Zhao <richard.zhao@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <eric.miao@linaro.org>, <patches@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>
Subject: [PATCH v2 1/6] dma/imx-sdma: let sdma_run_channel call sdma_enable_channel
Date: Fri, 13 Jan 2012 11:09:56 +0800
Message-ID: <1326424201-20056-2-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
References: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let all enable channel code call sdma_enable_channel.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
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


