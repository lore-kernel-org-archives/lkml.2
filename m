Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab2IRDaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:30:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41936 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab2IRDav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:30:51 -0400
Message-ID: <1347939042.15578.1.camel@phoenix>
Subject: [PATCH] ARM: OMAP: OMAP_DEBUG_LEDS needs to select LEDS_CLASS
From: Axel Lin <axel.lin@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Sep 2012 11:30:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build error when CONFIG_LEDS_CLASS is not set.

  LD      init/built-in.o
arch/arm/plat-omap/built-in.o: In function `fpga_probe':
arch/arm/plat-omap/debug-leds.c:113: undefined reference to `led_classdev_register'
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/plat-omap/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index ca83a76..c262781 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -43,6 +43,7 @@ config OMAP_DEBUG_DEVICES
 
 config OMAP_DEBUG_LEDS
 	def_bool y if NEW_LEDS
+	select LEDS_CLASS
 	depends on OMAP_DEBUG_DEVICES
 
 config POWER_AVS_OMAP
-- 
1.7.9.5



