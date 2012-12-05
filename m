Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab2LEL0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:26:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11101 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab2LEL0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:26:12 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d8-50bf2f50ec0b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH resend] DMA: add cpu_relax() to busy-loop in dma_sync_wait()
Date: Wed, 05 Dec 2012 12:23:48 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201212051223.49231.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jQd1A/f0BBmvesFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MtZvmMRWc4Kh4cquLrYFxNnsXIyeHhICJxJ31ZxghbDGJC/fW
	s3UxcnEICUxnlPjX1w+WEBJYyiRx4Z8ciM0mYCUxsX0VWFxEQFViy88OMFtYwEfiS2cPE4jN
	AhS/P3cVK4gtKuAg0Tl1AthQZoFuRonTnw6wgCR4BQQlfky+B2YzC2hJNL/ZxAhhy0tsXvOW
	GaLGUqJ18Wb2CYx8s5C0zELSMgtJywJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwSH1
	THoH46oGi0OMAhyMSjy8Esb7AoRYE8uKK3MPMUpwMCuJ8M6T2R8gxJuSWFmVWpQfX1Sak1p8
	iFGag0VJnLfZIyVASCA9sSQ1OzW1ILUIJsvEwSnVwFj/Pf29L7f0ddcUk1keMtcXuVhVf7/M
	KPH+z9J9TBV3OF/qFW+T/O9WX1z77lr2Fa44gyd7tYxuidmU3JhZWcz85qzcpCfzrOM4yxl1
	7vxoOD85xOMrQ4rcKuZVfOVW/Y+CRE3ulLOfcy5teVCn//+XQHyE3xOvYkWWqnCTr+q3n9/o
	4Zx5U4mlOCPRUIu5qDgRAKUXP5ElAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] DMA: add cpu_relax() to busy-loop in dma_sync_wait()

Removal of the busy-loop from dma_sync_wait() is not a trivial
task so just add cpu_relax() to the loop for now.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/dmaengine.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: b/drivers/dma/dmaengine.c
===================================================================
--- a/drivers/dma/dmaengine.c	2012-11-07 16:12:41.776876102 +0100
+++ b/drivers/dma/dmaengine.c	2012-11-07 16:13:04.956876097 +0100
@@ -266,7 +266,10 @@ enum dma_status dma_sync_wait(struct dma
 			pr_err("%s: timeout!\n", __func__);
 			return DMA_ERROR;
 		}
-	} while (status == DMA_IN_PROGRESS);
+		if (status != DMA_IN_PROGRESS)
+			break;
+		cpu_relax();
+	} while (1);
 
 	return status;
 }
