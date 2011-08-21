Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab1HUOdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 10:33:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59712 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab1HUOdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 10:33:36 -0400
Subject: [PATCH] backlight: ep93xx_bl: add missing include of linux/module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Aug 2011 22:33:29 +0800
Message-ID: <1313937209.13671.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep93xx_bl.c uses interfaces from linux/module.h,
so it should include that file. This patch fixes below build errors.

  CC [M]  drivers/video/backlight/ep93xx_bl.o
drivers/video/backlight/ep93xx_bl.c:138: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/video/backlight/ep93xx_bl.c:158: error: expected declaration specifiers or '...' before string constant
drivers/video/backlight/ep93xx_bl.c:158: warning: data definition has no type or storage class
drivers/video/backlight/ep93xx_bl.c:158: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/video/backlight/ep93xx_bl.c:158: warning: function declaration isn't a prototype
drivers/video/backlight/ep93xx_bl.c:159: error: expected declaration specifiers or '...' before string constant
drivers/video/backlight/ep93xx_bl.c:159: warning: data definition has no type or storage class
drivers/video/backlight/ep93xx_bl.c:159: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/video/backlight/ep93xx_bl.c:159: warning: function declaration isn't a prototype
drivers/video/backlight/ep93xx_bl.c:160: error: expected declaration specifiers or '...' before string constant
drivers/video/backlight/ep93xx_bl.c:160: warning: data definition has no type or storage class
drivers/video/backlight/ep93xx_bl.c:160: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/video/backlight/ep93xx_bl.c:160: warning: function declaration isn't a prototype
drivers/video/backlight/ep93xx_bl.c:161: error: expected declaration specifiers or '...' before string constant
drivers/video/backlight/ep93xx_bl.c:161: warning: data definition has no type or storage class
drivers/video/backlight/ep93xx_bl.c:161: warning: type defaults to 'int' in declaration of 'MODULE_ALIAS'
drivers/video/backlight/ep93xx_bl.c:161: warning: function declaration isn't a prototype
make[3]: *** [drivers/video/backlight/ep93xx_bl.o] Error 1
make[2]: *** [drivers/video/backlight] Error 2
make[1]: *** [drivers/video] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/ep93xx_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index 9f1e389..b058291 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -11,7 +11,7 @@
  * BRIGHT, on the Cirrus EP9307, EP9312, and EP9315 processors.
  */
 
-
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/fb.h>
-- 
1.7.4.1



