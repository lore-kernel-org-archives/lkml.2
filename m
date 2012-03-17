Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031425Ab2CQR5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 13:57:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48219 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab2CQR5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 13:57:09 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Airlie <airlied@linux.ie>
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/gpu/drm/savage/savage_state.c: add missing kfree
Date: Sat, 17 Mar 2012 18:57:02 +0100
Message-Id: <1332007022-28014-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Most of the error handling code in this function frees the buffers
kcmd_addr, kvb_addr, and kbox_addr allocated at the beginning of this
function.  These two branches are changed to do the same.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/gpu/drm/savage/savage_state.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/savage/savage_state.c b/drivers/gpu/drm/savage/savage_state.c
index 8a3e315..031aaaf 100644
--- a/drivers/gpu/drm/savage/savage_state.c
+++ b/drivers/gpu/drm/savage/savage_state.c
@@ -1057,7 +1057,8 @@ int savage_bci_cmdbuf(struct drm_device *dev, void *data, struct drm_file *file_
 				DRM_ERROR("indexed drawing command extends "
 					  "beyond end of command buffer\n");
 				DMA_FLUSH();
-				return -EINVAL;
+				ret = -EINVAL;
+				goto done;
 			}
 			/* fall through */
 		case SAVAGE_CMD_DMA_PRIM:
@@ -1076,7 +1077,7 @@ int savage_bci_cmdbuf(struct drm_device *dev, void *data, struct drm_file *file_
 				      cmdbuf->vb_stride,
 				      cmdbuf->nbox, cmdbuf->box_addr);
 				if (ret != 0)
-					return ret;
+					goto done;
 				first_draw_cmd = NULL;
 			}
 		}

