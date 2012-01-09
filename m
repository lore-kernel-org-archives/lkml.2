Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2AIHL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:11:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60838 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2AIHL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:11:26 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-b6-4f0a931d4055
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: "'Vinod Koul'" <vinod.koul@intel.com>,
        "'Dan Williams'" <dan.j.williams@intel.com>,
        "'Boojin Kim'" <boojin.kim@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: [PATCH] DMA: PL330: Fix calculating burst_size
Date: Mon, 09 Jan 2012 16:11:20 +0900
Message-id: <002901ccce9d$e4d84db0$ae88e910$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczOneMm29+xgXCpQKC485X8lbdGyw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boojin Kim <boojin.kim@samsung.com>

The burst size of PL330 DMAC should be aligned with source
address, destination address and size. If not, PL330 DMAC
HW generates transmit or data mismatch error. This patch
adds the condition that checks the align of source and
destination address for burst size.

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/dma/pl330.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index d87d884..c3f7fcb 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2553,7 +2553,7 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 	burst = pi->pcfg.data_bus_width / 8;
 
 	while (burst > 1) {
-		if (!(len % burst))
+		if (!(len % burst) && !(dst % burst) && !(src % burst))
 			break;
 		burst /= 2;
 	}
-- 
1.7.1


