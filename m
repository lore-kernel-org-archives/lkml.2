Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2FKPj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:39:56 -0400
Received: from mail.df.lth.se ([194.47.250.12]:24021 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab2FKPjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:39:54 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>
Subject: [PATCH 1/3] ARM: integrator: put symbolic bus names on devices
Date: Mon, 11 Jun 2012 17:39:40 +0200
Message-Id: <1339429180-32546-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the Integrator devices have bus names like "mb:16" which
I think means "memory base 0x16000000" which is where the
UART0 is. So let's call it "uart0" because that's what most
platforms do these days.

Change this everywhere for the integrator as we prepare for
some core clock code movement.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-integrator/core.c          |   20 ++++++++++----------
 arch/arm/mach-integrator/integrator_cp.c |    8 ++++----
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index eaf6c63..2a20bba 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -41,17 +41,17 @@ static struct amba_pl010_data integrator_uart_data;
 #define KMI0_IRQ		{ IRQ_KMIINT0 }
 #define KMI1_IRQ		{ IRQ_KMIINT1 }
 
-static AMBA_APB_DEVICE(rtc, "mb:15", 0,
+static AMBA_APB_DEVICE(rtc, "rtc", 0,
 	INTEGRATOR_RTC_BASE, INTEGRATOR_RTC_IRQ, NULL);
 
-static AMBA_APB_DEVICE(uart0, "mb:16", 0,
+static AMBA_APB_DEVICE(uart0, "uart0", 0,
 	INTEGRATOR_UART0_BASE, INTEGRATOR_UART0_IRQ, &integrator_uart_data);
 
-static AMBA_APB_DEVICE(uart1, "mb:17", 0,
+static AMBA_APB_DEVICE(uart1, "uart1", 0,
 	INTEGRATOR_UART1_BASE, INTEGRATOR_UART1_IRQ, &integrator_uart_data);
 
-static AMBA_APB_DEVICE(kmi0, "mb:18", 0, KMI0_BASE, KMI0_IRQ, NULL);
-static AMBA_APB_DEVICE(kmi1, "mb:19", 0, KMI1_BASE, KMI1_IRQ, NULL);
+static AMBA_APB_DEVICE(kmi0, "kmi0", 0, KMI0_BASE, KMI0_IRQ, NULL);
+static AMBA_APB_DEVICE(kmi1, "kmi1", 0, KMI1_BASE, KMI1_IRQ, NULL);
 
 static struct amba_device *amba_devs[] __initdata = {
 	&rtc_device,
@@ -83,19 +83,19 @@ static struct clk_lookup lookups[] = {
 		.dev_id		= "ap_timer",
 		.clk		= &clk24mhz,
 	}, {	/* UART0 */
-		.dev_id		= "mb:16",
+		.dev_id		= "uart0",
 		.clk		= &uartclk,
 	}, {	/* UART1 */
-		.dev_id		= "mb:17",
+		.dev_id		= "uart1",
 		.clk		= &uartclk,
 	}, {	/* KMI0 */
-		.dev_id		= "mb:18",
+		.dev_id		= "kmi0",
 		.clk		= &clk24mhz,
 	}, {	/* KMI1 */
-		.dev_id		= "mb:19",
+		.dev_id		= "kmi1",
 		.clk		= &clk24mhz,
 	}, {	/* MMCI - IntegratorCP */
-		.dev_id		= "mb:1c",
+		.dev_id		= "mmci",
 		.clk		= &uartclk,
 	}
 };
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index a56c536..a8c6480 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -221,7 +221,7 @@ static struct clk sp804_clk = {
 
 static struct clk_lookup cp_lookups[] = {
 	{	/* CLCD */
-		.dev_id		= "mb:c0",
+		.dev_id		= "clcd",
 		.clk		= &cp_auxclk,
 	}, {	/* SP804 timers */
 		.dev_id		= "sp804",
@@ -336,10 +336,10 @@ static struct mmci_platform_data mmc_data = {
 #define INTEGRATOR_CP_MMC_IRQS	{ IRQ_CP_MMCIINT0, IRQ_CP_MMCIINT1 }
 #define INTEGRATOR_CP_AACI_IRQS	{ IRQ_CP_AACIINT }
 
-static AMBA_APB_DEVICE(mmc, "mb:1c", 0, INTEGRATOR_CP_MMC_BASE,
+static AMBA_APB_DEVICE(mmc, "mmci", 0, INTEGRATOR_CP_MMC_BASE,
 	INTEGRATOR_CP_MMC_IRQS, &mmc_data);
 
-static AMBA_APB_DEVICE(aaci, "mb:1d", 0, INTEGRATOR_CP_AACI_BASE,
+static AMBA_APB_DEVICE(aaci, "aaci", 0, INTEGRATOR_CP_AACI_BASE,
 	INTEGRATOR_CP_AACI_IRQS, NULL);
 
 
@@ -393,7 +393,7 @@ static struct clcd_board clcd_data = {
 	.remove		= versatile_clcd_remove_dma,
 };
 
-static AMBA_AHB_DEVICE(clcd, "mb:c0", 0, INTCP_PA_CLCD_BASE,
+static AMBA_AHB_DEVICE(clcd, "clcd", 0, INTCP_PA_CLCD_BASE,
 	{ IRQ_CP_CLCDCINT }, &clcd_data);
 
 static struct amba_device *amba_devs[] __initdata = {
-- 
1.7.7.6

