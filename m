Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2KNGEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:04:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55060 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909Ab2KNFuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:24 -0500
Message-Id: <20121114053943.103451925@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:40 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>, Dmitry Torokhov <dtor@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 67/82] drm/vmwgfx: Fix a case where the code would BUG when trying to pin
 GMR memory
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit afcc87aa6a233e52df73552dc1dc9ae3881b7cc8 upstream.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Brian Paul <brianp@vmware.com>
Reviewed-by: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-graphics-maintainer@vmware.com
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
index 3ce68a2..d1498bf 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
@@ -306,7 +306,7 @@ void vmw_bo_pin(struct ttm_buffer_object *bo, bool pin)
 
 	BUG_ON(!atomic_read(&bo->reserved));
 	BUG_ON(old_mem_type != TTM_PL_VRAM &&
-	       old_mem_type != VMW_PL_FLAG_GMR);
+	       old_mem_type != VMW_PL_GMR);
 
 	pl_flags = TTM_PL_FLAG_VRAM | VMW_PL_FLAG_GMR | TTM_PL_FLAG_CACHED;
 	if (pin)


