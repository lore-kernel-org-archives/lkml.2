Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802Ab0GWPaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:30:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:59857 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760732Ab0GWP3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:29:45 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+klxlVsg2kyw1NyMDjFguLeOxHGQdDJJ/5YkdLSR
	A47+ciZU+EPMNl
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 08/11] viafb: update fix before calculating depth
Date: Fri, 23 Jul 2010 15:39:23 +0000
Message-Id: <1279899566-4359-9-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: update fix before calculating depth

As the depth calculation depends on information in fix it is saner to
do the update first.
No runtime change expected as the value visual in fix used never
changes to MONO.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/viafbdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 1082541..ab39552 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -234,6 +234,7 @@ static int viafb_set_par(struct fb_info *info)
 	struct VideoModeTable *vmode_entry, *vmode_entry1 = NULL;
 	DEBUG_MSG(KERN_INFO "viafb_set_par!\n");
 
+	viafb_update_fix(info);
 	viapar->depth = fb_get_color_depth(&info->var, &info->fix);
 	viafb_update_device_setting(viafbinfo->var.xres, viafbinfo->var.yres,
 		viafbinfo->var.bits_per_pixel, viafb_refresh, 0);
@@ -257,7 +258,6 @@ static int viafb_set_par(struct fb_info *info)
 	}
 
 	if (vmode_entry) {
-		viafb_update_fix(info);
 		if (viafb_dual_fb && viapar->iga_path == IGA2)
 			viafb_bpp1 = info->var.bits_per_pixel;
 		else
-- 
1.6.3.2

