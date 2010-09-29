Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0I2UB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:01:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47651 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab0I2UB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JArULpp3QBQBTb5xJYt0vSyQYBX9cGFn1UyQqrBqXwzUAd08ErKx63LLerMPDR0QC8
         TCGZfSSrRMwjRnZ/Y/uXygPNtyi+p2Jr3272zYkgnqanzCyhbeON1usYZN3TTpBgd3r4
         l/9sCUSdfGI63K+7wFiR6f9PpgaCqd8gQX8+A=
MIME-Version: 1.0
Date: Wed, 29 Sep 2010 21:01:55 +0100
Message-ID: <AANLkTime3uHvcrRLnJcM_L81QuQ-38SgL8xOfxK6wOTr@mail.gmail.com>
Subject: [2.6.36-rc6] fix OMAP2 MTD build failure
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus; here is a build failure one-liner:

Fix build failure from recent interface change and merge. Tested on OMAP3430.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 133d515..513e0a7 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -413,7 +413,7 @@ static inline int omap_nand_dma_transfer(struct
mtd_info *mtd, void *addr,
 		prefetch_status = gpmc_read_status(GPMC_PREFETCH_COUNT);
 	} while (prefetch_status);
 	/* disable and stop the PFPW engine */
-	gpmc_prefetch_reset();
+	gpmc_prefetch_reset(info->gpmc_cs);

 	dma_unmap_single(&info->pdev->dev, dma_addr, len, dir);
 	return 0;
-- 
Daniel J Blueman
