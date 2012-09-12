Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab2ILPRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:17:35 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62674 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758855Ab2ILPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:17:31 -0400
From: Daniel J Blueman <daniel@quora.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] nouveau: Fix kernel log mangling
Date: Wed, 12 Sep 2012 23:17:08 +0800
Message-Id: <1347463028-3127-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing newline to prevent the following kernel log line getting
appended to the currnet one.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 drivers/gpu/drm/nouveau/nouveau_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index 7e289d2..2a9294f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -61,7 +61,7 @@ auxch_init(struct drm_device *dev, int ch)
 		ctrl = nv_rd32(dev, 0x00e4e4 + (ch * 0x50));
 		udelay(1);
 		if (!timeout--) {
-			AUX_ERR("begin idle timeout 0x%08x", ctrl);
+			AUX_ERR("begin idle timeout 0x%08x\n", ctrl);
 			return -EBUSY;
 		}
 	} while (ctrl & 0x03010000);
-- 
1.7.10.4

