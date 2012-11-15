Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767591Ab2KOEP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:15:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:50104 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993411Ab2KOENO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:13:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>, Dmitry Torokhov <dtor@vmware.com>,
        Dave Airlie <airlied@redhat.com>, linux-graphics-maintainer@vmware.com
Subject: [ 51/57] drm/vmwgfx: Fix a case where the code would BUG when trying to pin GMR memory
Date: Wed, 14 Nov 2012 20:11:59 -0800
Message-Id: <20121115040936.265759937@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit afcc87aa6a233e52df73552dc1dc9ae3881b7cc8 upstream.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Brian Paul <brianp@vmware.com>
Reviewed-by: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-graphics-maintainer@vmware.com
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c
@@ -306,7 +306,7 @@ void vmw_bo_pin(struct ttm_buffer_object
 
 	BUG_ON(!atomic_read(&bo->reserved));
 	BUG_ON(old_mem_type != TTM_PL_VRAM &&
-	       old_mem_type != VMW_PL_FLAG_GMR);
+	       old_mem_type != VMW_PL_GMR);
 
 	pl_flags = TTM_PL_FLAG_VRAM | VMW_PL_FLAG_GMR | TTM_PL_FLAG_CACHED;
 	if (pin)


