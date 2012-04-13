Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2DMLsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:48:00 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:48048 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab2DMLr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:47:59 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 2/2] drm/i915/intel_i2c: reduce verbosity of some messages
Date: Fri, 13 Apr 2012 19:47:54 +0800
Message-Id: <1334317674-32450-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334317674-32450-1-git-send-email-djkurtz@chromium.org>
References: <1334317674-32450-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of these messages can be hit when userspace tries to probe the i2c
with nothing connected or if the driver code tries to do the same. See:
https://bugs.freedesktop.org/show_bug.cgi?id=48248

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index e249160..e04255e 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -383,7 +383,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	 */
 	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
 		     10)) {
-		DRM_INFO("GMBUS [%s] timed out waiting for idle\n",
+		DRM_DEBUG_KMS("GMBUS [%s] timed out waiting for idle\n",
 			 adapter->name);
 		ret = -ETIMEDOUT;
 	}
@@ -399,7 +399,8 @@ clear_err:
 	 */
 	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
 		     10))
-		DRM_INFO("GMBUS [%s] timed out after NAK\n", adapter->name);
+		DRM_DEBUG_KMS("GMBUS [%s] timed out after NAK\n",
+			      adapter->name);
 
 	/* Toggle the Software Clear Interrupt bit. This has the effect
 	 * of resetting the GMBUS controller and so clearing the
@@ -409,7 +410,7 @@ clear_err:
 	I915_WRITE(GMBUS1 + reg_offset, 0);
 	I915_WRITE(GMBUS0 + reg_offset, 0);
 
-	DRM_DEBUG_DRIVER("GMBUS [%s] NAK for addr: %04x %c(%d)\n",
+	DRM_DEBUG_KMS("GMBUS [%s] NAK for addr: %04x %c(%d)\n",
 			 adapter->name, msgs[i].addr,
 			 (msgs[i].flags & I2C_M_RD) ? 'r' : 'w', msgs[i].len);
 
-- 
1.7.7.3

