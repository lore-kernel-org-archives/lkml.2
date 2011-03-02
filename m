Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab1CBVRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:17:37 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19919 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab1CBVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:17:35 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77438207"
X-IronPort-AV: E=Sophos;i="4.62,253,1297065600"; 
   d="scan'208";a="56219381"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Dima Zavin <dima@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH 2/4] [ARM] msm: mdp: Add support for RGBX 8888 image format.
Date: Wed,  2 Mar 2011 13:17:08 -0800
Message-Id: <1299100629-11625-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
References: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dima Zavin <dima@android.com>

Signed-off-by: Dima Zavin <dima@android.com>
Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/mdp_hw.h  |    9 ++++++++-
 drivers/video/msm/mdp_ppp.c |    1 +
 include/linux/msm_mdp.h     |    1 +
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
index 4e3deb4..9e1e92e 100644
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@ -449,6 +449,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define PPP_CFG_MDP_XRGB_8888(dir) PPP_CFG_MDP_ARGB_8888(dir)
 #define PPP_CFG_MDP_RGBA_8888(dir) PPP_CFG_MDP_ARGB_8888(dir)
 #define PPP_CFG_MDP_BGRA_8888(dir) PPP_CFG_MDP_ARGB_8888(dir)
+#define PPP_CFG_MDP_RGBX_8888(dir) PPP_CFG_MDP_ARGB_8888(dir)
 
 #define PPP_CFG_MDP_Y_CBCR_H2V2(dir)   (PPP_##dir##_C2R_8BIT | \
 					PPP_##dir##_C0G_8BIT | \
@@ -494,6 +495,8 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 	MDP_GET_PACK_PATTERN(CLR_ALPHA, CLR_B, CLR_G, CLR_R, 8)
 #define PPP_PACK_PATTERN_MDP_BGRA_8888 \
 	MDP_GET_PACK_PATTERN(CLR_ALPHA, CLR_R, CLR_G, CLR_B, 8)
+#define PPP_PACK_PATTERN_MDP_RGBX_8888 \
+	MDP_GET_PACK_PATTERN(CLR_ALPHA, CLR_B, CLR_G, CLR_R, 8)
 #define PPP_PACK_PATTERN_MDP_Y_CBCR_H2V1 \
 	MDP_GET_PACK_PATTERN(0, 0, CLR_CB, CLR_CR, 8)
 #define PPP_PACK_PATTERN_MDP_Y_CBCR_H2V2 PPP_PACK_PATTERN_MDP_Y_CBCR_H2V1
@@ -509,6 +512,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 #define PPP_CHROMA_SAMP_MDP_ARGB_8888(dir) PPP_OP_##dir##_CHROMA_RGB
 #define PPP_CHROMA_SAMP_MDP_RGBA_8888(dir) PPP_OP_##dir##_CHROMA_RGB
 #define PPP_CHROMA_SAMP_MDP_BGRA_8888(dir) PPP_OP_##dir##_CHROMA_RGB
+#define PPP_CHROMA_SAMP_MDP_RGBX_8888(dir) PPP_OP_##dir##_CHROMA_RGB
 #define PPP_CHROMA_SAMP_MDP_Y_CBCR_H2V1(dir) PPP_OP_##dir##_CHROMA_H2V1
 #define PPP_CHROMA_SAMP_MDP_Y_CBCR_H2V2(dir) PPP_OP_##dir##_CHROMA_420
 #define PPP_CHROMA_SAMP_MDP_Y_CRCB_H2V1(dir) PPP_OP_##dir##_CHROMA_H2V1
@@ -523,6 +527,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 	[MDP_ARGB_8888] = PPP_##name##_MDP_ARGB_8888,\
 	[MDP_RGBA_8888] = PPP_##name##_MDP_RGBA_8888,\
 	[MDP_BGRA_8888] = PPP_##name##_MDP_BGRA_8888,\
+	[MDP_RGBX_8888] = PPP_##name##_MDP_RGBX_8888,\
 	[MDP_Y_CBCR_H2V1] = PPP_##name##_MDP_Y_CBCR_H2V1,\
 	[MDP_Y_CBCR_H2V2] = PPP_##name##_MDP_Y_CBCR_H2V2,\
 	[MDP_Y_CRCB_H2V1] = PPP_##name##_MDP_Y_CRCB_H2V1,\
@@ -536,6 +541,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 	[MDP_ARGB_8888] = PPP_##name##_MDP_ARGB_8888(dir),\
 	[MDP_RGBA_8888] = PPP_##name##_MDP_RGBA_8888(dir),\
 	[MDP_BGRA_8888] = PPP_##name##_MDP_BGRA_8888(dir),\
+	[MDP_RGBX_8888] = PPP_##name##_MDP_RGBX_8888(dir),\
 	[MDP_Y_CBCR_H2V1] = PPP_##name##_MDP_Y_CBCR_H2V1(dir),\
 	[MDP_Y_CBCR_H2V2] = PPP_##name##_MDP_Y_CBCR_H2V2(dir),\
 	[MDP_Y_CRCB_H2V1] = PPP_##name##_MDP_Y_CRCB_H2V1(dir),\
@@ -547,7 +553,8 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
 		       (img == MDP_YCRYCB_H2V1))
 #define IS_RGB(img) ((img == MDP_RGB_565) | (img == MDP_RGB_888) | \
 		     (img == MDP_ARGB_8888) | (img == MDP_RGBA_8888) | \
-		     (img == MDP_XRGB_8888) | (img == MDP_BGRA_8888))
+		     (img == MDP_XRGB_8888) | (img == MDP_BGRA_8888) | \
+		     (img == MDP_RGBX_8888))
 #define HAS_ALPHA(img) ((img == MDP_ARGB_8888) | (img == MDP_RGBA_8888) | \
 			(img == MDP_BGRA_8888))
 
diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
index 4ff001f..2b6564e 100644
--- a/drivers/video/msm/mdp_ppp.c
+++ b/drivers/video/msm/mdp_ppp.c
@@ -69,6 +69,7 @@ static uint32_t bytes_per_pixel[] = {
 	[MDP_ARGB_8888] = 4,
 	[MDP_RGBA_8888] = 4,
 	[MDP_BGRA_8888] = 4,
+	[MDP_RGBX_8888] = 4,
 	[MDP_Y_CBCR_H2V1] = 1,
 	[MDP_Y_CBCR_H2V2] = 1,
 	[MDP_Y_CRCB_H2V1] = 1,
diff --git a/include/linux/msm_mdp.h b/include/linux/msm_mdp.h
index d11fe0f..fe722c1 100644
--- a/include/linux/msm_mdp.h
+++ b/include/linux/msm_mdp.h
@@ -32,6 +32,7 @@ enum {
 	MDP_Y_CBCR_H2V1,	/* Y and CrCb, pseduo planar w/ Cr is in MSB */
 	MDP_RGBA_8888,		/* ARGB 888 */
 	MDP_BGRA_8888,		/* ABGR 888 */
+	MDP_RGBX_8888,		/* RGBX 888 */
 	MDP_IMGTYPE_LIMIT	/* Non valid image type after this enum */
 };
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

