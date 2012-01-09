Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab2AIItc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:49:32 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:26902 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2AIIt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:49:29 -0500
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
Subject: [PATCH 1/2] dma/imx-sdma: call sdma_set_channel_priority after sdma_request_channel
Date: Mon, 9 Jan 2012 16:48:59 +0800
Message-ID: <1326098940-3697-1-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdma_request_channel sets the default priority. sdma_alloc_chan_resources
should call sdma_set_channel_priority thereafter to over write it.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
---
 drivers/dma/imx-sdma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 2cc96c4..6376009 100644
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


