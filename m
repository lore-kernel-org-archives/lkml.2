Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2FMSrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:47:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58729 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2FMSrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:47:03 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] drm/i915: ignore pipe select bit when checking for LVDS register initialization
Date: Wed, 13 Jun 2012 13:46:58 -0500
Message-Id: <1339613218-4699-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120613162544.GJ4829@phenom.ffwll.local>
References: <20120613162544.GJ4829@phenom.ffwll.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Lenovo Thinkpad T410 has the LVDS_PIPEB_SELECT bit set in the LVDS
register when booted with the lid closed, even though the LVDS hasn't
really been initialized. Ignore this bit so that the VBT value will be
used instead.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e0aa064..ae17526 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -434,7 +434,7 @@ static bool is_dual_link_lvds(struct drm_i915_private *dev_priv,
 		 * register is uninitialized.
 		 */
 		val = I915_READ(reg);
-		if (!(val & ~LVDS_DETECTED))
+		if (!(val & ~(LVDS_PIPE_MASK | LVDS_DETECTED)))
 			val = dev_priv->bios_lvds_val;
 		dev_priv->lvds_val = val;
 	}
-- 
1.7.9.5

