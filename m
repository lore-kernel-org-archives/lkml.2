Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1KUUyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:54:11 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:33171 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1KUUyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:54:07 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/8] fbdev/amifb: Remove superfluous casts when assigning void *
Date: Mon, 21 Nov 2011 21:53:56 +0100
Message-Id: <1321908839-11419-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
References: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/amifb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index d3847e7..421c1f9 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -2411,7 +2411,7 @@ static int amifb_check_var(struct fb_var_screeninfo *var,
 
 static int amifb_set_par(struct fb_info *info)
 {
-	struct amifb_par *par = (struct amifb_par *)info->par;
+	struct amifb_par *par = info->par;
 
 	do_vmode_pan = 0;
 	do_vmode_full = 0;
@@ -3181,7 +3181,7 @@ static inline void xor_one_line(int bpp, unsigned long next_plane,
 static void amifb_fillrect(struct fb_info *info,
 			   const struct fb_fillrect *rect)
 {
-	struct amifb_par *par = (struct amifb_par *)info->par;
+	struct amifb_par *par = info->par;
 	int dst_idx, x2, y2;
 	unsigned long *dst;
 	u32 width, height;
@@ -3259,7 +3259,7 @@ static inline void copy_one_line_rev(int bpp, unsigned long next_plane,
 static void amifb_copyarea(struct fb_info *info,
 			   const struct fb_copyarea *area)
 {
-	struct amifb_par *par = (struct amifb_par *)info->par;
+	struct amifb_par *par = info->par;
 	int x2, y2;
 	u32 dx, dy, sx, sy, width, height;
 	unsigned long *dst, *src;
@@ -3352,7 +3352,7 @@ static inline void expand_one_line(int bpp, unsigned long next_plane,
 
 static void amifb_imageblit(struct fb_info *info, const struct fb_image *image)
 {
-	struct amifb_par *par = (struct amifb_par *)info->par;
+	struct amifb_par *par = info->par;
 	int x2, y2;
 	unsigned long *dst;
 	int dst_idx;
-- 
1.7.0.4

