Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab2E1Dnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:43:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52100 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928Ab2E1D3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:34 -0400
Message-Id: <20120528031216.379775219@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 098/117] nouveau: nouveau_set_bo_placement takes TTM flags
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit c284815debba2f14ee2fd07b1b4cc972ab116110 upstream.

This seems to be wrong to me, spotted while thinking about dma-buf.

Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 7d15a77..12ce044 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1030,7 +1030,7 @@ nouveau_ttm_fault_reserve_notify(struct ttm_buffer_object *bo)
 
 	nvbo->placement.fpfn = 0;
 	nvbo->placement.lpfn = dev_priv->fb_mappable_pages;
-	nouveau_bo_placement_set(nvbo, TTM_PL_VRAM, 0);
+	nouveau_bo_placement_set(nvbo, TTM_PL_FLAG_VRAM, 0);
 	return nouveau_bo_validate(nvbo, false, true, false);
 }
 


