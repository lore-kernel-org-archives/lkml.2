Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab2HOJ3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:29:40 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:24786
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab2HOJ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:29:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Huang Shijie <b32955@freescale.com>
To: <linux@arm.linux.org.uk>
CC: <vapier@gentoo.org>, <ralf@linux-mips.org>, <benh@kernel.crashing.org>,
        <paulus@samba.org>, <robert.richter@amd.com>, <a.p.zijlstra@chello.nl>,
        <mingo@kernel.org>, <kgene.kim@samsung.com>, <wim@iguana.be>,
        <FlorianSchandinat@gmx.de>, <balbi@ti.com>, <linus.walleij@linaro.org>,
        <arnd@arndb.de>, <scott.jiang.linux@gmail.com>, <lliubbo@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>, <linux-mips@linux-mips.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-mtd@lists.infradead.org>,
        <akpm@linux-foundation.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH] kconfig: remove CONFIG_MTD_NAND_VERIFY_WRITE
Date: Wed, 15 Aug 2012 17:12:10 +0800
Message-ID: <1345021930-5033-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as Artem suggested:

"Both UBI and JFFS2 are able to read verify what they wrote already.
There are also MTD tests which do this verification. So I think there
is no reason to keep this in the NAND layer, let alone wasting RAM in
the driver to support this feature."

So kill MTD_NAND_VERIFY_WRITE entirely. Please see the patch:
http://lists.infradead.org/pipermail/linux-mtd/2012-August/043189.html
  
This patch removes the CONFIG_MTD_NAND_VERIFY_WRITE in the defconfigs.


Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 arch/arm/configs/bcmring_defconfig              |    1 -
 arch/arm/configs/cam60_defconfig                |    1 -
 arch/arm/configs/corgi_defconfig                |    1 -
 arch/arm/configs/ep93xx_defconfig               |    1 -
 arch/arm/configs/mini2440_defconfig             |    1 -
 arch/arm/configs/mv78xx0_defconfig              |    1 -
 arch/arm/configs/nhk8815_defconfig              |    1 -
 arch/arm/configs/orion5x_defconfig              |    1 -
 arch/arm/configs/pxa3xx_defconfig               |    1 -
 arch/arm/configs/spitz_defconfig                |    1 -
 arch/blackfin/configs/BF561-ACVILON_defconfig   |    1 -
 arch/mips/configs/rb532_defconfig               |    1 -
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig |    1 -
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig |    1 -
 arch/powerpc/configs/mpc83xx_defconfig          |    1 -
 15 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/arm/configs/bcmring_defconfig b/arch/arm/configs/bcmring_defconfig
index 9e6a8fe..6c389d9 100644
--- a/arch/arm/configs/bcmring_defconfig
+++ b/arch/arm/configs/bcmring_defconfig
@@ -44,7 +44,6 @@ CONFIG_MTD_CFI_ADV_OPTIONS=y
 CONFIG_MTD_CFI_GEOMETRY=y
 # CONFIG_MTD_CFI_I2 is not set
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_BCM_UMI=y
 CONFIG_MTD_NAND_BCM_UMI_HWCS=y
 # CONFIG_MISC_DEVICES is not set
diff --git a/arch/arm/configs/cam60_defconfig b/arch/arm/configs/cam60_defconfig
index cedc92e..1457971 100644
--- a/arch/arm/configs/cam60_defconfig
+++ b/arch/arm/configs/cam60_defconfig
@@ -49,7 +49,6 @@ CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_PLATRAM=m
 CONFIG_MTD_DATAFLASH=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_ATMEL=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
index e53c475..4b8a25d 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -97,7 +97,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_ROM=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_SHARPSL=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_IDE=y
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 8e97b2f..806005a 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -61,7 +61,6 @@ CONFIG_MTD_CFI_STAA=y
 CONFIG_MTD_ROM=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_BLK_DEV_NBD=y
 CONFIG_EEPROM_LEGACY=y
 CONFIG_SCSI=y
diff --git a/arch/arm/configs/mini2440_defconfig b/arch/arm/configs/mini2440_defconfig
index 082175c..00630e6 100644
--- a/arch/arm/configs/mini2440_defconfig
+++ b/arch/arm/configs/mini2440_defconfig
@@ -102,7 +102,6 @@ CONFIG_MTD_CFI_STAA=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_ROM=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_S3C2410=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_MTD_LPDDR=y
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index 7305ebd..1f08219 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -49,7 +49,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_ORION=y
 CONFIG_BLK_DEV_LOOP=y
 # CONFIG_SCSI_PROC_FS is not set
diff --git a/arch/arm/configs/nhk8815_defconfig b/arch/arm/configs/nhk8815_defconfig
index bf123c5..240b25e 100644
--- a/arch/arm/configs/nhk8815_defconfig
+++ b/arch/arm/configs/nhk8815_defconfig
@@ -57,7 +57,6 @@ CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ECC_SMC=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_NOMADIK=y
 CONFIG_MTD_ONENAND=y
 CONFIG_MTD_ONENAND_VERIFY_WRITE=y
diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
index a288d70..cd5e6ba 100644
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -72,7 +72,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_MTD_NAND_ORION=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/arch/arm/configs/pxa3xx_defconfig b/arch/arm/configs/pxa3xx_defconfig
index 1677a06..60e3138 100644
--- a/arch/arm/configs/pxa3xx_defconfig
+++ b/arch/arm/configs/pxa3xx_defconfig
@@ -36,7 +36,6 @@ CONFIG_MTD_CONCAT=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_PXA3xx=y
 CONFIG_MTD_NAND_PXA3xx_BUILTIN=y
 CONFIG_MTD_ONENAND=y
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index 7015827..df77931 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -94,7 +94,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_ROM=y
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_SHARPSL=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_IDE=y
diff --git a/arch/blackfin/configs/BF561-ACVILON_defconfig b/arch/blackfin/configs/BF561-ACVILON_defconfig
index 0fdc4ec..9198837 100644
--- a/arch/blackfin/configs/BF561-ACVILON_defconfig
+++ b/arch/blackfin/configs/BF561-ACVILON_defconfig
@@ -57,7 +57,6 @@ CONFIG_MTD_PLATRAM=y
 CONFIG_MTD_PHRAM=y
 CONFIG_MTD_BLOCK2MTD=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index 55902d9..b85b121 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -119,7 +119,6 @@ CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_BLOCK2MTD=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_ATA=y
 # CONFIG_ATA_VERBOSE_ERROR is not set
diff --git a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
index 126ef1b..e4ad2e2 100644
--- a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
@@ -38,7 +38,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_FSL_ELBC=y
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
index abcf00a..34ff568 100644
--- a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
@@ -37,7 +37,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
diff --git a/arch/powerpc/configs/mpc83xx_defconfig b/arch/powerpc/configs/mpc83xx_defconfig
index 5aac9a8..f6fc66c 100644
--- a/arch/powerpc/configs/mpc83xx_defconfig
+++ b/arch/powerpc/configs/mpc83xx_defconfig
@@ -52,7 +52,6 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
 CONFIG_MTD_NAND_FSL_ELBC=y
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
-- 
1.7.0.4


