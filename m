Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1HYXrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:47:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46632 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1HYXn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:43:56 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v3 01/13] arm/tegra: Prep boards for gpio/pinmux conversion to pdevs
Date: Thu, 25 Aug 2011 17:43:32 -0600
Message-Id: <1314315824-9687-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra GPIO driver will be converted from static registration via
postcore_initcall() to be a platform device later in this patch series.
A new Tegra pinmux platform device will also be added.

Prepare for this by modifying all boards to register the appropriate
platform devices before-hand, so that when the drivers are converted,
those devices will be probed, and git bisectability will be maintained.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/board-harmony-pinmux.c   |    8 ++++++++
 arch/arm/mach-tegra/board-paz00-pinmux.c     |    8 ++++++++
 arch/arm/mach-tegra/board-seaboard-pinmux.c  |    9 +++++++--
 arch/arm/mach-tegra/board-trimslice-pinmux.c |    7 +++++++
 arch/arm/mach-tegra/devices.c                |   10 ++++++++++
 arch/arm/mach-tegra/devices.h                |    2 ++
 6 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony-pinmux.c b/arch/arm/mach-tegra/board-harmony-pinmux.c
index 4d63e2e..e99b456 100644
--- a/arch/arm/mach-tegra/board-harmony-pinmux.c
+++ b/arch/arm/mach-tegra/board-harmony-pinmux.c
@@ -20,6 +20,7 @@
 
 #include "gpio-names.h"
 #include "board-harmony.h"
+#include "devices.h"
 
 static struct tegra_pingroup_config harmony_pinmux[] = {
 	{TEGRA_PINGROUP_ATA,   TEGRA_MUX_IDE,           TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
@@ -140,6 +141,11 @@ static struct tegra_pingroup_config harmony_pinmux[] = {
 	{TEGRA_PINGROUP_XM2D,  TEGRA_MUX_NONE,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
 };
 
+static struct platform_device *pinmux_devices[] = {
+	&tegra_gpio_device,
+	&tegra_pinmux_device,
+};
+
 static struct tegra_gpio_table gpio_table[] = {
 	{ .gpio = TEGRA_GPIO_SD2_CD,		.enable = true	},
 	{ .gpio = TEGRA_GPIO_SD2_WP,		.enable = true	},
@@ -155,6 +161,8 @@ static struct tegra_gpio_table gpio_table[] = {
 
 void harmony_pinmux_init(void)
 {
+	platform_add_devices(pinmux_devices, ARRAY_SIZE(pinmux_devices));
+
 	tegra_pinmux_config_table(harmony_pinmux, ARRAY_SIZE(harmony_pinmux));
 
 	tegra_gpio_config(gpio_table, ARRAY_SIZE(gpio_table));
diff --git a/arch/arm/mach-tegra/board-paz00-pinmux.c b/arch/arm/mach-tegra/board-paz00-pinmux.c
index bdd2627..43633f4 100644
--- a/arch/arm/mach-tegra/board-paz00-pinmux.c
+++ b/arch/arm/mach-tegra/board-paz00-pinmux.c
@@ -20,6 +20,7 @@
 
 #include "gpio-names.h"
 #include "board-paz00.h"
+#include "devices.h"
 
 static struct tegra_pingroup_config paz00_pinmux[] = {
 	{TEGRA_PINGROUP_ATA,   TEGRA_MUX_GMI,           TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
@@ -140,6 +141,11 @@ static struct tegra_pingroup_config paz00_pinmux[] = {
 	{TEGRA_PINGROUP_XM2D,  TEGRA_MUX_NONE,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
 };
 
+static struct platform_device *pinmux_devices[] = {
+	&tegra_gpio_device,
+	&tegra_pinmux_device,
+};
+
 static struct tegra_gpio_table gpio_table[] = {
 	{ .gpio = TEGRA_GPIO_SD1_CD,	.enable = true },
 	{ .gpio = TEGRA_GPIO_SD1_WP,	.enable = true },
@@ -149,6 +155,8 @@ static struct tegra_gpio_table gpio_table[] = {
 
 void paz00_pinmux_init(void)
 {
+	platform_add_devices(pinmux_devices, ARRAY_SIZE(pinmux_devices));
+
 	tegra_pinmux_config_table(paz00_pinmux, ARRAY_SIZE(paz00_pinmux));
 
 	tegra_gpio_config(gpio_table, ARRAY_SIZE(gpio_table));
diff --git a/arch/arm/mach-tegra/board-seaboard-pinmux.c b/arch/arm/mach-tegra/board-seaboard-pinmux.c
index 74f78b7..f092298 100644
--- a/arch/arm/mach-tegra/board-seaboard-pinmux.c
+++ b/arch/arm/mach-tegra/board-seaboard-pinmux.c
@@ -21,6 +21,7 @@
 
 #include "gpio-names.h"
 #include "board-seaboard.h"
+#include "devices.h"
 
 #define DEFAULT_DRIVE(_name)					\
 	{							\
@@ -157,8 +158,10 @@ static __initdata struct tegra_pingroup_config seaboard_pinmux[] = {
 	{TEGRA_PINGROUP_XM2D,  TEGRA_MUX_NONE,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
 };
 
-
-
+static struct platform_device *pinmux_devices[] = {
+	&tegra_gpio_device,
+	&tegra_pinmux_device,
+};
 
 static struct tegra_gpio_table gpio_table[] = {
 	{ .gpio = TEGRA_GPIO_SD2_CD,		.enable = true },
@@ -173,6 +176,8 @@ static struct tegra_gpio_table gpio_table[] = {
 
 void __init seaboard_pinmux_init(void)
 {
+	platform_add_devices(pinmux_devices, ARRAY_SIZE(pinmux_devices));
+
 	tegra_pinmux_config_table(seaboard_pinmux, ARRAY_SIZE(seaboard_pinmux));
 
 	tegra_drive_pinmux_config_table(seaboard_drive_pinmux,
diff --git a/arch/arm/mach-tegra/board-trimslice-pinmux.c b/arch/arm/mach-tegra/board-trimslice-pinmux.c
index bcb1916..4969dd2 100644
--- a/arch/arm/mach-tegra/board-trimslice-pinmux.c
+++ b/arch/arm/mach-tegra/board-trimslice-pinmux.c
@@ -21,6 +21,7 @@
 
 #include "gpio-names.h"
 #include "board-trimslice.h"
+#include "devices.h"
 
 static __initdata struct tegra_pingroup_config trimslice_pinmux[] = {
 	{TEGRA_PINGROUP_ATA,   TEGRA_MUX_IDE,           TEGRA_PUPD_NORMAL,	TEGRA_TRI_TRISTATE},
@@ -141,6 +142,11 @@ static __initdata struct tegra_pingroup_config trimslice_pinmux[] = {
 	{TEGRA_PINGROUP_XM2D,  TEGRA_MUX_NONE,          TEGRA_PUPD_NORMAL,      TEGRA_TRI_NORMAL},
 };
 
+static struct platform_device *pinmux_devices[] = {
+	&tegra_gpio_device,
+	&tegra_pinmux_device,
+};
+
 static struct tegra_gpio_table gpio_table[] = {
 	{ .gpio = TRIMSLICE_GPIO_SD4_CD, .enable = true	}, /* mmc4 cd */
 	{ .gpio = TRIMSLICE_GPIO_SD4_WP, .enable = true	}, /* mmc4 wp */
@@ -151,6 +157,7 @@ static struct tegra_gpio_table gpio_table[] = {
 
 void __init trimslice_pinmux_init(void)
 {
+	platform_add_devices(pinmux_devices, ARRAY_SIZE(pinmux_devices));
 	tegra_pinmux_config_table(trimslice_pinmux, ARRAY_SIZE(trimslice_pinmux));
 	tegra_gpio_config(gpio_table, ARRAY_SIZE(gpio_table));
 }
diff --git a/arch/arm/mach-tegra/devices.c b/arch/arm/mach-tegra/devices.c
index 57e35d2..48262bf 100644
--- a/arch/arm/mach-tegra/devices.c
+++ b/arch/arm/mach-tegra/devices.c
@@ -31,6 +31,16 @@
 #include <mach/usb_phy.h>
 #include "gpio-names.h"
 
+struct platform_device tegra_gpio_device = {
+	.name		= "tegra-gpio",
+	.id		= -1,
+};
+
+struct platform_device tegra_pinmux_device = {
+	.name		= "tegra-pinmux",
+	.id		= -1,
+};
+
 static struct resource i2c_resource1[] = {
 	[0] = {
 		.start	= INT_I2C,
diff --git a/arch/arm/mach-tegra/devices.h b/arch/arm/mach-tegra/devices.h
index 4a7dc0a..873ecb2 100644
--- a/arch/arm/mach-tegra/devices.h
+++ b/arch/arm/mach-tegra/devices.h
@@ -21,6 +21,8 @@
 
 #include <linux/platform_device.h>
 
+extern struct platform_device tegra_gpio_device;
+extern struct platform_device tegra_pinmux_device;
 extern struct platform_device tegra_sdhci_device1;
 extern struct platform_device tegra_sdhci_device2;
 extern struct platform_device tegra_sdhci_device3;
-- 
1.7.0.4

