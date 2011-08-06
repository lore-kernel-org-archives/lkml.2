Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab1HFSyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 14:54:53 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33083 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab1HFSyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 14:54:52 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, alan@linux.intel.com,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] gma500: fix build error in drivers/staging/gma500/gem_glue.c
Date: Sun,  7 Aug 2011 02:52:07 +0800
Message-Id: <1312656727-4603-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  LD      drivers/built-in.o
  drivers/staging/built-in.o: In function 'drm_gem_private_object_init':
  /home/stufever/linux-2.6/drivers/staging/gma500/gem_glue.c:30: multiple definition of 'drm_gem_private_object_init'
  drivers/gpu/built-in.o:/home/stufever/linux-2.6/drivers/gpu/drm/drm_gem.c:160: first defined here
  make[1]: *** [drivers/built-in.o] Error 1
  make: *** [drivers] Error 2

The function drm_gem_private_object_init had been EXPORT_SYMBOL at drivers/gpu/drm/drm_gem.c, so delete repeated code.

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 drivers/staging/gma500/gem_glue.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/gma500/gem_glue.c b/drivers/staging/gma500/gem_glue.c
index 779ac1a..6770166 100644
--- a/drivers/staging/gma500/gem_glue.c
+++ b/drivers/staging/gma500/gem_glue.c
@@ -20,26 +20,6 @@
 #include <drm/drmP.h>
 #include <drm/drm.h>
 
-/**
- * Initialize an already allocated GEM object of the specified size with
- * no GEM provided backing store. Instead the caller is responsible for
- * backing the object and handling it.
- */
-int drm_gem_private_object_init(struct drm_device *dev,
-			struct drm_gem_object *obj, size_t size)
-{
-	BUG_ON((size & (PAGE_SIZE - 1)) != 0);
-
-	obj->dev = dev;
-	obj->filp = NULL;
-
-	kref_init(&obj->refcount);
-	atomic_set(&obj->handle_count, 0);
-	obj->size = size;
-
-	return 0;
-}
-
 void drm_gem_object_release_wrap(struct drm_gem_object *obj)
 {
 	/* Remove the list map if one is present */
-- 
1.7.0.4

