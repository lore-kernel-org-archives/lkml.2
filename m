Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1KXLr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:47:57 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:62607 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1KXLrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:47:55 -0500
Date: Thu, 24 Nov 2011 14:47:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] dmatest: store correct thread count in dmatest_add_channel()
Message-ID: <20111124114734.GB32522@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4ECE2EEA.0146,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code added 1 to the thread_count, but the intent was to
add += cnt.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 2b8661b..24225f0 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -599,7 +599,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
 	}
 	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
 		cnt = dmatest_add_threads(dtc, DMA_PQ);
-		thread_count += cnt > 0 ?: 0;
+		thread_count += cnt > 0 ? cnt : 0;
 	}
 
 	pr_info("dmatest: Started %u threads using %s\n",
