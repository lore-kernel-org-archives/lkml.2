Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab1E1JxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 05:53:21 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:59955 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1E1JxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 05:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=XDEdHKZiT3mjJxnulwrUVmexIqADMMdxp9HwLaalhKewVy61treYD+RcqjAj97yVr9
         EYLcnKB8vw1Bytd8iHlOJw/Jz3BpyrfdbK/IagZPvOasLsPzWP40c215RY0TzpY5kGZL
         Qkhmp/CY7liViCwaEZIQzWDi3vH+ZISkdRJSQ=
Subject: [PATCH] leds: make LEDS_GPIO_REGISTER depend on NEW_LEDS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 May 2011 17:52:56 +0800
Message-ID: <1306576376.10669.12.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4440673a "leds: provide helper to register "leds-gpio" devices"
adds "config LEDS_GPIO_REGISTER" in drivers/leds/Kconfig.
However, config LEDS_GPIO_REGISTER does not depend on NEW_LEDS, while executing
make menuconfig a side-effect is observed that the "LED drivers" and
"LED Triggers" are now displayed at the same level of "LED Support".
( They was in sub-menu of "LED Support" before the commit. )

This patch makes LEDS_GPIO_REGISTER depend on NEW_LEDS to correctly show
"LED drivers" and "LED Triggers" in sub-menu of "LED Support".

Besides, LEDS_GPIO_REGISTER is set to be bool but no description.  Thus I
cannot find LEDS_GPIO_REGISTER config option while executing make menuconfig.

This patch also adds the description for LEDS_GPIO_REGISTER so the option can
be correctly displayed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 23f0d5e..784f74f 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -15,7 +15,8 @@ config LEDS_CLASS
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
 config LEDS_GPIO_REGISTER
-	bool
+	bool "LED GPIO Register Support"
+	depends on NEW_LEDS
 	help
 	  This option provides the function gpio_led_register_device.
 	  As this function is used by arch code it must not be compiled as a
-- 
1.7.1



