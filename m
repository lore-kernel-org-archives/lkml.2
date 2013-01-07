Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3AGLXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:23:49 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56843 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab3AGLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:23:47 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 04/16] dmaengine: ste_dma40: limit burst size to 16
Date: Mon,  7 Jan 2013 12:21:46 +0100
Message-Id: <1357557718-15676-5-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@stericsson.com>

The client is not aware of the maximum burst size in the dma driver.  If
the size exceeds 16 set max to 16.

Signed-off-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index f5724d9..2d0c63d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2578,6 +2578,14 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 		return -EINVAL;
 	}
 
+	if (src_maxburst > 16) {
+		src_maxburst = 16;
+		dst_maxburst = src_maxburst * src_addr_width / dst_addr_width;
+	} else if (dst_maxburst > 16) {
+		dst_maxburst = 16;
+		src_maxburst = dst_maxburst * dst_addr_width / src_addr_width;
+	}
+
 	ret = dma40_config_to_halfchannel(d40c, &cfg->src_info,
 					  src_addr_width,
 					  src_maxburst);
-- 
1.7.12.1

