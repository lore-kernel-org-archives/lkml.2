Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435Ab2CNXv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:51:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10046 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760795Ab2CNXvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:51:55 -0400
Date: Thu, 15 Mar 2012 00:50:49 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.freedesktop.org, Francisco Jerez <currojerez@riseup.net>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>
Subject: [PATCH] nouveau: kfree() gracefully handles NULL pointers, testing
 is redundant
Message-ID: <alpine.LNX.2.00.1203150048360.22671@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant NULL checks before kfree() in
drivers/gpu/drm/nouveau/nvc0_graph.c

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/nouveau/nvc0_graph.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvc0_graph.c b/drivers/gpu/drm/nouveau/nvc0_graph.c
index 8ee3963..e9eca29 100644
--- a/drivers/gpu/drm/nouveau/nvc0_graph.c
+++ b/drivers/gpu/drm/nouveau/nvc0_graph.c
@@ -755,10 +755,8 @@ nvc0_graph_create_fw(struct drm_device *dev, const char *fwname,
 static void
 nvc0_graph_destroy_fw(struct nvc0_graph_fuc *fuc)
 {
-	if (fuc->data) {
-		kfree(fuc->data);
-		fuc->data = NULL;
-	}
+	kfree(fuc->data);
+	fuc->data = NULL;
 }
 
 static void
@@ -778,8 +776,7 @@ nvc0_graph_destroy(struct drm_device *dev, int engine)
 	nouveau_gpuobj_ref(NULL, &priv->unk4188b8);
 	nouveau_gpuobj_ref(NULL, &priv->unk4188b4);
 
-	if (priv->grctx_vals)
-		kfree(priv->grctx_vals);
+	kfree(priv->grctx_vals);
 
 	NVOBJ_ENGINE_DEL(dev, GR);
 	kfree(priv);
-- 
1.7.9.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

