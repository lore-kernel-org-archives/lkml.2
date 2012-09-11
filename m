Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2IKNAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:00:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55269 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2IKNAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:00:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Wan ZongShun <mcuos.com@gmail.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 11/16] ARM: w90x900: move platform_data definitions
Date: Tue, 11 Sep 2012 14:59:45 +0200
Message-Id: <1347368390-31252-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368390-31252-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:YCk8GqGnh4Zk4XY6F9tbtr3/N+BZgJV7iEG0jgfTOEq
 Jr2gItqmJ2zD75+q41fA+QBVWieMesK0DWhwRENQr/mGUWLi8s
 njZbuq1/WD9r8aPAv08GtnjtJ3TiF4ILbu/H+5+dcuEJ0JYfac
 6bg+g/CjqerQFWqm5QcHRDqQ5dyA2579xl/3sKzvufeqofS1zK
 doXRaVbwzN7YSZBBYUrlqm9ZStw10ELUi2FXNXm+CqQstqHTqr
 khrlXAEVbHIVmfgQuB3Iao4mtUNGjuSqf43QuMD9zuDIz6g3wY
 1pzAB41PIu1E1hYOuly7sVjpGtnhJR2D89ns1re1qeixfy9SBI
 YOobXnQqYJEBI8Ad61ElvMwK1e9dsnPCwMy/zu2U+E6RhS8PZt
 HNWteDP+mQvI9713gRi5eRy+p4vieCGBQM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the w90x900 include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 arch/arm/mach-w90x900/dev.c                                      |    6 +++---
 arch/arm/mach-w90x900/mach-nuc950evb.c                           |    2 +-
 drivers/i2c/busses/i2c-nuc900.c                                  |    2 +-
 drivers/input/keyboard/w90p910_keypad.c                          |    2 +-
 drivers/spi/spi-nuc900.c                                         |    2 +-
 drivers/video/nuc900fb.c                                         |    2 +-
 drivers/video/nuc900fb.h                                         |    2 +-
 .../mach/i2c.h => include/linux/platform_data/i2c-nuc900.h       |    0
 .../linux/platform_data/keypad-w90p910.h                         |    0
 .../nuc900_spi.h => include/linux/platform_data/spi-nuc900.h     |    0
 .../mach/fb.h => include/linux/platform_data/video-nuc900fb.h    |    0
 11 files changed, 9 insertions(+), 9 deletions(-)
 rename arch/arm/mach-w90x900/include/mach/i2c.h => include/linux/platform_data/i2c-nuc900.h (100%)
 rename arch/arm/mach-w90x900/include/mach/w90p910_keypad.h => include/linux/platform_data/keypad-w90p910.h (100%)
 rename arch/arm/mach-w90x900/include/mach/nuc900_spi.h => include/linux/platform_data/spi-nuc900.h (100%)
 rename arch/arm/mach-w90x900/include/mach/fb.h => include/linux/platform_data/video-nuc900fb.h (100%)

diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
index 48f5b9f..7abdb96 100644
--- a/arch/arm/mach-w90x900/dev.c
+++ b/arch/arm/mach-w90x900/dev.c
@@ -34,11 +34,11 @@
 #include <asm/mach-types.h>
 
 #include <mach/regs-serial.h>
-#include <mach/nuc900_spi.h>
+#include <linux/platform_data/spi-nuc900.h>
 #include <mach/map.h>
-#include <mach/fb.h>
+#include <linux/platform_data/video-nuc900fb.h>
 #include <mach/regs-ldm.h>
-#include <mach/w90p910_keypad.h>
+#include <linux/platform_data/keypad-w90p910.h>
 
 #include "cpu.h"
 
diff --git a/arch/arm/mach-w90x900/mach-nuc950evb.c b/arch/arm/mach-w90x900/mach-nuc950evb.c
index 067d8f9..500fe59 100644
--- a/arch/arm/mach-w90x900/mach-nuc950evb.c
+++ b/arch/arm/mach-w90x900/mach-nuc950evb.c
@@ -20,7 +20,7 @@
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
 #include <mach/map.h>
-#include <mach/fb.h>
+#include <linux/platform_data/video-nuc900fb.h>
 
 #include "nuc950.h"
 
diff --git a/drivers/i2c/busses/i2c-nuc900.c b/drivers/i2c/busses/i2c-nuc900.c
index a26dfb8..f41502e 100644
--- a/drivers/i2c/busses/i2c-nuc900.c
+++ b/drivers/i2c/busses/i2c-nuc900.c
@@ -29,7 +29,7 @@
 #include <linux/io.h>
 
 #include <mach/mfp.h>
-#include <mach/i2c.h>
+#include <linux/platform_data/i2c-nuc900.h>
 
 /* nuc900 i2c registers offset */
 
diff --git a/drivers/input/keyboard/w90p910_keypad.c b/drivers/input/keyboard/w90p910_keypad.c
index 085ede4..e0f6cd1 100644
--- a/drivers/input/keyboard/w90p910_keypad.c
+++ b/drivers/input/keyboard/w90p910_keypad.c
@@ -21,7 +21,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include <mach/w90p910_keypad.h>
+#include <linux/platform_data/keypad-w90p910.h>
 
 /* Keypad Interface Control Registers */
 #define KPI_CONF		0x00
diff --git a/drivers/spi/spi-nuc900.c b/drivers/spi/spi-nuc900.c
index dae8be2..a6eca6f 100644
--- a/drivers/spi/spi-nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -26,7 +26,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_bitbang.h>
 
-#include <mach/nuc900_spi.h>
+#include <linux/platform_data/spi-nuc900.h>
 
 /* usi registers offset */
 #define USI_CNT		0x00
diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index e10f551..9338755 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -38,7 +38,7 @@
 #include <mach/map.h>
 #include <mach/regs-clock.h>
 #include <mach/regs-ldm.h>
-#include <mach/fb.h>
+#include <linux/platform_data/video-nuc900fb.h>
 
 #include "nuc900fb.h"
 
diff --git a/drivers/video/nuc900fb.h b/drivers/video/nuc900fb.h
index bc7c930..9a1ca6d 100644
--- a/drivers/video/nuc900fb.h
+++ b/drivers/video/nuc900fb.h
@@ -16,7 +16,7 @@
 #define __NUC900FB_H
 
 #include <mach/map.h>
-#include <mach/fb.h>
+#include <linux/platform_data/video-nuc900fb.h>
 
 enum nuc900_lcddrv_type {
 	LCDDRV_NUC910,
diff --git a/arch/arm/mach-w90x900/include/mach/i2c.h b/include/linux/platform_data/i2c-nuc900.h
similarity index 100%
rename from arch/arm/mach-w90x900/include/mach/i2c.h
rename to include/linux/platform_data/i2c-nuc900.h
diff --git a/arch/arm/mach-w90x900/include/mach/w90p910_keypad.h b/include/linux/platform_data/keypad-w90p910.h
similarity index 100%
rename from arch/arm/mach-w90x900/include/mach/w90p910_keypad.h
rename to include/linux/platform_data/keypad-w90p910.h
diff --git a/arch/arm/mach-w90x900/include/mach/nuc900_spi.h b/include/linux/platform_data/spi-nuc900.h
similarity index 100%
rename from arch/arm/mach-w90x900/include/mach/nuc900_spi.h
rename to include/linux/platform_data/spi-nuc900.h
diff --git a/arch/arm/mach-w90x900/include/mach/fb.h b/include/linux/platform_data/video-nuc900fb.h
similarity index 100%
rename from arch/arm/mach-w90x900/include/mach/fb.h
rename to include/linux/platform_data/video-nuc900fb.h
-- 
1.7.10

