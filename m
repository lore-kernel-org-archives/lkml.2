Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2CGLvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:51:01 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:38169 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2CGLu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:50:59 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 1/9] drm/i915/intel_i2c: cleanup
Date: Wed,  7 Mar 2012 19:50:42 +0800
Message-Id: <1331121050-17857-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

80 col, spaces around operators and other basic cleanup.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index d30cccc..a94e383 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -236,8 +236,9 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	int i, reg_offset;
 
 	if (bus->force_bit)
-		return intel_i2c_quirk_xfer(dev_priv,
-					    bus->force_bit, msgs, num);
+		return intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs,
+					    num);
+
 
 	reg_offset = HAS_PCH_SPLIT(dev_priv->dev) ? PCH_GMBUS0 - GMBUS0 : 0;
 
@@ -253,11 +254,13 @@ gmbus_xfer(struct i2c_adapter *adapter,
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
 				if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
 					goto clear_err;
@@ -282,10 +285,12 @@ gmbus_xfer(struct i2c_adapter *adapter,
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
 				if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
 					goto clear_err;
@@ -296,11 +301,14 @@ gmbus_xfer(struct i2c_adapter *adapter,
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
-- 
1.7.7.3

