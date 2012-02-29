Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031297Ab2B2THS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:07:18 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:49237 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030667Ab2B2THQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:07:16 -0500
Message-ID: <4F4E774F.4010502@xenotime.net>
Date: Wed, 29 Feb 2012 11:06:55 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH -next] backlight: fix ot200_bl build
References: <20120229175205.d165fa5266f400bc080253a0@canb.auug.org.au>
In-Reply-To: <20120229175205.d165fa5266f400bc080253a0@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error when GPIO_CS5535 is not enabled:

drivers/built-in.o: In function `ot200_backlight_probe':
ot200_bl.c:(.text+0x205bf): undefined reference to `cs5535_gpio_set'
ot200_bl.c:(.text+0x205d1): undefined reference to `cs5535_gpio_set'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120229.orig/drivers/video/backlight/Kconfig
+++ linux-next-20120229/drivers/video/backlight/Kconfig
@@ -343,7 +343,7 @@ config BACKLIGHT_LP855X
 
 config BACKLIGHT_OT200
 	tristate "Backlight driver for ot200 visualisation device"
-	depends on BACKLIGHT_CLASS_DEVICE && CS5535_MFGPT
+	depends on BACKLIGHT_CLASS_DEVICE && CS5535_MFGPT && GPIO_CS5535
 	help
 	  To compile this driver as a module, choose M here: the module will be
 	  called ot200_bl.
