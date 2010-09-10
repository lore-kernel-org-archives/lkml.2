Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0IJX6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:58:08 -0400
Received: from ns2.cypress.com ([157.95.67.5]:33970 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab0IJX6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:58:07 -0400
Subject: [PATCH] west bridge, pnand hal fixes
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Cypress
Date: Fri, 10 Sep 2010 16:57:56 -0700
Message-Id: <1284163076.16135.10.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes changing some defines, necessary for compilation
with the linux-next tree.

Signed-off-by: David Cross <david.cross@cypress.com>
---
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c linux-next-incremen/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incremen/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c	2010-09-10 14:05:42.000000000 -0700
@@ -359,9 +359,9 @@ static int cy_as_hal_gpmc_init(void)
 	/*
 	 * these are globals are full VMAs of the gpmc_base above
 	 */
-	ncmd_reg_vma = GPMC_VMA(GPMC_NAND_CMD);
-	naddr_reg_vma = GPMC_VMA(GPMC_NAND_ADDR);
-	ndata_reg_vma = GPMC_VMA(GPMC_NAND_DATA);
+	ncmd_reg_vma = GPMC_VMA(AST_GPMC_NAND_CMD);
+	naddr_reg_vma = GPMC_VMA(AST_GPMC_NAND_ADDR);
+	ndata_reg_vma = GPMC_VMA(AST_GPMC_NAND_DATA);
 
 	/*
 	 * request GPMC CS for ASTORIA request
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasmemmap.h linux-next-incremen/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasmemmap.h
--- linux-next-vanilla/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasmemmap.h	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incremen/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasmemmap.h	2010-09-10 14:00:15.000000000 -0700
@@ -31,6 +31,9 @@
 #define _INCLUDED_CYASMEMMAP_H_
 
 /* defines copied from OMAP kernel branch */
+
+#define OMAP2_PULL_UP		(1 << 4)
+#define OMAP2_PULL_ENA		(1 << 3)
 #define	OMAP34XX_MUX_MODE0	0
 #define	OMAP34XX_MUX_MODE4	4
 #define OMAP3_INPUT_EN		(1 << 8)
@@ -250,9 +253,9 @@
 /*
  *gpmc nand registers for CS4
  */
-#define GPMC_NAND_CMD		(0x7c + (0x30*AST_GPMC_CS))
-#define GPMC_NAND_ADDR		(0x80 + (0x30*AST_GPMC_CS))
-#define GPMC_NAND_DATA		(0x84 + (0x30*AST_GPMC_CS))
+#define AST_GPMC_NAND_CMD		(0x7c + (0x30*AST_GPMC_CS))
+#define AST_GPMC_NAND_ADDR		(0x80 + (0x30*AST_GPMC_CS))
+#define AST_GPMC_NAND_DATA		(0x84 + (0x30*AST_GPMC_CS))
 
 #define GPMC_STAT_REG		(0x54)
 #define GPMC_ERR_TYPE	   (0x48)


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

