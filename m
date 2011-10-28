Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1J1Rww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:52:52 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:48566 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1J1Rwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:52:50 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 06/13] mtd/docg3: add OOB layout to mtdinfo
Date: Fri, 28 Oct 2011 19:51:25 +0200
Message-Id: <1319824292-11085-7-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OOB layout description for docg3, so that userspace can
use this information to setup the data for write_oob().

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 709d886..26fc135 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -63,6 +63,18 @@
  *
  */
 
+/**
+ * struct docg3_oobinfo - DiskOnChip G3 OOB layout
+ * @eccbytes: 8 bytes are used (1 for Hamming ECC, 7 for BCH ECC)
+ * @eccpos: ecc positions (byte 7 is Hamming ECC, byte 8-14 are BCH ECC)
+ * @oobfree: free pageinfo bytes (byte 0 until byte 6, byte 15
+ */
+static struct nand_ecclayout docg3_oobinfo = {
+	.eccbytes = 8,
+	.eccpos = {7, 8, 9, 10, 11, 12, 13, 14},
+	.oobfree = {{0, 7}, {15, 1} }
+};
+
 static inline u8 doc_readb(struct docg3 *docg3, u16 reg)
 {
 	u8 val = readb(docg3->base + reg);
@@ -977,6 +989,7 @@ static void __init doc_set_driver_info(int chip_id, struct mtd_info *mtd)
 	mtd->write_oob = NULL;
 	mtd->sync = NULL;
 	mtd->block_isbad = doc_block_isbad;
+	mtd->ecclayout = &docg3_oobinfo;
 }
 
 /**
-- 
1.7.5.4

