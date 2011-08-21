Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1HUOjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 10:39:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42932 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab1HUOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 10:39:11 -0400
Subject: [PATCH] video: ep93xx-fb: add missing include of linux/module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Aug 2011 22:39:05 +0800
Message-ID: <1313937545.13671.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep93xx-fb.c uses interfaces from linux/module.h,
so it should include that file.  This patch fixes below build errors.

  CC      drivers/video/ep93xx-fb.o
drivers/video/ep93xx-fb.c:120: error: expected ')' before 'int'
drivers/video/ep93xx-fb.c:122: error: expected ')' before string constant
drivers/video/ep93xx-fb.c:409: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/video/ep93xx-fb.c:645: error: expected declaration specifiers or '...' before string constant
drivers/video/ep93xx-fb.c:645: warning: data definition has no type or storage class
drivers/video/ep93xx-fb.c:645: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/video/ep93xx-fb.c:645: warning: function declaration isn't a prototype
drivers/video/ep93xx-fb.c:646: error: expected declaration specifiers or '...' before string constant
drivers/video/ep93xx-fb.c:646: warning: data definition has no type or storage class
drivers/video/ep93xx-fb.c:646: warning: type defaults to 'int' in declaration of 'MODULE_ALIAS'
drivers/video/ep93xx-fb.c:646: warning: function declaration isn't a prototype
drivers/video/ep93xx-fb.c:647: error: expected declaration specifiers or '...' before string constant
drivers/video/ep93xx-fb.c:647: warning: data definition has no type or storage class
drivers/video/ep93xx-fb.c:647: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/video/ep93xx-fb.c:647: warning: function declaration isn't a prototype
drivers/video/ep93xx-fb.c:649: error: expected declaration specifiers or '...' before string constant
drivers/video/ep93xx-fb.c:649: warning: data definition has no type or storage class
drivers/video/ep93xx-fb.c:649: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/video/ep93xx-fb.c:649: warning: function declaration isn't a prototype
make[2]: *** [drivers/video/ep93xx-fb.o] Error 1
make[1]: *** [drivers/video] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/ep93xx-fb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
index 40e5f17..8133a9d 100644
--- a/drivers/video/ep93xx-fb.c
+++ b/drivers/video/ep93xx-fb.c
@@ -17,6 +17,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
-- 
1.7.4.1



