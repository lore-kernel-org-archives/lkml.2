Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab0JQOwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:52:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42424 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab0JQOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XGXSQEdLolWRdTl0boLIvk2dqhZQbEg3QVccbqnzOsvnbnfV0Rtn15zQsqmaF7v+dM
         gOHOkKazv7xJ8bL1HPGX0T9QWB1wcv0XjQu191JC9r8B3U82QSYMisR9+M1pihsEzfbf
         G9Lp99KKn2cB6YD3CdAnulQChfe/yVHWqT38U=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dma: imx-dma: fix signedness bug
Date: Sun, 17 Oct 2010 18:51:50 +0400
Message-Id: <1287327110-9158-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mxdmac->channel was unsigned, so check (imxdmac->channel < 0) for
failed imx_dma_request_by_prio() made no sence.  Explicitly check
signed values.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/dma/imx-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 346be62..75d870f 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -335,7 +335,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 
 		imxdmac->imxdma_channel = imx_dma_request_by_prio("dmaengine",
 				DMA_PRIO_MEDIUM);
-		if (imxdmac->channel < 0)
+		if ((int)imxdmac->channel < 0)
 			goto err_init;
 
 		imx_dma_setup_handlers(imxdmac->imxdma_channel,
-- 
1.7.0.4

