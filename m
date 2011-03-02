Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab1CBVQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:16:51 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63913 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818Ab1CBVQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:16:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77638259"
X-IronPort-AV: E=Sophos;i="4.62,253,1297065600"; 
   d="scan'208";a="56219172"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Dima Zavin <dima@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carl Vanderlip <carlv@codeaurora.org>,
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH 1/4] video: msmfb: Put the partial update magic value into the fix_screen struct.
Date: Wed,  2 Mar 2011 13:16:36 -0800
Message-Id: <1299100596-11157-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
References: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dima Zavin <dima@android.com>

This can then be tested by userspace to see if the capability is supported.
Userspace cannot rely on that value being left in var_screen, since userspace
itself can change it.

Signed-off-by: Dima Zavin <dima@android.com>
Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/msm_fb.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
index 5436aeb..fe5efe5 100644
--- a/drivers/video/msm/msm_fb.c
+++ b/drivers/video/msm/msm_fb.c
@@ -469,6 +469,18 @@ static void setup_fb_info(struct msmfb_info *msmfb)
 	fb_info->var.yoffset = 0;
 
 	if (msmfb->panel->caps & MSMFB_CAP_PARTIAL_UPDATES) {
+		/*
+		 * Set the param in the fixed screen, so userspace can't
+		 * change it. This will be used to check for the
+		 * capability.
+		 */
+		fb_info->fix.reserved[0] = 0x5444;
+		fb_info->fix.reserved[1] = 0x5055;
+
+		/*
+		 * This preloads the value so that if userspace doesn't
+		 * change it, it will be a full update
+		 */
 		fb_info->var.reserved[0] = 0x54445055;
 		fb_info->var.reserved[1] = 0;
 		fb_info->var.reserved[2] = (uint16_t)msmfb->xres |
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

