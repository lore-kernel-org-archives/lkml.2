Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2FYLuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:50:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46108 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab2FYLum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:50:42 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Adam Jackson <ajax@redhat.com>
Cc: Eric Anholt <eric@anholt.net>, Jonathan Nieder <jrnieder@gmail.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/i915: Attempt to fix watermark setup on 85x (v2)" has been added to staging queue
Date: Mon, 25 Jun 2012 13:50:38 +0200
Message-Id: <1340625038-11257-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/i915: Attempt to fix watermark setup on 85x (v2)

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next
  or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 8f4695ed1c9e068772bcce4cd4ff03f88d57a008 Mon Sep 17 00:00:00 2001
From: Adam Jackson <ajax@redhat.com>
Date: Fri, 16 Apr 2010 18:20:57 -0400
Subject: [PATCH] drm/i915: Attempt to fix watermark setup on 85x (v2)

IS_MOBILE() catches 85x, so we'd always try to use the 9xx FIFO sizing;
since there's an explicit 85x version, this seems wrong.

v2: Handle 830m correctly too.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Eric Anholt <eric@anholt.net>

BugLink: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=661696
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
(cherry-picked from commit 8f4695ed1c9e068772bcce4cd4ff03f88d57a008 upstream)
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e7356fb..c7502b6 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4853,17 +4853,18 @@ static void intel_init_display(struct drm_device *dev)
 		dev_priv->display.update_wm = g4x_update_wm;
 	else if (IS_I965G(dev))
 		dev_priv->display.update_wm = i965_update_wm;
-	else if (IS_I9XX(dev) || IS_MOBILE(dev)) {
+	else if (IS_I9XX(dev)) {
 		dev_priv->display.update_wm = i9xx_update_wm;
 		dev_priv->display.get_fifo_size = i9xx_get_fifo_size;
+	} else if (IS_I85X(dev)) {
+		dev_priv->display.update_wm = i9xx_update_wm;
+		dev_priv->display.get_fifo_size = i85x_get_fifo_size;
 	} else {
-		if (IS_I85X(dev))
-			dev_priv->display.get_fifo_size = i85x_get_fifo_size;
-		else if (IS_845G(dev))
+		dev_priv->display.update_wm = i830_update_wm;
+		if (IS_845G(dev))
 			dev_priv->display.get_fifo_size = i845_get_fifo_size;
 		else
 			dev_priv->display.get_fifo_size = i830_get_fifo_size;
-		dev_priv->display.update_wm = i830_update_wm;
 	}
 }

--
1.7.9.5

