Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965683Ab2DLQNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:13:11 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:54411 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965639Ab2DLQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:13:07 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] dma/ste_dma40: fix erroneous comparison
Date: Thu, 12 Apr 2012 18:12:52 +0200
Message-ID: <1334247172-17388-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

A small fallout from Vinod's conversions to dma_transfer_direction,
this small comparison was done with a dma_data_direction instead.
Fix it by comparing against the correct enum.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 94d760e..f591194 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2071,7 +2071,7 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	if (sg_next(&sg_src[sg_len - 1]) == sg_src)
 		desc->cyclic = true;
 
-	if (direction != DMA_NONE) {
+	if (direction != DMA_TRANS_NONE) {
 		dma_addr_t dev_addr = d40_get_dev_addr(chan, direction);
 
 		if (direction == DMA_DEV_TO_MEM)
-- 
1.7.9.2

