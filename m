Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1HBPgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 11:36:16 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:51843 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699Ab1HBPgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 11:36:08 -0400
From: Per Forlin <per.forlin@stericsson.com>
To: Felipe Balbi <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>, <users@igloocommunity.org>,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH] usb: musb: ux500: set dma config for both src and dst
Date: Tue, 2 Aug 2011 17:33:39 +0200
Message-ID: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@linaro.org>

The dma driver requires both src and dst to be set.
This fix is needed in order to run gadget mass storage.
Patch is verified on snowball.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/usb/musb/ux500_dma.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index cecace4..2313475 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -133,15 +133,13 @@ static bool ux500_configure_channel(struct dma_channel *channel,
 					DMA_SLAVE_BUSWIDTH_4_BYTES;
 
 	slave_conf.direction = direction;
-	if (direction == DMA_FROM_DEVICE) {
-		slave_conf.src_addr = usb_fifo_addr;
-		slave_conf.src_addr_width = addr_width;
-		slave_conf.src_maxburst = 16;
-	} else {
-		slave_conf.dst_addr = usb_fifo_addr;
-		slave_conf.dst_addr_width = addr_width;
-		slave_conf.dst_maxburst = 16;
-	}
+	slave_conf.src_addr = usb_fifo_addr;
+	slave_conf.src_addr_width = addr_width;
+	slave_conf.src_maxburst = 16;
+	slave_conf.dst_addr = usb_fifo_addr;
+	slave_conf.dst_addr_width = addr_width;
+	slave_conf.dst_maxburst = 16;
+
 	dma_chan->device->device_control(dma_chan, DMA_SLAVE_CONFIG,
 					     (unsigned long) &slave_conf);
 
-- 
1.6.3.3

