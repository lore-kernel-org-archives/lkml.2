Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2IQJyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:54:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53405 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab2IQJxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:53:54 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, jassisinghbrar@gmail.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 2/2] DMA: PL330: Check the pointer returned by kzalloc
Date: Mon, 17 Sep 2012 15:20:23 +0530
Message-Id: <1347875423-7970-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1347875423-7970-1-git-send-email-sachin.kamat@linaro.org>
References: <1347875423-7970-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc could return NULL. Hence add a check to avoid
NULL pointer dereference.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/dma/pl330.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 018a445..5d3bbcd 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2930,6 +2930,11 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		num_chan = max_t(int, pi->pcfg.num_peri, pi->pcfg.num_chan);
 
 	pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
+	if (!pdmac->peripherals) {
+		ret = -ENOMEM;
+		dev_err(&adev->dev, "unable to allocate pdmac->peripherals\n");
+		goto probe_err5;
+	}
 
 	for (i = 0; i < num_chan; i++) {
 		pch = &pdmac->peripherals[i];
-- 
1.7.4.1

