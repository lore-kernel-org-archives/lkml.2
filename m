Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab2DFM6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 08:58:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64966 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2DFM6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 08:58:47 -0400
From: Xi Wang <xi.wang@gmail.com>
To: Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Xi Wang <xi.wang@gmail.com>
Subject: [PATCH 1/2] drm/i915: fix integer overflow in i915_gem_execbuffer2()
Date: Fri,  6 Apr 2012 08:58:18 -0400
Message-Id: <1333717099-32679-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A large args->buffer_count from userspace may overflow the allocation
size, leading to out-of-bounds access.

Use kmalloc_array() to avoid that.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index f51a696..19962bd 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1409,8 +1409,8 @@ i915_gem_execbuffer2(struct drm_device *dev, void *data,
 		return -EINVAL;
 	}
 
-	exec2_list = kmalloc(sizeof(*exec2_list)*args->buffer_count,
-			     GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
+	exec2_list = kmalloc_array(args->buffer_count, sizeof(*exec2_list),
+				   GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
 	if (exec2_list == NULL)
 		exec2_list = drm_malloc_ab(sizeof(*exec2_list),
 					   args->buffer_count);
-- 
1.7.5.4

