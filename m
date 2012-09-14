Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881Ab2INVfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:35:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab2INVfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
Subject: [PATCH 16/24] ARM: spear13xx: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:44 +0200
Message-Id: <1347658492-11608-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:zyWPd/FkvYholnQnrR9SckkvLYdiGRCLYTq6gxLK8Pp
 opSdF+Iqnv4U9kK9o5tsZB5q2bzowIpIEb2xR60y1eos8tNfqr
 ZaB3mHLLIRMEsmuy8p0D6txXNO4CshFRW0eEacbIRAUPvZCeva
 EgnWVNhLl9WIst4lj0DG95grQU7odDmdDkRbFJHm/yESv9PQVy
 c/8yLTaEbH/1205Fj54kfbpS58HgG+alT5O+qNAshuyfyG0Sqz
 XGJEqtX9QiyDkUB5cocDcNQ2CbddF3xNHgsWIldY9DOZexcxrs
 L4d74ji/YoTNrAhCP75yGShjW/RUXOTniL7nwJYbu52ge2Qha1
 29d+DrILDznJv6a1XloGnUtTNyalH8Kl64Wh3JyPbIE/M3KBdF
 4ke2Ulg6GLifg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Cc: spear-devel@list.st.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-spear13xx/include/mach/spear.h |   14 +++++++-------
 arch/arm/mach-spear13xx/spear13xx.c          |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-spear13xx/include/mach/spear.h b/arch/arm/mach-spear13xx/include/mach/spear.h
index 65f27de..07d90ac 100644
--- a/arch/arm/mach-spear13xx/include/mach/spear.h
+++ b/arch/arm/mach-spear13xx/include/mach/spear.h
@@ -17,26 +17,26 @@
 #include <asm/memory.h>
 
 #define PERIP_GRP2_BASE				UL(0xB3000000)
-#define VA_PERIP_GRP2_BASE			UL(0xFE000000)
+#define VA_PERIP_GRP2_BASE			IOMEM(0xFE000000)
 #define MCIF_SDHCI_BASE				UL(0xB3000000)
 #define SYSRAM0_BASE				UL(0xB3800000)
-#define VA_SYSRAM0_BASE				UL(0xFE800000)
+#define VA_SYSRAM0_BASE				IOMEM(0xFE800000)
 #define SYS_LOCATION				(VA_SYSRAM0_BASE + 0x600)
 
 #define PERIP_GRP1_BASE				UL(0xE0000000)
-#define VA_PERIP_GRP1_BASE			UL(0xFD000000)
+#define VA_PERIP_GRP1_BASE			IOMEM(0xFD000000)
 #define UART_BASE				UL(0xE0000000)
-#define VA_UART_BASE				UL(0xFD000000)
+#define VA_UART_BASE				IOMEM(0xFD000000)
 #define SSP_BASE				UL(0xE0100000)
 #define MISC_BASE				UL(0xE0700000)
-#define VA_MISC_BASE				IOMEM(UL(0xFD700000))
+#define VA_MISC_BASE				IOMEM(0xFD700000)
 
 #define A9SM_AND_MPMC_BASE			UL(0xEC000000)
-#define VA_A9SM_AND_MPMC_BASE			UL(0xFC000000)
+#define VA_A9SM_AND_MPMC_BASE			IOMEM(0xFC000000)
 
 /* A9SM peripheral offsets */
 #define A9SM_PERIP_BASE				UL(0xEC800000)
-#define VA_A9SM_PERIP_BASE			UL(0xFC800000)
+#define VA_A9SM_PERIP_BASE			IOMEM(0xFC800000)
 #define VA_SCU_BASE				(VA_A9SM_PERIP_BASE + 0x00)
 
 #define L2CC_BASE				UL(0xED000000)
diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index cf936b1..e106488 100644
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@ -114,17 +114,17 @@ void __init spear13xx_l2x0_init(void)
  */
 struct map_desc spear13xx_io_desc[] __initdata = {
 	{
-		.virtual	= VA_PERIP_GRP2_BASE,
+		.virtual	= (unsigned long)VA_PERIP_GRP2_BASE,
 		.pfn		= __phys_to_pfn(PERIP_GRP2_BASE),
 		.length		= SZ_16M,
 		.type		= MT_DEVICE
 	}, {
-		.virtual	= VA_PERIP_GRP1_BASE,
+		.virtual	= (unsigned long)VA_PERIP_GRP1_BASE,
 		.pfn		= __phys_to_pfn(PERIP_GRP1_BASE),
 		.length		= SZ_16M,
 		.type		= MT_DEVICE
 	}, {
-		.virtual	= VA_A9SM_AND_MPMC_BASE,
+		.virtual	= (unsigned long)VA_A9SM_AND_MPMC_BASE,
 		.pfn		= __phys_to_pfn(A9SM_AND_MPMC_BASE),
 		.length		= SZ_16M,
 		.type		= MT_DEVICE
-- 
1.7.10

