Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab1CGDAE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 22:00:04 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46677 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab1CGDAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 22:00:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AgN8+NWuWT/s9MS9QuIkfglcf6OfW93iTcv0QDgZrYAa42YDMp+ZDky4W7m122JCar
         1KAdsF+VT8DTUPO7+db94OqmIvFbp3hyXuhh8FAHuLlEETUeXMiTJ3Z5R8NhZQ0XatGV
         oZsbHI2SyCzprQtbG7y59Tr/rb6GIE7JmPyK4=
Subject: [PATCH 2/3] mtd: add "platform:" prefix for platform modalias
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jian Zhang <jzhang@ti.com>, Vimal Singh <vimalsingh@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
In-Reply-To: <1299466949.3879.0.camel@mola>
References: <1299466949.3879.0.camel@mola>
Content-Type: text/plain
Date: Mon, 07 Mar 2011 11:04:24 +0800
Message-Id: <1299467064.3879.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Jian Zhang <jzhang@ti.com>
Cc: Vimal Singh <vimalsingh@ti.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 drivers/mtd/nand/omap2.c      |    2 +-
 drivers/mtd/onenand/generic.c |    2 +-
 drivers/mtd/onenand/omap2.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 4e33972..7b8f1ff 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1159,6 +1159,6 @@ static void __exit omap_nand_exit(void)
 module_init(omap_nand_init);
 module_exit(omap_nand_exit);
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Glue layer for NAND flash on TI OMAP boards");
diff --git a/drivers/mtd/onenand/generic.c b/drivers/mtd/onenand/generic.c
index e789149..ac08750 100644
--- a/drivers/mtd/onenand/generic.c
+++ b/drivers/mtd/onenand/generic.c
@@ -131,7 +131,7 @@ static struct platform_driver generic_onenand_driver = {
 	.remove		= __devexit_p(generic_onenand_remove),
 };
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 
 static int __init generic_onenand_init(void)
 {
diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index ec26399..14a49ab 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -840,7 +840,7 @@ static void __exit omap2_onenand_exit(void)
 module_init(omap2_onenand_init);
 module_exit(omap2_onenand_exit);
 
-MODULE_ALIAS(DRIVER_NAME);
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jarkko Lavinen <jarkko.lavinen@nokia.com>");
 MODULE_DESCRIPTION("Glue layer for OneNAND flash on OMAP2 / OMAP3");
-- 
1.7.2



