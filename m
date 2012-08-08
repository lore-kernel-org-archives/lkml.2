Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab2HHMz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:55:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62097 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180Ab2HHMzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:55:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 6/6] ARM: imx: gpmi-nand depends on mxs-dma
Date: Wed,  8 Aug 2012 14:54:53 +0200
Message-Id: <1344430493-5304-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344430493-5304-1-git-send-email-arnd@arndb.de>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Lw1yWhdKZwFCJlJUcV61xs3WARbGeXO4zXB8ph3Lri7
 l5yxoDOZfCaatsxdBqopR1dD1yCr6SUw3nC9abQ+gksSoxLaeF
 gpXtSr3lGLOpigMNVejFbYPQIJO70h7QpQKs7kXA1RHzP+TxSh
 nF0cdDLRcqW44FcUe7C9hYZmDdXXKXMkXcCAzo5YFx0T+Mb+AV
 GZonQwTBUYPmD6nA27jO3aqLJz9wzxlqeT+vds060GvWt0KtAC
 BsXMGZ+hzg+KzBkdIw0h5GDlZh3rgs4JrFUAK8ZegwdTsIazKB
 oT85Vcko9FA4UqZrd67ZyzTG2l00SZlMEkLhYpYwvBm7NLWgJ6
 AosxlTGU+rlKeLOtESpuj4AywdWuKVaELWgjdRScjAeSvl4UmU
 zlbbuMFfEEt9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not currently possible to build the gpmi-nand driver without
also building the mxs-dma driver. Clarify this Kconfig and enable
both in the defconfig file so we can build it again with both enabled.

drivers/built-in.o: In function `gpmi_dma_filter':
clk-fixed-factor.c:(.text+0xafc18): undefined reference to `mxs_dma_is_apbh'
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/configs/imx_v6_v7_defconfig |    1 +
 drivers/mtd/nand/Kconfig             |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index f725b96..3c9f32f 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -192,6 +192,7 @@ CONFIG_RTC_DRV_MC13XXX=y
 CONFIG_RTC_DRV_MXC=y
 CONFIG_DMADEVICES=y
 CONFIG_IMX_SDMA=y
+CONFIG_MXS_DMA=y
 CONFIG_COMMON_CLK_DEBUG=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_EXT2_FS=y
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 31bb7e5..8ca4176 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -480,7 +480,7 @@ config MTD_NAND_NANDSIM
 
 config MTD_NAND_GPMI_NAND
         bool "GPMI NAND Flash Controller driver"
-        depends on MTD_NAND && (SOC_IMX23 || SOC_IMX28 || SOC_IMX6Q)
+        depends on MTD_NAND && MXS_DMA
         help
 	 Enables NAND Flash support for IMX23 or IMX28.
 	 The GPMI controller is very powerful, with the help of BCH
-- 
1.7.10

