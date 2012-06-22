Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab2FVN3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:29:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49007 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab2FVN3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:29:45 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-janitors@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] Atmel NAND ECC: Remove unaffected config option
Date: Fri, 22 Jun 2012 15:29:28 +0200
Message-Id: <1340371768-24703-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit bf4289cba02b8cf770ecd7959ca70839f0dd9d3c removed the use of
CONFIG_MTD_NAND_ATMEL_ECC_NONE and CONFIG_MTD_NAND_ATMEL_ECC_HW but the
Kconfig file was forgotten.

This patch remove those inoperative options.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/configs/afeb9260_defconfig    |    1 -
 arch/arm/configs/at91sam9263_defconfig |    1 -
 arch/arm/configs/qil-a9260_defconfig   |    1 -
 arch/arm/configs/usb-a9260_defconfig   |    1 -
 drivers/mtd/nand/Kconfig               |   40 --------------------------------
 5 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/arch/arm/configs/afeb9260_defconfig b/arch/arm/configs/afeb9260_defconfig
index 2afdf67..c285a9d 100644
--- a/arch/arm/configs/afeb9260_defconfig
+++ b/arch/arm/configs/afeb9260_defconfig
@@ -39,7 +39,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_DATAFLASH=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
-CONFIG_MTD_NAND_ATMEL_ECC_SOFT=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
 CONFIG_ATMEL_SSC=y
diff --git a/arch/arm/configs/at91sam9263_defconfig b/arch/arm/configs/at91sam9263_defconfig
index 1cf9626..585e7e0 100644
--- a/arch/arm/configs/at91sam9263_defconfig
+++ b/arch/arm/configs/at91sam9263_defconfig
@@ -61,7 +61,6 @@ CONFIG_MTD_DATAFLASH=y
 CONFIG_MTD_BLOCK2MTD=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
-CONFIG_MTD_NAND_ATMEL_ECC_SOFT=y
 CONFIG_MTD_UBI=y
 CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/arch/arm/configs/qil-a9260_defconfig b/arch/arm/configs/qil-a9260_defconfig
index 9160f3b..2bb100b 100644
--- a/arch/arm/configs/qil-a9260_defconfig
+++ b/arch/arm/configs/qil-a9260_defconfig
@@ -50,7 +50,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_DATAFLASH=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
-CONFIG_MTD_NAND_ATMEL_ECC_SOFT=y
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
diff --git a/arch/arm/configs/usb-a9260_defconfig b/arch/arm/configs/usb-a9260_defconfig
index 2e39f38..a1501e1 100644
--- a/arch/arm/configs/usb-a9260_defconfig
+++ b/arch/arm/configs/usb-a9260_defconfig
@@ -49,7 +49,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_DATAFLASH=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
-CONFIG_MTD_NAND_ATMEL_ECC_SOFT=y
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 31bb7e5..0d93407 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -406,46 +406,6 @@ config MTD_NAND_ATMEL
 	help
 	  Enables support for NAND Flash / Smart Media Card interface
 	  on Atmel AT91 and AVR32 processors.
-choice
-	prompt "ECC management for NAND Flash / SmartMedia on AT91 / AVR32"
-	depends on MTD_NAND_ATMEL
-
-config MTD_NAND_ATMEL_ECC_HW
-	bool "Hardware ECC"
-	depends on ARCH_AT91SAM9263 || ARCH_AT91SAM9260 || AVR32
-	help
-	  Use hardware ECC instead of software ECC when the chip
-	  supports it.
-
-	  The hardware ECC controller is capable of single bit error
-	  correction and 2-bit random detection per page.
-
-	  NB : hardware and software ECC schemes are incompatible.
-	  If you switch from one to another, you'll have to erase your
-	  mtd partition.
-
-	  If unsure, say Y
-
-config MTD_NAND_ATMEL_ECC_SOFT
-	bool "Software ECC"
-	help
-	  Use software ECC.
-
-	  NB : hardware and software ECC schemes are incompatible.
-	  If you switch from one to another, you'll have to erase your
-	  mtd partition.
-
-config MTD_NAND_ATMEL_ECC_NONE
-	bool "No ECC (testing only, DANGEROUS)"
-	depends on DEBUG_KERNEL
-	help
-	  No ECC will be used.
-	  It's not a good idea and it should be reserved for testing
-	  purpose only.
-
-	  If unsure, say N
-
-endchoice
 
 config MTD_NAND_PXA3xx
 	tristate "Support for NAND flash devices on PXA3xx"
-- 
1.7.2.5

