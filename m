Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab2H2EtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 00:49:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51184 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2H2Es5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 00:48:57 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, kgene.kim@samsung.com, jaswinder.singh@linaro.org,
        patches@linaro.org
Subject: [PATCH 2/2] DMA: PL330: Set the capability of pdm0 and pdm1 as DMA_PRIVATE
Date: Wed, 29 Aug 2012 10:16:25 +0530
Message-Id: <1346215585-31023-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346215585-31023-1-git-send-email-tushar.behera@linaro.org>
References: <1346215585-31023-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA clients pdma0 and pdma1 are internal to the SoC and are used only
by dedicated peripherals. Since they cannot be used for generic
purpose, their capability should be set as DMA_PRIVATE.

CC: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/dma/pl330.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index e4feba6..600ea5e 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2954,6 +2954,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		if (pi->pcfg.num_peri) {
 			dma_cap_set(DMA_SLAVE, pd->cap_mask);
 			dma_cap_set(DMA_CYCLIC, pd->cap_mask);
+			dma_cap_set(DMA_PRIVATE, pd->cap_mask);
 		}
 	}
 
-- 
1.7.4.1

