Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab2DIUuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:50:00 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20764 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2DIUt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:49:58 -0400
Date: Mon, 9 Apr 2012 22:49:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, dri-devel@lists.freedesktop.org,
        Jon Mason <jdmason@kudzu.us>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>
Subject: [PATCH 02/26] radeon_cp: Remove unneeded tests for NULL before
 calling release_firmware()
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204092204380.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_firmware() does its own tests for NULL pointers so there's no
need to explicitly test before calling it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/radeon/radeon_cp.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
index 0ebb7d4..ef67e18 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -1827,14 +1827,10 @@ void radeon_do_release(struct drm_device * dev)
 			r600_do_cleanup_cp(dev);
 		else
 			radeon_do_cleanup_cp(dev);
-		if (dev_priv->me_fw) {
-			release_firmware(dev_priv->me_fw);
-			dev_priv->me_fw = NULL;
-		}
-		if (dev_priv->pfp_fw) {
-			release_firmware(dev_priv->pfp_fw);
-			dev_priv->pfp_fw = NULL;
-		}
+		release_firmware(dev_priv->me_fw);
+		dev_priv->me_fw = NULL;
+		release_firmware(dev_priv->pfp_fw);
+		dev_priv->pfp_fw = NULL;
 	}
 }
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

