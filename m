Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2FZWzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 18:55:40 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11638 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2FZWzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 18:55:39 -0400
Date: Wed, 27 Jun 2012 00:55:37 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] drm/i915/sprite: Fix mem leak in intel_plane_init()
Message-ID: <alpine.LNX.2.00.1206270053570.3759@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we ever hit the default case in the switch statement we'll return
from the function without freeing the memory we just allocated to
'intel_plane' (but that has not been used).

This patch gets rid of the leak by freeing the memory just before we
return.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/i915/intel_sprite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index 2a20fb0..c8851ba 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -685,6 +685,7 @@ intel_plane_init(struct drm_device *dev, enum pipe pipe)
 		break;
 
 	default:
+		kfree(intel_plane);
 		return -ENODEV;
 	}
 
@@ -699,4 +700,3 @@ intel_plane_init(struct drm_device *dev, enum pipe pipe)
 
 	return ret;
 }
-
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

