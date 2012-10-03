Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2JCOtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:49:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48045 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab2JCOtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:49:12 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <tony@atomide.com>
CC: <afzal@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <ivan.djelic@parrot.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 1/4] mtd: nand: omap2: Update nerrors using ecc.strength
Date: Wed, 3 Oct 2012 19:59:46 +0530
Message-ID: <1349274589-11389-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update number of errors using nand ecc strength.
Also add macro definitions BCH8_ERROR_MAX & BCH4_ERROR_MAX

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 5b31386... af511a9... M	drivers/mtd/nand/omap2.c
 drivers/mtd/nand/omap2.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 5b31386..af511a9 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -111,6 +111,9 @@
 #define	ECCCLEAR			0x100
 #define	ECC1				0x1
 
+#define BCH8_MAX_ERROR		8	/* upto 8 bit coorectable */
+#define BCH4_MAX_ERROR		4	/* upto 4 bit correctable */
+
 /* oob info generated runtime depending on ecc algorithm and layout selected */
 static struct nand_ecclayout omap_oobinfo;
 /* Define some generic bad / good block scan pattern which are used
@@ -1034,7 +1037,7 @@ static void omap3_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 						   mtd);
 	struct nand_chip *chip = mtd->priv;
 
-	nerrors = (info->nand.ecc.bytes == 13) ? 8 : 4;
+	nerrors = info->nand.ecc.strength;
 	dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
 	/*
 	 * Program GPMC to perform correction on one 512-byte sector at a time.
@@ -1129,13 +1132,14 @@ static int omap3_init_bch(struct mtd_info *mtd, int ecc_opt)
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 						   mtd);
 #ifdef CONFIG_MTD_NAND_OMAP_BCH8
-	const int hw_errors = 8;
+	const int hw_errors = BCH8_MAX_ERROR;
 #else
-	const int hw_errors = 4;
+	const int hw_errors = BCH4_MAX_ERROR;
 #endif
 	info->bch = NULL;
 
-	max_errors = (ecc_opt == OMAP_ECC_BCH8_CODE_HW) ? 8 : 4;
+	max_errors = (ecc_opt == OMAP_ECC_BCH8_CODE_HW) ?
+		BCH8_MAX_ERROR : BCH4_MAX_ERROR;
 	if (max_errors != hw_errors) {
 		pr_err("cannot configure %d-bit BCH ecc, only %d-bit supported",
 		       max_errors, hw_errors);
-- 
1.7.0.4

