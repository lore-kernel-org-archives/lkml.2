Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1K2PMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 10:12:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53670 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1K2PMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 10:12:00 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org
Subject: [PATCH 2/2] drm/i915: properly clflush pwrites to phys objects
Date: Tue, 29 Nov 2011 16:09:29 +0100
Message-Id: <1322579369-26954-2-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322579369-26954-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1322579369-26954-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually results in (rare) cursor corruptions on platforms
requiring physically addressed cursors.

Note to the stable team: This requires the drm core patch
"drm: add helper to clflush a virtual address range" which
creates the helper used here.

Tested-and-reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Cc: stable@kernel.org
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=35460
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=21442
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 39459d2..e395a7d 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4123,6 +4123,7 @@ i915_gem_phys_pwrite(struct drm_device *dev,
 			return -EFAULT;
 	}
 
+	drm_clflush_virt_range(vaddr, args->size);
 	intel_gtt_chipset_flush();
 	return 0;
 }
-- 
1.7.7.3

