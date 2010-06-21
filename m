Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab0FUW1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:27:49 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34389 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab0FUW1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s5sTeQ2VQfs/l7w77/bKWY1P3NLOsJbEzfBZQfgka4ap0lNn9OFQ+4bDNzJYbQXYAT
         duDtZjgR+KbOmwSG+Ks4f2uxlbiDaXMsODX03zxvOD3ThEld0s1fCzMfBlGGEIwB/Z8X
         IUyZ+UbDmFseBt/dct6e7LN5k+IzGfn8PVTJo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/8 v2]drm:drm_gem Fix  warning: variable 'dev' set but not used
Date: Mon, 21 Jun 2010 15:27:29 -0700
Message-Id: <1277159249-22007-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a redu due to the original being completly wrong
(better to leave a warning than shut it off).
I've removed the "dev =" variable but then receive a 
drm_gem.c:207:2: warning: statement with no effect
telling me this thing is not doing anything according to gcc

so the below patch fixes a warning from gcc:
  CC [M]  drivers/gpu/drm/drm_gem.o
drivers/gpu/drm/drm_gem.c: In function 'drm_gem_handle_delete':
drivers/gpu/drm/drm_gem.c:188:21: warning: variable 'dev' set but not used
have a look if you have the time, and if theres something else
to do then let me know(i'll test it out!!) 

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/gpu/drm/drm_gem.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 33dad3f..d1648bf 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -185,7 +185,6 @@ EXPORT_SYMBOL(drm_gem_object_alloc);
 static int
 drm_gem_handle_delete(struct drm_file *filp, u32 handle)
 {
-	struct drm_device *dev;
 	struct drm_gem_object *obj;
 
 	/* This is gross. The idr system doesn't let us try a delete and
@@ -205,7 +204,6 @@ drm_gem_handle_delete(struct drm_file *filp, u32 handle)
 		spin_unlock(&filp->table_lock);
 		return -EINVAL;
 	}
-	dev = obj->dev;
 
 	/* Release reference and decrement refcount. */
 	idr_remove(&filp->object_idr, handle);
-- 
1.7.1.rc1.21.gf3bd6

