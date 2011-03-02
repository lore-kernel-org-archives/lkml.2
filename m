Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab1CBVSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:18:06 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19964 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab1CBVSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:18:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77438299"
X-IronPort-AV: E=Sophos;i="4.62,253,1297065600"; 
   d="scan'208";a="56219428"
From: Carl Vanderlip <carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Carl Vanderlip <carlv@codeaurora.org>,
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH 3/4] [ARM] msm_fb: Fix framebuffer console
Date: Wed,  2 Mar 2011 13:17:51 -0800
Message-Id: <1299100671-11665-1-git-send-email-carlv@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
References: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Don't allow non panning updates to bypass the wait for the panel to turn on.

Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
---
 drivers/video/msm/msm_fb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
index fe5efe5..ec35130 100644
--- a/drivers/video/msm/msm_fb.c
+++ b/drivers/video/msm/msm_fb.c
@@ -219,8 +219,8 @@ restart:
 
 	sleeping = msmfb->sleeping;
 	/* on a full update, if the last frame has not completed, wait for it */
-	if (pan_display && (msmfb->frame_requested != msmfb->frame_done ||
-			    sleeping == UPDATING)) {
+	if ((pan_display && msmfb->frame_requested != msmfb->frame_done) ||
+			    sleeping == UPDATING) {
 		int ret;
 		spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
 		ret = wait_event_interruptible_timeout(msmfb->frame_wq,
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

