Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1J1RxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:53:15 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:40590 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab1J1RxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:53:11 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 11/13] mtd/docg3: map erase and write functions
Date: Fri, 28 Oct 2011 19:51:30 +0200
Message-Id: <1319824292-11085-12-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Map the developped write and erase functions into the mtd
structure.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 6e323f3..9983594 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -41,8 +41,6 @@
  *
  * As no specification is available from M-Systems/Sandisk, this drivers lacks
  * several functions available on the chip, as :
- *  - block erase
- *  - page write
  *  - IPL write
  *  - ECC fixing (lack of BCH algorith understanding)
  *  - powerdown / powerup
@@ -1467,23 +1465,19 @@ static void __init doc_set_driver_info(int chip_id, struct mtd_info *mtd)
 		break;
 	}
 	mtd->type = MTD_NANDFLASH;
-	/*
-	 * Once write methods are added, the correct flags will be set.
-	 * mtd->flags = MTD_CAP_NANDFLASH;
-	 */
-	mtd->flags = MTD_CAP_ROM;
+	mtd->flags = MTD_CAP_NANDFLASH;
 	mtd->size = (docg3->max_block + 1) * DOC_LAYOUT_BLOCK_SIZE;
 	mtd->erasesize = DOC_LAYOUT_BLOCK_SIZE * DOC_LAYOUT_NBPLANES;
 	mtd->writesize = DOC_LAYOUT_PAGE_SIZE;
 	mtd->oobsize = DOC_LAYOUT_OOB_SIZE;
 	mtd->owner = THIS_MODULE;
-	mtd->erase = NULL;
+	mtd->erase = doc_erase;
 	mtd->point = NULL;
 	mtd->unpoint = NULL;
 	mtd->read = doc_read;
-	mtd->write = NULL;
+	mtd->write = doc_write;
 	mtd->read_oob = doc_read_oob;
-	mtd->write_oob = NULL;
+	mtd->write_oob = doc_write_oob;
 	mtd->sync = NULL;
 	mtd->block_isbad = doc_block_isbad;
 	mtd->ecclayout = &docg3_oobinfo;
-- 
1.7.5.4

