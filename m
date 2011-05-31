Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab1EaIQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:16:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41503 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab1EaIQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:16:19 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net, grant.likely@secretlab.ca, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] leds: remove config option LEDS_GPIO_PLATFORM from Kconfig
Date: Tue, 31 May 2011 16:23:43 +0800
Message-Id: <1306830223-18850-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the commit a314c5c0040aab51ebb1ecfd37a9198a91962243
(leds/leds-gpio: merge platform_driver with of_platform_driver),
the config option LEDS_GPIO_PLATFORM becomes useless, so remove it.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/leds/Kconfig |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 23f0d5e..af86cbd 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -93,7 +93,7 @@ config LEDS_NET48XX
 config LEDS_NET5501
 	tristate "LED Support for Soekris net5501 series Error LED"
 	depends on LEDS_TRIGGERS
-	depends on X86 && LEDS_GPIO_PLATFORM && GPIO_CS5535
+	depends on X86 && GPIO_CS5535
 	select LEDS_TRIGGER_DEFAULT_ON
 	default n
 	help
@@ -183,14 +183,6 @@ config LEDS_GPIO
 	  defined as platform devices and/or OpenFirmware platform devices.
 	  The code to use these bindings can be selected below.
 
-config LEDS_GPIO_PLATFORM
-	bool "Platform device bindings for GPIO LEDs"
-	depends on LEDS_GPIO
-	default y
-	help
-	  Let the leds-gpio driver drive LEDs which have been defined as
-	  platform devices.  If you don't know what this means, say yes.
-
 config LEDS_GPIO_OF
 	bool "OpenFirmware platform device bindings for GPIO LEDs"
 	depends on LEDS_GPIO && OF_DEVICE
-- 
1.7.4.1

