Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2FSKej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:34:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:11070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab2FSKee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:34:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="159441823"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 09/10] dw_dmac: move from __init to __devinit
Date: Tue, 19 Jun 2012 13:34:09 +0300
Message-Id: <1340102050-12697-10-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We usually have more than one DMA device. Thus, the probe function should serve
for all of them in case when the driver is built as a module.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9c47279..d3845ef 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1377,7 +1377,7 @@ static void dw_dma_off(struct dw_dma *dw)
 		dw->chan[i].initialized = false;
 }
 
-static int __init dw_probe(struct platform_device *pdev)
+static int __devinit dw_probe(struct platform_device *pdev)
 {
 	struct dw_dma_platform_data *pdata;
 	struct resource		*io;
@@ -1514,7 +1514,7 @@ err_kfree:
 	return err;
 }
 
-static int __exit dw_remove(struct platform_device *pdev)
+static int __devexit dw_remove(struct platform_device *pdev)
 {
 	struct dw_dma		*dw = platform_get_drvdata(pdev);
 	struct dw_dma_chan	*dwc, *_dwc;
@@ -1593,7 +1593,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
 #endif
 
 static struct platform_driver dw_driver = {
-	.remove		= __exit_p(dw_remove),
+	.remove		= __devexit_p(dw_remove),
 	.shutdown	= dw_shutdown,
 	.driver = {
 		.name	= "dw_dmac",
-- 
1.7.10

