Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0CXMSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:18:08 -0400
Received: from server78.greatnet.de ([83.133.96.102]:54267 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab0CXMSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:18:07 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Andres Salomon <dilinger@debian.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix section mismatches in virtual framebuffer
Date: Wed, 24 Mar 2010 13:17:15 +0100
Message-Id: <1269433035-6141-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both structs, vfb_default and vfb_fix, should not be freed,
since they are referenced and used by the struct fb_info of that device.

WARNING: drivers/video/vfb.o(.devinit.text+0x13f): Section mismatch in
reference from the function vfb_probe() to the variable
.init.data:vfb_default
The function __devinit vfb_probe() references
a variable __initdata vfb_default.
If vfb_default is only used by vfb_probe then
annotate vfb_default with a matching annotation.

WARNING: drivers/video/vfb.o(.devinit.text+0x162): Section mismatch in
reference from the function vfb_probe() to the variable
.init.data:vfb_fix
The function __devinit vfb_probe() references
a variable __initdata vfb_fix.
If vfb_fix is only used by vfb_probe then
annotate vfb_fix with a matching annotation.

WARNING: drivers/video/vfb.o(.devinit.text+0x177): Section mismatch in
reference from the function vfb_probe() to the variable
.init.data:vfb_fix
The function __devinit vfb_probe() references
a variable __initdata vfb_fix.
If vfb_fix is only used by vfb_probe then
annotate vfb_fix with a matching annotation.

WARNING: drivers/video/vfb.o(.devinit.text+0x184): Section mismatch in
reference from the function vfb_probe() to the (unknown reference)
.init.data:(unknown)
The function __devinit vfb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by vfb_probe then
annotate (unknown) with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/video/vfb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
index b8ab995..ae5796d 100644
--- a/drivers/video/vfb.c
+++ b/drivers/video/vfb.c
@@ -79,7 +79,7 @@ static void rvfree(void *mem, unsigned long size)
 	vfree(mem);
 }
 
-static struct fb_var_screeninfo vfb_default __initdata = {
+static struct fb_var_screeninfo vfb_default = {
 	.xres =		640,
 	.yres =		480,
 	.xres_virtual =	640,
@@ -101,7 +101,7 @@ static struct fb_var_screeninfo vfb_default __initdata = {
       	.vmode =	FB_VMODE_NONINTERLACED,
 };
 
-static struct fb_fix_screeninfo vfb_fix __initdata = {
+static struct fb_fix_screeninfo vfb_fix = {
 	.id =		"Virtual FB",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_PSEUDOCOLOR,
-- 
1.6.3.3

