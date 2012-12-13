Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab2LMOzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:55:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261Ab2LMOFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:08 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        linux-graphics-maintainer@vmware.com, Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 071/241] drm/vmwgfx: Fix a case where the code would BUG when trying to pin GMR memory
Date: Thu, 13 Dec 2012 11:57:16 -0200
Message-Id: <1355407206-17100-72-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit afcc87aa6a233e52df73552dc1dc9ae3881b7cc8 upstream.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Brian Paul <brianp@vmware.com>
Reviewed-by: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-graphics-maintainer@vmware.com
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
index 3fa884d..27151f7 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
@@ -306,7 +306,7 @@ void vmw_bo_pin(struct ttm_buffer_object *bo, bool pin)
 
 	BUG_ON(!atomic_read(&bo->reserved));
 	BUG_ON(old_mem_type != TTM_PL_VRAM &&
-	       old_mem_type != VMW_PL_FLAG_GMR);
+	       old_mem_type != VMW_PL_GMR);
 
 	pl_flags = TTM_PL_FLAG_VRAM | VMW_PL_FLAG_GMR | TTM_PL_FLAG_CACHED;
 	if (pin)
-- 
1.7.9.5

