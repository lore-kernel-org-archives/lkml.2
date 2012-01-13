Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2AMDKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 22:10:55 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:40440 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab2AMDKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 22:10:20 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dhc1ahc1bh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Richard Zhao <richard.zhao@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <eric.miao@linaro.org>, <patches@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>
Subject: [PATCH v2 4/6] dma/imx-sdma: move clk_enable out of sdma_request_channel
Date: Fri, 13 Jan 2012 11:09:59 +0800
Message-ID: <1326424201-20056-5-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
References: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes clk_enable/disable pair more readable, and fix one bug:
sdma_init calls sdma_request_channel, but seems don't know
sdma_request_channel enabled the clok.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/dma/imx-sdma.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index b40f630..015d93f 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -802,8 +802,6 @@ static int sdma_request_channel(struct sdma_channel *sdmac)
 	sdma->channel_control[channel].base_bd_ptr = sdmac->bd_phys;
 	sdma->channel_control[channel].current_bd_ptr = sdmac->bd_phys;
 
-	clk_enable(sdma->clk);
-
 	sdma_set_channel_priority(sdmac, MXC_SDMA_DEFAULT_PRIORITY);
 
 	init_completion(&sdmac->done);
@@ -875,6 +873,9 @@ static int sdma_alloc_chan_resources(struct dma_chan *chan)
 
 	sdmac->peripheral_type = data->peripheral_type;
 	sdmac->event_id0 = data->dma_request;
+
+	clk_enable(sdmac->sdma->clk);
+
 	ret = sdma_request_channel(sdmac);
 	if (ret)
 		return ret;
-- 
1.7.5.4


