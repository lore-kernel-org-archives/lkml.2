Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1GFSBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:01:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33946 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab1GFSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:01:18 -0400
Subject: [PATCH] gpio: Move mpc5200 gpio driver to drivers/gpio
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 06 Jul 2011 12:01:15 -0600
Message-ID: <20110706175950.1776.79176.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO drivers are getting consolidated into drivers/gpio.  While at it,
change the driver name to mpc5200-gpio* to avoid collisions.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Ben, I'm going to take this via the gpio/next branch to avoid
conflicts with the big gpio rename.

g.

 arch/powerpc/platforms/52xx/Kconfig        |    8 --------
 arch/powerpc/platforms/52xx/Makefile       |    1 -
 drivers/gpio/Kconfig                       |    4 ++++
 drivers/gpio/Makefile                      |    1 +
 drivers/gpio/gpio-mpc5200.c                |   12 ++++--------
 5 files changed, 9 insertions(+), 17 deletions(-)
 rename arch/powerpc/platforms/52xx/mpc52xx_gpio.c => drivers/gpio/gpio-mpc5200.c (98%)

diff --git a/arch/powerpc/platforms/52xx/Kconfig b/arch/powerpc/platforms/52xx/Kconfig
index 47ea1be..90f4496 100644
--- a/arch/powerpc/platforms/52xx/Kconfig
+++ b/arch/powerpc/platforms/52xx/Kconfig
@@ -55,14 +55,6 @@ config PPC_MPC5200_BUGFIX
 
 	  It is safe to say 'Y' here
 
-config PPC_MPC5200_GPIO
-	bool "MPC5200 GPIO support"
-	depends on PPC_MPC52xx
-	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_GPIO
-	help
-	  Enable gpiolib support for mpc5200 based boards
-
 config PPC_MPC5200_LPBFIFO
 	tristate "MPC5200 LocalPlus bus FIFO driver"
 	depends on PPC_MPC52xx
diff --git a/arch/powerpc/platforms/52xx/Makefile b/arch/powerpc/platforms/52xx/Makefile
index 2bc8cd0..4e62486 100644
--- a/arch/powerpc/platforms/52xx/Makefile
+++ b/arch/powerpc/platforms/52xx/Makefile
@@ -14,5 +14,4 @@ ifeq ($(CONFIG_PPC_LITE5200),y)
 	obj-$(CONFIG_PM)	+= lite5200_sleep.o lite5200_pm.o
 endif
 
-obj-$(CONFIG_PPC_MPC5200_GPIO)	+= mpc52xx_gpio.o
 obj-$(CONFIG_PPC_MPC5200_LPBFIFO)	+= mpc52xx_lpbfifo.o
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index a4ac78b..47eae6e 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -99,6 +99,10 @@ config GPIO_EXYNOS4
 	def_bool y
 	depends on CPU_EXYNOS4210
 
+config GPIO_MPC5200
+	def_bool y
+	depends on PPC_MPC52xx
+
 config GPIO_MXC
 	def_bool y
 	depends on ARCH_MXC
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index b847fb5..7207112 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_GPIO_MAX732X)	+= gpio-max732x.o
 obj-$(CONFIG_GPIO_MC33880)	+= gpio-mc33880.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= gpio-mcp23s08.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= gpio-ml-ioh.o
+obj-$(CONFIG_GPIO_MPC5200)	+= gpio-mpc5200.o
 obj-$(CONFIG_GPIO_MXC)		+= gpio-mxc.o
 obj-$(CONFIG_GPIO_MXS)		+= gpio-mxs.o
 obj-$(CONFIG_PLAT_NOMADIK)	+= gpio-nomadik.o
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c b/drivers/gpio/gpio-mpc5200.c
similarity index 98%
rename from arch/powerpc/platforms/52xx/mpc52xx_gpio.c
rename to drivers/gpio/gpio-mpc5200.c
index 1757d1d..9b325dd 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
+++ b/drivers/gpio/gpio-mpc5200.c
@@ -184,15 +184,13 @@ static int mpc52xx_gpiochip_remove(struct platform_device *ofdev)
 }
 
 static const struct of_device_id mpc52xx_wkup_gpiochip_match[] = {
-	{
-		.compatible = "fsl,mpc5200-gpio-wkup",
-	},
+	{ .compatible = "fsl,mpc5200-gpio-wkup", },
 	{}
 };
 
 static struct platform_driver mpc52xx_wkup_gpiochip_driver = {
 	.driver = {
-		.name = "gpio_wkup",
+		.name = "mpc5200-gpio-wkup",
 		.owner = THIS_MODULE,
 		.of_match_table = mpc52xx_wkup_gpiochip_match,
 	},
@@ -341,15 +339,13 @@ static int __devinit mpc52xx_simple_gpiochip_probe(struct platform_device *ofdev
 }
 
 static const struct of_device_id mpc52xx_simple_gpiochip_match[] = {
-	{
-		.compatible = "fsl,mpc5200-gpio",
-	},
+	{ .compatible = "fsl,mpc5200-gpio", },
 	{}
 };
 
 static struct platform_driver mpc52xx_simple_gpiochip_driver = {
 	.driver = {
-		.name = "gpio",
+		.name = "gpio-mpc5200",
 		.owner = THIS_MODULE,
 		.of_match_table = mpc52xx_simple_gpiochip_match,
 	},

