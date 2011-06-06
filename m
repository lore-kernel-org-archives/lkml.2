Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab1FFUtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:49:17 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:8427 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab1FFUtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:49:16 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1307393344!28043020!16
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] dma: mv_xor: use resource_size()
Date: Mon, 6 Jun 2011 13:49:00 -0700
User-Agent: KMail/1.9.9
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106061349.00474.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Dan Williams <dan.j.williams@intel.com> (supporter:ASYNCHRONOUS TRAN...)
Cc: Vinod Koul <vinod.koul@intel.com> (supporter:DMA GENERIC OFFLO...)

---

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 954e334..9a353c2 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1305,7 +1305,7 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	msp->xor_base = devm_ioremap(&pdev->dev, res->start,
-				     res->end - res->start + 1);
+				     resource_size(res));
 	if (!msp->xor_base)
 		return -EBUSY;
 
@@ -1314,7 +1314,7 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	msp->xor_high_base = devm_ioremap(&pdev->dev, res->start,
-					  res->end - res->start + 1);
+					  resource_size(res));
 	if (!msp->xor_high_base)
 		return -EBUSY;
 
