Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab1CRVvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:51:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27429 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab1CRVvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:51:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6289"; a="80848151"
X-IronPort-AV: E=Sophos;i="4.63,205,1299484800"; 
   d="scan'208";a="37044403"
From: Carl Vanderlip <carlv@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Carl Vanderlip <carlv@codeaurora.org>
Subject: [PATCH 01/20] video: msm: Fix typo 'mpd'->'mdp'
Date: Fri, 18 Mar 2011 14:51:35 -0700
Message-Id: <1300485095-26923-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Swetland <swetland@google.com>

Trivial fix

Authors:
Dima Zavin <dima@android.com>
Rebecca Schultz Zavin <rebecca@android.com>
Colin Cross <ccross@android.com>

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_fb.h |    2 +-
 drivers/video/msm/mdp.c                 |    8 ++++----
 drivers/video/msm/mdp_ppp.c             |   10 +++++-----
 drivers/video/msm/msm_fb.c              |    1 -
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_fb.h b/arch/arm/mach-msm/include/mach/msm_fb.h
index 1f4fc81..da11719 100644
--- a/arch/arm/mach-msm/include/mach/msm_fb.h
+++ b/arch/arm/mach-msm/include/mach/msm_fb.h
@@ -114,7 +114,7 @@ struct mdp_blit_req;
 struct fb_info;
 struct mdp_device {
 	struct device dev;
-	void (*dma)(struct mdp_device *mpd, uint32_t addr,
+	void (*dma)(struct mdp_device *mdp, uint32_t addr,
 		    uint32_t stride, uint32_t w, uint32_t h, uint32_t x,
 		    uint32_t y, struct msmfb_callback *callback, int interface);
 	void (*dma_wait)(struct mdp_device *mdp);
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index c3636d5..45af97d 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -2,7 +2,7 @@
  *
  * MSM MDP Interface (used by framebuffer core)
  *
- * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007, 2011 Code Aurora Forum. All rights reserved.
  * Copyright (C) 2007 Google Incorporated
  *
  * This software is licensed under the terms of the GNU General Public
@@ -288,7 +288,7 @@ int mdp_blit(struct mdp_device *mdp_dev, struct fb_info *fb,
 	/* WORKAROUND FOR HARDWARE BUG IN BG TILE FETCH */
 	if (unlikely(req->src_rect.h == 0 ||
 		     req->src_rect.w == 0)) {
-		printk(KERN_ERR "mpd_ppp: src img of zero size!\n");
+		printk(KERN_ERR "mdp_ppp: src img of zero size!\n");
 		return -EINVAL;
 	}
 	if (unlikely(req->dst_rect.h == 0 ||
@@ -298,13 +298,13 @@ int mdp_blit(struct mdp_device *mdp_dev, struct fb_info *fb,
 	/* do this first so that if this fails, the caller can always
 	 * safely call put_img */
 	if (unlikely(get_img(&req->src, fb, &src_start, &src_len, &src_file))) {
-		printk(KERN_ERR "mpd_ppp: could not retrieve src image from "
+		printk(KERN_ERR "mdp_ppp: could not retrieve src image from "
 				"memory\n");
 		return -EINVAL;
 	}
 
 	if (unlikely(get_img(&req->dst, fb, &dst_start, &dst_len, &dst_file))) {
-		printk(KERN_ERR "mpd_ppp: could not retrieve dst image from "
+		printk(KERN_ERR "mdp_ppp: could not retrieve dst image from "
 				"memory\n");
 		return -EINVAL;
 	}
diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
index 4ff001f..2b04027 100644
--- a/drivers/video/msm/mdp_ppp.c
+++ b/drivers/video/msm/mdp_ppp.c
@@ -1,6 +1,6 @@
 /* drivers/video/msm/mdp_ppp.c
  *
- * Copyright (C) 2007 QUALCOMM Incorporated
+ * Copyright (C) 2007, 2011 Code Aurora Forum. All rights reserved.
  * Copyright (C) 2007 Google Incorporated
  *
  * This software is licensed under the terms of the GNU General Public
@@ -650,7 +650,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 
 	if (unlikely(req->src.format >= MDP_IMGTYPE_LIMIT ||
 		     req->dst.format >= MDP_IMGTYPE_LIMIT)) {
-		printk(KERN_ERR "mpd_ppp: img is of wrong format\n");
+		printk(KERN_ERR "mdp_ppp: img is of wrong format\n");
 		return -EINVAL;
 	}
 
@@ -658,7 +658,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		     req->src_rect.y > req->src.height ||
 		     req->dst_rect.x > req->dst.width ||
 		     req->dst_rect.y > req->dst.height)) {
-		printk(KERN_ERR "mpd_ppp: img rect is outside of img!\n");
+		printk(KERN_ERR "mdp_ppp: img rect is outside of img!\n");
 		return -EINVAL;
 	}
 
@@ -694,7 +694,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 
 	if (!valid_src_dst(src_start, src_len, dst_start, dst_len, req,
 			   &regs)) {
-		printk(KERN_ERR "mpd_ppp: final src or dst location is "
+		printk(KERN_ERR "mdp_ppp: final src or dst location is "
 			"invalid, are you trying to make an image too large "
 			"or to place it outside the screen?\n");
 		return -EINVAL;
@@ -708,7 +708,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		regs.op |= PPP_OP_DITHER_EN;
 	blit_blend(req, &regs);
 	if (blit_scale(mdp, req, &regs)) {
-		printk(KERN_ERR "mpd_ppp: error computing scale for img.\n");
+		printk(KERN_ERR "mdp_ppp: error computing scale for img.\n");
 		return -EINVAL;
 	}
 	blit_blur(mdp, req, &regs);
diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
index 5436aeb..04d0067 100644
--- a/drivers/video/msm/msm_fb.c
+++ b/drivers/video/msm/msm_fb.c
@@ -321,7 +321,6 @@ error:
 	mutex_unlock(&msmfb->panel_init_lock);
 }
 
-
 static int msmfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	if ((var->xres != info->var.xres) ||
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

