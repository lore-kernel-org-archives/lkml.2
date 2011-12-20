Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab1LTTAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:00:18 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:44681 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1LTTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:00:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fbdev: matroxfb: Fix compilation after fb_var_screeninfo change
Date: Tue, 20 Dec 2011 20:00:11 +0100
Message-Id: <1324407611-6886-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fb21c2f42879 ("fbdev: Add FOURCC-based format configuration API")
modified the layout of the fb_var_screeninfo structure. Remove zero
fields from the static initializers in the matroxfb driver accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/matrox/matroxfb_base.c  |    1 -
 drivers/video/matrox/matroxfb_crtc2.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index 44bf8d4..401a56e 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -147,7 +147,6 @@ static struct fb_var_screeninfo vesafb_defined = {
 	39721L,48L,16L,33L,10L,
 	96L,2L,~0,	/* No sync info */
 	FB_VMODE_NONINTERLACED,
-	0, {0,0,0,0,0}
 };
 
 
diff --git a/drivers/video/matrox/matroxfb_crtc2.c b/drivers/video/matrox/matroxfb_crtc2.c
index d7112c3..02796a4 100644
--- a/drivers/video/matrox/matroxfb_crtc2.c
+++ b/drivers/video/matrox/matroxfb_crtc2.c
@@ -593,7 +593,6 @@ static struct fb_var_screeninfo matroxfb_dh_defined = {
 		39721L,48L,16L,33L,10L,
 		96L,2,0,	/* no sync info */
 		FB_VMODE_NONINTERLACED,
-		0, {0,0,0,0,0}
 };
 
 static int matroxfb_dh_regit(const struct matrox_fb_info *minfo,
-- 
Regards,

Laurent Pinchart

