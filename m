Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1FAWKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:10:48 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:52308 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1FAWKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:10:47 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-209.messagelabs.com!1306966229!6743046!24
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] dma: ipu_idmac.c: use resource_size in ioremap
Date: Wed, 1 Jun 2011 15:10:30 -0700
User-Agent: KMail/1.9.9
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <g.liakhovetski@gmx.de>, <agust@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106011510.30560.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Anatolij Gustschin <agust@denx.de>

---

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index c1a125e..25447a8 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1705,16 +1705,14 @@ static int __init ipu_probe(struct platform_device *pdev)
 		ipu_data.irq_fn, ipu_data.irq_err, ipu_data.irq_base);
 
 	/* Remap IPU common registers */
-	ipu_data.reg_ipu = ioremap(mem_ipu->start,
-				   mem_ipu->end - mem_ipu->start + 1);
+	ipu_data.reg_ipu = ioremap(mem_ipu->start, resource_size(mem_ipu));
 	if (!ipu_data.reg_ipu) {
 		ret = -ENOMEM;
 		goto err_ioremap_ipu;
 	}
 
 	/* Remap Image Converter and Image DMA Controller registers */
-	ipu_data.reg_ic = ioremap(mem_ic->start,
-				  mem_ic->end - mem_ic->start + 1);
+	ipu_data.reg_ic = ioremap(mem_ic->start, resource_size(mem_ic));
 	if (!ipu_data.reg_ic) {
 		ret = -ENOMEM;
 		goto err_ioremap_ic;
