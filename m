Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2JZAIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:08:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:53814 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2JZAIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 62/85] drm/i915: Use cpu relocations if the object is in the GTT but not mappable
Date: Thu, 25 Oct 2012 17:06:20 -0700
Message-Id: <20121026000037.352119166@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -269,6 +269,7 @@ eb_destroy(struct eb_objects *eb)
 static inline int use_cpu_reloc(struct drm_i915_gem_object *obj)
 {
 	return (obj->base.write_domain == I915_GEM_DOMAIN_CPU ||
+		!obj->map_and_fenceable ||
 		obj->cache_level != I915_CACHE_NONE);
 }
 


