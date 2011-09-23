Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1IWRS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:18:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53771 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab1IWRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:18:22 -0400
From: Matt Turner <mattst88@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH] drm/radeon: use DDC_ADDR instead of hard-coding it
Date: Fri, 23 Sep 2011 13:18:16 -0400
Message-Id: <1316798296-21668-2-git-send-email-mattst88@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316798296-21668-1-git-send-email-mattst88@gmail.com>
References: <1316798296-21668-1-git-send-email-mattst88@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Turner <mattst88@gmail.com>
---
 drivers/gpu/drm/radeon/radeon_i2c.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
index 6c111c1..37a6d38 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -24,6 +24,7 @@
  *          Alex Deucher
  */
 #include "drmP.h"
+#include "drm_edid.h"
 #include "radeon_drm.h"
 #include "radeon.h"
 #include "atom.h"
@@ -39,13 +40,13 @@ bool radeon_ddc_probe(struct radeon_connector *radeon_connector, bool requires_e
 	int ret;
 	struct i2c_msg msgs[] = {
 		{
-			.addr = 0x50,
+			.addr = DDC_ADDR,
 			.flags = 0,
 			.len = 1,
 			.buf = &out,
 		},
 		{
-			.addr = 0x50,
+			.addr = DDC_ADDR,
 			.flags = I2C_M_RD,
 			.len = 1,
 			.buf = buf,
-- 
1.7.3.4

