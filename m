Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505Ab0KQGlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:41:24 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57973 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934439Ab0KQGlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:41:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GPXDNVmm8x3Zw6hZMthnJN3bKKiu0Ho0wL1rODMJsDrnCAT1KYA8PgRsS/MdRYEdNx
         DefgnMCJFsDQuBaN64y8kxdGv1Asn98KkyKsL1waQT6/HdkomxiySzsCntFWBgqdF6A9
         QEr1dXM6sqTXwL6Uy6jxMuACh8Od07Gw5tqrc=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
        g.liakhovetski@gmx.de, linux-sh@vger.kernel.org
Date: Wed, 17 Nov 2010 15:44:15 +0900
Message-Id: <20101117064415.18139.28996.sendpatchset@t400s>
In-Reply-To: <20101117064405.18139.57035.sendpatchset@t400s>
References: <20101117064405.18139.57035.sendpatchset@t400s>
Subject: [PATCH 01/05] fbdev: sh_mipi_dsi: Remove request/release mem region
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

The driver core already manages resources for us, so
there is no need to perform request_mem_region() and
release_mem_region() in the MIPI-DSI driver.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/video/sh_mipi_dsi.c |   11 -----------
 1 file changed, 11 deletions(-)

--- 0001/drivers/video/sh_mipi_dsi.c
+++ work/drivers/video/sh_mipi_dsi.c	2010-11-16 17:34:08.000000000 +0900
@@ -344,12 +344,6 @@ static int __init sh_mipi_probe(struct p
 		goto ealloc;
 	}
 
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev, "MIPI register region already claimed\n");
-		ret = -EBUSY;
-		goto ereqreg;
-	}
-
 	mipi->base = ioremap(res->start, resource_size(res));
 	if (!mipi->base) {
 		ret = -ENOMEM;
@@ -433,8 +427,6 @@ esettrate:
 eclktget:
 	iounmap(mipi->base);
 emap:
-	release_mem_region(res->start, resource_size(res));
-ereqreg:
 	kfree(mipi);
 ealloc:
 efindslot:
@@ -446,7 +438,6 @@ efindslot:
 static int __exit sh_mipi_remove(struct platform_device *pdev)
 {
 	struct sh_mipi_dsi_info *pdata = pdev->dev.platform_data;
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct sh_mipi *mipi = platform_get_drvdata(pdev);
 	int i, ret;
 
@@ -476,8 +467,6 @@ static int __exit sh_mipi_remove(struct 
 	clk_put(mipi->dsit_clk);
 	clk_put(mipi->dsip_clk);
 	iounmap(mipi->base);
-	if (res)
-		release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
 	kfree(mipi);
 
