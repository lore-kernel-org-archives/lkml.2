Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab0HXPMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:12:20 -0400
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:57197
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751507Ab0HXPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:12:18 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-gfx@lists.freedesktop.org, Ivan Bulatovic <combuster@gmx.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] drm/i915/tv: After disabling the pipe, use wait_for_vblank_off()
Date: Tue, 24 Aug 2010 16:11:52 +0100
Message-Id: <1282662712-20493-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282647815.2221.15.camel@localhost.localdomain>
References: <1282647815.2221.15.camel@localhost.localdomain>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully this is a contributing factor to the spurious TV detection
repoted by Ivan Bulatovic and others.

References:

  Bug 16871 - "TV1 connected" with no tv
  https://bugzilla.kernel.org/show_bug.cgi?id=16871

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-by: Ivan Bulatovic <combuster@gmx.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/intel_tv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index f70bc76..f96289d 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1171,7 +1171,7 @@ intel_tv_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
 		I915_WRITE(pipeconf_reg, pipeconf & ~PIPEACONF_ENABLE);
 		POSTING_READ(pipeconf_reg);
 		/* Wait for vblank for the disable to take effect. */
-		intel_wait_for_vblank(dev, intel_crtc->pipe);
+		intel_wait_for_vblank_off(dev, intel_crtc->pipe);
 
 		/* Filter ctl must be set before TV_WIN_SIZE */
 		I915_WRITE(TV_FILTER_CTL_1, TV_AUTO_SCALE);
-- 
1.7.1

