Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab2AMDK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 22:10:57 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:25370
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757237Ab2AMDKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 22:10:18 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dhc1ahc1bh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Richard Zhao <richard.zhao@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <eric.miao@linaro.org>, <patches@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>
Subject: [PATCH v2 3/6] dma/imx-sdma: call sdma_set_channel_priority after sdma_request_channel
Date: Fri, 13 Jan 2012 11:09:58 +0800
Message-ID: <1326424201-20056-4-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
References: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdma_request_channel sets the default priority. sdma_alloc_chan_resources
should call sdma_set_channel_priority thereafter to over write it.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/dma/imx-sdma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 63f4752..b40f630 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -875,11 +875,11 @@ static int sdma_alloc_chan_resources(struct dma_chan *chan)
 
 	sdmac->peripheral_type = data->peripheral_type;
 	sdmac->event_id0 = data->dma_request;
-	ret = sdma_set_channel_priority(sdmac, prio);
+	ret = sdma_request_channel(sdmac);
 	if (ret)
 		return ret;
 
-	ret = sdma_request_channel(sdmac);
+	ret = sdma_set_channel_priority(sdmac, prio);
 	if (ret)
 		return ret;
 
-- 
1.7.5.4


