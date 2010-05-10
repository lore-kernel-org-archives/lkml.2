Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab0EJP2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:28:33 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:17184 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0EJP2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:28:32 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: avictor.za@gmail.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] AT91: add new at91 chips in at91sam9g45 family
Date: Mon, 10 May 2010 18:45:00 +0200
Message-Id: <1273509900-30278-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the basic support for at91sam9g46, at91sam9m10 and at91sam9m11. Those
are just very basic cpu macros and clock definition.

Signed-off-by: Patrice Vilchez <patrice.vilchez@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9g45.c      |   11 +++++++++++
 arch/arm/mach-at91/include/mach/cpu.h |   10 ++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 85166b7..753c0d3 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -20,6 +20,7 @@
 #include <mach/at91_pmc.h>
 #include <mach/at91_rstc.h>
 #include <mach/at91_shdwc.h>
+#include <mach/cpu.h>
 
 #include "generic.h"
 #include "clock.h"
@@ -176,6 +177,13 @@ static struct clk mmc1_clk = {
 	.type		= CLK_TYPE_PERIPHERAL,
 };
 
+/* Video decoder clock - Only for sam9m10/sam9m11 */
+static struct clk vdec_clk = {
+	.name		= "vdec_clk",
+	.pmc_mask	= 1 << AT91SAM9G45_ID_VDEC,
+	.type		= CLK_TYPE_PERIPHERAL,
+};
+
 /* One additional fake clock for ohci */
 static struct clk ohci_clk = {
 	.name		= "ohci_clk",
@@ -239,6 +247,9 @@ static void __init at91sam9g45_register_clocks(void)
 	for (i = 0; i < ARRAY_SIZE(periph_clocks); i++)
 		clk_register(periph_clocks[i]);
 
+	if (cpu_is_at91sam9m10() || cpu_is_at91sam9m11())
+		clk_register(&vdec_clk);
+
 	clk_register(&pck0);
 	clk_register(&pck1);
 }
diff --git a/arch/arm/mach-at91/include/mach/cpu.h b/arch/arm/mach-at91/include/mach/cpu.h
index 5a06501..fa74b0c 100644
--- a/arch/arm/mach-at91/include/mach/cpu.h
+++ b/arch/arm/mach-at91/include/mach/cpu.h
@@ -52,6 +52,7 @@ static inline unsigned long at91_cpu_fully_identify(void)
 
 #define ARCH_EXID_AT91SAM9M11	0x00000001
 #define ARCH_EXID_AT91SAM9M10	0x00000002
+#define ARCH_EXID_AT91SAM9G46	0x00000003
 #define ARCH_EXID_AT91SAM9G45	0x00000004
 
 static inline unsigned long at91_exid_identify(void)
@@ -128,9 +129,18 @@ static inline unsigned long at91cap9_rev_identify(void)
 #ifdef CONFIG_ARCH_AT91SAM9G45
 #define cpu_is_at91sam9g45()	(at91_cpu_identify() == ARCH_ID_AT91SAM9G45)
 #define cpu_is_at91sam9g45es()	(at91_cpu_fully_identify() == ARCH_ID_AT91SAM9G45ES)
+#define cpu_is_at91sam9m10()    (cpu_is_at91sam9g45() && \
+                                (at91_exid_identify() == ARCH_EXID_AT91SAM9M10))
+#define cpu_is_at91sam9m46()    (cpu_is_at91sam9g45() && \
+                                (at91_exid_identify() == ARCH_EXID_AT91SAM9G46))
+#define cpu_is_at91sam9m11()    (cpu_is_at91sam9g45() && \
+                                (at91_exid_identify() == ARCH_EXID_AT91SAM9M11))
 #else
 #define cpu_is_at91sam9g45()	(0)
 #define cpu_is_at91sam9g45es()	(0)
+#define cpu_is_at91sam9m10()	(0)
+#define cpu_is_at91sam9g46()	(0)
+#define cpu_is_at91sam9m11()	(0)
 #endif
 
 #ifdef CONFIG_ARCH_AT91CAP9
-- 
1.5.6.5

