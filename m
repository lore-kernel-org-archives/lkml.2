Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2AJHCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 02:02:23 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19488
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753221Ab2AJHCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 02:02:19 -0500
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
Subject: [PATCH 6/6] dma/imx-sdma: check whether event_id0 < 32 when set event_mask
Date: Tue, 10 Jan 2012 15:01:50 +0800
Message-ID: <1326178910-14044-6-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
---
 drivers/dma/imx-sdma.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 22fd561..1d5b6ab 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -753,8 +753,11 @@ static int sdma_config_channel(struct sdma_channel *sdmac)
 			if (sdmac->event_id0 > 31)
 				sdmac->watermark_level |= 1 << 30;
 		} else {
-			sdmac->event_mask0 = 1 << sdmac->event_id0;
-			sdmac->event_mask1 = 1 << (sdmac->event_id0 - 32);
+			if (sdmac->event_id0 < 32)
+				sdmac->event_mask0 = 1 << sdmac->event_id0;
+			else
+				sdmac->event_mask1 =
+						1 << (sdmac->event_id0 - 32);
 		}
 		/* Watermark Level */
 		sdmac->watermark_level |= sdmac->watermark_level;
-- 
1.7.5.4


