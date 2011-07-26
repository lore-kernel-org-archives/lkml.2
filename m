Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1GZQXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:23:43 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60640 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1GZQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:23:39 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] gma500: Fix clashes with DRM updates
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Jul 2011 17:15:50 +0100
Message-ID: <20110726161536.4910.21396.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The private object support has migrated from gma500 into the DRM core,
remove our now clashing copy so -next can build.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/gem_glue.c |   23 +----------------------
 drivers/staging/gma500/gem_glue.h |    2 --
 2 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/gma500/gem_glue.c b/drivers/staging/gma500/gem_glue.c
index 779ac1a..daac121 100644
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
@@ -51,8 +31,7 @@ void drm_gem_object_release_wrap(struct drm_gem_object *obj)
 		kfree(list->map);
 		list->map = NULL;
 	}
-	if (obj->filp)
-		drm_gem_object_release(obj);
+	drm_gem_object_release(obj);
 }
 
 /**
diff --git a/drivers/staging/gma500/gem_glue.h b/drivers/staging/gma500/gem_glue.h
index a0f2bc4..ce5ce30 100644
--- a/drivers/staging/gma500/gem_glue.h
+++ b/drivers/staging/gma500/gem_glue.h
@@ -1,4 +1,2 @@
 extern void drm_gem_object_release_wrap(struct drm_gem_object *obj);
-extern int drm_gem_private_object_init(struct drm_device *dev,
-			struct drm_gem_object *obj, size_t size);
 extern int gem_create_mmap_offset(struct drm_gem_object *obj);

