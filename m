Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717Ab1KJFMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:12:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934656Ab1KJD0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:12 2011
Message-Id: <20111109212712.309828355@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [116/262] viafb: use display information in info not in var for panning
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

commit d933990c57b498c092ceef591c7c5d69dbfe9f30 upstream.

As Laurent pointed out we must not use any information in the passed
var besides xoffset, yoffset and vmode as otherwise applications
might abuse it. Also use the aligned fix.line_length and not the
(possible) unaligned xres_virtual.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/via/viafbdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -348,8 +348,9 @@ static int viafb_pan_display(struct fb_v
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


