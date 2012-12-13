Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154Ab2LMOMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:12:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44885 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123Ab2LMOMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:06 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 182/241] drm/i915: Use cpu relocations if the object is in the GTT but not mappable
Date: Thu, 13 Dec 2012 11:59:07 -0200
Message-Id: <1355407206-17100-183-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 504c7267a1e84b157cbd7e9c1b805e1bc0c2c846 upstream.

This prevents the case of unbinding the object in order to process the
relocations through the GTT and then rebinding it only to then proceed
to use cpu relocations as the object is now in the CPU write domain. By
choosing to use cpu relocations up front, we can therefore avoid the
rebind penalty.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 974a9f1..3debf95 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -269,6 +269,7 @@ eb_destroy(struct eb_objects *eb)
 static inline int use_cpu_reloc(struct drm_i915_gem_object *obj)
 {
 	return (obj->base.write_domain == I915_GEM_DOMAIN_CPU ||
+		!obj->map_and_fenceable ||
 		obj->cache_level != I915_CACHE_NONE);
 }
 
-- 
1.7.9.5

