Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab2HVPNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:13:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab2HVPNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:13:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/6] ARM: ux500: don't select LEDS_GPIO for snowball
Date: Wed, 22 Aug 2012 17:13:05 +0200
Message-Id: <1345648390-4234-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1345648390-4234-1-git-send-email-arnd@arndb.de>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Y5kvlH3VNvcTPmjv21ZalAgS4o+wSe/DamZ0+PX/WB4
 I8uz9CXEZ6TUt4hEMUwT6iU9BFzlts86KuZnP4hBgVmzDotK66
 2z99jERAZJy49TDbW6YAiiSjnwCivrMoHTOTIYU7YslfAEEle1
 JF6AmkF6HS36+KeNHm6rAPHZYgBgkqgTmt81BX3ZIpGSMSjHsE
 pag4Sb/D/jTQsp2mpEmderwvp/n/rrhlY3/SULJwLXVSZJMI9A
 inbx9n1uUoICgnQHqo3M9IBnJFWKAqgMcrFd+mvLd6i58VpMZR
 sfyPMSC6GMs1pFgWL+Ujk+wmArY2WFGe6lIyMuD5gKLGEbrSbh
 MjNJ6VN3SRY/fxjYdBXtTnxCyp9tQz/MJWvnV/vHHD7MlSCH6V
 +m7YBo0DTPEGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio leds driver can only be built if the generic LED code is
also enabled. Snowball selects LEDS_GPIO for an unknown reason
but it does not select LEDS_CLASS and also does not really require
the LED support at all, so we can just drop this dependency.

Without this patch, building without LEDS_CLASS esults in:

drivers/built-in.o: In function `create_gpio_led.part.2':
governor_userspace.c:(.devinit.text+0x5a58): undefined reference to `led_classdev_register'
drivers/built-in.o: In function `gpio_led_remove':
governor_userspace.c:(.devexit.text+0x6b8): undefined reference to `led_classdev_unregister'

This reverts 8733f53c6 "ARM: ux500: Kconfig: Compile in leds-gpio
support for Snowball", which was not completely thought through.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index c013bbf..53d3d46 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -41,7 +41,6 @@ config MACH_HREFV60
 config MACH_SNOWBALL
 	bool "U8500 Snowball platform"
 	select MACH_MOP500
-	select LEDS_GPIO
 	help
 	  Include support for the snowball development platform.
 
-- 
1.7.10

