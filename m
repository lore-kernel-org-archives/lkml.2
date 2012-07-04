Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702Ab2GDIIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:08:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36202 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab2GDIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:08:36 -0400
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>, Andrew Victor <linux@maxim.org.za>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 3/5] ubi: kill CONFIG_MTD_UBI_BEB_RESERVE
Date: Wed,  4 Jul 2012 11:06:02 +0300
Message-Id: <1341389164-24409-4-git-send-email-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_MTD_UBI_BEB_RESERVE and MIN_RESEVED_PEBS are no longer used,
since the amount of reserved eraseblocks for bad PEB handling is now
derived from 'ubi->bad_peb_limit' (ubi's maximum expected bad
eraseblocks).

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
 arch/arm/configs/sam9_l9260_defconfig |    1 -
 drivers/mtd/ubi/Kconfig               |   15 ---------------
 drivers/mtd/ubi/ubi.h                 |    3 ---
 3 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index f6917c9..da276f9 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -39,7 +39,6 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_MTD_UBI=y
-CONFIG_MTD_UBI_BEB_RESERVE=3
 CONFIG_MTD_UBI_BEB_LIMIT=3
 CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 7eb91cb..145cda2 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -27,21 +27,6 @@ config MTD_UBI_WL_THRESHOLD
 	  life-cycle less than 10000, the threshold should be lessened (e.g.,
 	  to 128 or 256, although it does not have to be power of 2).
 
-config MTD_UBI_BEB_RESERVE
-	int "Percentage of reserved eraseblocks for bad eraseblocks handling"
-	default 1
-	range 0 25
-	help
-	  If the MTD device admits of bad eraseblocks (e.g. NAND flash), UBI
-	  reserves some amount of physical eraseblocks to handle new bad
-	  eraseblocks. For example, if a flash physical eraseblock becomes bad,
-	  UBI uses these reserved physical eraseblocks to relocate the bad one.
-	  This option specifies how many physical eraseblocks will be reserved
-	  for bad eraseblock handling (percents of total number of good flash
-	  eraseblocks). If the underlying flash does not admit of bad
-	  eraseblocks (e.g. NOR flash), this value is ignored and nothing is
-	  reserved. Leave the default value if unsure.
-
 config MTD_UBI_BEB_LIMIT
 	int "Percentage of maximum expected bad eraseblocks"
 	default 2
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index b5217ef..80c394eb 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -59,9 +59,6 @@
 #define ubi_err(fmt, ...) printk(KERN_ERR "UBI error: %s: " fmt "\n", \
 				 __func__, ##__VA_ARGS__)
 
-/* Lowest number PEBs reserved for bad PEB handling */
-#define MIN_RESEVED_PEBS 2
-
 /* Background thread name pattern */
 #define UBI_BGT_NAME_PATTERN "ubi_bgt%dd"
 
-- 
1.7.9

