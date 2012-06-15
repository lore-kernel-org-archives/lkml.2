Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2FOHFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:05:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:37602 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163Ab2FOHFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:05:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165961740"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@st.com>, Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 9/9] dw_dmac: move from __init to __devinit
Date: Fri, 15 Jun 2012 10:05:13 +0300
Message-Id: <1339743913-6236-10-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
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
index 5d025d3..5217f71 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1379,7 +1379,7 @@ static void dw_dma_off(struct dw_dma *dw)
 		dw->chan[i].initialized = false;
 }
 
-static int __init dw_probe(struct platform_device *pdev)
+static int __devinit dw_probe(struct platform_device *pdev)
 {
 	struct dw_dma_platform_data *pdata;
 	struct resource		*io;
@@ -1513,7 +1513,7 @@ err_kfree:
 	return err;
 }
 
-static int __exit dw_remove(struct platform_device *pdev)
+static int __devexit dw_remove(struct platform_device *pdev)
 {
 	struct dw_dma		*dw = platform_get_drvdata(pdev);
 	struct dw_dma_chan	*dwc, *_dwc;
@@ -1592,7 +1592,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
 #endif
 
 static struct platform_driver dw_driver = {
-	.remove		= __exit_p(dw_remove),
+	.remove		= __devexit_p(dw_remove),
 	.shutdown	= dw_shutdown,
 	.driver = {
 		.name	= "dw_dmac",
-- 
1.7.10

