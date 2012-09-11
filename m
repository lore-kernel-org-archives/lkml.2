Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab2IKNCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:02:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56263 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2IKNAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:00:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Axel Lin <axel.lin@gmail.com>
Subject: [PATCH 03/16] ARM: ep93xx: move platform_data definitions
Date: Tue, 11 Sep 2012 14:59:37 +0200
Message-Id: <1347368390-31252-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368390-31252-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:4S4TzLgjYscIKsl7nNFuaBf5grQHl7TzmfVGNtBFjdu
 4pcXw23IakwYSHcP4OXjYuzfhyrG7oSIk5FZOeaa8/4xkvgULz
 EJFdL3goCpw/HblDjCo6sPL0JCxfVzcwab2Z2WRg/dPFMSlz9M
 fRG4Nc7mC8bC56sxDo4NAETbOaahJuOIllUUm1GJd0p4SOCiSm
 pIa371PMOMMksoF0kmCEBio5bYlMRiDEl89wwbMh+Tpfa4D8l4
 Elq2XOdKBM9Lujq7fB+pJC2LEqjgUxJZAnZZOwuqVzHKSuJNSi
 vlqIsVkqxdcw/O0yIfwhpIBehd3ew7Ttb2zFvInWp1vrZetnxH
 LXN5RrvoCWdnW8H3wvKt5+AKFTYdxQuY2mexxfFuT7pO/03+NE
 FK2CySUi0YlUoDb8tyu5UZy2nXJZ1GyeRk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the ep93xx include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com> (supporter:SERIAL ATA
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com> (maintainer:INPUT
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Axel Lin <axel.lin@gmail.com>
---
 Documentation/spi/ep93xx_spi                                     |    2 +-
 arch/arm/mach-ep93xx/core.c                                      |    6 +++---
 arch/arm/mach-ep93xx/dma.c                                       |    2 +-
 arch/arm/mach-ep93xx/edb93xx.c                                   |    4 ++--
 arch/arm/mach-ep93xx/simone.c                                    |    2 +-
 arch/arm/mach-ep93xx/snappercl15.c                               |    2 +-
 arch/arm/mach-ep93xx/vision_ep9307.c                             |    4 ++--
 drivers/ata/pata_ep93xx.c                                        |    2 +-
 drivers/dma/ep93xx_dma.c                                         |    2 +-
 drivers/input/keyboard/ep93xx_keypad.c                           |    2 +-
 drivers/spi/spi-ep93xx.c                                         |    4 ++--
 drivers/video/ep93xx-fb.c                                        |    2 +-
 .../mach/dma.h => include/linux/platform_data/dma-ep93xx.h       |    0
 .../linux/platform_data/keypad-ep93xx.h                          |    0
 .../ep93xx_spi.h => include/linux/platform_data/spi-ep93xx.h     |    0
 .../mach/fb.h => include/linux/platform_data/video-ep93xx.h      |    0
 sound/soc/ep93xx/ep93xx-ac97.c                                   |    2 +-
 sound/soc/ep93xx/ep93xx-i2s.c                                    |    2 +-
 sound/soc/ep93xx/ep93xx-pcm.c                                    |    2 +-
 19 files changed, 20 insertions(+), 20 deletions(-)
 rename arch/arm/mach-ep93xx/include/mach/dma.h => include/linux/platform_data/dma-ep93xx.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/ep93xx_keypad.h => include/linux/platform_data/keypad-ep93xx.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h => include/linux/platform_data/spi-ep93xx.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/fb.h => include/linux/platform_data/video-ep93xx.h (100%)

diff --git a/Documentation/spi/ep93xx_spi b/Documentation/spi/ep93xx_spi
index d8eb01c..832ddce 100644
--- a/Documentation/spi/ep93xx_spi
+++ b/Documentation/spi/ep93xx_spi
@@ -26,7 +26,7 @@ arch/arm/mach-ep93xx/ts72xx.c:
 #include <linux/gpio.h>
 #include <linux/spi/spi.h>
 
-#include <mach/ep93xx_spi.h>
+#include <linux/platform_data/spi-ep93xx.h>
 
 /* this is our GPIO line used for chip select */
 #define MMC_CHIP_SELECT_GPIO EP93XX_GPIO_LINE_EGPIO9
diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index 4afe52a..e85bf17 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -36,9 +36,9 @@
 #include <linux/export.h>
 
 #include <mach/hardware.h>
-#include <mach/fb.h>
-#include <mach/ep93xx_keypad.h>
-#include <mach/ep93xx_spi.h>
+#include <linux/platform_data/video-ep93xx.h>
+#include <linux/platform_data/keypad-ep93xx.h>
+#include <linux/platform_data/spi-ep93xx.h>
 #include <mach/gpio-ep93xx.h>
 
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-ep93xx/dma.c b/arch/arm/mach-ep93xx/dma.c
index 16976d7..d8bfd02 100644
--- a/arch/arm/mach-ep93xx/dma.c
+++ b/arch/arm/mach-ep93xx/dma.c
@@ -25,7 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 
-#include <mach/dma.h>
+#include <linux/platform_data/dma-ep93xx.h>
 #include <mach/hardware.h>
 
 #include "soc.h"
diff --git a/arch/arm/mach-ep93xx/edb93xx.c b/arch/arm/mach-ep93xx/edb93xx.c
index 337ab7c..b8f53d5 100644
--- a/arch/arm/mach-ep93xx/edb93xx.c
+++ b/arch/arm/mach-ep93xx/edb93xx.c
@@ -35,8 +35,8 @@
 #include <sound/cs4271.h>
 
 #include <mach/hardware.h>
-#include <mach/fb.h>
-#include <mach/ep93xx_spi.h>
+#include <linux/platform_data/video-ep93xx.h>
+#include <linux/platform_data/spi-ep93xx.h>
 #include <mach/gpio-ep93xx.h>
 
 #include <asm/hardware/vic.h>
diff --git a/arch/arm/mach-ep93xx/simone.c b/arch/arm/mach-ep93xx/simone.c
index 33dc079..0eb3f17 100644
--- a/arch/arm/mach-ep93xx/simone.c
+++ b/arch/arm/mach-ep93xx/simone.c
@@ -22,7 +22,7 @@
 #include <linux/i2c-gpio.h>
 
 #include <mach/hardware.h>
-#include <mach/fb.h>
+#include <linux/platform_data/video-ep93xx.h>
 #include <mach/gpio-ep93xx.h>
 
 #include <asm/hardware/vic.h>
diff --git a/arch/arm/mach-ep93xx/snappercl15.c b/arch/arm/mach-ep93xx/snappercl15.c
index 01abd35..50043ee 100644
--- a/arch/arm/mach-ep93xx/snappercl15.c
+++ b/arch/arm/mach-ep93xx/snappercl15.c
@@ -28,7 +28,7 @@
 #include <linux/mtd/nand.h>
 
 #include <mach/hardware.h>
-#include <mach/fb.h>
+#include <linux/platform_data/video-ep93xx.h>
 #include <mach/gpio-ep93xx.h>
 
 #include <asm/hardware/vic.h>
diff --git a/arch/arm/mach-ep93xx/vision_ep9307.c b/arch/arm/mach-ep93xx/vision_ep9307.c
index 2905a49..ba92e25 100644
--- a/arch/arm/mach-ep93xx/vision_ep9307.c
+++ b/arch/arm/mach-ep93xx/vision_ep9307.c
@@ -30,8 +30,8 @@
 #include <linux/mmc/host.h>
 
 #include <mach/hardware.h>
-#include <mach/fb.h>
-#include <mach/ep93xx_spi.h>
+#include <linux/platform_data/video-ep93xx.h>
+#include <linux/platform_data/spi-ep93xx.h>
 #include <mach/gpio-ep93xx.h>
 
 #include <asm/hardware/vic.h>
diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index 6ef2e37..e056406 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -43,7 +43,7 @@
 #include <linux/dmaengine.h>
 #include <linux/ktime.h>
 
-#include <mach/dma.h>
+#include <linux/platform_data/dma-ep93xx.h>
 #include <mach/platform.h>
 
 #define DRV_NAME	"ep93xx-ide"
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index c64917e..4aeaea7 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -26,7 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <mach/dma.h>
+#include <linux/platform_data/dma-ep93xx.h>
 
 #include "dmaengine.h"
 
diff --git a/drivers/input/keyboard/ep93xx_keypad.c b/drivers/input/keyboard/ep93xx_keypad.c
index c46fc81..7363402 100644
--- a/drivers/input/keyboard/ep93xx_keypad.c
+++ b/drivers/input/keyboard/ep93xx_keypad.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 
 #include <mach/hardware.h>
-#include <mach/ep93xx_keypad.h>
+#include <linux/platform_data/keypad-ep93xx.h>
 
 /*
  * Keypad Interface Register offsets
diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index f97f1d2..3a21959 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -31,8 +31,8 @@
 #include <linux/scatterlist.h>
 #include <linux/spi/spi.h>
 
-#include <mach/dma.h>
-#include <mach/ep93xx_spi.h>
+#include <linux/platform_data/dma-ep93xx.h>
+#include <linux/platform_data/spi-ep93xx.h>
 
 #define SSPCR0			0x0000
 #define SSPCR0_MODE_SHIFT	6
diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
index 345d962..f2c092da 100644
--- a/drivers/video/ep93xx-fb.c
+++ b/drivers/video/ep93xx-fb.c
@@ -24,7 +24,7 @@
 #include <linux/clk.h>
 #include <linux/fb.h>
 
-#include <mach/fb.h>
+#include <linux/platform_data/video-ep93xx.h>
 
 /* Vertical Frame Timing Registers */
 #define EP93XXFB_VLINES_TOTAL			0x0000	/* SW locked */
diff --git a/arch/arm/mach-ep93xx/include/mach/dma.h b/include/linux/platform_data/dma-ep93xx.h
similarity index 100%
rename from arch/arm/mach-ep93xx/include/mach/dma.h
rename to include/linux/platform_data/dma-ep93xx.h
diff --git a/arch/arm/mach-ep93xx/include/mach/ep93xx_keypad.h b/include/linux/platform_data/keypad-ep93xx.h
similarity index 100%
rename from arch/arm/mach-ep93xx/include/mach/ep93xx_keypad.h
rename to include/linux/platform_data/keypad-ep93xx.h
diff --git a/arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h b/include/linux/platform_data/spi-ep93xx.h
similarity index 100%
rename from arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h
rename to include/linux/platform_data/spi-ep93xx.h
diff --git a/arch/arm/mach-ep93xx/include/mach/fb.h b/include/linux/platform_data/video-ep93xx.h
similarity index 100%
rename from arch/arm/mach-ep93xx/include/mach/fb.h
rename to include/linux/platform_data/video-ep93xx.h
diff --git a/sound/soc/ep93xx/ep93xx-ac97.c b/sound/soc/ep93xx/ep93xx-ac97.c
index bdffab3..c352165 100644
--- a/sound/soc/ep93xx/ep93xx-ac97.c
+++ b/sound/soc/ep93xx/ep93xx-ac97.c
@@ -21,7 +21,7 @@
 #include <sound/ac97_codec.h>
 #include <sound/soc.h>
 
-#include <mach/dma.h>
+#include <linux/platform_data/dma-ep93xx.h>
 #include "ep93xx-pcm.h"
 
 /*
diff --git a/sound/soc/ep93xx/ep93xx-i2s.c b/sound/soc/ep93xx/ep93xx-i2s.c
index 8df8f6d..ac4a751 100644
--- a/sound/soc/ep93xx/ep93xx-i2s.c
+++ b/sound/soc/ep93xx/ep93xx-i2s.c
@@ -28,7 +28,7 @@
 
 #include <mach/hardware.h>
 #include <mach/ep93xx-regs.h>
-#include <mach/dma.h>
+#include <linux/platform_data/dma-ep93xx.h>
 
 #include "ep93xx-pcm.h"
 
diff --git a/sound/soc/ep93xx/ep93xx-pcm.c b/sound/soc/ep93xx/ep93xx-pcm.c
index 4eea98b..665d9c9 100644
--- a/sound/soc/ep93xx/ep93xx-pcm.c
+++ b/sound/soc/ep93xx/ep93xx-pcm.c
@@ -25,7 +25,7 @@
 #include <sound/soc.h>
 #include <sound/dmaengine_pcm.h>
 
-#include <mach/dma.h>
+#include <linux/platform_data/dma-ep93xx.h>
 #include <mach/hardware.h>
 #include <mach/ep93xx-regs.h>
 
-- 
1.7.10

