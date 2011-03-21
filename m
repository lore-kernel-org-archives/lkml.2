Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1CUXyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:54:15 -0400
Received: from kroah.org ([198.145.64.141]:49213 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab1CUXPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:09 2011
Message-Id: <20110321230709.579698378@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [04/87] mtd: add "platform:" prefix for platform modalias
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit c804c733846572ca85c2bba60c7fe6fa024dff18 upstream.

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/omap2.c      |    2 +-
 drivers/mtd/onenand/generic.c |    2 +-
 drivers/mtd/onenand/omap2.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -968,6 +968,6 @@ static void __exit omap_nand_exit(void)
 module_init(omap_nand_init);
 module_exit(omap_nand_exit);
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Glue layer for NAND flash on TI OMAP boards");
--- a/drivers/mtd/onenand/generic.c
+++ b/drivers/mtd/onenand/generic.c
@@ -131,7 +131,7 @@ static struct platform_driver generic_on
 	.remove		= __devexit_p(generic_onenand_remove),
 };
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 
 static int __init generic_onenand_init(void)
 {
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -815,7 +815,7 @@ static void __exit omap2_onenand_exit(vo
 module_init(omap2_onenand_init);
 module_exit(omap2_onenand_exit);
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarkko Lavinen <jarkko.lavinen@nokia.com>");
 MODULE_DESCRIPTION("Glue layer for OneNAND flash on OMAP2 / OMAP3");


