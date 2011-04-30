Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab1D3NvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 09:51:18 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:64502 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab1D3NvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 09:51:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 4/5] dmaengine: at_hdmac: remove channel status testing in tasklet
Date: Sat, 30 Apr 2011 16:57:48 +0200
Message-Id: <3ed5a90ff2cf3b531d967ca80359de25c7c430f0.1304174965.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1303791881.896.18.camel@vkoul-udesk3>
References: <1303791881.896.18.camel@vkoul-udesk3>
In-Reply-To: <35f32b2bdf51d9d5867ca352ce96d786c74a58eb.1304174965.git.nicolas.ferre@atmel.com>
References: <35f32b2bdf51d9d5867ca352ce96d786c74a58eb.1304174965.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to test if channel is enabled in tasklet:
- in error path, channel is disabled in interrupt routine
- in normal path, this test is performed in sub functions to report
a misuse of the engine.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 8f50a0f..65bd52a 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -472,13 +472,6 @@ static void atc_tasklet(unsigned long data)
 {
 	struct at_dma_chan *atchan = (struct at_dma_chan *)data;
 
-	/* Channel cannot be enabled here */
-	if (atc_chan_is_enabled(atchan)) {
-		dev_err(chan2dev(&atchan->chan_common),
-			"BUG: channel enabled in tasklet\n");
-		return;
-	}
-
 	spin_lock(&atchan->lock);
 	if (test_and_clear_bit(ATC_IS_ERROR, &atchan->status))
 		atc_handle_error(atchan);
-- 
1.7.3

