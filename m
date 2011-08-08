Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab1HHKPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 06:15:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35155 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab1HHKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 06:15:50 -0400
Date: Mon, 8 Aug 2011 13:15:46 +0300
From: "Maxin B. John" <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arch:arm:plat-omap:iovmm: remove unused variable 'va'
Message-ID: <20110808101546.GA25572@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer "va" returned from "phys_to_virt(pa)" is never used in
"sgtable_fill_kmalloc()".So,it is safe to remove this set-but-unused variable.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index c60737c..79e7fed 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -423,9 +423,6 @@ static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 pa, u32 da,
 {
 	unsigned int i;
 	struct scatterlist *sg;
-	void *va;
-
-	va = phys_to_virt(pa);
 
 	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
 		unsigned bytes;
