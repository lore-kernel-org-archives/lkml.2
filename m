Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056Ab1C3VI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:48428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965020Ab1C3VIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133646"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: axel.lin@gmail.com, Artem.Bityutskiy@nokia.com, David.Woodhouse@intel.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [185/275] mtd: add "platform:" prefix for platform modalias
Message-Id: <20110330210708.7D34B3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Axel Lin <axel.lin@gmail.com>

commit c804c733846572ca85c2bba60c7fe6fa024dff18 upstream.

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/mtd/nand/omap2.c      |    2 +-
 drivers/mtd/onenand/generic.c |    2 +-
 drivers/mtd/onenand/omap2.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/mtd/nand/omap2.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mtd/nand/omap2.c	2011-03-29 22:50:48.138026688 -0700
+++ linux-2.6.35.y/drivers/mtd/nand/omap2.c	2011-03-29 23:03:02.106246277 -0700
@@ -1077,6 +1077,6 @@
 module_init(omap_nand_init);
 module_exit(omap_nand_exit);
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Glue layer for NAND flash on TI OMAP boards");
Index: linux-2.6.35.y/drivers/mtd/onenand/generic.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mtd/onenand/generic.c	2011-03-29 22:50:48.138026688 -0700
+++ linux-2.6.35.y/drivers/mtd/onenand/generic.c	2011-03-29 23:03:02.106246277 -0700
@@ -131,7 +131,7 @@
 	.remove		= __devexit_p(generic_onenand_remove),
 };
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 
 static int __init generic_onenand_init(void)
 {
Index: linux-2.6.35.y/drivers/mtd/onenand/omap2.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mtd/onenand/omap2.c	2011-03-29 22:50:48.138026688 -0700
+++ linux-2.6.35.y/drivers/mtd/onenand/omap2.c	2011-03-29 23:03:02.107246252 -0700
@@ -815,7 +815,7 @@
 module_init(omap2_onenand_init);
 module_exit(omap2_onenand_exit);
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarkko Lavinen <jarkko.lavinen@nokia.com>");
 MODULE_DESCRIPTION("Glue layer for OneNAND flash on OMAP2 / OMAP3");
