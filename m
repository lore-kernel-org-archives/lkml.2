Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0ILTEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:04:21 -0400
Received: from server109-228-6-235.live-servers.net ([109.228.6.235]:58121
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752947Ab0ILTEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:04:20 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915/crt: Downgrade warnings for hotplug failures
Date: Sun, 12 Sep 2010 20:07:04 +0100
Message-Id: <1284318424-5512-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <87mxrswddf.fsf@basil.nowhere.org>
References: <87mxrswddf.fsf@basil.nowhere.org>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are not fatal errors, so do not alarm the user by filling the
logs with *** ERROR ***. Especially as we know that g4x CRT detection
is a little sticky.

On the one hand the errors are valid since they are warning us of a
stall -- we poll the register whilst holding the mode lock so not even
the mouse will update. On the other hand, those stalls were already present
yet nobody complained.

Reported-by: Andi Kleen <andi@firstfloor.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=18332
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_crt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index a02a8df..197d4f3 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -188,7 +188,7 @@ static bool intel_ironlake_crt_detect_hotplug(struct drm_connector *connector)
 
 	if (wait_for((I915_READ(PCH_ADPA) & ADPA_CRT_HOTPLUG_FORCE_TRIGGER) == 0,
 		     1000, 1))
-		DRM_ERROR("timed out waiting for FORCE_TRIGGER");
+		DRM_DEBUG_KMS("timed out waiting for FORCE_TRIGGER");
 
 	if (turn_off_dac) {
 		I915_WRITE(PCH_ADPA, temp);
@@ -245,7 +245,7 @@ static bool intel_crt_detect_hotplug(struct drm_connector *connector)
 		if (wait_for((I915_READ(PORT_HOTPLUG_EN) &
 			      CRT_HOTPLUG_FORCE_DETECT) == 0,
 			     1000, 1))
-			DRM_ERROR("timed out waiting for FORCE_DETECT to go off");
+			DRM_DEBUG_KMS("timed out waiting for FORCE_DETECT to go off");
 	}
 
 	stat = I915_READ(PORT_HOTPLUG_STAT);
-- 
1.7.1

