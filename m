Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813Ab2FHXlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 19:41:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63080 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761653Ab2FHXlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 19:41:50 -0400
Message-ID: <1339198902.15067.1.camel@phoenix>
Subject: [PATCH] leds: Make LEDS_ASIC3 and LEDS_RENESAS_TPU depend on
 LEDS_CLASS=y
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <damm@opensource.se>, Paul Parsons <lost.distance@yahoo.com>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org
Date: Sat, 09 Jun 2012 07:41:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, I got below build error when CONFIG_LEDS_CLASS=m.

  LD      init/built-in.o
drivers/built-in.o: In function `asic3_led_probe':
clkdev.c:(.devinit.text+0x4680): undefined reference to `led_classdev_register'
drivers/built-in.o: In function `r_tpu_probe':
clkdev.c:(.devinit.text+0x4838): undefined reference to `led_classdev_register'
drivers/built-in.o: In function `asic3_led_remove':
clkdev.c:(.devexit.text+0x564): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `r_tpu_remove':
clkdev.c:(.devexit.text+0x5a0): undefined reference to `led_classdev_unregister'
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 04cb8c8..12b2b55 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -379,7 +379,7 @@ config LEDS_NETXBIG
 
 config LEDS_ASIC3
 	bool "LED support for the HTC ASIC3"
-	depends on LEDS_CLASS
+	depends on LEDS_CLASS=y
 	depends on MFD_ASIC3
 	default y
 	help
@@ -390,7 +390,7 @@ config LEDS_ASIC3
 
 config LEDS_RENESAS_TPU
 	bool "LED support for Renesas TPU"
-	depends on LEDS_CLASS && HAVE_CLK && GENERIC_GPIO
+	depends on LEDS_CLASS=y && HAVE_CLK && GENERIC_GPIO
 	help
 	  This option enables build of the LED TPU platform driver,
 	  suitable to drive any TPU channel on newer Renesas SoCs.
-- 
1.7.9.5



