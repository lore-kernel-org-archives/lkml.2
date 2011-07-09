Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1GIPH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 11:07:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32850 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1GIPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 11:07:27 -0400
Subject: [PATCH] drivers/leds/leds-netxbig: make LEDS_NETXBIG depend on
 LEDS_CLASS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Simon Guinot <sguinot@lacie.com>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Jul 2011 23:07:18 +0800
Message-ID: <1310224038.14501.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call led_classdev_register/led_classdev_unregister in
create_netxbig_led/delete_netxbig_led, thus make LEDS_NETXBIG
depend on LEDS_CLASS.

This patch fixes below build error if LEDS_CLASS is not configured.

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `create_netxbig_led':
drivers/leds/leds-netxbig.c:350: undefined reference to `led_classdev_register'
drivers/leds/leds-netxbig.c:361: undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `delete_netxbig_led':
drivers/leds/leds-netxbig.c:313: undefined reference to `led_classdev_unregister'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 6cb0708..8974d27 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -357,6 +357,7 @@ config LEDS_NS2
 config LEDS_NETXBIG
 	tristate "LED support for Big Network series LEDs"
 	depends on MACH_NET2BIG_V2 || MACH_NET5BIG_V2
+	depends on LEDS_CLASS
 	default y
 	help
 	  This option enable support for LEDs found on the LaCie 2Big
-- 
1.7.4.1



