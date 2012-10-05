Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2JEKSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:18:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62685 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab2JEKSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:18:18 -0400
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jassisinghbrar@gmail.com, boojin.kim@samsung.com, vinod.koul@intel.com,
        patches@linaro.org, kgene.kim@samsung.com
Subject: [PATCH v2 4/4] DMA: PL330: unregister dma_device in module's remove function
Date: Fri,  5 Oct 2012 15:47:56 +0530
Message-Id: <1349432276-22919-5-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unregister dma_device in module's remove function.

Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
---
 drivers/dma/pl330.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 4b7a34d..e7dc040 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -3017,6 +3017,8 @@ static int __devexit pl330_remove(struct amba_device *adev)
 			return -EBUSY;
 	}
 
+	dma_async_device_unregister(&pdmac->ddma);
+
 	amba_set_drvdata(adev, NULL);
 
 	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
-- 
1.7.9.5

