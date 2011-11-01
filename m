Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1KAGZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:25:23 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:33550 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1KAGZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:25:22 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Nov 2011 02:25:22 EDT
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>, stable@kernel.org
Subject: [PATCH] drm/i915: Fix object refcount leak on mmappable size limit error path.
Date: Mon, 31 Oct 2011 23:16:21 -0700
Message-Id: <1320128181-3161-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing memory leaks on my system in the form of large
(300-400MB) GEM objects created by now-dead processes laying around
clogging up memory.  I usually notice when it gets to about 1.2GB of
them.  Hopefully this clears up the issue, but I just found this bug
by inspection.

Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: stable@kernel.org
---
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 6c69cfa..ee78c8e 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1477,7 +1477,7 @@ i915_gem_mmap_gtt(struct drm_file *file,
 
 	if (obj->base.size > dev_priv->mm.gtt_mappable_end) {
 		ret = -E2BIG;
-		goto unlock;
+		goto out;
 	}
 
 	if (obj->madv != I915_MADV_WILLNEED) {
-- 
1.7.7

