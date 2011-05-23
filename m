Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208Ab1EWVvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:51:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46782 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757661Ab1EWVvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:51:02 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+s1fQWvjOsxWAqHvLHal4YGX4jRT8LqjXs8lKiHq
	dUcTDhswB51qI5
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        stable@kernel.org
Subject: [PATCH] viafb: use display information in info not in var for panning
Date: Mon, 23 May 2011 22:07:26 +0000
Message-Id: <1306188446-5160-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <201105232211.40154.laurent.pinchart@ideasonboard.com>
References: <201105232211.40154.laurent.pinchart@ideasonboard.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Laurent pointed out we must not use any information in the passed
var besides xoffset, yoffset and vmode as otherwise applications
might abuse it. Also use the aligned fix.line_length and not the
(possible) unaligned xres_virtual.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@kernel.org
---
 drivers/video/via/viafbdev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 3114a87..aa87529 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -348,8 +348,9 @@ static int viafb_pan_display(struct fb_var_screeninfo *var,
 	struct fb_info *info)
 {
 	struct viafb_par *viapar = info->par;
-	u32 vram_addr = (var->yoffset * var->xres_virtual + var->xoffset)
-		* (var->bits_per_pixel / 8) + viapar->vram_addr;
+	u32 vram_addr = viapar->vram_addr
+		+ var->yoffset * info->fix.line_length
+		+ var->xoffset * info->var.bits_per_pixel / 8;
 
 	DEBUG_MSG(KERN_DEBUG "viafb_pan_display, address = %d\n", vram_addr);
 	if (!viafb_dual_fb) {
-- 
1.6.3.2

