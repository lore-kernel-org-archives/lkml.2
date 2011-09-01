Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1IAAMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 20:12:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46815 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab1IAAMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 20:12:12 -0400
Subject: [PATCH RESEND] video: mxsfb: add missing include of linux/module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 08:11:59 +0800
Message-ID: <1314835919.2208.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/module.h to fix below build error:

                 from drivers/video/mxsfb.c:42:
arch/arm/mach-mxs/include/mach/memory.h:22:1: warning: this is the location of the previous definition
drivers/video/mxsfb.c:574: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/video/mxsfb.c:893: warning: data definition has no type or storage class
drivers/video/mxsfb.c:893: warning: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE'
drivers/video/mxsfb.c:893: warning: parameter names (without types) in function declaration
drivers/video/mxsfb.c:917: error: expected declaration specifiers or '...' before string constant
drivers/video/mxsfb.c:917: warning: data definition has no type or storage class
drivers/video/mxsfb.c:917: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/video/mxsfb.c:917: warning: function declaration isn't a prototype
drivers/video/mxsfb.c:918: error: expected declaration specifiers or '...' before string constant
drivers/video/mxsfb.c:918: warning: data definition has no type or storage class
drivers/video/mxsfb.c:918: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/video/mxsfb.c:918: warning: function declaration isn't a prototype
drivers/video/mxsfb.c:919: error: expected declaration specifiers or '...' before string constant
drivers/video/mxsfb.c:919: warning: data definition has no type or storage class
drivers/video/mxsfb.c:919: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/video/mxsfb.c:919: warning: function declaration isn't a prototype
make[2]: *** [drivers/video/mxsfb.o] Error 1
make[1]: *** [drivers/video] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/mxsfb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 0b2f2dd..d837d63 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -39,6 +39,7 @@
  * the required value in the imx_fb_videomode structure.
  */
 
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
-- 
1.7.4.1



