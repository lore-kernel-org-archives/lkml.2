Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2C1MwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:52:14 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64178 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2C1MwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:52:05 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 02/14 v5] drm/i915/intel_i2c: cleanup error messages and comments
Date: Wed, 28 Mar 2012 20:51:45 +0800
Message-Id: <1332939117-6513-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_i2c.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 30675ce..e6c090b 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -333,17 +333,20 @@ done:
 	 * till then let it sleep.
 	 */
 	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0, 10))
-		DRM_INFO("GMBUS timed out waiting for idle\n");
+		DRM_INFO("GMBUS [%s] timed out waiting for idle\n",
+			 bus->adapter.name);
 	I915_WRITE(GMBUS0 + reg_offset, 0);
 	ret = i;
 	goto out;
 
 timeout:
-	DRM_INFO("GMBUS timed out, falling back to bit banging on pin %d [%s]\n",
-		 bus->reg0 & 0xff, bus->adapter.name);
+	DRM_INFO("GMBUS [%s] timed out, falling back to bit banging on pin %d\n",
+		 bus->adapter.name, bus->reg0 & 0xff);
 	I915_WRITE(GMBUS0 + reg_offset, 0);
 
-	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
+	/* Hardware may not support GMBUS over these pins?
+	 * Try GPIO bitbanging instead.
+	 */
 	if (!bus->has_gpio) {
 		ret = -EIO;
 	} else {
-- 
1.7.7.3

