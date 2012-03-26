Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab2CZO1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:27:03 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59875 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab2CZO04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:26:56 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 01/11 v3] drm/i915/intel_i2c: cleanup
Date: Mon, 26 Mar 2012 22:26:40 +0800
Message-Id: <1332772010-19619-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

80 col, spaces around operators and other basic cleanup.
Some info message cleanup.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 0713cc2..86b1861 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -230,13 +230,16 @@ gmbus_xfer(struct i2c_adapter *adapter,
 				   (len << GMBUS_BYTE_COUNT_SHIFT) |
 				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
 				   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
-			POSTING_READ(GMBUS2+reg_offset);
+			POSTING_READ(GMBUS2 + reg_offset);
 			do {
 				u32 val, loop = 0;
 
-				if (wait_for(I915_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_RDY), 50))
+				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+					     (GMBUS_SATOER | GMBUS_HW_RDY),
+					     50))
 					goto timeout;
-				if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+				if (I915_READ(GMBUS2 + reg_offset) &
+				    GMBUS_SATOER)
 					goto clear_err;
 
 				val = I915_READ(GMBUS3 + reg_offset);
@@ -260,12 +263,15 @@ gmbus_xfer(struct i2c_adapter *adapter,
 				   (msgs[i].len << GMBUS_BYTE_COUNT_SHIFT) |
 				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
 				   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
-			POSTING_READ(GMBUS2+reg_offset);
+			POSTING_READ(GMBUS2 + reg_offset);
 
 			while (len) {
-				if (wait_for(I915_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_RDY), 50))
+				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+					     (GMBUS_SATOER | GMBUS_HW_RDY),
+					     50))
 					goto timeout;
-				if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+				if (I915_READ(GMBUS2 + reg_offset) &
+				    GMBUS_SATOER)
 					goto clear_err;
 
 				val = loop = 0;
@@ -274,11 +280,14 @@ gmbus_xfer(struct i2c_adapter *adapter,
 				} while (--len && ++loop < 4);
 
 				I915_WRITE(GMBUS3 + reg_offset, val);
-				POSTING_READ(GMBUS2+reg_offset);
+				POSTING_READ(GMBUS2 + reg_offset);
 			}
 		}
 
-		if (i + 1 < num && wait_for(I915_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE), 50))
+		if (i + 1 < num &&
+		    wait_for(I915_READ(GMBUS2 + reg_offset) &
+			     (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
+			     50))
 			goto timeout;
 		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
 			goto clear_err;
@@ -300,14 +309,15 @@ done:
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
 
 	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
-- 
1.7.7.3

