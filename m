Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2KGQ3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:29:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42420 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab2KGQ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:29:33 -0500
From: Daniel J Blueman <daniel@quora.org>
To: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Daniel J Blueman <daniel@quora.org>
Subject: [PATCH, RESEND] nouveau: Prevent kernel log mangling
Date: Thu,  8 Nov 2012 00:29:20 +0800
Message-Id: <1352305760-3584-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.7-rc4, add missing newline to to prevent the following kernel log
line getting appended to the current one after switching the integrated
GPU and suspending the discrete GPU.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c b/drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c
index fe1ebf1..dc27e79 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c
@@ -50,7 +50,7 @@ auxch_init(struct nouveau_i2c *aux, int ch)
 		ctrl = nv_rd32(aux, 0x00e4e4 + (ch * 0x50));
 		udelay(1);
 		if (!timeout--) {
-			AUX_ERR("begin idle timeout 0x%08x", ctrl);
+			AUX_ERR("begin idle timeout 0x%08x\n", ctrl);
 			return -EBUSY;
 		}
 	} while (ctrl & 0x03010000);
-- 
1.7.10.4

