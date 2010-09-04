Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0IDIRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 04:17:19 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:56067 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab0IDIRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 04:17:17 -0400
From: Pekka Enberg <penberg@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] Revert "drm/i915: fix vblank wait test condition"
Date: Sat,  4 Sep 2010 11:17:14 +0300
Message-Id: <1283588234-2514-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 9559fcdbff4f93d29af04478bbc48294519424f5. The commit causes
wrong screen resolution on some i915 machines such as MacBook which is a
regression from 2.6.35. The issue has been reported multiple times but no fix
has emerged:

  - i915: 2.6.36-rc2 wrong resolution on gdm start:
    http://lkml.org/lkml/2010/8/23/452

  - i915: wrong framebuffer size in 2.6.36-rc3
    http://kerneltrap.org/mailarchive/linux-kernel/2010/8/30/4613057

I think it's time to revert the commit and try again in 2.6.37.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Reported-by Ivan Bulatovic <combuster@gmx.com>
Reported-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 11a3394..23157e1 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -992,7 +992,7 @@ void intel_wait_for_vblank(struct drm_device *dev, int pipe)
 
 	/* Wait for vblank interrupt bit to set */
 	if (wait_for((I915_READ(pipestat_reg) &
-		      PIPE_VBLANK_INTERRUPT_STATUS),
+		      PIPE_VBLANK_INTERRUPT_STATUS) == 0,
 		     50, 0))
 		DRM_DEBUG_KMS("vblank wait timed out\n");
 }
-- 
1.6.3.3

