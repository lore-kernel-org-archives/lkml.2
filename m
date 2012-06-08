Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259Ab2FHXsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 19:48:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56779 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761737Ab2FHXsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 19:48:09 -0400
Message-ID: <1339199282.15067.3.camel@phoenix>
Subject: [PATCH] ARM: plat-versatile: Make PLAT_VERSATILE_LEDS depend on
 LEDS_CLASS=y
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Sat, 09 Jun 2012 07:48:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config PLAT_VERSATILE_LEDS needs LEDS_CLASS=y, otherwise I got below build
error when CONFIG_LEDS_CLASS=m.

  LD      init/built-in.o
arch/arm/plat-versatile/built-in.o: In function `versatile_leds_init':
sched-clock.c:(.init.text+0x190): undefined reference to `led_classdev_register'
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/plat-versatile/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-versatile/Kconfig b/arch/arm/plat-versatile/Kconfig
index 81ee7cc..62ffdc7 100644
--- a/arch/arm/plat-versatile/Kconfig
+++ b/arch/arm/plat-versatile/Kconfig
@@ -13,7 +13,7 @@ config PLAT_VERSATILE_FPGA_IRQ_NR
        depends on PLAT_VERSATILE_FPGA_IRQ
 
 config PLAT_VERSATILE_LEDS
-	def_bool y if LEDS_CLASS
+	def_bool y if LEDS_CLASS=y
 	depends on ARCH_REALVIEW || ARCH_VERSATILE
 
 config PLAT_VERSATILE_SCHED_CLOCK
-- 
1.7.9.5



