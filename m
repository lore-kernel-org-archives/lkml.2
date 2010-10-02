Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab0JBNzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 09:55:48 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:52935 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab0JBNy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 09:54:58 -0400
From: Julia Lawall <julia@diku.dk>
To: David Airlie <airlied@linux.ie>
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] drivers/gpu/drm/i915/i915_gem.c: Add missing error handling code
Date: Sat,  2 Oct 2010 15:59:17 +0200
Message-Id: <1286027958-7333-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the error handling code with operations found in other nearby error
handling code

A simplified version of the sematic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
@r@
statement S1,S2,S3;
constant C1,C2,C3;
@@

*if (...)
 {... S1 return -C1;}
...
*if (...)
 {... when != S1
    return -C2;}
...
*if (...)
 {... S1 return -C3;}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This is only a suggestion.  All of the other ways out of this function call
these two functions.  But I don't understand the code well enough to know
why, or whether there is a reason not to do it in this case.

 drivers/gpu/drm/i915/i915_gem.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index bced9b2..cfe5978 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3258,6 +3258,8 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 				  (int) reloc->offset,
 				  reloc->read_domains,
 				  reloc->write_domain);
+			drm_gem_object_unreference(target_obj);
+			i915_gem_object_unpin(obj);
 			return -EINVAL;
 		}
 		if (reloc->write_domain & I915_GEM_DOMAIN_CPU ||

