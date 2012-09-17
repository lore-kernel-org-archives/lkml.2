Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab2IQOXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:23:34 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:29453 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab2IQOXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:23:32 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 10:23:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkCABEvV1BbdWObgWdsb2JhbABEvBUiAQEWJieCIAEBBSdSECAxPBsHEogEulqSCQOVYok1iVQ
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="969870754"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 1/7] staging: sm7xxfb: clean fb_fix_screeninfo and fb_var_screeninfo initialization
Date: Mon, 17 Sep 2012 16:12:47 +0200
Message-Id: <1347891173-13916-2-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
References: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

Part of fb_fix_screeninfo and fb_var_screeninfo initialization happens
in smtc_alloc_fb_info. It duplicates code while hiding the real
functionality of smtc_alloc_fb_info. This patch groups initialization
together.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index d935c23..b809e2c 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -72,6 +72,8 @@ static struct fb_var_screeninfo smtcfb_var = {
 	.height         = -1,
 	.width          = -1,
 	.vmode          = FB_VMODE_NONINTERLACED,
+	.nonstd         = 0,
+	.accel_flags    = FB_ACCELF_TEXT,
 };
 
 static struct fb_fix_screeninfo smtcfb_fix = {
@@ -80,6 +82,10 @@ static struct fb_fix_screeninfo smtcfb_fix = {
 	.visual         = FB_VISUAL_TRUECOLOR,
 	.line_length    = 800 * 3,
 	.accel          = FB_ACCEL_SMI_LYNX,
+	.type_aux       = 0,
+	.xpanstep       = 0,
+	.ypanstep       = 0,
+	.ywrapstep      = 0,
 };
 
 struct vesa_mode {
@@ -694,20 +700,7 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev, char *name)
 	sfb->fb.fix = smtcfb_fix;
 	strcpy(sfb->fb.fix.id, name);
 
-	sfb->fb.fix.type        = FB_TYPE_PACKED_PIXELS;
-	sfb->fb.fix.type_aux    = 0;
-	sfb->fb.fix.xpanstep    = 0;
-	sfb->fb.fix.ypanstep    = 0;
-	sfb->fb.fix.ywrapstep   = 0;
-	sfb->fb.fix.accel       = FB_ACCEL_SMI_LYNX;
-
-	sfb->fb.var             = smtcfb_var;
-	sfb->fb.var.nonstd      = 0;
-	sfb->fb.var.activate    = FB_ACTIVATE_NOW;
-	sfb->fb.var.height      = -1;
-	sfb->fb.var.width       = -1;
-	sfb->fb.var.accel_flags = FB_ACCELF_TEXT;
-	sfb->fb.var.vmode       = FB_VMODE_NONINTERLACED;
+	sfb->fb.var = smtcfb_var;
 
 	sfb->fb.pseudo_palette  = sfb->colreg;
 
-- 
1.7.10.4

