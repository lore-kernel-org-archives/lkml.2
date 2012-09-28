Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031365Ab2I1Tei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:34:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965384Ab2I1TA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 143/262] DMA: PL330: Check the pointer returned by kzalloc
Date: Fri, 28 Sep 2012 11:51:12 -0700
Message-Id: <20120928183014.951635373@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2930,6 +2930,11 @@ pl330_probe(struct amba_device *adev, co
 		num_chan = max_t(int, pi->pcfg.num_peri, pi->pcfg.num_chan);
 
 	pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
+	if (!pdmac->peripherals) {
+		ret = -ENOMEM;
+		dev_err(&adev->dev, "unable to allocate pdmac->peripherals\n");
+		goto probe_err5;
+	}
 
 	for (i = 0; i < num_chan; i++) {
 		pch = &pdmac->peripherals[i];


