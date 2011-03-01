Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab1CATSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:18:38 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:37297 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757114Ab1CATSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:18:35 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Ondrej Zajicek <santiago@crfreenet.org>
Subject: [PATCH 3/5] s3fb: fix 15/16bpp modes with over 115MHz pixclocks on 86C365 Trio3D
Date: Tue, 1 Mar 2011 20:18:27 +0100
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103012018.30651.linux@rainbow-software.org>
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
