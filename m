Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1IWRSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:18:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34948 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab1IWRSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:18:44 -0400
From: Matt Turner <mattst88@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, Matt Turner <mattst88@gmail.com>
Subject: [PATCH] drm/i915: use DDC_ADDR instead of hard-coding it
Date: Fri, 23 Sep 2011 13:18:40 -0400
Message-Id: <1316798320-21704-1-git-send-email-mattst88@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Turner <mattst88@gmail.com>
---
 drivers/gpu/drm/i915/intel_modes.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_modes.c b/drivers/gpu/drm/i915/intel_modes.c
index 3b26a3b..ab534be 100644
--- a/drivers/gpu/drm/i915/intel_modes.c
+++ b/drivers/gpu/drm/i915/intel_modes.c
@@ -27,6 +27,7 @@
 #include <linux/i2c.h>
 #include <linux/fb.h>
 #include "drmP.h"
+#include "drm_edid.h"
 #include "intel_drv.h"
 #include "i915_drv.h"
 
@@ -41,13 +42,13 @@ bool intel_ddc_probe(struct intel_encoder *intel_encoder, int ddc_bus)
 	u8 buf[2];
 	struct i2c_msg msgs[] = {
 		{
-			.addr = 0x50,
+			.addr = DDC_ADDR,
 			.flags = 0,
 			.len = 1,
 			.buf = out_buf,
 		},
 		{
-			.addr = 0x50,
+			.addr = DDC_ADDR,
 			.flags = I2C_M_RD,
 			.len = 1,
 			.buf = buf,
-- 
1.7.3.4

