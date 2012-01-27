Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2A0G2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:28:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64941 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2A0G23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:28:29 -0500
Message-ID: <4F224408.2040208@gmail.com>
Date: Fri, 27 Jan 2012 17:28:24 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: airlied@linux.ie, airlied@redhat.com, Alan Cox <alan@linux.intel.com>,
        ville.syrjala@linux.intel.com
CC: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] gma500: Fix suspend/resume functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both the suspend and resume functions incorrectly set psbfb =
to_psb_fb(NULL) outside of the loop over all of the framebuffers. Fix
this by moving the assignment of psbfb inside the loop and removing the
initialisation of fb.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index 791c0ef..830dfdd 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -113,12 +113,12 @@ static int psbfb_pan(struct fb_var_screeninfo *var, struct fb_info *info)
 
 void psbfb_suspend(struct drm_device *dev)
 {
-	struct drm_framebuffer *fb = 0;
-	struct psb_framebuffer *psbfb = to_psb_fb(fb);
+	struct drm_framebuffer *fb;
 
 	console_lock();
 	mutex_lock(&dev->mode_config.mutex);
 	list_for_each_entry(fb, &dev->mode_config.fb_list, head) {
+		struct psb_framebuffer *psbfb = to_psb_fb(fb);
 		struct fb_info *info = psbfb->fbdev;
 		fb_set_suspend(info, 1);
 		drm_fb_helper_blank(FB_BLANK_POWERDOWN, info);
@@ -129,12 +129,12 @@ void psbfb_suspend(struct drm_device *dev)
 
 void psbfb_resume(struct drm_device *dev)
 {
-	struct drm_framebuffer *fb = 0;
-	struct psb_framebuffer *psbfb = to_psb_fb(fb);
+	struct drm_framebuffer *fb;
 
 	console_lock();
 	mutex_lock(&dev->mode_config.mutex);
 	list_for_each_entry(fb, &dev->mode_config.fb_list, head) {
+		struct psb_framebuffer *psbfb = to_psb_fb(fb);
 		struct fb_info *info = psbfb->fbdev;
 		fb_set_suspend(info, 0);
 		drm_fb_helper_blank(FB_BLANK_UNBLANK, info);

