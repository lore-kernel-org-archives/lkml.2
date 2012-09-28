Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032616Ab2I1U1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:27:49 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51449 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032599Ab2I1U1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 114/218] DMA: PL330: Check the pointer returned by kzalloc
Date: Fri, 28 Sep 2012 13:15:31 -0700
Message-Id: <20120928201514.599733596@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 61c6e7531d3b66b33187b8cdd700fd8ab93ffd62 upstream.

kzalloc could return NULL. Hence add a check to avoid
NULL pointer dereference.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/pl330.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2937,6 +2937,11 @@ pl330_probe(struct amba_device *adev, co
 		num_chan = max_t(int, pi->pcfg.num_peri, pi->pcfg.num_chan);
 
 	pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
+	if (!pdmac->peripherals) {
+		ret = -ENOMEM;
+		dev_err(&adev->dev, "unable to allocate pdmac->peripherals\n");
+		goto probe_err5;
+	}
 
 	for (i = 0; i < num_chan; i++) {
 		pch = &pdmac->peripherals[i];


