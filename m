Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab2HXPO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:14:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56533 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab2HXPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:14:52 -0400
Date: Fri, 24 Aug 2012 16:14:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ola.o.lilja@stericsson.com" <ola.o.lilja@stericsson.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "roger.xr.nilsson@stericsson.com" <roger.xr.nilsson@stericsson.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "STEricsson_nomadik_linux@list.st.com" 
	<STEricsson_nomadik_linux@list.st.com>
Subject: Re: [alsa-devel] [PATCH 14/17] ARM: ux500: Rename MSP board file to
 something more meaningful
Message-ID: <20120824151446.GQ32491@gmail.com>
References: <1345816913-4113-1-git-send-email-lee.jones@linaro.org>
 <1345816913-4113-15-git-send-email-lee.jones@linaro.org>
 <1BAFE6F6C881BF42822005164F1491C33EA69B3A@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EA69B3A@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like this?

From: Lee Jones <lee.jones@linaro.org>
Date: Fri, 24 Aug 2012 13:16:06 +0100
Subject: [PATCH 1/1] ARM: ux500: Rename MSP board file to something more meaningful

The 'msp' board file does more than just register MSP devices. It
also registers some other components necessary to get audio working
on ux500 based platforms; such as the PCM and Machine Drivers. For
that reason we're changing the filename to be more encompassing -
'audio'.

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
index 2af017f..18f6c5a 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -172,14 +172,7 @@ struct msp_i2s_platform_data msp3_platform_data = {
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
@@ -197,3 +190,10 @@ void mop500_msp_init(struct device *parent)
 	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
 	platform_device_register(&ux500_pcm);
 }
+
+/* Due for removal once the MSP driver has been fully DT:ed. */
+void mop500_of_audio_init(struct device *parent)
+{
+	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
+	platform_device_register(&ux500_pcm);
+}
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 0c141d5..7152635 100644
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
@@ -807,7 +807,7 @@ static void __init u8500_init_machine(void)
 				ARRAY_SIZE(mop500_platform_devs));
 
 		mop500_sdi_init(parent);
-		mop500_msp_init(parent);
+		mop500_audio_init(parent);
 		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 		i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
 		i2c_register_board_info(2, mop500_i2c2_devices,
@@ -816,7 +816,7 @@ static void __init u8500_init_machine(void)
 		mop500_uib_init();
 
 	} else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
-		mop500_of_msp_init(parent);
+		mop500_of_audio_init(parent);
 	} else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
 		/*
 		 * The HREFv60 board removed a GPIO expander and routed
@@ -828,7 +828,7 @@ static void __init u8500_init_machine(void)
 				ARRAY_SIZE(mop500_platform_devs));
 
 		hrefv60_sdi_init(parent);
-		mop500_msp_init(parent);
+		mop500_audio_init(parent);
 
 		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 		i2c0_devs -= NUM_PRE_V60_I2C0_DEVICES;
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index 3fbf48f..9e9dd5a 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -97,9 +97,9 @@ void __init mop500_stuib_init(void);
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
