Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1BVWhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:37:06 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:33039 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754476Ab1BVWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:37:04 -0500
To: Ondrej Zajicek <santiago@crfreenet.org>
Subject: [PATCH] s3fb: fix 15/16bpp modes with over 115MHz pixclocks on 86C365 Trio3D
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Tue, 22 Feb 2011 23:36:45 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102222336.48506.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pixel multiplexing in 15/16bpp modes when pixclock is over 115MHz
on Trio3D (86C365) cards to fix artifacts on the left side of screen.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.38-rc4-/drivers/video/s3fb.c	2011-02-20 20:48:41.000000000 +0100
+++ linux-2.6.38-rc4/drivers/video/s3fb.c	2011-02-22 23:31:16.000000000 +0100
@@ -675,6 +675,15 @@
 				svga_wcrt_mask(par->state.vgabase, 0x67, 0x20, 0xF0);
 			else
 				svga_wcrt_mask(par->state.vgabase, 0x67, 0x30, 0xF0);
+		} else if (par->chip == CHIP_365_TRIO3D) {
+			svga_wcrt_mask(par->state.vgabase, 0x50, 0x10, 0x30);
+			if (info->var.pixclock > 8695) {
+				svga_wcrt_mask(par->state.vgabase, 0x67, 0x30, 0xF0);
+				hmul = 2;
+			} else {
+				svga_wcrt_mask(par->state.vgabase, 0x67, 0x20, 0xF0);
+				multiplex = 1;
+			}
 		} else {
 			svga_wcrt_mask(par->state.vgabase, 0x50, 0x10, 0x30);
 			svga_wcrt_mask(par->state.vgabase, 0x67, 0x30, 0xF0);
@@ -691,6 +700,15 @@
 				svga_wcrt_mask(par->state.vgabase, 0x67, 0x40, 0xF0);
 			else
 				svga_wcrt_mask(par->state.vgabase, 0x67, 0x50, 0xF0);
+		} else if (par->chip == CHIP_365_TRIO3D) {
+			svga_wcrt_mask(par->state.vgabase, 0x50, 0x10, 0x30);
+			if (info->var.pixclock > 8695) {
+				svga_wcrt_mask(par->state.vgabase, 0x67, 0x50, 0xF0);
+				hmul = 2;
+			} else {
+				svga_wcrt_mask(par->state.vgabase, 0x67, 0x40, 0xF0);
+				multiplex = 1;
+			}
 		} else {
 			svga_wcrt_mask(par->state.vgabase, 0x50, 0x10, 0x30);
 			svga_wcrt_mask(par->state.vgabase, 0x67, 0x50, 0xF0);


-- 
Ondrej Zary
