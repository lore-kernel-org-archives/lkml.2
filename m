Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2BVJlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:41:45 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:28880 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2BVJkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:40:19 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk
Subject: [PATCH v2 09/19] ARM: at91: make sdram/ddr register base soc independent
Date: Wed, 22 Feb 2012 10:39:35 +0100
Message-Id: <0acddc0a57ea5a198f662bf37047ebe95e3eb695.1329903206.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91rm9200.c                    |    1 +
 arch/arm/mach-at91/at91rm9200_devices.c            |   13 ++++----
 arch/arm/mach-at91/at91sam9260.c                   |    1 +
 arch/arm/mach-at91/at91sam9261.c                   |    1 +
 arch/arm/mach-at91/at91sam9263.c                   |    2 +
 arch/arm/mach-at91/at91sam9_alt_reset.S            |   12 +++----
 arch/arm/mach-at91/at91sam9g45.c                   |    2 +
 arch/arm/mach-at91/at91sam9g45_reset.S             |   12 +++----
 arch/arm/mach-at91/at91sam9rl.c                    |    1 +
 arch/arm/mach-at91/at91sam9x5.c                    |    1 +
 arch/arm/mach-at91/board-cpuat91.c                 |    1 +
 arch/arm/mach-at91/board-eco920.c                  |    5 ++-
 arch/arm/mach-at91/board-kb9202.c                  |    1 +
 arch/arm/mach-at91/board-picotux200.c              |    1 +
 arch/arm/mach-at91/board-rm9200dk.c                |    1 +
 arch/arm/mach-at91/board-rm9200ek.c                |    1 +
 arch/arm/mach-at91/board-yl-9200.c                 |    3 +-
 arch/arm/mach-at91/generic.h                       |    3 ++
 arch/arm/mach-at91/include/mach/at91_ramc.h        |   31 ++++++++++++++++++++
 arch/arm/mach-at91/include/mach/at91rm9200.h       |    2 +-
 arch/arm/mach-at91/include/mach/at91rm9200_mc.h    |   14 ++++----
 .../arm/mach-at91/include/mach/at91rm9200_sdramc.h |   18 ++++++------
 arch/arm/mach-at91/include/mach/at91sam9260.h      |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9261.h      |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9263.h      |    4 +-
 arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h  |    6 ----
 arch/arm/mach-at91/include/mach/at91sam9_sdramc.h  |    6 ----
 arch/arm/mach-at91/include/mach/at91sam9g45.h      |    4 +-
 arch/arm/mach-at91/include/mach/at91sam9rl.h       |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9x5.h       |    2 +-
 arch/arm/mach-at91/pm.c                            |   27 ++++++++---------
 arch/arm/mach-at91/pm.h                            |    6 +--
 arch/arm/mach-at91/pm_slowclock.S                  |   10 +------
 drivers/pcmcia/at91_cf.c                           |    5 ++-
 34 files changed, 114 insertions(+), 89 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/at91_ramc.h

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index ebe597b..7923197 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -320,6 +320,7 @@ static void __init at91rm9200_map_io(void)
 static void __init at91rm9200_ioremap_registers(void)
 {
 	at91rm9200_ioremap_st(AT91RM9200_BASE_ST);
+	at91_ioremap_ramc(0, AT91RM9200_BASE_MC, 256);
 }
 
 static void __init at91rm9200_initialize(void)
diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 18bacec..aca272b 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -21,6 +21,7 @@
 #include <mach/board.h>
 #include <mach/at91rm9200.h>
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91_ramc.h>
 
 #include "generic.h"
 
@@ -241,15 +242,15 @@ void __init at91_add_device_cf(struct at91_cf_data *data)
 	data->chipselect = 4;		/* can only use EBI ChipSelect 4 */
 
 	/* CF takes over CS4, CS5, CS6 */
-	csa = at91_sys_read(AT91_EBI_CSA);
-	at91_sys_write(AT91_EBI_CSA, csa | AT91_EBI_CS4A_SMC_COMPACTFLASH);
+	csa = at91_ramc_read(0, AT91_EBI_CSA);
+	at91_ramc_write(0, AT91_EBI_CSA, csa | AT91_EBI_CS4A_SMC_COMPACTFLASH);
 
 	/*
 	 * Static memory controller timing adjustments.
 	 * REVISIT:  these timings are in terms of MCK cycles, so
 	 * when MCK changes (cpufreq etc) so must these values...
 	 */
-	at91_sys_write(AT91_SMC_CSR(4),
+	at91_ramc_write(0, AT91_SMC_CSR(4),
 				  AT91_SMC_ACSS_STD
 				| AT91_SMC_DBW_16
 				| AT91_SMC_BAT
@@ -407,11 +408,11 @@ void __init at91_add_device_nand(struct atmel_nand_data *data)
 		return;
 
 	/* enable the address range of CS3 */
-	csa = at91_sys_read(AT91_EBI_CSA);
-	at91_sys_write(AT91_EBI_CSA, csa | AT91_EBI_CS3A_SMC_SMARTMEDIA);
+	csa = at91_ramc_read(0, AT91_EBI_CSA);
+	at91_ramc_write(0, AT91_EBI_CSA, csa | AT91_EBI_CS3A_SMC_SMARTMEDIA);
 
 	/* set the bus interface characteristics */
-	at91_sys_write(AT91_SMC_CSR(3), AT91_SMC_ACSS_STD | AT91_SMC_DBW_8 | AT91_SMC_WSEN
+	at91_ramc_write(0, AT91_SMC_CSR(3), AT91_SMC_ACSS_STD | AT91_SMC_DBW_8 | AT91_SMC_WSEN
 		| AT91_SMC_NWS_(5)
 		| AT91_SMC_TDF_(1)
 		| AT91_SMC_RWSETUP_(0)	/* tDS Data Set up Time 30 - ns */
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 5c15d14..14882ae 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -325,6 +325,7 @@ static void __init at91sam9260_ioremap_registers(void)
 {
 	at91_ioremap_shdwc(AT91SAM9260_BASE_SHDWC);
 	at91_ioremap_rstc(AT91SAM9260_BASE_RSTC);
+	at91_ioremap_ramc(0, AT91SAM9260_BASE_SDRAMC, 512);
 	at91sam926x_ioremap_pit(AT91SAM9260_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9260_BASE_SMC);
 	at91_ioremap_matrix(AT91SAM9260_BASE_MATRIX);
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 50971e6..684c5df 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -283,6 +283,7 @@ static void __init at91sam9261_ioremap_registers(void)
 {
 	at91_ioremap_shdwc(AT91SAM9261_BASE_SHDWC);
 	at91_ioremap_rstc(AT91SAM9261_BASE_RSTC);
+	at91_ioremap_ramc(0, AT91SAM9261_BASE_SDRAMC, 512);
 	at91sam926x_ioremap_pit(AT91SAM9261_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9261_BASE_SMC);
 	at91_ioremap_matrix(AT91SAM9261_BASE_MATRIX);
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 5fd6fe8..0b4fa5a 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -303,6 +303,8 @@ static void __init at91sam9263_ioremap_registers(void)
 {
 	at91_ioremap_shdwc(AT91SAM9263_BASE_SHDWC);
 	at91_ioremap_rstc(AT91SAM9263_BASE_RSTC);
+	at91_ioremap_ramc(0, AT91SAM9263_BASE_SDRAMC0, 512);
+	at91_ioremap_ramc(1, AT91SAM9263_BASE_SDRAMC1, 512);
 	at91sam926x_ioremap_pit(AT91SAM9263_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9263_BASE_SMC0);
 	at91sam9_ioremap_smc(1, AT91SAM9263_BASE_SMC1);
diff --git a/arch/arm/mach-at91/at91sam9_alt_reset.S b/arch/arm/mach-at91/at91sam9_alt_reset.S
index 518e423..7af2e10 100644
--- a/arch/arm/mach-at91/at91sam9_alt_reset.S
+++ b/arch/arm/mach-at91/at91sam9_alt_reset.S
@@ -15,16 +15,17 @@
 
 #include <linux/linkage.h>
 #include <mach/hardware.h>
-#include <mach/at91sam9_sdramc.h>
+#include <mach/at91_ramc.h>
 #include <mach/at91_rstc.h>
 
 			.arm
 
 			.globl	at91sam9_alt_restart
 
-at91sam9_alt_restart:	ldr	r0, .at91_va_base_sdramc	@ preload constants
-			ldr	r1, =at91_rstc_base
-			ldr	r1, [r1]
+at91sam9_alt_restart:	ldr	r0, =at91_ramc_base		@ preload constants
+			ldr	r0, [r0]
+			ldr	r4, =at91_rstc_base
+			ldr	r1, [r4]
 
 			mov	r2, #1
 			mov	r3, #AT91_SDRAMC_LPCB_POWER_DOWN
@@ -37,6 +38,3 @@ at91sam9_alt_restart:	ldr	r0, .at91_va_base_sdramc	@ preload constants
 			str	r4, [r1, #AT91_RSTC_CR]		@ reset processor
 
 			b	.
-
-.at91_va_base_sdramc:
-	.word AT91_VA_BASE_SYS + AT91_SDRAMC0
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 3726160..a41622ea6 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -331,6 +331,8 @@ static void __init at91sam9g45_ioremap_registers(void)
 {
 	at91_ioremap_shdwc(AT91SAM9G45_BASE_SHDWC);
 	at91_ioremap_rstc(AT91SAM9G45_BASE_RSTC);
+	at91_ioremap_ramc(0, AT91SAM9G45_BASE_DDRSDRC1, 512);
+	at91_ioremap_ramc(1, AT91SAM9G45_BASE_DDRSDRC0, 512);
 	at91sam926x_ioremap_pit(AT91SAM9G45_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9G45_BASE_SMC);
 	at91_ioremap_matrix(AT91SAM9G45_BASE_MATRIX);
diff --git a/arch/arm/mach-at91/at91sam9g45_reset.S b/arch/arm/mach-at91/at91sam9g45_reset.S
index 0468be1..9d45718 100644
--- a/arch/arm/mach-at91/at91sam9g45_reset.S
+++ b/arch/arm/mach-at91/at91sam9g45_reset.S
@@ -12,7 +12,7 @@
 
 #include <linux/linkage.h>
 #include <mach/hardware.h>
-#include <mach/at91sam9_ddrsdr.h>
+#include <mach/at91_ramc.h>
 #include <mach/at91_rstc.h>
 
 			.arm
@@ -20,9 +20,10 @@
 			.globl	at91sam9g45_restart
 
 at91sam9g45_restart:
-			ldr	r0, .at91_va_base_sdramc0	@ preload constants
-			ldr	r1, =at91_rstc_base
-			ldr	r1, [r1]
+			ldr	r5, =at91_ramc_base		@ preload constants
+			ldr	r0, [r5]
+			ldr	r4, =at91_rstc_base
+			ldr	r1, [r4]
 
 			mov	r2, #1
 			mov	r3, #AT91_DDRSDRC_LPCB_POWER_DOWN
@@ -35,6 +36,3 @@ at91sam9g45_restart:
 			str	r4, [r1, #AT91_RSTC_CR]		@ reset processor
 
 			b	.
-
-.at91_va_base_sdramc0:
-	.word AT91_VA_BASE_SYS + AT91_DDRSDRC0
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index d95ff97..63d9372 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -288,6 +288,7 @@ static void __init at91sam9rl_ioremap_registers(void)
 {
 	at91_ioremap_shdwc(AT91SAM9RL_BASE_SHDWC);
 	at91_ioremap_rstc(AT91SAM9RL_BASE_RSTC);
+	at91_ioremap_ramc(0, AT91SAM9RL_BASE_SDRAMC, 512);
 	at91sam926x_ioremap_pit(AT91SAM9RL_BASE_PIT);
 	at91sam9_ioremap_smc(0, AT91SAM9RL_BASE_SMC);
 	at91_ioremap_matrix(AT91SAM9RL_BASE_MATRIX);
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index 1c3444d..67b37a0 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -303,6 +303,7 @@ static void __init at91sam9x5_ioremap_registers(void)
 {
 	if (of_at91sam926x_pit_init() < 0)
 		panic("Impossible to find PIT\n");
+	at91_ioremap_ramc(0, AT91SAM9X5_BASE_DDRSDRC0, 512);
 }
 
 void __init at91sam9x5_initialize(void)
diff --git a/arch/arm/mach-at91/board-cpuat91.c b/arch/arm/mach-at91/board-cpuat91.c
index 368e142..e094cc8 100644
--- a/arch/arm/mach-at91/board-cpuat91.c
+++ b/arch/arm/mach-at91/board-cpuat91.c
@@ -38,6 +38,7 @@
 
 #include <mach/board.h>
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91_ramc.h>
 #include <mach/cpu.h>
 
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
index 07ef35b..f23aabe 100644
--- a/arch/arm/mach-at91/board-eco920.c
+++ b/arch/arm/mach-at91/board-eco920.c
@@ -26,6 +26,7 @@
 
 #include <mach/board.h>
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91_ramc.h>
 #include <mach/cpu.h>
 
 #include "generic.h"
@@ -110,7 +111,7 @@ static void __init eco920_board_init(void)
 	at91_add_device_mmc(0, &eco920_mmc_data);
 	platform_device_register(&eco920_flash);
 
-	at91_sys_write(AT91_SMC_CSR(7),	AT91_SMC_RWHOLD_(1)
+	at91_ramc_write(0, AT91_SMC_CSR(7),	AT91_SMC_RWHOLD_(1)
 				| AT91_SMC_RWSETUP_(1)
 				| AT91_SMC_DBW_8
 				| AT91_SMC_WSEN
@@ -122,7 +123,7 @@ static void __init eco920_board_init(void)
 	at91_set_deglitch(AT91_PIN_PA23, 1);
 
 /* Initialization of the Static Memory Controller for Chip Select 3 */
-	at91_sys_write(AT91_SMC_CSR(3),
+	at91_ramc_write(0, AT91_SMC_CSR(3),
 		AT91_SMC_DBW_16  |	/* 16 bit */
 		AT91_SMC_WSEN    |
 		AT91_SMC_NWS_(5) |	/* wait states */
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index d75a4a2..bb99145 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -38,6 +38,7 @@
 #include <mach/board.h>
 #include <mach/cpu.h>
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91_ramc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-picotux200.c b/arch/arm/mach-at91/board-picotux200.c
index ab024fa..59e35dd 100644
--- a/arch/arm/mach-at91/board-picotux200.c
+++ b/arch/arm/mach-at91/board-picotux200.c
@@ -39,6 +39,7 @@
 
 #include <mach/board.h>
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91_ramc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
index 782f379..9083df0 100644
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@ -41,6 +41,7 @@
 #include <mach/hardware.h>
 #include <mach/board.h>
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91_ramc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index ef7c12a..11cbaa8 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -41,6 +41,7 @@
 #include <mach/hardware.h>
 #include <mach/board.h>
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91_ramc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index bbd553e..52f4607 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -45,6 +45,7 @@
 #include <mach/hardware.h>
 #include <mach/board.h>
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91_ramc.h>
 #include <mach/cpu.h>
 
 #include "generic.h"
@@ -393,7 +394,7 @@ static void yl9200_init_video(void)
 	at91_set_A_periph(AT91_PIN_PC6, 0);
 
 	/* Initialization of the Static Memory Controller for Chip Select 2 */
-	at91_sys_write(AT91_SMC_CSR(2), AT91_SMC_DBW_16		/* 16 bit */
+	at91_ramc_write(0, AT91_SMC_CSR(2), AT91_SMC_DBW_16		/* 16 bit */
 			| AT91_SMC_WSEN | AT91_SMC_NWS_(0x4)	/* wait states */
 			| AT91_SMC_TDF_(0x100)			/* float time */
 	);
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index aec7fd0..4cad85e 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -71,6 +71,9 @@ extern void at91_ioremap_shdwc(u32 base_addr);
 /* Matrix */
 extern void at91_ioremap_matrix(u32 base_addr);
 
+/* Ram Controler */
+extern void at91_ioremap_ramc(int id, u32 addr, u32 size);
+
  /* GPIO */
 #define AT91RM9200_PQFP		3	/* AT91RM9200 PQFP package has 3 banks */
 #define AT91RM9200_BGA		4	/* AT91RM9200 BGA package has 4 banks */
diff --git a/arch/arm/mach-at91/include/mach/at91_ramc.h b/arch/arm/mach-at91/include/mach/at91_ramc.h
new file mode 100644
index 0000000..3155499
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/at91_ramc.h
@@ -0,0 +1,31 @@
+/*
+ * Header file for the Atmel RAM Controller
+ *
+ * Copyright (C) 2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
+ *
+ * Under GPLv2 only
+ */
+
+#ifndef __AT91_RAMC_H__
+#define __AT91_RAMC_H__
+
+#ifndef __ASSEMBLY__
+extern void __iomem *at91_ramc_base[];
+
+#define at91_ramc_read(id, field) \
+	__raw_readl(at91_ramc_base[id] + field)
+
+#define at91_ramc_write(id, field, value) \
+	__raw_writel(value, at91_ramc_base[id] + field)
+#else
+.extern at91_ramc_base
+#endif
+
+#ifdef CONFIG_ARCH_AT91RM9200
+#include <mach/at91rm9200_mc.h>
+#else
+#include <mach/at91sam9_ddrsdr.h>
+#include <mach/at91sam9_sdramc.h>
+#endif
+
+#endif /* __AT91_RAMC_H__ */
diff --git a/arch/arm/mach-at91/include/mach/at91rm9200.h b/arch/arm/mach-at91/include/mach/at91rm9200.h
index 0d0b9b3..32d57be 100644
--- a/arch/arm/mach-at91/include/mach/at91rm9200.h
+++ b/arch/arm/mach-at91/include/mach/at91rm9200.h
@@ -80,7 +80,6 @@
  * System Peripherals (offset from AT91_BASE_SYS)
  */
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)	/* Power Management Controller */
-#define AT91_MC		(0xffffff00 - AT91_BASE_SYS)	/* Memory Controllers */
 
 #define AT91RM9200_BASE_DBGU	AT91_BASE_DBGU0	/* Debug Unit */
 #define AT91RM9200_BASE_PIOA	0xfffff400	/* PIO Controller A */
@@ -89,6 +88,7 @@
 #define AT91RM9200_BASE_PIOD	0xfffffa00	/* PIO Controller D */
 #define AT91RM9200_BASE_ST	0xfffffd00	/* System Timer */
 #define AT91RM9200_BASE_RTC	0xfffffe00	/* Real-Time Clock */
+#define AT91RM9200_BASE_MC	0xffffff00	/* Memory Controllers */
 
 #define AT91_USART0	AT91RM9200_BASE_US0
 #define AT91_USART1	AT91RM9200_BASE_US1
diff --git a/arch/arm/mach-at91/include/mach/at91rm9200_mc.h b/arch/arm/mach-at91/include/mach/at91rm9200_mc.h
index 0eb031b..aeaadfb 100644
--- a/arch/arm/mach-at91/include/mach/at91rm9200_mc.h
+++ b/arch/arm/mach-at91/include/mach/at91rm9200_mc.h
@@ -17,10 +17,10 @@
 #define AT91RM9200_MC_H
 
 /* Memory Controller */
-#define AT91_MC_RCR		(AT91_MC + 0x00)	/* MC Remap Control Register */
+#define AT91_MC_RCR		0x00			/* MC Remap Control Register */
 #define		AT91_MC_RCB		(1 <<  0)		/* Remap Command Bit */
 
-#define AT91_MC_ASR		(AT91_MC + 0x04)	/* MC Abort Status Register */
+#define AT91_MC_ASR		0x04			/* MC Abort Status Register */
 #define		AT91_MC_UNADD		(1 <<  0)		/* Undefined Address Abort Status */
 #define		AT91_MC_MISADD		(1 <<  1)		/* Misaligned Address Abort Status */
 #define		AT91_MC_ABTSZ		(3 <<  8)		/* Abort Size Status */
@@ -40,16 +40,16 @@
 #define		AT91_MC_SVMST2		(1 << 26)		/* Saved UHP Abort Source */
 #define		AT91_MC_SVMST3		(1 << 27)		/* Saved EMAC Abort Source */
 
-#define AT91_MC_AASR		(AT91_MC + 0x08)	/* MC Abort Address Status Register */
+#define AT91_MC_AASR		0x08			/* MC Abort Address Status Register */
 
-#define AT91_MC_MPR		(AT91_MC + 0x0c)	/* MC Master Priority Register */
+#define AT91_MC_MPR		0x0c			/* MC Master Priority Register */
 #define		AT91_MPR_MSTP0		(7 <<  0)		/* ARM920T Priority */
 #define		AT91_MPR_MSTP1		(7 <<  4)		/* PDC Priority */
 #define		AT91_MPR_MSTP2		(7 <<  8)		/* UHP Priority */
 #define		AT91_MPR_MSTP3		(7 << 12)		/* EMAC Priority */
 
 /* External Bus Interface (EBI) registers */
-#define AT91_EBI_CSA		(AT91_MC + 0x60)	/* Chip Select Assignment Register */
+#define AT91_EBI_CSA		0x60			/* Chip Select Assignment Register */
 #define		AT91_EBI_CS0A		(1 << 0)		/* Chip Select 0 Assignment */
 #define			AT91_EBI_CS0A_SMC		(0 << 0)
 #define			AT91_EBI_CS0A_BFC		(1 << 0)
@@ -66,7 +66,7 @@
 #define		AT91_EBI_DBPUC		(1 << 0)		/* Data Bus Pull-Up Configuration */
 
 /* Static Memory Controller (SMC) registers */
-#define	AT91_SMC_CSR(n)		(AT91_MC + 0x70 + ((n) * 4))/* SMC Chip Select Register */
+#define	AT91_SMC_CSR(n)		(0x70 + ((n) * 4))	/* SMC Chip Select Register */
 #define		AT91_SMC_NWS		(0x7f <<  0)		/* Number of Wait States */
 #define			AT91_SMC_NWS_(x)	((x) << 0)
 #define		AT91_SMC_WSEN		(1    <<  7)		/* Wait State Enable */
@@ -88,7 +88,7 @@
 #define			AT91_SMC_RWHOLD_(x)	((x) << 28)
 
 /* Burst Flash Controller register */
-#define AT91_BFC_MR		(AT91_MC + 0xc0)	/* Mode Register */
+#define AT91_BFC_MR		0xc0			/* Mode Register */
 #define		AT91_BFC_BFCOM		(3   <<  0)		/* Burst Flash Controller Operating Mode */
 #define			AT91_BFC_BFCOM_DISABLED	(0 << 0)
 #define			AT91_BFC_BFCOM_ASYNC	(1 << 0)
diff --git a/arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h b/arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
index 7ad3597..aa047f45 100644
--- a/arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
+++ b/arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h
@@ -17,7 +17,7 @@
 #define AT91RM9200_SDRAMC_H
 
 /* SDRAM Controller registers */
-#define AT91RM9200_SDRAMC_MR		(AT91_MC + 0x90)	/* Mode Register */
+#define AT91RM9200_SDRAMC_MR		0x90			/* Mode Register */
 #define		AT91RM9200_SDRAMC_MODE	(0xf << 0)		/* Command Mode */
 #define			AT91RM9200_SDRAMC_MODE_NORMAL		(0 << 0)
 #define			AT91RM9200_SDRAMC_MODE_NOP		(1 << 0)
@@ -28,10 +28,10 @@
 #define			AT91RM9200_SDRAMC_DBW_32	(0 << 4)
 #define			AT91RM9200_SDRAMC_DBW_16	(1 << 4)
 
-#define AT91RM9200_SDRAMC_TR		(AT91_MC + 0x94)	/* Refresh Timer Register */
+#define AT91RM9200_SDRAMC_TR		0x94			/* Refresh Timer Register */
 #define		AT91RM9200_SDRAMC_COUNT	(0xfff << 0)		/* Refresh Timer Count */
 
-#define AT91RM9200_SDRAMC_CR		(AT91_MC + 0x98)	/* Configuration Register */
+#define AT91RM9200_SDRAMC_CR		0x98			/* Configuration Register */
 #define		AT91RM9200_SDRAMC_NC		(3   <<  0)		/* Number of Column Bits */
 #define			AT91RM9200_SDRAMC_NC_8	(0 << 0)
 #define			AT91RM9200_SDRAMC_NC_9	(1 << 0)
@@ -53,11 +53,11 @@
 #define		AT91RM9200_SDRAMC_TRAS	(0xf << 23)		/* Active to Precharge Delay */
 #define		AT91RM9200_SDRAMC_TXSR	(0xf << 27)		/* Exit Self Refresh to Active Delay */
 
-#define AT91RM9200_SDRAMC_SRR		(AT91_MC + 0x9c)	/* Self Refresh Register */
-#define AT91RM9200_SDRAMC_LPR		(AT91_MC + 0xa0)	/* Low Power Register */
-#define AT91RM9200_SDRAMC_IER		(AT91_MC + 0xa4)	/* Interrupt Enable Register */
-#define AT91RM9200_SDRAMC_IDR		(AT91_MC + 0xa8)	/* Interrupt Disable Register */
-#define AT91RM9200_SDRAMC_IMR		(AT91_MC + 0xac)	/* Interrupt Mask Register */
-#define AT91RM9200_SDRAMC_ISR		(AT91_MC + 0xb0)	/* Interrupt Status Register */
+#define AT91RM9200_SDRAMC_SRR		0x9c			/* Self Refresh Register */
+#define AT91RM9200_SDRAMC_LPR		0xa0			/* Low Power Register */
+#define AT91RM9200_SDRAMC_IER		0xa4			/* Interrupt Enable Register */
+#define AT91RM9200_SDRAMC_IDR		0xa8			/* Interrupt Disable Register */
+#define AT91RM9200_SDRAMC_IMR		0xac			/* Interrupt Mask Register */
+#define AT91RM9200_SDRAMC_ISR		0xb0			/* Interrupt Status Register */
 
 #endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9260.h b/arch/arm/mach-at91/include/mach/at91sam9260.h
index 2bde649..c5b6b3b 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9260.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9260.h
@@ -80,11 +80,11 @@
 /*
  * System Peripherals (offset from AT91_BASE_SYS)
  */
-#define AT91_SDRAMC0	(0xffffea00 - AT91_BASE_SYS)
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 #define AT91_GPBR	(0xfffffd50 - AT91_BASE_SYS)
 
 #define AT91SAM9260_BASE_ECC	0xffffe800
+#define AT91SAM9260_BASE_SDRAMC	0xffffea00
 #define AT91SAM9260_BASE_SMC	0xffffec00
 #define AT91SAM9260_BASE_MATRIX	0xffffee00
 #define AT91SAM9260_BASE_DBGU	AT91_BASE_DBGU0
diff --git a/arch/arm/mach-at91/include/mach/at91sam9261.h b/arch/arm/mach-at91/include/mach/at91sam9261.h
index 6dcff27..a269cef 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9261.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9261.h
@@ -65,12 +65,12 @@
 /*
  * System Peripherals (offset from AT91_BASE_SYS)
  */
-#define AT91_SDRAMC0	(0xffffea00 - AT91_BASE_SYS)
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 #define AT91_GPBR	(0xfffffd50 - AT91_BASE_SYS)
 
 #define AT91SAM9261_BASE_SMC	0xffffec00
 #define AT91SAM9261_BASE_MATRIX	0xffffee00
+#define AT91SAM9261_BASE_SDRAMC	0xffffea00
 #define AT91SAM9261_BASE_DBGU	AT91_BASE_DBGU0
 #define AT91SAM9261_BASE_PIOA	0xfffff400
 #define AT91SAM9261_BASE_PIOB	0xfffff600
diff --git a/arch/arm/mach-at91/include/mach/at91sam9263.h b/arch/arm/mach-at91/include/mach/at91sam9263.h
index fe73bfa..bccba0b 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9263.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9263.h
@@ -74,14 +74,14 @@
 /*
  * System Peripherals (offset from AT91_BASE_SYS)
  */
-#define AT91_SDRAMC0	(0xffffe200 - AT91_BASE_SYS)
-#define AT91_SDRAMC1	(0xffffe800 - AT91_BASE_SYS)
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 #define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
 
 #define AT91SAM9263_BASE_ECC0	0xffffe000
+#define AT91SAM9263_BASE_SDRAMC0 0xffffe200
 #define AT91SAM9263_BASE_SMC0	0xffffe400
 #define AT91SAM9263_BASE_ECC1	0xffffe600
+#define AT91SAM9263_BASE_SDRAMC1 0xffffe800
 #define AT91SAM9263_BASE_SMC1	0xffffea00
 #define AT91SAM9263_BASE_MATRIX	0xffffec00
 #define AT91SAM9263_BASE_DBGU	AT91_BASE_DBGU1
diff --git a/arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h b/arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h
index 5d4a9f8..0210797 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h
@@ -121,10 +121,4 @@
 #define		AT91_DDRSDRC_WPVS	(1 << 0)		/* Write protect violation status */
 #define		AT91_DDRSDRC_WPVSRC	(0xffff << 8)		/* Write protect violation source */
 
-/* Register access macros */
-#define at91_ramc_read(num, reg) \
-	at91_sys_read(AT91_DDRSDRC##num + reg)
-#define at91_ramc_write(num, reg, value) \
-	at91_sys_write(AT91_DDRSDRC##num + reg, value)
-
 #endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h b/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
index 100f5a5..3d085a9 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
@@ -82,10 +82,4 @@
 #define			AT91_SDRAMC_MD_SDRAM		0
 #define			AT91_SDRAMC_MD_LOW_POWER_SDRAM	1
 
-/* Register access macros */
-#define at91_ramc_read(num, reg) \
-	at91_sys_read(AT91_SDRAMC##num + reg)
-#define at91_ramc_write(num, reg, value) \
-	at91_sys_write(AT91_SDRAMC##num + reg, value)
-
 #endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9g45.h b/arch/arm/mach-at91/include/mach/at91sam9g45.h
index c8fe455..dfc4570 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9g45.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9g45.h
@@ -86,12 +86,12 @@
 /*
  * System Peripherals (offset from AT91_BASE_SYS)
  */
-#define AT91_DDRSDRC1	(0xffffe400 - AT91_BASE_SYS)
-#define AT91_DDRSDRC0	(0xffffe600 - AT91_BASE_SYS)
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 #define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
 
 #define AT91SAM9G45_BASE_ECC	0xffffe200
+#define AT91SAM9G45_BASE_DDRSDRC1 0xffffe400
+#define AT91SAM9G45_BASE_DDRSDRC0 0xffffe600
 #define AT91SAM9G45_BASE_DMA	0xffffec00
 #define AT91SAM9G45_BASE_SMC	0xffffe800
 #define AT91SAM9G45_BASE_MATRIX	0xffffea00
diff --git a/arch/arm/mach-at91/include/mach/at91sam9rl.h b/arch/arm/mach-at91/include/mach/at91sam9rl.h
index 51edc25..de960dc 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9rl.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9rl.h
@@ -69,13 +69,13 @@
 /*
  * System Peripherals (offset from AT91_BASE_SYS)
  */
-#define AT91_SDRAMC0	(0xffffea00 - AT91_BASE_SYS)
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 #define AT91_SCKCR	(0xfffffd50 - AT91_BASE_SYS)
 #define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
 
 #define AT91SAM9RL_BASE_DMA	0xffffe600
 #define AT91SAM9RL_BASE_ECC	0xffffe800
+#define AT91SAM9RL_BASE_SDRAMC	0xffffea00
 #define AT91SAM9RL_BASE_SMC	0xffffec00
 #define AT91SAM9RL_BASE_MATRIX	0xffffee00
 #define AT91SAM9RL_BASE_DBGU	AT91_BASE_DBGU0
diff --git a/arch/arm/mach-at91/include/mach/at91sam9x5.h b/arch/arm/mach-at91/include/mach/at91sam9x5.h
index 8476871..96f25f5 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9x5.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9x5.h
@@ -57,7 +57,7 @@
 /*
  * System Peripherals (offset from AT91_BASE_SYS)
  */
-#define AT91_DDRSDRC0	(0xffffe800 - AT91_BASE_SYS)
+#define AT91SAM9X5_BASE_DDRSDRC0	0xffffe800
 #define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
 
 /*
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 8046a50..6a02ea2 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -196,19 +196,18 @@ extern u32 at91_slow_clock_sz;
 #endif
 
 static void __iomem *at91_pmc_base = (void __iomem*)(AT91_VA_BASE_SYS + AT91_PMC);
-#ifdef CONFIG_ARCH_AT91RM9200
-static void __iomem *at91_ramc0_base = (void __iomem*)AT91_VA_BASE_SYS;
-#elif defined(CONFIG_ARCH_AT91SAM9G45)
-static void __iomem *at91_ramc0_base = (void __iomem*)(AT91_VA_BASE_SYS + AT91_DDRSDRC0);
-#else
-static void __iomem *at91_ramc0_base = (void __iomem*)(AT91_VA_BASE_SYS + AT91_SDRAMC0);
-#endif
+void __iomem *at91_ramc_base[2];
 
-#if defined(CONFIG_ARCH_AT91SAM9G45)
-static void __iomem *at91_ramc1_base = (void __iomem*)(AT91_VA_BASE_SYS + AT91_DDRSDRC1);
-#else
-static void __iomem *at91_ramc1_base = NULL;
-#endif
+void __init at91_ioremap_ramc(int id, u32 addr, u32 size)
+{
+	if (id > 1) {
+		pr_warn("%s: id > 2\n", __func__);
+		return;
+	}
+	at91_ramc_base[id] = ioremap(addr, size);
+	if (!at91_ramc_base[id])
+		pr_warn("Impossible to ioremap ramc.%d 0x%x\n", id, addr);
+}
 
 static int at91_pm_enter(suspend_state_t state)
 {
@@ -246,7 +245,7 @@ static int at91_pm_enter(suspend_state_t state)
 				/* copy slow_clock handler to SRAM, and call it */
 				memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
 #endif
-				slow_clock(at91_pmc_base, at91_ramc0_base, at91_ramc1_base);
+				slow_clock(at91_pmc_base, at91_ramc_base[0], at91_ramc_base[1]);
 				break;
 			} else {
 				pr_info("AT91: PM - no slow clock mode enabled ...\n");
@@ -315,7 +314,7 @@ static int __init at91_pm_init(void)
 
 #ifdef CONFIG_ARCH_AT91RM9200
 	/* AT91RM9200 SDRAM low-power mode cannot be used with self-refresh. */
-	at91_sys_write(AT91RM9200_SDRAMC_LPR, 0);
+	at91_ramc_write(0, AT91RM9200_SDRAMC_LPR, 0);
 #endif
 
 	suspend_set_ops(&at91_pm_ops);
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index 41cdd2b..89f56f3 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -11,8 +11,8 @@
 #ifndef __ARCH_ARM_MACH_AT91_PM
 #define __ARCH_ARM_MACH_AT91_PM
 
+#include <mach/at91_ramc.h>
 #ifdef CONFIG_ARCH_AT91RM9200
-#include <mach/at91rm9200_mc.h>
 #include <mach/at91rm9200_sdramc.h>
 
 /*
@@ -27,7 +27,7 @@
 
 static inline void at91rm9200_standby(void)
 {
-	u32 lpr = at91_sys_read(AT91RM9200_SDRAMC_LPR);
+	u32 lpr = at91_ramc_read(0, AT91RM9200_SDRAMC_LPR);
 
 	asm volatile(
 		"b    1f\n\t"
@@ -46,7 +46,6 @@ static inline void at91rm9200_standby(void)
 #define at91_standby at91rm9200_standby
 
 #elif defined(CONFIG_ARCH_AT91SAM9G45)
-#include <mach/at91sam9_ddrsdr.h>
 
 /* We manage both DDRAM/SDRAM controllers, we need more than one value to
  * remember.
@@ -79,7 +78,6 @@ static inline void at91sam9g45_standby(void)
 #define at91_standby at91sam9g45_standby
 
 #else
-#include <mach/at91sam9_sdramc.h>
 
 #ifdef CONFIG_ARCH_AT91SAM9263
 /*
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index c2cc7d4..9c3117c 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -15,15 +15,7 @@
 #include <linux/linkage.h>
 #include <mach/hardware.h>
 #include <mach/at91_pmc.h>
-
-#if defined(CONFIG_ARCH_AT91RM9200)
-#include <mach/at91rm9200_mc.h>
-#include <mach/at91rm9200_sdramc.h>
-#elif defined(CONFIG_ARCH_AT91SAM9G45)
-#include <mach/at91sam9_ddrsdr.h>
-#else
-#include <mach/at91sam9_sdramc.h>
-#endif
+#include <mach/at91_ramc.h>
 
 
 #ifdef CONFIG_ARCH_AT91SAM9263
diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 4902206..1dd68f5 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -26,6 +26,7 @@
 
 #include <mach/board.h>
 #include <mach/at91rm9200_mc.h>
+#include <mach/at91_ramc.h>
 
 
 /*
@@ -156,7 +157,7 @@ static int at91_cf_set_io_map(struct pcmcia_socket *s, struct pccard_io_map *io)
 	/*
 	 * Use 16 bit accesses unless/until we need 8-bit i/o space.
 	 */
-	csr = at91_sys_read(AT91_SMC_CSR(cf->board->chipselect)) & ~AT91_SMC_DBW;
+	csr = at91_ramc_read(0, AT91_SMC_CSR(cf->board->chipselect)) & ~AT91_SMC_DBW;
 
 	/*
 	 * NOTE: this CF controller ignores IOIS16, so we can't really do
@@ -175,7 +176,7 @@ static int at91_cf_set_io_map(struct pcmcia_socket *s, struct pccard_io_map *io)
 		csr |= AT91_SMC_DBW_16;
 		pr_debug("%s: 16bit i/o bus\n", driver_name);
 	}
-	at91_sys_write(AT91_SMC_CSR(cf->board->chipselect), csr);
+	at91_ramc_write(0, AT91_SMC_CSR(cf->board->chipselect), csr);
 
 	io->start = cf->socket.io_offset;
 	io->stop = io->start + SZ_2K - 1;
-- 
1.7.9

