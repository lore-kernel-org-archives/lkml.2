Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab2CIS4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:56:52 -0500
Received: from mail-ww0-f74.google.com ([74.125.82.74]:54924 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab2CIS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:56:50 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 01/10 v2] drm/i915/intel_i2c: cleanup
Date: Sat, 10 Mar 2012 02:48:15 +0800
Message-Id: <1331318904-20577-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
References: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

80 col, spaces around operators and other basic cleanup.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index d30cccc..5e413c4 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -253,11 +253,13 @@ gmbus_xfer(struct i2c_adapter *adapter,
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
@@ -282,10 +284,12 @@ gmbus_xfer(struct i2c_adapter *adapter,
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
@@ -296,11 +300,14 @@ gmbus_xfer(struct i2c_adapter *adapter,
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

