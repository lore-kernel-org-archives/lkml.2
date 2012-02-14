Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2BNFvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:51:42 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:49564 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752157Ab2BNFvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:51:39 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX185PYUvHHw5DXYcgi/asSi4xQamI/yYxcisveJlDH
	+3B0wSBwsnNaFN
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: fill xres and yres
Date: Tue, 14 Feb 2012 06:12:03 +0000
Message-Id: <561c9079ea1de24f8d49c73391811c547d1b2636.1329194838.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329194838.git.FlorianSchandinat@gmx.de>
References: <cover.1329194838.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fills xres and yres in var which is required when a
temporary var is genereated when viafb_SAMM_ON is set and
viafb_dual_fb is not set. It also removes an obsolete comment.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 08c1036..399d507 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2125,7 +2125,6 @@ void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 	}
 }
 
-/*According var's xres, yres fill var's other timing information*/
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var,
 	struct crt_mode_table *mode)
 {
@@ -2134,6 +2133,8 @@ void viafb_fill_var_timing_info(struct fb_var_screeninfo *var,
 	crt_reg = mode->crtc;
 	var->pixclock = 1000000000 / (crt_reg.hor_total * crt_reg.ver_total)
 		* 1000 / mode->refresh_rate;
+	var->xres = crt_reg.hor_addr;
+	var->yres = crt_reg.ver_addr;
 	var->left_margin =
 	    crt_reg.hor_total - (crt_reg.hor_sync_start + crt_reg.hor_sync_end);
 	var->right_margin = crt_reg.hor_sync_start - crt_reg.hor_addr;
-- 
1.7.9

