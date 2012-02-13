Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2BMOoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:44:12 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:62775 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2BMOoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:44:11 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: tglx@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        avictor.za@gmail.com, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 8/9] ARM: at91/gpio: remove the static specification of gpio_chip.base
Date: Mon, 13 Feb 2012 15:43:08 +0100
Message-Id: <6f442941051964c268bfa3cfdd2a9a544c2860dc.1329139662.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
References: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This value is determined at runtime using device tree or platform data
information.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/gpio.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index e8f5831..ecf6bbb 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -51,7 +51,7 @@ static int at91_gpiolib_direction_input(struct gpio_chip *chip,
 					unsigned offset);
 static int at91_gpiolib_to_irq(struct gpio_chip *chip, unsigned offset);
 
-#define AT91_GPIO_CHIP(name, base_gpio, nr_gpio)			\
+#define AT91_GPIO_CHIP(name, nr_gpio)					\
 	{								\
 		.chip = {						\
 			.label		  = name,			\
@@ -60,18 +60,17 @@ static int at91_gpiolib_to_irq(struct gpio_chip *chip, unsigned offset);
 			.get		  = at91_gpiolib_get,		\
 			.set		  = at91_gpiolib_set,		\
 			.dbg_show	  = at91_gpiolib_dbg_show,	\
-			.base		  = base_gpio,			\
 			.to_irq		  = at91_gpiolib_to_irq,	\
 			.ngpio		  = nr_gpio,			\
 		},							\
 	}
 
 static struct at91_gpio_chip gpio_chip[] = {
-	AT91_GPIO_CHIP("pioA", 0x00, 32),
-	AT91_GPIO_CHIP("pioB", 0x20, 32),
-	AT91_GPIO_CHIP("pioC", 0x40, 32),
-	AT91_GPIO_CHIP("pioD", 0x60, 32),
-	AT91_GPIO_CHIP("pioE", 0x80, 32),
+	AT91_GPIO_CHIP("pioA", 32),
+	AT91_GPIO_CHIP("pioB", 32),
+	AT91_GPIO_CHIP("pioC", 32),
+	AT91_GPIO_CHIP("pioD", 32),
+	AT91_GPIO_CHIP("pioE", 32),
 };
 
 static int gpio_banks;
-- 
1.7.9

