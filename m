Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab0JFQBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:01:25 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:36211 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932666Ab0JFQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:01:20 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <lars@metafoo.de>, <akpm@linux-foundation.org>, <kernel@pengutronix.de>,
        <philipp.zabel@gmail.com>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <eric.y.miao@gmail.com>, <rpurdie@rpsys.net>,
        <sameo@linux.intel.com>, <kgene.kim@samsung.com>,
        <linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>, <bgat@billgatliff.com>,
        <khilman@deeprootsystems.com>
Subject: [PATCHv3 7/7] pwm: Modify backlight and led Kconfig aligning to pwm core
Date: Wed, 6 Oct 2010 21:29:18 +0530
Message-ID: <1286380758-14063-8-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1286380758-14063-1-git-send-email-arun.murthy@stericsson.com>
References: <1286380758-14063-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWM based backlight and led driver will not be calling the pwm drivers
through the pwm core driver and hence adding dependancy on the same.

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/leds/Kconfig            |    2 +-
 drivers/pwm/Kconfig             |    2 --
 drivers/video/backlight/Kconfig |    2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index e411262..8324dd0 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -244,7 +244,7 @@ config LEDS_DAC124S085
 
 config LEDS_PWM
 	tristate "PWM driven LED Support"
-	depends on HAVE_PWM
+	depends on HAVE_PWM || PWM_DEVICES
 	help
 	  This option enables support for pwm driven LEDs
 
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index e4ef199..4acc0a6 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -19,7 +19,6 @@ if PWM_DEVICES
 config AB8500_PWM
 	bool "AB8500 PWM support"
 	depends on AB8500_CORE
-	select HAVE_PWM
 	help
 	  This driver exports functions to enable/disble/config/free Pulse
 	  Width Modulation in the Analog Baseband Chip AB8500.
@@ -28,7 +27,6 @@ config AB8500_PWM
 config TWL6030_PWM
 	tristate "TWL6030 PWM (Pulse Width Modulator) Support"
 	depends on TWL4030_CORE
-	select HAVE_PWM
 	default n
 	help
 	  Say yes here if you want support for TWL6030 PWM.
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index e54a337..c07fc16 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -217,7 +217,7 @@ config BACKLIGHT_CARILLO_RANCH
 
 config BACKLIGHT_PWM
 	tristate "Generic PWM based Backlight Driver"
-	depends on HAVE_PWM
+	depends on HAVE_PWM || PWM_DEVICES
 	help
 	  If you have a LCD backlight adjustable by PWM, say Y to enable
 	  this driver.
-- 
1.7.2.dirty

