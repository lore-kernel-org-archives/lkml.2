Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab2E0BYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:24:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab2E0BTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:19:42 -0400
Message-Id: <20120527002522.834588388@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:19 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 73/91] nouveau: nouveau_set_bo_placement takes TTM flags
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit c284815debba2f14ee2fd07b1b4cc972ab116110 upstream.

This seems to be wrong to me, spotted while thinking about dma-buf.

Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1030,7 +1030,7 @@ nouveau_ttm_fault_reserve_notify(struct
 
 	nvbo->placement.fpfn = 0;
 	nvbo->placement.lpfn = dev_priv->fb_mappable_pages;
-	nouveau_bo_placement_set(nvbo, TTM_PL_VRAM, 0);
+	nouveau_bo_placement_set(nvbo, TTM_PL_FLAG_VRAM, 0);
 	return nouveau_bo_validate(nvbo, false, true, false);
 }
 


