Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2JGX0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:26:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38698 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754686Ab2JGXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:28 -0400
Message-Id: <20121007225838.314150856@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 026/108] DMA: PL330: Check the pointer returned by kzalloc
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 61c6e7531d3b66b33187b8cdd700fd8ab93ffd62 upstream.

kzalloc could return NULL. Hence add a check to avoid
NULL pointer dereference.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
[bwh: Backported to 3.2: adjust context and error label]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/dma/pl330.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -858,6 +858,11 @@ pl330_probe(struct amba_device *adev, co
 	/* Initialize channel parameters */
 	num_chan = max(pdat ? pdat->nr_valid_peri : 0, (u8)pi->pcfg.num_chan);
 	pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
+	if (!pdmac->peripherals) {
+		ret = -ENOMEM;
+		dev_err(&adev->dev, "unable to allocate pdmac->peripherals\n");
+		goto probe_err4;
+	}
 
 	for (i = 0; i < num_chan; i++) {
 		pch = &pdmac->peripherals[i];


