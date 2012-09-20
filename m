Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2ITMQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:16:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49890 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2ITMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/32] ARM: ux500: Rename MSP board file to something more meaningful
Date: Thu, 20 Sep 2012 14:12:40 +0200
Message-Id: <1348143170-2130-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'msp' board file does more than just register MSP devices. It
also registers some other components necessary to get audio working
on ux500 based platforms; such as the PCM and Machine Drivers. For
that reason we're changing the filename to be more encompassing -
'audio'.

Acked-by: Ola Lilja <ola.o.lilja@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/Makefile                       |    2 +-
 .../{board-mop500-msp.c => board-mop500-audio.c}   |   16 ++++++++--------
 arch/arm/mach-ux500/board-mop500.c                 |   12 ++++++------
 arch/arm/mach-ux500/board-mop500.h                 |    4 ++--
 4 files changed, 17 insertions(+), 17 deletions(-)
 rename arch/arm/mach-ux500/{board-mop500-msp.c => board-mop500-audio.c} (98%)

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 026086f..1dc2cfa 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -12,6 +12,6 @@ obj-$(CONFIG_MACH_MOP500)	+= board-mop500.o board-mop500-sdi.o \
 				board-mop500-uib.o board-mop500-stuib.o \
 				board-mop500-u8500uib.o \
 				board-mop500-pins.o \
-				board-mop500-msp.o
+				board-mop500-audio.o
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-audio.c
similarity index 98%
rename from arch/arm/mach-ux500/board-mop500-msp.c
rename to arch/arm/mach-ux500/board-mop500-audio.c
index d04f54d..070629a 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -171,14 +171,7 @@ struct msp_i2s_platform_data msp3_platform_data = {
 	.msp_i2s_dma_tx	= NULL,
 };
 
-/* Due for removal once the MSP driver has been fully DT:ed. */
-void mop500_of_msp_init(struct device *parent)
-{
-	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
-	platform_device_register(&ux500_pcm);
-}
-
-void mop500_msp_init(struct device *parent)
+void mop500_audio_init(struct device *parent)
 {
 	pr_info("%s: Register platform-device 'snd-soc-mop500'.\n", __func__);
 	platform_device_register(&snd_soc_mop500);
@@ -193,3 +186,10 @@ void mop500_msp_init(struct device *parent)
 	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
 			   &msp3_platform_data);
 }
+
+/* Due for removal once the MSP driver has been fully DT:ed. */
+void mop500_of_audio_init(struct device *parent)
+{
+	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
+	platform_device_register(&ux500_pcm);
+}
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 2cb13bc..ab3fe2c 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -607,7 +607,7 @@ static void __init mop500_init_machine(void)
 	mop500_i2c_init(parent);
 	mop500_sdi_init(parent);
 	mop500_spi_init(parent);
-	mop500_msp_init(parent);
+	mop500_audio_init(parent);
 	mop500_uart_init(parent);
 
 	u8500_cryp1_hash1_init(parent);
@@ -641,7 +641,7 @@ static void __init snowball_init_machine(void)
 	mop500_i2c_init(parent);
 	snowball_sdi_init(parent);
 	mop500_spi_init(parent);
-	mop500_msp_init(parent);
+	mop500_audio_init(parent);
 	mop500_uart_init(parent);
 
 	/* This board has full regulator constraints */
@@ -673,7 +673,7 @@ static void __init hrefv60_init_machine(void)
 	mop500_i2c_init(parent);
 	hrefv60_sdi_init(parent);
 	mop500_spi_init(parent);
-	mop500_msp_init(parent);
+	mop500_audio_init(parent);
 	mop500_uart_init(parent);
 
 	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
@@ -804,7 +804,7 @@ static void __init u8500_init_machine(void)
 				ARRAY_SIZE(mop500_platform_devs));
 
 		mop500_sdi_init(parent);
-		mop500_msp_init(parent);
+		mop500_audio_init(parent);
 		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 		i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
 		i2c_register_board_info(2, mop500_i2c2_devices,
@@ -813,7 +813,7 @@ static void __init u8500_init_machine(void)
 		mop500_uib_init();
 
 	} else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
-		mop500_of_msp_init(parent);
+		mop500_of_audio_init(parent);
 	} else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
 		/*
 		 * The HREFv60 board removed a GPIO expander and routed
@@ -825,7 +825,7 @@ static void __init u8500_init_machine(void)
 				ARRAY_SIZE(mop500_platform_devs));
 
 		hrefv60_sdi_init(parent);
-		mop500_msp_init(parent);
+		mop500_audio_init(parent);
 
 		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 		i2c0_devs -= NUM_PRE_V60_I2C0_DEVICES;
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 6794324..aca39a6 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -99,9 +99,9 @@ void __init mop500_stuib_init(void);
 void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
 void __init hrefv60_pinmaps_init(void);
-void mop500_msp_init(struct device *parent);
+void mop500_audio_init(struct device *parent);
 /* Due for removal once the MSP driver has been fully DT:ed. */
-void mop500_of_msp_init(struct device *parent);
+void mop500_of_audio_init(struct device *parent);
 
 int __init mop500_uib_init(void);
 void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
-- 
1.7.9.5

