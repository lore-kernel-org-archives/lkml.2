Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1KFTQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:16:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59204 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1KFTPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:35 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 09/13] drm/i915: don't use gtt_pwrite on LLC cached objects
Date: Sun,  6 Nov 2011 20:13:56 +0100
Message-Id: <1320606840-21132-10-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

~120 µs instead fo ~210 µs to write 1mb on my snb. I like this.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 0048917..8fd175c 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -842,6 +842,7 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 		ret = i915_gem_phys_pwrite(dev, obj, args, file);
 		goto out;
 	} else if (obj->gtt_space &&
+		   obj->cache_level == I915_CACHE_NONE &&
 		   obj->base.write_domain != I915_GEM_DOMAIN_CPU) {
 		ret = i915_gem_object_pin(obj, 0, true);
 		if (ret)
-- 
1.7.6.4

