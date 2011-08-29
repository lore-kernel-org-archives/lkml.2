Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1H2TyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 15:54:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51850 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1H2TyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 15:54:10 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] leds: kill CONFIG_LEDS_CLASS option
Date: Tue, 30 Aug 2011 03:53:48 +0800
Message-Id: <1314647628-21707-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost all the new leds driver and trigger driver are depends on
CONFIG_LED_CLASS, so there is no such user with CONFIG_NEW_LEDS=y
and CONFIG_LED_CLASS=n. Moreover, lots of API functions in led-class.c
are very common and should be built-in when CONFIG_NEW_LEDS=y.

Obviously, CONFIG_LEDS_CLASS is pointless. This patch kills it and
also updates defconfigs which contains CONFIG_LEDS_CLASS.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/configs/at91rm9200_defconfig              |    1 -
 arch/arm/configs/at91sam9261_defconfig             |    1 -
 arch/arm/configs/at91sam9263_defconfig             |    1 -
 arch/arm/configs/at91sam9g20ek_defconfig           |    1 -
 arch/arm/configs/cm_x2xx_defconfig                 |    1 -
 arch/arm/configs/cm_x300_defconfig                 |    1 -
 arch/arm/configs/collie_defconfig                  |    1 -
 arch/arm/configs/cpu9260_defconfig                 |    1 -
 arch/arm/configs/cpu9g20_defconfig                 |    1 -
 arch/arm/configs/davinci_all_defconfig             |    1 -
 arch/arm/configs/em_x270_defconfig                 |    1 -
 arch/arm/configs/ezx_defconfig                     |    1 -
 arch/arm/configs/imote2_defconfig                  |    1 -
 arch/arm/configs/ixp4xx_defconfig                  |    1 -
 arch/arm/configs/kirkwood_defconfig                |    1 -
 arch/arm/configs/magician_defconfig                |    1 -
 arch/arm/configs/mini2440_defconfig                |    1 -
 arch/arm/configs/msm_defconfig                     |    1 -
 arch/arm/configs/mv78xx0_defconfig                 |    1 -
 arch/arm/configs/mx51_defconfig                    |    1 -
 arch/arm/configs/omap1_defconfig                   |    1 -
 arch/arm/configs/orion5x_defconfig                 |    1 -
 arch/arm/configs/pcontrol_g20_defconfig            |    1 -
 arch/arm/configs/pxa3xx_defconfig                  |    1 -
 arch/arm/configs/qil-a9260_defconfig               |    1 -
 arch/arm/configs/raumfeld_defconfig                |    1 -
 arch/arm/configs/realview-smp_defconfig            |    1 -
 arch/arm/configs/realview_defconfig                |    1 -
 arch/arm/configs/s3c2410_defconfig                 |    1 -
 arch/arm/configs/sam9_l9260_defconfig              |    1 -
 arch/arm/configs/stamp9g20_defconfig               |    1 -
 arch/arm/configs/u8500_defconfig                   |    1 -
 arch/arm/configs/usb-a9260_defconfig               |    1 -
 arch/arm/configs/zeus_defconfig                    |    1 -
 arch/arm/mach-davinci/board-dm365-evm.c            |    2 +-
 arch/arm/mach-s3c2440/Kconfig                      |    1 -
 arch/arm/plat-omap/Kconfig                         |    2 +-
 arch/arm/plat-versatile/Kconfig                    |    2 +-
 arch/avr32/configs/atngw100_defconfig              |    1 -
 arch/avr32/configs/atngw100_evklcd100_defconfig    |    1 -
 arch/avr32/configs/atngw100_evklcd101_defconfig    |    1 -
 arch/avr32/configs/atngw100_mrmt_defconfig         |    1 -
 arch/avr32/configs/atngw100mkii_defconfig          |    1 -
 .../avr32/configs/atngw100mkii_evklcd100_defconfig |    1 -
 .../avr32/configs/atngw100mkii_evklcd101_defconfig |    1 -
 arch/avr32/configs/atstk1002_defconfig             |    1 -
 arch/avr32/configs/atstk1003_defconfig             |    1 -
 arch/avr32/configs/atstk1004_defconfig             |    1 -
 arch/avr32/configs/atstk1006_defconfig             |    1 -
 arch/avr32/configs/favr-32_defconfig               |    1 -
 arch/avr32/configs/merisc_defconfig                |    1 -
 arch/avr32/configs/mimc200_defconfig               |    1 -
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig     |    1 -
 arch/mips/configs/ar7_defconfig                    |    1 -
 arch/mips/configs/bcm47xx_defconfig                |    1 -
 arch/mips/configs/bcm63xx_defconfig                |    1 -
 arch/mips/configs/cobalt_defconfig                 |    1 -
 arch/mips/configs/db1200_defconfig                 |    1 -
 arch/mips/configs/jmr3927_defconfig                |    1 -
 arch/mips/configs/lemote2f_defconfig               |    1 -
 arch/mips/configs/malta_defconfig                  |    1 -
 arch/mips/configs/mtx1_defconfig                   |    1 -
 arch/mips/configs/pb1200_defconfig                 |    1 -
 arch/mips/configs/rb532_defconfig                  |    1 -
 arch/mips/configs/rbtx49xx_defconfig               |    1 -
 arch/mips/txx9/rbtx4939/setup.c                    |    4 +-
 arch/powerpc/configs/44x/warp_defconfig            |    1 -
 arch/powerpc/configs/52xx/motionpro_defconfig      |    1 -
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig    |    1 -
 arch/sh/configs/rsk7203_defconfig                  |    1 -
 arch/sh/configs/sdk7780_defconfig                  |    1 -
 arch/sh/configs/se7712_defconfig                   |    1 -
 arch/sh/configs/se7721_defconfig                   |    1 -
 arch/sh/configs/sh2007_defconfig                   |    1 -
 arch/unicore32/configs/unicore32_defconfig         |    1 -
 drivers/hid/Kconfig                                |    4 +-
 drivers/hwmon/Kconfig                              |    1 -
 drivers/input/joystick/Kconfig                     |    2 +-
 drivers/input/keyboard/Kconfig                     |    2 +-
 drivers/input/misc/Kconfig                         |    3 +-
 drivers/leds/Kconfig                               |   47 +------------------
 drivers/leds/Makefile                              |    3 +-
 drivers/macintosh/Kconfig                          |    3 +-
 drivers/media/rc/Kconfig                           |    1 -
 drivers/mmc/host/au1xmmc.c                         |    6 +-
 drivers/mmc/host/sdhci.c                           |   17 +++----
 drivers/net/wireless/ath/ath5k/Kconfig             |    1 -
 drivers/net/wireless/ath/ath9k/Kconfig             |    2 -
 drivers/net/wireless/ath/carl9170/Kconfig          |    1 -
 drivers/net/wireless/b43/Kconfig                   |    2 +-
 drivers/net/wireless/b43legacy/Kconfig             |    2 +-
 drivers/net/wireless/iwlegacy/Kconfig              |    1 -
 drivers/net/wireless/iwlwifi/Kconfig               |    1 -
 drivers/net/wireless/p54/Kconfig                   |    2 +-
 drivers/net/wireless/rt2x00/Kconfig                |    2 +-
 drivers/net/wireless/rtl818x/Kconfig               |    2 +-
 drivers/platform/x86/Kconfig                       |    9 +---
 drivers/platform/x86/fujitsu-laptop.c              |   12 -----
 drivers/video/backlight/Kconfig                    |    2 -
 include/linux/mmc/sdhci.h                          |    2 +-
 net/mac80211/Kconfig                               |    2 +-
 net/netfilter/Kconfig                              |    2 +-
 102 files changed, 35 insertions(+), 180 deletions(-)

diff --git a/arch/arm/configs/at91rm9200_defconfig b/arch/arm/configs/at91rm9200_defconfig
index 38cb7c9..1840a63 100644
--- a/arch/arm/configs/at91rm9200_defconfig
+++ b/arch/arm/configs/at91rm9200_defconfig
@@ -250,7 +250,6 @@ CONFIG_USB_MASS_STORAGE=m
 CONFIG_MMC=y
 CONFIG_MMC_AT91=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/at91sam9261_defconfig b/arch/arm/configs/at91sam9261_defconfig
index ade6b2f..f0fe08b 100644
--- a/arch/arm/configs/at91sam9261_defconfig
+++ b/arch/arm/configs/at91sam9261_defconfig
@@ -130,7 +130,6 @@ CONFIG_USB_G_SERIAL=m
 CONFIG_MMC=y
 CONFIG_MMC_AT91=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/at91sam9263_defconfig b/arch/arm/configs/at91sam9263_defconfig
index 1cf9626..25970fc 100644
--- a/arch/arm/configs/at91sam9263_defconfig
+++ b/arch/arm/configs/at91sam9263_defconfig
@@ -140,7 +140,6 @@ CONFIG_MMC=y
 CONFIG_SDIO_UART=m
 CONFIG_MMC_AT91=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/arm/configs/at91sam9g20ek_defconfig b/arch/arm/configs/at91sam9g20ek_defconfig
index 9e90e6d..d2f6adc 100644
--- a/arch/arm/configs/at91sam9g20ek_defconfig
+++ b/arch/arm/configs/at91sam9g20ek_defconfig
@@ -97,7 +97,6 @@ CONFIG_USB_G_SERIAL=m
 CONFIG_MMC=y
 CONFIG_MMC_AT91=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/cm_x2xx_defconfig b/arch/arm/configs/cm_x2xx_defconfig
index a93ff8d..3aee332 100644
--- a/arch/arm/configs/cm_x2xx_defconfig
+++ b/arch/arm/configs/cm_x2xx_defconfig
@@ -152,7 +152,6 @@ CONFIG_USB_STORAGE=y
 CONFIG_MMC=m
 CONFIG_MMC_PXA=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
diff --git a/arch/arm/configs/cm_x300_defconfig b/arch/arm/configs/cm_x300_defconfig
index f4b7672..c0ce1f5 100644
--- a/arch/arm/configs/cm_x300_defconfig
+++ b/arch/arm/configs/cm_x300_defconfig
@@ -137,7 +137,6 @@ CONFIG_USB_STORAGE=y
 CONFIG_MMC=m
 CONFIG_MMC_PXA=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
index 6c56ad0..e8e4358 100644
--- a/arch/arm/configs/collie_defconfig
+++ b/arch/arm/configs/collie_defconfig
@@ -72,7 +72,6 @@ CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
 CONFIG_FONTS=y
 CONFIG_FONT_MINI_4x6=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_LOCOMO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/cpu9260_defconfig b/arch/arm/configs/cpu9260_defconfig
index bbf729e..4d07b2d 100644
--- a/arch/arm/configs/cpu9260_defconfig
+++ b/arch/arm/configs/cpu9260_defconfig
@@ -84,7 +84,6 @@ CONFIG_USB_ETH=m
 CONFIG_MMC=y
 CONFIG_MMC_AT91=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/cpu9g20_defconfig b/arch/arm/configs/cpu9g20_defconfig
index e7d7942..45e950c 100644
--- a/arch/arm/configs/cpu9g20_defconfig
+++ b/arch/arm/configs/cpu9g20_defconfig
@@ -84,7 +84,6 @@ CONFIG_USB_ETH=m
 CONFIG_MMC=y
 CONFIG_MMC_AT91=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
index 67b5abb6..792eac6 100644
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -152,7 +152,6 @@ CONFIG_MMC=m
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_MMC_DAVINCI=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=m
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
diff --git a/arch/arm/configs/em_x270_defconfig b/arch/arm/configs/em_x270_defconfig
index 60a21e0..beba41f 100644
--- a/arch/arm/configs/em_x270_defconfig
+++ b/arch/arm/configs/em_x270_defconfig
@@ -152,7 +152,6 @@ CONFIG_USB_STORAGE=y
 CONFIG_MMC=m
 CONFIG_MMC_PXA=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_DA903X=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
index 227a477..b93013c 100644
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -296,7 +296,6 @@ CONFIG_SDIO_UART=m
 CONFIG_MMC_PXA=y
 CONFIG_MMC_SPI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_LP3944=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/imote2_defconfig b/arch/arm/configs/imote2_defconfig
index 176ec22..9cd3eb9 100644
--- a/arch/arm/configs/imote2_defconfig
+++ b/arch/arm/configs/imote2_defconfig
@@ -272,7 +272,6 @@ CONFIG_SDIO_UART=m
 CONFIG_MMC_PXA=y
 CONFIG_MMC_SPI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_LP3944=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/ixp4xx_defconfig b/arch/arm/configs/ixp4xx_defconfig
index 063e2ab..8cd6af4 100644
--- a/arch/arm/configs/ixp4xx_defconfig
+++ b/arch/arm/configs/ixp4xx_defconfig
@@ -176,7 +176,6 @@ CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_UHCI_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_FSG=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/arm/configs/kirkwood_defconfig b/arch/arm/configs/kirkwood_defconfig
index aeb3af5..c489f93 100644
--- a/arch/arm/configs/kirkwood_defconfig
+++ b/arch/arm/configs/kirkwood_defconfig
@@ -134,7 +134,6 @@ CONFIG_MMC=y
 CONFIG_SDIO_UART=y
 CONFIG_MMC_MVSDIO=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index a88e64d..7246362 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -144,7 +144,6 @@ CONFIG_MMC=y
 CONFIG_SDIO_UART=m
 CONFIG_MMC_PXA=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_BACKLIGHT=y
diff --git a/arch/arm/configs/mini2440_defconfig b/arch/arm/configs/mini2440_defconfig
index 2472a95..456f3bf 100644
--- a/arch/arm/configs/mini2440_defconfig
+++ b/arch/arm/configs/mini2440_defconfig
@@ -247,7 +247,6 @@ CONFIG_SDIO_UART=y
 CONFIG_MMC_SDHCI=y
 CONFIG_MMC_SPI=y
 CONFIG_MMC_S3C=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_S3C24XX=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index 2b8f7af..c95e53e 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -60,7 +60,6 @@ CONFIG_FB_MSM=y
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_INOTIFY=y
 CONFIG_TMPFS=y
 CONFIG_MAGIC_SYSRQ=y
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index 7305ebd..c9c9da0 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -93,7 +93,6 @@ CONFIG_USB_STORAGE_SDDR09=y
 CONFIG_USB_STORAGE_SDDR55=y
 CONFIG_USB_STORAGE_JUMPSHOT=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
diff --git a/arch/arm/configs/mx51_defconfig b/arch/arm/configs/mx51_defconfig
index 88c5802..b2f4dd9 100644
--- a/arch/arm/configs/mx51_defconfig
+++ b/arch/arm/configs/mx51_defconfig
@@ -111,7 +111,6 @@ CONFIG_MMC=y
 CONFIG_MMC_BLOCK=m
 CONFIG_MMC_SDHCI=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_INTF_DEV_UIE_EMUL=y
 CONFIG_EXT2_FS=y
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index 7b63462..2319972 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -228,7 +228,6 @@ CONFIG_MMC_SDHCI=y
 CONFIG_MMC_SDHCI_PLTFM=y
 CONFIG_MMC_OMAP=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
index a288d70..fa62a70 100644
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -122,7 +122,6 @@ CONFIG_USB_STORAGE_SDDR09=y
 CONFIG_USB_STORAGE_SDDR55=y
 CONFIG_USB_STORAGE_JUMPSHOT=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/pcontrol_g20_defconfig b/arch/arm/configs/pcontrol_g20_defconfig
index c75c9fc..3586eab 100644
--- a/arch/arm/configs/pcontrol_g20_defconfig
+++ b/arch/arm/configs/pcontrol_g20_defconfig
@@ -139,7 +139,6 @@ CONFIG_MMC=y
 CONFIG_MMC_UNSAFE_RESUME=y
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/pxa3xx_defconfig b/arch/arm/configs/pxa3xx_defconfig
index 1677a06..4e29a4d 100644
--- a/arch/arm/configs/pxa3xx_defconfig
+++ b/arch/arm/configs/pxa3xx_defconfig
@@ -99,7 +99,6 @@ CONFIG_LOGO=y
 CONFIG_MMC=y
 CONFIG_MMC_PXA=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=m
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_DA903X=m
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/arm/configs/qil-a9260_defconfig b/arch/arm/configs/qil-a9260_defconfig
index 9160f3b..13356e0 100644
--- a/arch/arm/configs/qil-a9260_defconfig
+++ b/arch/arm/configs/qil-a9260_defconfig
@@ -89,7 +89,6 @@ CONFIG_USB_ETH=m
 CONFIG_MMC=y
 CONFIG_MMC_AT91=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
diff --git a/arch/arm/configs/raumfeld_defconfig b/arch/arm/configs/raumfeld_defconfig
index f7caa90..d334f59 100644
--- a/arch/arm/configs/raumfeld_defconfig
+++ b/arch/arm/configs/raumfeld_defconfig
@@ -135,7 +135,6 @@ CONFIG_USB_STORAGE_SDDR55=y
 CONFIG_MMC=y
 CONFIG_MMC_PXA=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_LT3593=y
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/arm/configs/realview-smp_defconfig b/arch/arm/configs/realview-smp_defconfig
index abe61bf..2cd2ca6 100644
--- a/arch/arm/configs/realview-smp_defconfig
+++ b/arch/arm/configs/realview-smp_defconfig
@@ -75,7 +75,6 @@ CONFIG_SND_ARMAACI=y
 CONFIG_MMC=y
 CONFIG_MMC_ARMMMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_RTC_CLASS=y
diff --git a/arch/arm/configs/realview_defconfig b/arch/arm/configs/realview_defconfig
index 7079cbe..85555e8 100644
--- a/arch/arm/configs/realview_defconfig
+++ b/arch/arm/configs/realview_defconfig
@@ -74,7 +74,6 @@ CONFIG_SND_ARMAACI=y
 CONFIG_MMC=y
 CONFIG_MMC_ARMMMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_RTC_CLASS=y
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index f9096c1..7902aba3 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -387,7 +387,6 @@ CONFIG_MMC_TEST=m
 CONFIG_MMC_SDHCI=m
 CONFIG_MMC_SPI=m
 CONFIG_MMC_S3C=y
-CONFIG_LEDS_CLASS=m
 CONFIG_LEDS_S3C24XX=m
 CONFIG_LEDS_H1940=m
 CONFIG_LEDS_PCA9532=m
diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index ecf2531..c329314 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -79,7 +79,6 @@ CONFIG_USB_GADGET=y
 CONFIG_MMC=y
 CONFIG_MMC_DEBUG=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/stamp9g20_defconfig b/arch/arm/configs/stamp9g20_defconfig
index d5e260b..905008e 100644
--- a/arch/arm/configs/stamp9g20_defconfig
+++ b/arch/arm/configs/stamp9g20_defconfig
@@ -103,7 +103,6 @@ CONFIG_MMC=y
 # CONFIG_MMC_AT91 is not set
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 97d31a4..5f5610b 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -87,7 +87,6 @@ CONFIG_MMC=y
 CONFIG_MMC_CLKGATE=y
 CONFIG_MMC_ARMMMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_LM3530=y
 CONFIG_LEDS_LP5521=y
 CONFIG_RTC_CLASS=y
diff --git a/arch/arm/configs/usb-a9260_defconfig b/arch/arm/configs/usb-a9260_defconfig
index 2e39f38..6e39030 100644
--- a/arch/arm/configs/usb-a9260_defconfig
+++ b/arch/arm/configs/usb-a9260_defconfig
@@ -82,7 +82,6 @@ CONFIG_USB_STORAGE=y
 CONFIG_USB_GADGET=y
 CONFIG_USB_ETH=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
diff --git a/arch/arm/configs/zeus_defconfig b/arch/arm/configs/zeus_defconfig
index 59577ad..f1e8cdc 100644
--- a/arch/arm/configs/zeus_defconfig
+++ b/arch/arm/configs/zeus_defconfig
@@ -150,7 +150,6 @@ CONFIG_MMC=y
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_MMC_PXA=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=m
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 9818f21..8a2aad0 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -385,7 +385,7 @@ static struct platform_device *dm365_evm_nand_devices[] __initdata = {
 
 static inline int have_leds(void)
 {
-#ifdef CONFIG_LEDS_CLASS
+#ifdef CONFIG_NEW_LEDS
 	return 1;
 #else
 	return 0;
diff --git a/arch/arm/mach-s3c2440/Kconfig b/arch/arm/mach-s3c2440/Kconfig
index 50825a3..074647e 100644
--- a/arch/arm/mach-s3c2440/Kconfig
+++ b/arch/arm/mach-s3c2440/Kconfig
@@ -181,7 +181,6 @@ config MACH_MINI2440
 	select CPU_S3C2440
 	select EEPROM_AT24
 	select NEW_LEDS
-	select LEDS_CLASS
 	select LEDS_TRIGGER
 	select LEDS_TRIGGER_BACKLIGHT
 	select S3C_DEV_NAND
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index bb8f4a6..be1503d 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -37,7 +37,7 @@ config OMAP_DEBUG_DEVICES
 config OMAP_DEBUG_LEDS
 	bool
 	depends on OMAP_DEBUG_DEVICES
-	default y if LEDS_CLASS
+	default y if NEW_LEDS
 
 config OMAP_SMARTREFLEX
 	bool "SmartReflex support"
diff --git a/arch/arm/plat-versatile/Kconfig b/arch/arm/plat-versatile/Kconfig
index 52353be..bfcea07 100644
--- a/arch/arm/plat-versatile/Kconfig
+++ b/arch/arm/plat-versatile/Kconfig
@@ -7,7 +7,7 @@ config PLAT_VERSATILE_FPGA_IRQ
 	bool
 
 config PLAT_VERSATILE_LEDS
-	def_bool y if LEDS_CLASS
+	def_bool y if NEW_LEDS
 	depends on ARCH_REALVIEW || ARCH_VERSATILE
 
 config PLAT_VERSATILE_SCHED_CLOCK
diff --git a/arch/avr32/configs/atngw100_defconfig b/arch/avr32/configs/atngw100_defconfig
index a06bfcc..f4b3c9c 100644
--- a/arch/avr32/configs/atngw100_defconfig
+++ b/arch/avr32/configs/atngw100_defconfig
@@ -116,7 +116,6 @@ CONFIG_MMC=y
 CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/avr32/configs/atngw100_evklcd100_defconfig b/arch/avr32/configs/atngw100_evklcd100_defconfig
index d8f1fe8..2175d7f 100644
--- a/arch/avr32/configs/atngw100_evklcd100_defconfig
+++ b/arch/avr32/configs/atngw100_evklcd100_defconfig
@@ -132,7 +132,6 @@ CONFIG_MMC=y
 CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/avr32/configs/atngw100_evklcd101_defconfig b/arch/avr32/configs/atngw100_evklcd101_defconfig
index d4c5b19..1a22d29 100644
--- a/arch/avr32/configs/atngw100_evklcd101_defconfig
+++ b/arch/avr32/configs/atngw100_evklcd101_defconfig
@@ -131,7 +131,6 @@ CONFIG_MMC=y
 CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/avr32/configs/atngw100_mrmt_defconfig b/arch/avr32/configs/atngw100_mrmt_defconfig
index 77ca4f9..9973595 100644
--- a/arch/avr32/configs/atngw100_mrmt_defconfig
+++ b/arch/avr32/configs/atngw100_mrmt_defconfig
@@ -104,7 +104,6 @@ CONFIG_USB_G_SERIAL=m
 CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/avr32/configs/atngw100mkii_defconfig b/arch/avr32/configs/atngw100mkii_defconfig
index 6e0dca4..b7f5076 100644
--- a/arch/avr32/configs/atngw100mkii_defconfig
+++ b/arch/avr32/configs/atngw100mkii_defconfig
@@ -118,7 +118,6 @@ CONFIG_MMC=y
 CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/avr32/configs/atngw100mkii_evklcd100_defconfig b/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
index 7f2a344..bba6a44 100644
--- a/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
+++ b/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
@@ -135,7 +135,6 @@ CONFIG_MMC=y
 CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/avr32/configs/atngw100mkii_evklcd101_defconfig b/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
index 085eeba..d7ed6d1 100644
--- a/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
+++ b/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
@@ -134,7 +134,6 @@ CONFIG_MMC=y
 CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/avr32/configs/atstk1002_defconfig b/arch/avr32/configs/atstk1002_defconfig
index d1a887e..181d510 100644
--- a/arch/avr32/configs/atstk1002_defconfig
+++ b/arch/avr32/configs/atstk1002_defconfig
@@ -133,7 +133,6 @@ CONFIG_MMC=y
 CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=m
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/avr32/configs/atstk1003_defconfig b/arch/avr32/configs/atstk1003_defconfig
index 956f281..9a0da90 100644
--- a/arch/avr32/configs/atstk1003_defconfig
+++ b/arch/avr32/configs/atstk1003_defconfig
@@ -112,7 +112,6 @@ CONFIG_MMC=y
 CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=m
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/avr32/configs/atstk1004_defconfig b/arch/avr32/configs/atstk1004_defconfig
index 40c69f3..d52f005 100644
--- a/arch/avr32/configs/atstk1004_defconfig
+++ b/arch/avr32/configs/atstk1004_defconfig
@@ -111,7 +111,6 @@ CONFIG_MMC=y
 CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=m
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/avr32/configs/atstk1006_defconfig b/arch/avr32/configs/atstk1006_defconfig
index 511eb8a..0d7ad59 100644
--- a/arch/avr32/configs/atstk1006_defconfig
+++ b/arch/avr32/configs/atstk1006_defconfig
@@ -136,7 +136,6 @@ CONFIG_MMC=y
 CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=m
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/avr32/configs/favr-32_defconfig b/arch/avr32/configs/favr-32_defconfig
index 19973b0..26922af 100644
--- a/arch/avr32/configs/favr-32_defconfig
+++ b/arch/avr32/configs/favr-32_defconfig
@@ -124,7 +124,6 @@ CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
 CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=m
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/avr32/configs/merisc_defconfig b/arch/avr32/configs/merisc_defconfig
index 3befab9..ca1e597 100644
--- a/arch/avr32/configs/merisc_defconfig
+++ b/arch/avr32/configs/merisc_defconfig
@@ -104,7 +104,6 @@ CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
 CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=y
 CONFIG_RTC_CLASS=y
 # CONFIG_RTC_HCTOSYS is not set
diff --git a/arch/avr32/configs/mimc200_defconfig b/arch/avr32/configs/mimc200_defconfig
index 1bee51f..a0e64ce 100644
--- a/arch/avr32/configs/mimc200_defconfig
+++ b/arch/avr32/configs/mimc200_defconfig
@@ -90,7 +90,6 @@ CONFIG_MMC_TEST=y
 CONFIG_MMC_ATMELMCI=y
 CONFIG_MMC_SPI=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
index 8465b3e..f57cc93 100644
--- a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
@@ -150,7 +150,6 @@ CONFIG_USB_MON=y
 CONFIG_USB_MUSB_HDRC=y
 CONFIG_USB_STORAGE=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ADP5520=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_BFIN=y
diff --git a/arch/mips/configs/ar7_defconfig b/arch/mips/configs/ar7_defconfig
index 6cd5a51..d207951 100644
--- a/arch/mips/configs/ar7_defconfig
+++ b/arch/mips/configs/ar7_defconfig
@@ -125,7 +125,6 @@ CONFIG_WATCHDOG=y
 CONFIG_AR7_WDT=y
 # CONFIG_USB_SUPPORT is not set
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index ad15fb1..53b60d1 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -477,7 +477,6 @@ CONFIG_USB_GADGETFS=m
 CONFIG_USB_FILE_STORAGE=m
 CONFIG_USB_G_SERIAL=m
 CONFIG_USB_MIDI_GADGET=m
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
diff --git a/arch/mips/configs/bcm63xx_defconfig b/arch/mips/configs/bcm63xx_defconfig
index 9190051..5fdc0fc 100644
--- a/arch/mips/configs/bcm63xx_defconfig
+++ b/arch/mips/configs/bcm63xx_defconfig
@@ -74,7 +74,6 @@ CONFIG_USB=y
 CONFIG_USB_EHCI_HCD=y
 # CONFIG_USB_EHCI_TT_NEWSCHED is not set
 CONFIG_USB_OHCI_HCD=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_GPIO=y
diff --git a/arch/mips/configs/cobalt_defconfig b/arch/mips/configs/cobalt_defconfig
index 5419adb..296c275 100644
--- a/arch/mips/configs/cobalt_defconfig
+++ b/arch/mips/configs/cobalt_defconfig
@@ -63,7 +63,6 @@ CONFIG_USB_EHCI_HCD=m
 CONFIG_USB_OHCI_HCD=m
 CONFIG_USB_STORAGE=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_COBALT_QUBE=y
 CONFIG_LEDS_COBALT_RAQ=y
 CONFIG_RTC_CLASS=y
diff --git a/arch/mips/configs/db1200_defconfig b/arch/mips/configs/db1200_defconfig
index 1f69249..4e1454a 100644
--- a/arch/mips/configs/db1200_defconfig
+++ b/arch/mips/configs/db1200_defconfig
@@ -123,7 +123,6 @@ CONFIG_MMC=y
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_MMC_AU1X=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AU1XXX=y
diff --git a/arch/mips/configs/jmr3927_defconfig b/arch/mips/configs/jmr3927_defconfig
index db5705e..62e22db 100644
--- a/arch/mips/configs/jmr3927_defconfig
+++ b/arch/mips/configs/jmr3927_defconfig
@@ -49,7 +49,6 @@ CONFIG_WATCHDOG=y
 CONFIG_TXX9_WDT=y
 # CONFIG_USB_SUPPORT is not set
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index b6acd2f..c83e9cd 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -329,7 +329,6 @@ CONFIG_USB_LED=m
 CONFIG_USB_GADGET=m
 CONFIG_USB_GADGET_M66592=y
 CONFIG_MMC=m
-CONFIG_LEDS_CLASS=y
 CONFIG_STAGING=y
 # CONFIG_STAGING_EXCLUDE_BUILD is not set
 CONFIG_FB_SM7XX=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 5527abb..907b960 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -374,7 +374,6 @@ CONFIG_FB_CIRRUS=y
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_HID=m
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
 CONFIG_LEDS_TRIGGER_IDE_DISK=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=m
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 807c97e..936da95 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -672,7 +672,6 @@ CONFIG_MMC=m
 CONFIG_MMC_SDHCI=m
 CONFIG_MMC_TIFM_SD=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/mips/configs/pb1200_defconfig b/arch/mips/configs/pb1200_defconfig
index dcbe270..2851dcc 100644
--- a/arch/mips/configs/pb1200_defconfig
+++ b/arch/mips/configs/pb1200_defconfig
@@ -123,7 +123,6 @@ CONFIG_MMC=y
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_MMC_AU1X=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AU1XXX=y
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index 55902d9..11fa41c 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -163,7 +163,6 @@ CONFIG_RC32434_WDT=y
 # CONFIG_VGA_ARB is not set
 # CONFIG_HID is not set
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_MIKROTIK_RB532=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/mips/configs/rbtx49xx_defconfig b/arch/mips/configs/rbtx49xx_defconfig
index 9cba856..40d019e 100644
--- a/arch/mips/configs/rbtx49xx_defconfig
+++ b/arch/mips/configs/rbtx49xx_defconfig
@@ -88,7 +88,6 @@ CONFIG_SND_SOC_TXX9ACLC=m
 CONFIG_SND_SOC_TXX9ACLC_GENERIC=m
 # CONFIG_USB_SUPPORT is not set
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_IDE_DISK=y
diff --git a/arch/mips/txx9/rbtx4939/setup.c b/arch/mips/txx9/rbtx4939/setup.c
index 7dc0faf..47565c7 100644
--- a/arch/mips/txx9/rbtx4939/setup.c
+++ b/arch/mips/txx9/rbtx4939/setup.c
@@ -186,7 +186,7 @@ static void __init rbtx4939_update_ioc_pen(void)
 
 #define RBTX4939_MAX_7SEGLEDS	8
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#ifdef CONFIG_NEW_LEDS
 static u8 led_val[RBTX4939_MAX_7SEGLEDS];
 struct rbtx4939_led_data {
 	struct led_classdev cdev;
@@ -262,7 +262,7 @@ static inline void rbtx4939_led_setup(void)
 
 static void __rbtx4939_7segled_putc(unsigned int pos, unsigned char val)
 {
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#ifdef CONFIG_NEW_LEDS
 	unsigned long flags;
 	local_irq_save(flags);
 	/* bit7: reserved for LED class */
diff --git a/arch/powerpc/configs/44x/warp_defconfig b/arch/powerpc/configs/44x/warp_defconfig
index abf74dc..4319c21 100644
--- a/arch/powerpc/configs/44x/warp_defconfig
+++ b/arch/powerpc/configs/44x/warp_defconfig
@@ -81,7 +81,6 @@ CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
 CONFIG_USB_STORAGE=y
 CONFIG_MMC=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 # CONFIG_LEDS_GPIO_PLATFORM is not set
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/powerpc/configs/52xx/motionpro_defconfig b/arch/powerpc/configs/52xx/motionpro_defconfig
index 0c7de96..22c4a9b 100644
--- a/arch/powerpc/configs/52xx/motionpro_defconfig
+++ b/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -79,7 +79,6 @@ CONFIG_I2C_MPC=y
 CONFIG_WATCHDOG=y
 # CONFIG_USB_SUPPORT is not set
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_RTC_CLASS=y
diff --git a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
index 5ea3124..b1a18cf 100644
--- a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
+++ b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
@@ -132,7 +132,6 @@ CONFIG_USB_MON=y
 CONFIG_USB_ISP1760_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_PCA955X=y
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/sh/configs/rsk7203_defconfig b/arch/sh/configs/rsk7203_defconfig
index 4e5229b..0230e63 100644
--- a/arch/sh/configs/rsk7203_defconfig
+++ b/arch/sh/configs/rsk7203_defconfig
@@ -104,7 +104,6 @@ CONFIG_USB_DEVICEFS=y
 CONFIG_USB_MON=y
 CONFIG_USB_R8A66597_HCD=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/sh/configs/sdk7780_defconfig b/arch/sh/configs/sdk7780_defconfig
index ae11158..8de0e8a 100644
--- a/arch/sh/configs/sdk7780_defconfig
+++ b/arch/sh/configs/sdk7780_defconfig
@@ -109,7 +109,6 @@ CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_PRINTER=y
 CONFIG_USB_STORAGE=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_POSIX_ACL=y
diff --git a/arch/sh/configs/se7712_defconfig b/arch/sh/configs/se7712_defconfig
index 1248635..58a8e22 100644
--- a/arch/sh/configs/se7712_defconfig
+++ b/arch/sh/configs/se7712_defconfig
@@ -88,7 +88,6 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HWMON is not set
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
diff --git a/arch/sh/configs/se7721_defconfig b/arch/sh/configs/se7721_defconfig
index c3ba6e8..579a6ec 100644
--- a/arch/sh/configs/se7721_defconfig
+++ b/arch/sh/configs/se7721_defconfig
@@ -112,7 +112,6 @@ CONFIG_USB_MON=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index 0d2f414..04b1029 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -101,7 +101,6 @@ CONFIG_USB_DEVICEFS=y
 # CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_MON=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_INTF_DEV_UIE_EMUL=y
diff --git a/arch/unicore32/configs/unicore32_defconfig b/arch/unicore32/configs/unicore32_defconfig
index c9dd319..3bf3a10 100644
--- a/arch/unicore32/configs/unicore32_defconfig
+++ b/arch/unicore32/configs/unicore32_defconfig
@@ -157,7 +157,6 @@ CONFIG_USB_MUSB_HDRC=n
 
 #	LED Support
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
 #	LED Triggers
 CONFIG_LEDS_TRIGGERS=y
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 1130a89..0e0565f 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -437,7 +437,7 @@ config HID_PICOLCD_LEDS
 	bool "GPO via leds class" if EXPERT
 	default !EXPERT
 	depends on HID_PICOLCD
-	depends on HID_PICOLCD=LEDS_CLASS || LEDS_CLASS=y
+	depends on HID_PICOLCD=NEW_LEDS || NEW_LEDS=y
 	---help---
 	  Provide access to PicoLCD's GPO pins via leds class.
 
@@ -589,7 +589,7 @@ config HID_WACOM_POWER_SUPPLY
 config HID_WIIMOTE
 	tristate "Nintendo Wii Remote support"
 	depends on BT_HIDP
-	depends on LEDS_CLASS
+	depends on NEW_LEDS
 	---help---
 	Support for the Nintendo Wii Remote bluetooth device.
 
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 0b62c3c..5a08726 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1300,7 +1300,6 @@ config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
 	depends on INPUT && X86
 	select NEW_LEDS
-	select LEDS_CLASS
 	select INPUT_POLLDEV
 	default n
 	help
diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 56eb471..ddad6ca 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -300,7 +300,7 @@ config JOYSTICK_XPAD_FF
 
 config JOYSTICK_XPAD_LEDS
 	bool "LED Support for Xbox360 controller 'BigX' LED"
-	depends on JOYSTICK_XPAD && (LEDS_CLASS=y || LEDS_CLASS=JOYSTICK_XPAD)
+	depends on JOYSTICK_XPAD && (NEW_LEDS=y || NEW_LEDS=JOYSTICK_XPAD)
 	---help---
 	  This option enables support for the LED which surrounds the Big X on
 	  XBox 360 controller.
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index b4dee9d..e8e5ed5 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -285,7 +285,7 @@ config KEYBOARD_HP7XX
 config KEYBOARD_LM8323
 	tristate "LM8323 keypad chip"
 	depends on I2C
-	depends on LEDS_CLASS
+	depends on NEW_LEDS
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  LM8323 keypad controller.
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index c9104bb..c03aa48 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -123,7 +123,7 @@ config INPUT_MPU3050
 
 config INPUT_APANEL
 	tristate "Fujitsu Lifebook Application Panel buttons"
-	depends on X86 && I2C && LEDS_CLASS
+	depends on X86 && I2C && NEW_LEDS
 	select INPUT_POLLDEV
 	select CHECK_SIGNATURE
 	help
@@ -163,7 +163,6 @@ config INPUT_WISTRON_BTNS
 	select INPUT_POLLDEV
 	select INPUT_SPARSEKMAP
 	select NEW_LEDS
-	select LEDS_CLASS
 	select CHECK_SIGNATURE
 	help
 	  Say Y here for support of Wistron laptop button interfaces, used on
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index b591e72..9a28d8c 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -16,17 +16,10 @@ menuconfig NEW_LEDS
 
 if NEW_LEDS
 
-config LEDS_CLASS
-	bool "LED Class Support"
-	help
-	  This option enables the led sysfs class in /sys/class/leds.  You'll
-	  need this to do anything useful with LEDs.  If unsure, say N.
-
 comment "LED drivers"
 
 config LEDS_88PM860X
 	tristate "LED Support for Marvell 88PM860x PMIC"
-	depends on LEDS_CLASS
 	depends on MFD_88PM860X
 	help
 	  This option enables support for on-chip LED drivers found on Marvell
@@ -34,7 +27,6 @@ config LEDS_88PM860X
 
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
-	depends on LEDS_CLASS
 	depends on ATMEL_PWM
 	help
 	  This option enables support for LEDs driven using outputs
@@ -42,7 +34,6 @@ config LEDS_ATMEL_PWM
 
 config LEDS_LM3530
 	tristate "LCD Backlight driver for LM3530"
-	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for the LCD backlight using
@@ -52,7 +43,6 @@ config LEDS_LM3530
 
 config LEDS_LOCOMO
 	tristate "LED Support for Locomo device"
-	depends on LEDS_CLASS
 	depends on SHARP_LOCOMO
 	help
 	  This option enables support for the LEDs on Sharp Locomo.
@@ -60,7 +50,6 @@ config LEDS_LOCOMO
 
 config LEDS_MIKROTIK_RB532
 	tristate "LED Support for Mikrotik Routerboard 532"
-	depends on LEDS_CLASS
 	depends on MIKROTIK_RB532
 	help
 	  This option enables support for the so called "User LED" of
@@ -68,7 +57,6 @@ config LEDS_MIKROTIK_RB532
 
 config LEDS_S3C24XX
 	tristate "LED Support for Samsung S3C24XX GPIO LEDs"
-	depends on LEDS_CLASS
 	depends on ARCH_S3C2410
 	help
 	  This option enables support for LEDs connected to GPIO lines
@@ -76,14 +64,12 @@ config LEDS_S3C24XX
 
 config LEDS_AMS_DELTA
 	tristate "LED Support for the Amstrad Delta (E3)"
-	depends on LEDS_CLASS
 	depends on MACH_AMS_DELTA
 	help
 	  This option enables support for the LEDs on Amstrad Delta (E3).
 
 config LEDS_NET48XX
 	tristate "LED Support for Soekris net48xx series Error LED"
-	depends on LEDS_CLASS
 	depends on SCx200_GPIO
 	help
 	  This option enables support for the Soekris net4801 and net4826 error
@@ -101,21 +87,18 @@ config LEDS_NET5501
 
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
-	depends on LEDS_CLASS
 	depends on MACH_FSG
 	help
 	  This option enables support for the LEDs on the Freecom FSG-3.
 
 config LEDS_WRAP
 	tristate "LED Support for the WRAP series LEDs"
-	depends on LEDS_CLASS
 	depends on SCx200_GPIO
 	help
 	  This option enables support for the PCEngines WRAP programmable LEDs.
 
 config LEDS_ALIX2
 	tristate "LED Support for ALIX.2 and ALIX.3 series"
-	depends on LEDS_CLASS
 	depends on X86 && !GPIO_CS5535 && !CS5535_GPIO
 	help
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
@@ -123,21 +106,19 @@ config LEDS_ALIX2
 
 config LEDS_COBALT_QUBE
 	tristate "LED Support for the Cobalt Qube series front LED"
-	depends on LEDS_CLASS
 	depends on MIPS_COBALT
 	help
 	  This option enables support for the front LED on Cobalt Qube series
 
 config LEDS_COBALT_RAQ
 	bool "LED Support for the Cobalt Raq series"
-	depends on LEDS_CLASS=y && MIPS_COBALT
+	depends on MIPS_COBALT
 	select LEDS_TRIGGERS
 	help
 	  This option enables support for the Cobalt Raq series LEDs.
 
 config LEDS_SUNFIRE
 	tristate "LED support for SunFire servers."
-	depends on LEDS_CLASS
 	depends on SPARC64
 	select LEDS_TRIGGERS
 	help
@@ -146,7 +127,6 @@ config LEDS_SUNFIRE
 
 config LEDS_HP6XX
 	tristate "LED Support for the HP Jornada 6xx"
-	depends on LEDS_CLASS
 	depends on SH_HP6XX
 	help
 	  This option enables LED support for the handheld
@@ -154,7 +134,6 @@ config LEDS_HP6XX
 
 config LEDS_PCA9532
 	tristate "LED driver for PCA9532 dimmer"
-	depends on LEDS_CLASS
 	depends on I2C && INPUT && EXPERIMENTAL
 	help
 	  This option enables support for NXP pca9532
@@ -173,7 +152,6 @@ config LEDS_PCA9532_GPIO
 
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
-	depends on LEDS_CLASS
 	depends on GENERIC_GPIO
 	help
 	  This option enables support for the LEDs connected to GPIO
@@ -184,7 +162,6 @@ config LEDS_GPIO
 
 config LEDS_LP3944
 	tristate "LED Support for N.S. LP3944 (Fun Light) I2C chip"
-	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for LEDs connected to the National
@@ -196,7 +173,7 @@ config LEDS_LP3944
 
 config LEDS_LP5521
 	tristate "LED Support for N.S. LP5521 LED driver chip"
-	depends on LEDS_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  LP5521 LED driver. It is 3 channel chip with programmable engines.
@@ -205,7 +182,7 @@ config LEDS_LP5521
 
 config LEDS_LP5523
 	tristate "LED Support for N.S. LP5523 LED driver chip"
-	depends on LEDS_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  LP5523 LED driver. It is 9 channel chip with programmable engines.
@@ -214,7 +191,6 @@ config LEDS_LP5523
 
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook"
-	depends on LEDS_CLASS
 	depends on X86 && SERIO_I8042 && DMI
 	help
 	  This driver makes the mail LED accessible from userspace
@@ -245,7 +221,6 @@ config LEDS_CLEVO_MAIL
 
 config LEDS_PCA955X
 	tristate "LED Support for PCA955x I2C chips"
-	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for LEDs connected to PCA955x
@@ -254,7 +229,6 @@ config LEDS_PCA955X
 
 config LEDS_WM831X_STATUS
 	tristate "LED support for status LEDs on WM831x PMICs"
-	depends on LEDS_CLASS
 	depends on MFD_WM831X
 	help
 	  This option enables support for the status LEDs of the WM831x
@@ -262,7 +236,6 @@ config LEDS_WM831X_STATUS
 
 config LEDS_WM8350
 	tristate "LED Support for WM8350 AudioPlus PMIC"
-	depends on LEDS_CLASS
 	depends on MFD_WM8350
 	help
 	  This option enables support for LEDs driven by the Wolfson
@@ -270,7 +243,6 @@ config LEDS_WM8350
 
 config LEDS_DA903X
 	tristate "LED Support for DA9030/DA9034 PMIC"
-	depends on LEDS_CLASS
 	depends on PMIC_DA903X
 	help
 	  This option enables support for on-chip LED drivers found
@@ -278,7 +250,6 @@ config LEDS_DA903X
 
 config LEDS_DAC124S085
 	tristate "LED Support for DAC124S085 SPI DAC"
-	depends on LEDS_CLASS
 	depends on SPI
 	help
 	  This option enables support for DAC124S085 SPI DAC from NatSemi,
@@ -286,21 +257,18 @@ config LEDS_DAC124S085
 
 config LEDS_PWM
 	tristate "PWM driven LED Support"
-	depends on LEDS_CLASS
 	depends on HAVE_PWM
 	help
 	  This option enables support for pwm driven LEDs
 
 config LEDS_REGULATOR
 	tristate "REGULATOR driven LED support"
-	depends on LEDS_CLASS
 	depends on REGULATOR
 	help
 	  This option enables support for regulator driven LEDs.
 
 config LEDS_BD2802
 	tristate "LED driver for BD2802 RGB LED"
-	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for BD2802GU RGB LED driver chips
@@ -308,7 +276,6 @@ config LEDS_BD2802
 
 config LEDS_INTEL_SS4200
 	tristate "LED driver for Intel NAS SS4200 series"
-	depends on LEDS_CLASS
 	depends on PCI && DMI
 	help
 	  This option enables support for the Intel SS4200 series of
@@ -318,7 +285,6 @@ config LEDS_INTEL_SS4200
 
 config LEDS_LT3593
 	tristate "LED driver for LT3593 controllers"
-	depends on LEDS_CLASS
 	depends on GENERIC_GPIO
 	help
 	  This option enables support for LEDs driven by a Linear Technology
@@ -327,7 +293,6 @@ config LEDS_LT3593
 
 config LEDS_ADP5520
 	tristate "LED Support for ADP5520/ADP5501 PMIC"
-	depends on LEDS_CLASS
 	depends on PMIC_ADP5520
 	help
 	  This option enables support for on-chip LED drivers found
@@ -338,7 +303,6 @@ config LEDS_ADP5520
 
 config LEDS_DELL_NETBOOKS
 	tristate "External LED on Dell Business Netbooks"
-	depends on LEDS_CLASS
 	depends on X86 && ACPI_WMI
 	help
 	  This adds support for the Latitude 2100 and similar
@@ -346,7 +310,6 @@ config LEDS_DELL_NETBOOKS
 
 config LEDS_MC13783
 	tristate "LED Support for MC13783 PMIC"
-	depends on LEDS_CLASS
 	depends on MFD_MC13783
 	help
 	  This option enable support for on-chip LED drivers found
@@ -354,7 +317,6 @@ config LEDS_MC13783
 
 config LEDS_NS2
 	tristate "LED support for Network Space v2 GPIO LEDs"
-	depends on LEDS_CLASS
 	depends on MACH_NETSPACE_V2 || MACH_INETSPACE_V2 || MACH_NETSPACE_MAX_V2 || D2NET_V2
 	default y
 	help
@@ -365,7 +327,6 @@ config LEDS_NS2
 config LEDS_NETXBIG
 	tristate "LED support for Big Network series LEDs"
 	depends on MACH_NET2BIG_V2 || MACH_NET5BIG_V2
-	depends on LEDS_CLASS
 	default y
 	help
 	  This option enable support for LEDs found on the LaCie 2Big
@@ -374,7 +335,6 @@ config LEDS_NETXBIG
 
 config LEDS_ASIC3
 	bool "LED support for the HTC ASIC3"
-	depends on LEDS_CLASS
 	depends on MFD_ASIC3
 	default y
 	help
@@ -385,7 +345,6 @@ config LEDS_ASIC3
 
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
-	depends on LEDS_CLASS
 	help
 	  This option enables trigger support for the leds class.
 	  These triggers allow kernel events to drive the LEDs and can
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index bbfd2e3..b0b5ee2 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -1,7 +1,6 @@
 
 # LED Core
-obj-$(CONFIG_NEW_LEDS)			+= led-core.o
-obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
+obj-$(CONFIG_NEW_LEDS)			+= led-core.o led-class.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index fa51af1..e2461df 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -91,7 +91,6 @@ config ADB_PMU_LED
 	bool "Support for the Power/iBook front LED"
 	depends on ADB_PMU
 	select NEW_LEDS
-	select LEDS_CLASS
 	help
 	  Support the front LED on Power/iBooks as a generic LED that can
 	  be triggered by any of the supported triggers. To get the
@@ -102,7 +101,7 @@ config ADB_PMU_LED
 config ADB_PMU_LED_IDE
 	bool "Use front LED as IDE LED by default"
 	depends on ADB_PMU_LED
-	depends on LEDS_CLASS
+	depends on NEW_LEDS
 	select LEDS_TRIGGERS
 	select LEDS_TRIGGER_IDE_DISK
 	help
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 899f783..6786dae 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -212,7 +212,6 @@ config IR_WINBOND_CIR
 	depends on X86 && PNP
 	depends on RC_CORE
 	select NEW_LEDS
-	select LEDS_CLASS
 	select LEDS_TRIGGERS
 	select BITREVERSE
 	---help---
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index ef72e87..b30cfbe 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1034,7 +1034,7 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 		printk(KERN_INFO DRIVER_NAME ": DBDMA init failed; using PIO\n");
 #endif
 
-#ifdef CONFIG_LEDS_CLASS
+#ifdef CONFIG_NEW_LEDS
 	if (host->platdata && host->platdata->led) {
 		struct led_classdev *led = host->platdata->led;
 		led->name = mmc_hostname(mmc);
@@ -1063,7 +1063,7 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 	return 0;	/* all ok */
 
 out6:
-#ifdef CONFIG_LEDS_CLASS
+#ifdef CONFIG_NEW_LEDS
 	if (host->platdata && host->platdata->led)
 		led_classdev_unregister(host->platdata->led);
 out5:
@@ -1103,7 +1103,7 @@ static int __devexit au1xmmc_remove(struct platform_device *pdev)
 	if (host) {
 		mmc_remove_host(host->mmc);
 
-#ifdef CONFIG_LEDS_CLASS
+#ifdef CONFIG_NEW_LEDS
 		if (host->platdata && host->platdata->led)
 			led_classdev_unregister(host->platdata->led);
 #endif
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 0e02cc1..5e3a8a9 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -33,9 +33,8 @@
 #define DBG(f, x...) \
 	pr_debug(DRIVER_NAME " [%s()]: " f, __func__,## x)
 
-#if defined(CONFIG_LEDS_CLASS) || (defined(CONFIG_LEDS_CLASS_MODULE) && \
-	defined(CONFIG_MMC_SDHCI_MODULE))
-#define SDHCI_USE_LEDS_CLASS
+#if defined(CONFIG_NEW_LEDS) && defined(CONFIG_MMC_SDHCI_MODULE)
+#define SDHCI_USE_NEW_LEDS
 #endif
 
 #define MAX_TUNING_LOOP 40
@@ -242,7 +241,7 @@ static void sdhci_deactivate_led(struct sdhci_host *host)
 	sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
 }
 
-#ifdef SDHCI_USE_LEDS_CLASS
+#ifdef SDHCI_USE_NEW_LEDS
 static void sdhci_led_control(struct led_classdev *led,
 	enum led_brightness brightness)
 {
@@ -1213,7 +1212,7 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	WARN_ON(host->mrq != NULL);
 
-#ifndef SDHCI_USE_LEDS_CLASS
+#ifndef SDHCI_USE_NEW_LEDS
 	sdhci_activate_led(host);
 #endif
 
@@ -1897,7 +1896,7 @@ static void sdhci_tasklet_finish(unsigned long param)
 	host->cmd = NULL;
 	host->data = NULL;
 
-#ifndef SDHCI_USE_LEDS_CLASS
+#ifndef SDHCI_USE_NEW_LEDS
 	sdhci_deactivate_led(host);
 #endif
 
@@ -2754,7 +2753,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	sdhci_dumpregs(host);
 #endif
 
-#ifdef SDHCI_USE_LEDS_CLASS
+#ifdef SDHCI_USE_NEW_LEDS
 	snprintf(host->led_name, sizeof(host->led_name),
 		"%s::", mmc_hostname(mmc));
 	host->led.name = host->led_name;
@@ -2780,7 +2779,7 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	return 0;
 
-#ifdef SDHCI_USE_LEDS_CLASS
+#ifdef SDHCI_USE_NEW_LEDS
 reset:
 	sdhci_reset(host, SDHCI_RESET_ALL);
 	free_irq(host->irq, host);
@@ -2818,7 +2817,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 
 	mmc_remove_host(host->mmc);
 
-#ifdef SDHCI_USE_LEDS_CLASS
+#ifdef SDHCI_USE_NEW_LEDS
 	led_classdev_unregister(&host->led);
 #endif
 
diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index e18a9aa..3a7001a 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -2,7 +2,6 @@ config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on (PCI || ATHEROS_AR231X) && MAC80211
 	select MAC80211_LEDS
-	select LEDS_CLASS
 	select NEW_LEDS
 	select AVERAGE
 	select ATH5K_AHB if (ATHEROS_AR231X && !PCI)
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index d9c08c6..54b22d6 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -8,7 +8,6 @@ config ATH9K
 	depends on MAC80211
 	select ATH9K_HW
 	select MAC80211_LEDS
-	select LEDS_CLASS
 	select NEW_LEDS
 	select ATH9K_COMMON
 	---help---
@@ -63,7 +62,6 @@ config ATH9K_HTC
        depends on USB && MAC80211
        select ATH9K_HW
        select MAC80211_LEDS
-       select LEDS_CLASS
        select NEW_LEDS
        select ATH9K_COMMON
        ---help---
diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 2d1b821..dd94741 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -18,7 +18,6 @@ config CARL9170_LEDS
 	bool "SoftLED Support"
 	depends on CARL9170
 	select MAC80211_LEDS
-	select LEDS_CLASS
 	select NEW_LEDS
 	default y
 	help
diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 3cab843..031b567 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -143,7 +143,7 @@ config B43_PHY_LCN
 # if it's possible.
 config B43_LEDS
 	bool
-	depends on B43 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = B43)
+	depends on B43 && MAC80211_LEDS && (NEW_LEDS = y || NEW_LEDS = B43)
 	default y
 
 # This config option automatically enables b43 HW-RNG support,
diff --git a/drivers/net/wireless/b43legacy/Kconfig b/drivers/net/wireless/b43legacy/Kconfig
index 1ffa288..7cf5f35 100644
--- a/drivers/net/wireless/b43legacy/Kconfig
+++ b/drivers/net/wireless/b43legacy/Kconfig
@@ -39,7 +39,7 @@ config B43LEGACY_PCICORE_AUTOSELECT
 # if it's possible.
 config B43LEGACY_LEDS
 	bool
-	depends on B43LEGACY && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = B43LEGACY)
+	depends on B43LEGACY && MAC80211_LEDS && (NEW_LEDS = y || NEW_LEDS = B43LEGACY)
 	default y
 
 # This config option automatically enables b43 HW-RNG support,
diff --git a/drivers/net/wireless/iwlegacy/Kconfig b/drivers/net/wireless/iwlegacy/Kconfig
index aef65cd..eb4ce5c 100644
--- a/drivers/net/wireless/iwlegacy/Kconfig
+++ b/drivers/net/wireless/iwlegacy/Kconfig
@@ -2,7 +2,6 @@ config IWLWIFI_LEGACY
 	tristate
 	select FW_LOADER
 	select NEW_LEDS
-	select LEDS_CLASS
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
 
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index ad3bdba..4687c6d 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -3,7 +3,6 @@ config IWLAGN
 	depends on PCI && MAC80211
 	select FW_LOADER
 	select NEW_LEDS
-	select LEDS_CLASS
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
 	---help---
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index 0ec55b5..aea03d8 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -67,5 +67,5 @@ config P54_SPI_DEFAULT_EEPROM
 
 config P54_LEDS
 	bool
-	depends on P54_COMMON && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = P54_COMMON)
+	depends on P54_COMMON && MAC80211_LEDS && (NEW_LEDS = y || NEW_LEDS = P54_COMMON)
 	default y
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index a0a7854..d8bafee 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -206,7 +206,7 @@ config RT2X00_LIB_CRYPTO
 
 config RT2X00_LIB_LEDS
 	boolean
-	default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)
+	default y if (RT2X00_LIB=y && NEW_LEDS=y) || (RT2X00_LIB=m && NEW_LEDS!=n)
 
 config RT2X00_LIB_DEBUGFS
 	bool "Ralink debugfs support"
diff --git a/drivers/net/wireless/rtl818x/Kconfig b/drivers/net/wireless/rtl818x/Kconfig
index 17d80fe..ebcdc16 100644
--- a/drivers/net/wireless/rtl818x/Kconfig
+++ b/drivers/net/wireless/rtl818x/Kconfig
@@ -83,6 +83,6 @@ config RTL8187
 
 config RTL8187_LEDS
 	bool
-	depends on RTL8187 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = RTL8187)
+	depends on RTL8187 && MAC80211_LEDS && (NEW_LEDS = y || NEW_LEDS = RTL8187)
 	default y
 
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 1e88d47..edb38a8 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -18,7 +18,6 @@ if X86_PLATFORM_DEVICES
 config ACER_WMI
 	tristate "Acer WMI Laptop Extras"
 	depends on ACPI
-	select LEDS_CLASS
 	select NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on SERIO_I8042
@@ -58,7 +57,6 @@ config ASUS_LAPTOP
 	tristate "Asus Laptop Extras"
 	depends on ACPI
 	depends on !ACPI_ASUS
-	select LEDS_CLASS
 	select NEW_LEDS
 	select BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
@@ -119,7 +117,7 @@ config FUJITSU_LAPTOP
 	depends on ACPI
 	depends on INPUT
 	depends on BACKLIGHT_CLASS_DEVICE
-	depends on LEDS_CLASS || LEDS_CLASS=n
+	select NEW_LEDS
 	---help---
 	  This is a driver for laptops built by Fujitsu:
 
@@ -156,7 +154,6 @@ config HP_ACCEL
 	depends on INPUT && ACPI
 	select SENSORS_LIS3LV02D
 	select NEW_LEDS
-	select LEDS_CLASS
 	help
 	  This driver provides support for the "Mobile Data Protection System 3D"
 	  or "3D DriveGuard" feature of HP laptops. On such systems the driver
@@ -274,7 +271,6 @@ config THINKPAD_ACPI
 	select HWMON
 	select NVRAM
 	select NEW_LEDS
-	select LEDS_CLASS
 	---help---
 	  This is a driver for the IBM and Lenovo ThinkPad laptops. It adds
 	  support for Fn-Fx key combinations, Bluetooth control, video
@@ -442,7 +438,6 @@ config EEEPC_LAPTOP
 	depends on HOTPLUG_PCI
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
-	select LEDS_CLASS
 	select NEW_LEDS
 	select INPUT_SPARSEKMAP
 	---help---
@@ -465,7 +460,6 @@ config ASUS_WMI
 	depends on RFKILL || RFKILL = n
 	depends on HOTPLUG_PCI
 	select INPUT_SPARSEKMAP
-	select LEDS_CLASS
 	select NEW_LEDS
 	---help---
 	  Say Y here if you have a WMI aware Asus laptop (like Eee PCs or new
@@ -578,7 +572,6 @@ config TOPSTAR_LAPTOP
 config ACPI_TOSHIBA
 	tristate "Toshiba Laptop Extras"
 	depends on ACPI
-	select LEDS_CLASS
 	select NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 6b26666..b322be8 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -69,9 +69,7 @@
 #include <linux/video_output.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 #include <linux/leds.h>
-#endif
 
 #define FUJITSU_DRIVER_VERSION "0.6.0"
 
@@ -99,14 +97,12 @@
 /* FUNC interface - responses */
 #define UNSUPPORTED_CMD 0x80000000
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 /* FUNC interface - LED control */
 #define FUNC_LED_OFF	0x1
 #define FUNC_LED_ON	0x30001
 #define KEYBOARD_LAMPS	0x100
 #define LOGOLAMP_POWERON 0x2000
 #define LOGOLAMP_ALWAYS  0x4000
-#endif
 
 /* Hotkey details */
 #define KEY1_CODE	0x410	/* codes for the keys in the GIRB register */
@@ -179,7 +175,6 @@ static struct fujitsu_hotkey_t *fujitsu_hotkey;
 
 static void acpi_fujitsu_hotkey_notify(struct acpi_device *device, u32 event);
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 static enum led_brightness logolamp_get(struct led_classdev *cdev);
 static void logolamp_set(struct led_classdev *cdev,
 			       enum led_brightness brightness);
@@ -199,7 +194,6 @@ static struct led_classdev kblamps_led = {
  .brightness_get = kblamps_get,
  .brightness_set = kblamps_set
 };
-#endif
 
 #ifdef CONFIG_FUJITSU_LAPTOP_DEBUG
 static u32 dbg_level = 0x03;
@@ -260,7 +254,6 @@ static int call_fext_func(int cmd, int arg0, int arg1, int arg2)
 	return out_obj.integer.value;
 }
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 /* LED class callbacks */
 
 static void logolamp_set(struct led_classdev *cdev,
@@ -310,7 +303,6 @@ static enum led_brightness kblamps_get(struct led_classdev *cdev)
 
 	return brightness;
 }
-#endif
 
 /* Hardware access for LCD brightness control */
 
@@ -900,7 +892,6 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 	/* Suspect this is a keymap of the application panel, print it */
 	pr_info("BTNI: [0x%x]\n", call_fext_func(FUNC_BUTTONS, 0x0, 0x0, 0x0));
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 	if (call_fext_func(FUNC_LEDS, 0x0, 0x0, 0x0) & LOGOLAMP_POWERON) {
 		result = led_classdev_register(&fujitsu->pf_device->dev,
 						&logolamp_led);
@@ -923,7 +914,6 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 			       result);
 		}
 	}
-#endif
 
 	return result;
 
@@ -943,13 +933,11 @@ static int acpi_fujitsu_hotkey_remove(struct acpi_device *device, int type)
 	struct fujitsu_hotkey_t *fujitsu_hotkey = acpi_driver_data(device);
 	struct input_dev *input = fujitsu_hotkey->input;
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 	if (fujitsu_hotkey->logolamp_registered)
 		led_classdev_unregister(&logolamp_led);
 
 	if (fujitsu_hotkey->kblamps_registered)
 		led_classdev_unregister(&kblamps_led);
-#endif
 
 	input_unregister_device(input);
 
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 278aeaa..98e3be5 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -302,7 +302,6 @@ config BACKLIGHT_ADP8860
 	tristate "Backlight Driver for ADP8860/ADP8861/ADP8863 using WLED"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	select NEW_LEDS
-	select LEDS_CLASS
 	help
 	  If you have a LCD backlight connected to the ADP8860, ADP8861 or
 	  ADP8863 say Y here to enable this driver.
@@ -314,7 +313,6 @@ config BACKLIGHT_ADP8870
 	tristate "Backlight Driver for ADP8870 using WLED"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	select NEW_LEDS
-	select LEDS_CLASS
 	help
 	  If you have a LCD backlight connected to the ADP8870,
 	  say Y here to enable this driver.
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 5666f3a..eb9db93 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -99,7 +99,7 @@ struct sdhci_host {
 	struct mmc_host *mmc;	/* MMC structure */
 	u64 dma_mask;		/* custom DMA mask */
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#ifdef CONFIG_NEW_LEDS
 	struct led_classdev led;	/* LED control */
 	char led_name[32];
 #endif
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index f5fdfcb..7bb17ac 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -92,7 +92,7 @@ config MAC80211_MESH
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211
-	depends on LEDS_CLASS
+	depends on NEW_LEDS
 	select LEDS_TRIGGERS
 	---help---
 	  This option enables a few LED triggers for different
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 32bff6d..1b2c5ef 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -485,7 +485,7 @@ config NETFILTER_XT_TARGET_IDLETIMER
 
 config NETFILTER_XT_TARGET_LED
 	tristate '"LED" target support'
-	depends on LEDS_CLASS && LEDS_TRIGGERS
+	depends on NEW_LEDS && LEDS_TRIGGERS
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `LED' target, which allows you to blink LEDs in
-- 
1.7.5

