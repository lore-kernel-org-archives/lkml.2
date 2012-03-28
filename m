Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab2C1S11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:27:27 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51647 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab2C1S0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:26:46 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 7/7 v6] drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers
Date: Thu, 29 Mar 2012 02:26:39 +0800
Message-Id: <1332959199-32161-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The POSTING_READ() calls were originally added to make sure the writes
were flushed before any timing delays and across loops.
Now that the code has settled a bit, let's remove them.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 60f90cb..73431ed 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -217,7 +217,6 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 		   (len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
 		   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
-	POSTING_READ(GMBUS2 + reg_offset);
 	do {
 		int ret;
 		u32 val, loop = 0;
@@ -261,7 +260,6 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 		   (msg->len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
 		   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
-	POSTING_READ(GMBUS2 + reg_offset);
 	while (len) {
 		int ret;
 		u32 gmbus2;
@@ -272,7 +270,6 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 		} while (--len && ++loop < 4);
 
 		I915_WRITE(GMBUS3 + reg_offset, val);
-		POSTING_READ(GMBUS2 + reg_offset);
 
 		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
 			       (GMBUS_SATOER | GMBUS_HW_RDY),
-- 
1.7.7.3

