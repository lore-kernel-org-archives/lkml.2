Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935179Ab2JXPfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:35:20 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11192 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999Ab2JXPep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:34:45 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <voice.shen@atmel.com>,
        <marek.belisko@open-nandra.com>, <ivan.shugov@gmail.com>,
        <josh.wu@atmel.com>
Subject: [PATCH 7/8] ARM: at91/i2c: change id to let i2c-at91 work
Date: Wed, 24 Oct 2012 17:33:56 +0200
Message-ID: <55320d29feb80bb5da64dcb82518a56174da7ce4.1351092432.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <cover.1351092432.git.nicolas.ferre@atmel.com>
References: <cover.1351092432.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bo Shen <voice.shen@atmel.com>

The i2c core driver will turn the platform device ID to busnum
When using platfrom device ID as -1, it means dynamically assigned
the busnum. When writing code, we need to make sure the busnum,
and call i2c_register_board_info(int busnum, ...) to register device
if using -1, we do not know the value of busnum

In order to solve this issue, set the platform device ID as a fix number
Here using 0 to match the busnum used in i2c_regsiter_board_info()

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91rm9200.c          | 2 +-
 arch/arm/mach-at91/at91rm9200_devices.c  | 2 +-
 arch/arm/mach-at91/at91sam9260.c         | 4 ++--
 arch/arm/mach-at91/at91sam9260_devices.c | 2 +-
 arch/arm/mach-at91/at91sam9261.c         | 4 ++--
 arch/arm/mach-at91/at91sam9261_devices.c | 2 +-
 arch/arm/mach-at91/at91sam9263.c         | 2 +-
 arch/arm/mach-at91/at91sam9263_devices.c | 2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c  | 2 +-
 9 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index b4f0565..5269825 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -187,7 +187,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("pclk", "ssc.0", &ssc0_clk),
 	CLKDEV_CON_DEV_ID("pclk", "ssc.1", &ssc1_clk),
 	CLKDEV_CON_DEV_ID("pclk", "ssc.2", &ssc2_clk),
-	CLKDEV_CON_DEV_ID(NULL, "i2c-at91rm9200", &twi_clk),
+	CLKDEV_CON_DEV_ID(NULL, "i2c-at91rm9200.0", &twi_clk),
 	/* fake hclk clock */
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
 	CLKDEV_CON_ID("pioA", &pioA_clk),
diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 7cd8053..1e122bc 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -512,7 +512,7 @@ static struct resource twi_resources[] = {
 
 static struct platform_device at91rm9200_twi_device = {
 	.name		= "i2c-at91rm9200",
-	.id		= -1,
+	.id		= 0,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index ad29f93..f820261 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -211,8 +211,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.1", &tc4_clk),
 	CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.1", &tc5_clk),
 	CLKDEV_CON_DEV_ID("pclk", "ssc.0", &ssc_clk),
-	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9260", &twi_clk),
-	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9g20", &twi_clk),
+	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9260.0", &twi_clk),
+	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9g20.0", &twi_clk),
 	/* more usart lookup table for DT entries */
 	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
 	CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 44385a4..aa1e587 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -421,7 +421,7 @@ static struct resource twi_resources[] = {
 };
 
 static struct platform_device at91sam9260_twi_device = {
-	.id		= -1,
+	.id		= 0,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 8d999eb..04295c0 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -178,8 +178,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("pclk", "ssc.1", &ssc1_clk),
 	CLKDEV_CON_DEV_ID("pclk", "ssc.2", &ssc2_clk),
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &hck0),
-	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9261", &twi_clk),
-	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9g10", &twi_clk),
+	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9261.0", &twi_clk),
+	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9g10.0", &twi_clk),
 	CLKDEV_CON_ID("pioA", &pioA_clk),
 	CLKDEV_CON_ID("pioB", &pioB_clk),
 	CLKDEV_CON_ID("pioC", &pioC_clk),
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 0256a00..b948769 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -317,7 +317,7 @@ static struct resource twi_resources[] = {
 };
 
 static struct platform_device at91sam9261_twi_device = {
-	.id		= -1,
+	.id		= 0,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 6a01d03..d6f9c23 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -193,7 +193,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.0", &spi0_clk),
 	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.1", &spi1_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tcb_clk),
-	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9260", &twi_clk),
+	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9260.0", &twi_clk),
 	/* fake hclk clock */
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
 	CLKDEV_CON_ID("pioA", &pioA_clk),
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 23b6384..cb85da2 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -600,7 +600,7 @@ static struct resource twi_resources[] = {
 
 static struct platform_device at91sam9263_twi_device = {
 	.name		= "i2c-at91sam9260",
-	.id		= -1,
+	.id		= 0,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 3d2c81d..5047bdc 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -347,7 +347,7 @@ static struct resource twi_resources[] = {
 
 static struct platform_device at91sam9rl_twi_device = {
 	.name		= "i2c-at91sam9g20",
-	.id		= -1,
+	.id		= 0,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
-- 
1.7.11.3

