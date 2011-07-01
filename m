Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1GAJSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:18:09 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:34716 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab1GAJSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:18:07 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, patrice.vilchez@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH for 3.0] AT91: Change nand buswidth logic to match hardware default configuration
Date: Fri,  1 Jul 2011 12:25:24 +0200
Message-Id: <1309515924-22531-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently modified nand buswitth configuration is not aligned with
board reality: the double footprint on boards is always populated with 8bits
buswidth nand flashes.
So we have to consider that without particular configuration the 8bits
buswidth is selected by default.
Moreover, the previous logic was always using !board_have_nand_8bit(), we
change it to a simpler: board_have_nand_16bit().

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
 arch/arm/mach-at91/board-cap9adk.c           |    2 +-
 arch/arm/mach-at91/board-sam9260ek.c         |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c         |    2 +-
 arch/arm/mach-at91/board-sam9263ek.c         |    2 +-
 arch/arm/mach-at91/board-sam9g20ek.c         |    2 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c      |    2 +-
 arch/arm/mach-at91/include/mach/system_rev.h |   10 +++++-----
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-at91/board-cap9adk.c b/arch/arm/mach-at91/board-cap9adk.c
index 1904fdf..cdb65d4 100644
--- a/arch/arm/mach-at91/board-cap9adk.c
+++ b/arch/arm/mach-at91/board-cap9adk.c
@@ -215,7 +215,7 @@ static void __init cap9adk_add_device_nand(void)
 	csa = at91_sys_read(AT91_MATRIX_EBICSA);
 	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_EBI_VDDIOMSEL_3_3V);
 
-	cap9adk_nand_data.bus_width_16 = !board_have_nand_8bit();
+	cap9adk_nand_data.bus_width_16 = board_have_nand_16bit();
 	/* setup bus-width (8 or 16) */
 	if (cap9adk_nand_data.bus_width_16)
 		cap9adk_nand_smc_config.mode |= AT91_SMC_DBW_16;
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index d600dc1..5c24074 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -214,7 +214,7 @@ static struct sam9_smc_config __initdata ek_nand_smc_config = {
 
 static void __init ek_add_device_nand(void)
 {
-	ek_nand_data.bus_width_16 = !board_have_nand_8bit();
+	ek_nand_data.bus_width_16 = board_have_nand_16bit();
 	/* setup bus-width (8 or 16) */
 	if (ek_nand_data.bus_width_16)
 		ek_nand_smc_config.mode |= AT91_SMC_DBW_16;
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index f897f84..b60c22b 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -220,7 +220,7 @@ static struct sam9_smc_config __initdata ek_nand_smc_config = {
 
 static void __init ek_add_device_nand(void)
 {
-	ek_nand_data.bus_width_16 = !board_have_nand_8bit();
+	ek_nand_data.bus_width_16 = board_have_nand_16bit();
 	/* setup bus-width (8 or 16) */
 	if (ek_nand_data.bus_width_16)
 		ek_nand_smc_config.mode |= AT91_SMC_DBW_16;
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 605b26f..9bbdc92 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -221,7 +221,7 @@ static struct sam9_smc_config __initdata ek_nand_smc_config = {
 
 static void __init ek_add_device_nand(void)
 {
-	ek_nand_data.bus_width_16 = !board_have_nand_8bit();
+	ek_nand_data.bus_width_16 = board_have_nand_16bit();
 	/* setup bus-width (8 or 16) */
 	if (ek_nand_data.bus_width_16)
 		ek_nand_smc_config.mode |= AT91_SMC_DBW_16;
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
index 7624cf0..1325a50 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -198,7 +198,7 @@ static struct sam9_smc_config __initdata ek_nand_smc_config = {
 
 static void __init ek_add_device_nand(void)
 {
-	ek_nand_data.bus_width_16 = !board_have_nand_8bit();
+	ek_nand_data.bus_width_16 = board_have_nand_16bit();
 	/* setup bus-width (8 or 16) */
 	if (ek_nand_data.bus_width_16)
 		ek_nand_smc_config.mode |= AT91_SMC_DBW_16;
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 063c95d..33eaa13 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -178,7 +178,7 @@ static struct sam9_smc_config __initdata ek_nand_smc_config = {
 
 static void __init ek_add_device_nand(void)
 {
-	ek_nand_data.bus_width_16 = !board_have_nand_8bit();
+	ek_nand_data.bus_width_16 = board_have_nand_16bit();
 	/* setup bus-width (8 or 16) */
 	if (ek_nand_data.bus_width_16)
 		ek_nand_smc_config.mode |= AT91_SMC_DBW_16;
diff --git a/arch/arm/mach-at91/include/mach/system_rev.h b/arch/arm/mach-at91/include/mach/system_rev.h
index b855ee7..8f48660 100644
--- a/arch/arm/mach-at91/include/mach/system_rev.h
+++ b/arch/arm/mach-at91/include/mach/system_rev.h
@@ -13,13 +13,13 @@
  * the 16-31 bit are reserved for at91 generic information
  *
  * bit 31:
- *	0 => nand 16 bit
- *	1 => nand 8 bit
+ *	0 => nand 8 bit
+ *	1 => nand 16 bit
  */
-#define BOARD_HAVE_NAND_8BIT	(1 << 31)
-static int inline board_have_nand_8bit(void)
+#define BOARD_HAVE_NAND_16BIT	(1 << 31)
+static inline int board_have_nand_16bit(void)
 {
-	return system_rev & BOARD_HAVE_NAND_8BIT;
+	return system_rev & BOARD_HAVE_NAND_16BIT;
 }
 
 #endif /* __ARCH_SYSTEM_REV_H__ */
-- 
1.7.3

