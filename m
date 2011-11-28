Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1K1Log (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:44:36 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:36126 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1K1Loe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:44:34 -0500
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <92ee310a6e5161954d60357cd6f71993f6dad616.1322479017.git.n.voss@weinmann.de>
In-Reply-To: <cover.1322479017.git.n.voss@weinmann.de>
References: <cover.1322479017.git.n.voss@weinmann.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Mon, 28 Nov 2011 12:12:05 +0100
Subject: [PATCH v8 7/7] i2c-at91: make ckdiv bug a property of the
 platform_device
To: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The twi IP of AT91RM9200 has a bug which limits ckdiv to be
less than or equal to 5. Previously, this was checked in the
driver with cpu_is_rm9200(). This patch moves this information
into the platform_device as suggested by Arnd Bergmann.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 arch/arm/mach-at91/at91cap9_devices.c    |    9 +++++++++
 arch/arm/mach-at91/at91rm9200_devices.c  |    9 +++++++++
 arch/arm/mach-at91/at91sam9260_devices.c |    9 +++++++++
 arch/arm/mach-at91/at91sam9261_devices.c |    9 +++++++++
 arch/arm/mach-at91/at91sam9263_devices.c |    9 +++++++++
 arch/arm/mach-at91/at91sam9g45_devices.c |   10 ++++++++++
 arch/arm/mach-at91/at91sam9rl_devices.c  |    9 +++++++++
 drivers/i2c/busses/i2c-at91.c            |    7 ++++---
 8 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
index adad70d..495fd24 100644
--- a/arch/arm/mach-at91/at91cap9_devices.c
+++ b/arch/arm/mach-at91/at91cap9_devices.c
@@ -496,9 +496,18 @@ static struct resource twi_resources[] = {
 	},
 };
 
+static const struct platform_device_id twi_id = {
+	/*
+	 * driver_data is "1" for hardware with ckdiv upper limit == 5
+	 * (AT91RM9200 erratum 22), "0" for twi modules without this bug
+	 */
+	.driver_data	= 0,
+};
+
 static struct platform_device at91cap9_twi_device = {
 	.name		= "at91_i2c",
 	.id		= -1,
+	.id_entry	= &twi_id,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 66591fa..8db7383 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -493,9 +493,18 @@ static struct resource twi_resources[] = {
 	},
 };
 
+static const struct platform_device_id twi_id = {
+	/*
+	 * driver_data is "1" for hardware with ckdiv upper limit == 5
+	 * (AT91RM9200 erratum 22), "0" for twi modules without this bug
+	 */
+	.driver_data	= 1,
+};
+
 static struct platform_device at91rm9200_twi_device = {
 	.name		= "at91_i2c",
 	.id		= -1,
+	.id_entry	= &twi_id,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 25e3464..1e9a075 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -498,9 +498,18 @@ static struct resource twi_resources[] = {
 	},
 };
 
+static const struct platform_device_id twi_id = {
+	/*
+	 * driver_data is "1" for hardware with ckdiv upper limit == 5
+	 * (AT91RM9200 erratum 22), "0" for twi modules without this bug
+	 */
+	.driver_data	= 0,
+};
+
 static struct platform_device at91sam9260_twi_device = {
 	.name		= "at91_i2c",
 	.id		= -1,
+	.id_entry	= &twi_id,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index ae78f4d..16f22b7 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -315,9 +315,18 @@ static struct resource twi_resources[] = {
 	},
 };
 
+static const struct platform_device_id twi_id = {
+	/*
+	 * driver_data is "1" for hardware with ckdiv upper limit == 5
+	 * (AT91RM9200 erratum 22), "0" for twi modules without this bug
+	 */
+	.driver_data	= 0,
+};
+
 static struct platform_device at91sam9261_twi_device = {
 	.name		= "at91_i2c",
 	.id		= -1,
+	.id_entry	= &twi_id,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index ad017eb..346d258 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -571,9 +571,18 @@ static struct resource twi_resources[] = {
 	},
 };
 
+static const struct platform_device_id twi_id = {
+	/*
+	 * driver_data is "1" for hardware with ckdiv upper limit == 5
+	 * (AT91RM9200 erratum 22), "0" for twi modules without this bug
+	 */
+	.driver_data	= 0,
+};
+
 static struct platform_device at91sam9263_twi_device = {
 	.name		= "at91_i2c",
 	.id		= -1,
+	.id_entry	= &twi_id,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 8743b14..5916f0e 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -650,9 +650,18 @@ static struct resource twi0_resources[] = {
 	},
 };
 
+static const struct platform_device_id twi_id = {
+	/*
+	 * driver_data is "1" for hardware with ckdiv upper limit == 5
+	 * (AT91RM9200 erratum 22), "0" for twi modules without this bug
+	 */
+	.driver_data	= 0,
+};
+
 static struct platform_device at91sam9g45_twi0_device = {
 	.name		= "at91_i2c",
 	.id		= 0,
+	.id_entry	= &twi_id,
 	.resource	= twi0_resources,
 	.num_resources	= ARRAY_SIZE(twi0_resources),
 };
@@ -673,6 +682,7 @@ static struct resource twi1_resources[] = {
 static struct platform_device at91sam9g45_twi1_device = {
 	.name		= "at91_i2c",
 	.id		= 1,
+	.id_entry	= &twi_id,
 	.resource	= twi1_resources,
 	.num_resources	= ARRAY_SIZE(twi1_resources),
 };
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 628eb56..bec28b5 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -350,9 +350,18 @@ static struct resource twi_resources[] = {
 	},
 };
 
+static const struct platform_device_id twi_id = {
+	/*
+	 * driver_data is "1" for hardware with ckdiv upper limit == 5
+	 * (AT91RM9200 erratum 22), "0" for twi modules without this bug
+	 */
+	.driver_data	= 0,
+};
+
 static struct platform_device at91sam9rl_twi_device = {
 	.name		= "at91_i2c",
 	.id		= -1,
+	.id_entry	= &twi_id,
 	.resource	= twi_resources,
 	.num_resources	= ARRAY_SIZE(twi_resources),
 };
diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 34deef4..4364dd1 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -27,8 +27,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <mach/cpu.h>
-
 #define TWI_CLK_HZ		100000			/* max 400 Kbits/s */
 #define AT91_I2C_TIMEOUT	msecs_to_jiffies(100)	/* transfer timeout */
 
@@ -74,6 +72,7 @@ struct at91_twi_dev {
 	int			irq;
 	unsigned		transfer_status;
 	struct i2c_adapter	adapter;
+	bool			has_ckdiv_limit_bug;
 };
 
 static unsigned at91_twi_read(struct at91_twi_dev *dev, unsigned reg)
@@ -110,7 +109,7 @@ static void __devinit at91_set_twi_clock(struct at91_twi_dev *dev, int twi_clk)
 	int ckdiv = fls(div >> 8);
 	const int cdiv = div >> ckdiv;
 
-	if (cpu_is_at91rm9200() && (ckdiv > 5)) {
+	if (dev->has_ckdiv_limit_bug && (ckdiv > 5)) {
 		dev_warn(dev->dev, "AT91RM9200 erratum 22: using ckdiv = 5.\n");
 		ckdiv = 5;
 	}
@@ -314,6 +313,8 @@ static int __devinit at91_twi_probe(struct platform_device *pdev)
 		goto err_release_region;
 	}
 
+	dev->has_ckdiv_limit_bug = pdev->id_entry->driver_data == 1;
+
 	init_completion(&dev->cmd_complete);
 
 	dev->dev = &pdev->dev;
-- 
1.7.5.4

