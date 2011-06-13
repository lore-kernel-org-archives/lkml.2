Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1FMOkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:40:49 -0400
Received: from mta21.charter.net ([216.33.127.81]:46597 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1FMOks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:40:48 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=2vPNFbQ4uesA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=apapQfFnAAAA:8 a=Zh0XGXoQGCX4B2KpgjUA:9 a=LYNH9Ox2T_sA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: airlied@linux.ie
Cc: nikai@nikai.net, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH v2] savage: remove unnecessary if statement
Date: Mon, 13 Jun 2011 09:40:38 -0500
Message-Id: <1307976038-20351-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20110606125316.312fad32@absol.kitzblitz>
References: <20110606125316.312fad32@absol.kitzblitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the code always returns ret regardless, so if(ret) check is unnecessary.

v2: fixed up the spelling.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Reviewed-by: Nicolas Kaiser <nikai@nikai.net>

---
 drivers/gpu/drm/savage/savage_bci.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
index bf5f83e..cb1ee4e 100644
--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -647,9 +647,6 @@ int savage_driver_firstopen(struct drm_device *dev)
 	ret = drm_addmap(dev, aperture_base, SAVAGE_APERTURE_SIZE,
 			 _DRM_FRAME_BUFFER, _DRM_WRITE_COMBINING,
 			 &dev_priv->aperture);
-	if (ret)
-		return ret;
-
 	return ret;
 }
 
-- 
1.7.2.5

