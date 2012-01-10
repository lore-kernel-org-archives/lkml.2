Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab2AJHDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 02:03:30 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19464
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754533Ab2AJHCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 02:02:16 -0500
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
Subject: [PATCH 5/6] dma/imx-sdma: use num_events to validate event_id0
Date: Tue, 10 Jan 2012 15:01:49 +0800
Message-ID: <1326178910-14044-5-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

event number is not always 32. use num_events for checking instead.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
---
 drivers/dma/imx-sdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 015d93f..22fd561 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -723,7 +723,7 @@ static int sdma_config_channel(struct sdma_channel *sdmac)
 	sdmac->per_addr = 0;
 
 	if (sdmac->event_id0) {
-		if (sdmac->event_id0 > 32)
+		if (sdmac->event_id0 >= sdmac->sdma->num_events)
 			return -EINVAL;
 		sdma_event_enable(sdmac, sdmac->event_id0);
 	}
-- 
1.7.5.4


