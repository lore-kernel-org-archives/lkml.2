Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0FRHk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:40:29 -0400
Received: from server78.greatnet.de ([83.133.96.102]:45324 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab0FRHkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:40:24 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: akpm@linux-foundation.org
Cc: pjones@redhat.com, marcin.slusarz@gmail.com, arnaud.patard@rtp-net.org,
       jayakumar.lkml@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH] fbdev: section cleanup in efifb
Date: Fri, 18 Jun 2010 09:40:15 +0200
Message-Id: <1276846815-26550-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes 43 section mismatches by moving
the two structures efifb_defined and efifb_fix
from .init.data to .devinit.data.

Also the two structure arrays dmi_system_table[] and dmi_list[]
have been moved from .data to .init.rodata and .init.data,
which saves, if built-in, some space.

On x86_64 'size -A' showed that these sections changed size:

efifb.o:
section                     size-old        size-new
.data                       1200            688
.init.data                  7840            512
.init.rodata                0               7568
.devinit.data               0               256

Total                       11927           11911

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
This patch is:
* diffed against Linus tree
* compile tested
* carefully reviewed (by me)

 drivers/video/efifb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 4a56f46..815f84b 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -16,7 +16,7 @@
 
 #include <video/vga.h>
 
-static struct fb_var_screeninfo efifb_defined __initdata = {
+static struct fb_var_screeninfo efifb_defined __devinitdata = {
 	.activate		= FB_ACTIVATE_NOW,
 	.height			= -1,
 	.width			= -1,
@@ -27,7 +27,7 @@ static struct fb_var_screeninfo efifb_defined __initdata = {
 	.vmode			= FB_VMODE_NONINTERLACED,
 };
 
-static struct fb_fix_screeninfo efifb_fix __initdata = {
+static struct fb_fix_screeninfo efifb_fix __devinitdata = {
 	.id			= "EFI VGA",
 	.type			= FB_TYPE_PACKED_PIXELS,
 	.accel			= FB_ACCEL_NONE,
@@ -59,7 +59,7 @@ static struct efifb_dmi_info {
 	int stride;
 	int width;
 	int height;
-} dmi_list[] = {
+} dmi_list[] __initdata = {
 	[M_I17] = { "i17", 0x80010000, 1472 * 4, 1440, 900 },
 	[M_I20] = { "i20", 0x80010000, 1728 * 4, 1680, 1050 }, /* guess */
 	[M_I20_SR] = { "imac7", 0x40010000, 1728 * 4, 1680, 1050 },
@@ -83,7 +83,7 @@ static int set_system(const struct dmi_system_id *id);
 		DMI_MATCH(DMI_PRODUCT_NAME, name) },		\
 	  &dmi_list[enumid] }
 
-static struct dmi_system_id __initdata dmi_system_table[] = {
+static const struct dmi_system_id dmi_system_table[] __initconst = {
 	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac4,1", M_I17),
 	/* At least one of these two will be right; maybe both? */
 	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac5,1", M_I20),
-- 
1.7.0.4

