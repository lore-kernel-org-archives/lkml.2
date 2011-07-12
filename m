Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1GLNAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:00:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36078 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1GLNAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:00:21 -0400
Subject: [PATCH] dmaengine: imx-sdma: return proper error if kzalloc fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 21:00:13 +0800
Message-ID: <1310475613.2618.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/dma/imx-sdma.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 1ea47db..f96d038 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1281,8 +1281,10 @@ static int __init sdma_probe(struct platform_device *pdev)
 		goto err_request_irq;
 
 	sdma->script_addrs = kzalloc(sizeof(*sdma->script_addrs), GFP_KERNEL);
-	if (!sdma->script_addrs)
+	if (!sdma->script_addrs) {
+		ret = -ENOMEM;
 		goto err_alloc;
+	}
 
 	sdma->version = pdata->sdma_version;
 
-- 
1.7.4.1



