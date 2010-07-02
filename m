Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab0GBAFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab0GBAFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:05:46 -0400
From: Dave Airlie <airlied@gmail.com>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@redhat.com>
Subject: [PATCH] drm/i915: fix hibernation since 4bdadb9785696439c6e2b3efe34aa76df1149c83
Date: Fri,  2 Jul 2010 10:04:42 +1000
Message-Id: <1278029082-24223-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

Since 4bdadb9785696439c6e2b3efe34aa76df1149c83, we've been passing
GFP_MOVABLE where we weren't before caused hibernate on Intel hardware
to results in a lot of memory corruptions on resume.

[airlied: linus please enhance commit msg if you commit this]

http://bugzilla.kernel.org/show_bug.cgi?id=13811

Reported-by: Evengi Golov (in bugzilla)
Signed-off-by: Dave Airlie <airlied@redhat.com>
Tested-by: M. Vefa Bicakci <bicave@superonline.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 9ded3da..0743858 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2239,7 +2239,7 @@ i915_gem_object_get_pages(struct drm_gem_object *obj,
 	mapping = inode->i_mapping;
 	for (i = 0; i < page_count; i++) {
 		page = read_cache_page_gfp(mapping, i,
-					   mapping_gfp_mask (mapping) |
+					   GFP_HIGHUSER |
 					   __GFP_COLD |
 					   gfpmask);
 		if (IS_ERR(page))
-- 
1.7.0.1

