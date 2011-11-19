Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1KSPDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 10:03:51 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:52071 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab1KSPDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 10:03:47 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 07/16] mtd/docg3: add OOB layout to mtdinfo
Date: Sat, 19 Nov 2011 16:02:49 +0100
Message-Id: <1321714978-24543-8-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
References: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OOB layout description for docg3, so that userspace can
use this information to setup the data for write_oob().

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

---
Since V1: added ECC oobavail field for OOB auto placement
---
 drivers/mtd/devices/docg3.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 6eca7f6..27c4fea 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -63,6 +63,20 @@
  *
  */
 
+/**
+ * struct docg3_oobinfo - DiskOnChip G3 OOB layout
+ * @eccbytes: 8 bytes are used (1 for Hamming ECC, 7 for BCH ECC)
+ * @eccpos: ecc positions (byte 7 is Hamming ECC, byte 8-14 are BCH ECC)
+ * @oobfree: free pageinfo bytes (byte 0 until byte 6, byte 15
+ * @oobavail: 8 available bytes remaining after ECC toll
+ */
+static struct nand_ecclayout docg3_oobinfo = {
+	.eccbytes = 8,
+	.eccpos = {7, 8, 9, 10, 11, 12, 13, 14},
+	.oobfree = {{0, 7}, {15, 1} },
+	.oobavail = 8,
+};
+
 static inline u8 doc_readb(struct docg3 *docg3, u16 reg)
 {
 	u8 val = readb(docg3->base + reg);
@@ -973,6 +987,7 @@ static void __init doc_set_driver_info(int chip_id, struct mtd_info *mtd)
 	mtd->write_oob = NULL;
 	mtd->sync = NULL;
 	mtd->block_isbad = doc_block_isbad;
+	mtd->ecclayout = &docg3_oobinfo;
 }
 
 /**
-- 
1.7.5.4

