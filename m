Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab1L0BIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 20:08:15 -0500
Received: from home.keithp.com ([63.227.221.253]:36384 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab1L0BHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 20:07:35 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 2/2] drm/i915: Disable RC6 on Sandybridge by default
Date: Mon, 26 Dec 2011 17:02:11 -0800
Message-Id: <1324947731-22980-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324947731-22980-1-git-send-email-keithp@keithp.com>
References: <1324947731-22980-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RC6 fails again.

> I found my system freeze mostly during starting up X and KDE. Sometimes it
> works for some minutes, sometimes it freezes immediatly. When the freeze
> happens, everything is dead (even the reset button does not work, I need to
> power cycle).

> I disabled RC6, and my system runs wonderfully.

> The system is a Z68 Pro board with Sandybridge i5-2500K processor, 8
> GB of RAM and UEFI firmware.

Reported-by: Kai Krakow <hurikhan77@gmail.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_display.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 8a61b81..4b7a0f2 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7922,13 +7922,11 @@ static bool intel_enable_rc6(struct drm_device *dev)
 		return 0;
 
 	/*
-	 * Enable rc6 on Sandybridge if DMA remapping is disabled
+	 * Disable rc6 on Sandybridge
 	 */
 	if (INTEL_INFO(dev)->gen == 6) {
-		DRM_DEBUG_DRIVER("Sandybridge: intel_iommu_enabled %s -- RC6 %sabled\n",
-				 intel_iommu_enabled ? "true" : "false",
-				 !intel_iommu_enabled ? "en" : "dis");
-		return !intel_iommu_enabled;
+		DRM_DEBUG_DRIVER("Sandybridge: RC6 disabled\n");
+		return 0;
 	}
 	DRM_DEBUG_DRIVER("RC6 enabled\n");
 	return 1;
-- 
1.7.7.3

