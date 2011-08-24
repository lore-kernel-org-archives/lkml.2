Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1HXHIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 03:08:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1HXHI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 03:08:29 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/i915: Remove BUG_ON from i915_gem_evict_something" has been added to staging queue
Date: Wed, 24 Aug 2011 09:08:26 +0200
Message-Id: <1314169706-3691-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/i915: Remove BUG_ON from i915_gem_evict_something

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From d8b1184438cd9766ad970a2332aaf4c8f539b40e Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Tue, 23 Aug 2011 13:38:34 -0500
Subject: [PATCH] drm/i915: Remove BUG_ON from i915_gem_evict_something

BugLink: https://bugs.launcpad.net/bugs/828550

According to Chris Wilson this BUG_ON was just paranoia and never
something the kernel should explode on. He later removed it in
upstream commit e39a01501b228e1be2037d5bddccae2a820af902. So let's
just remove it.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_evict.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index 9c1ec78..c4c6b6f 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -175,13 +175,6 @@ found:
 		list_del_init(&obj_priv->evict_list);
 	}

-	/* The just created free hole should be on the top of the free stack
-	 * maintained by drm_mm, so this BUG_ON actually executes in O(1).
-	 * Furthermore all accessed data has just recently been used, so it
-	 * should be really fast, too. */
-	BUG_ON(!drm_mm_search_free(&dev_priv->mm.gtt_space, min_size,
-				   alignment, 0));
-
 	return 0;
 }

--
1.7.4.1

