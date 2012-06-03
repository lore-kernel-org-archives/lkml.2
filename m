Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2FCKtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 06:49:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62895 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2FCKtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 06:49:12 -0400
From: Il Han <corone.il.han@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Il Han <corone.il.han@gmail.com>
Subject: [PATCH] drm: An uninitialized return value is returned.
Date: Sun,  3 Jun 2012 19:41:17 +0900
Message-Id: <1338720077-14936-1-git-send-email-corone.il.han@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An uninitialized return value is returned.
If the value is not necessary,
it would be better to return the constant 0.

Signed-off-by: Il Han <corone.il.han@gmail.com>
---
 drivers/gpu/drm/nouveau/nv04_fence.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv04_fence.c b/drivers/gpu/drm/nouveau/nv04_fence.c
index abe89db..d4091eb 100644
--- a/drivers/gpu/drm/nouveau/nv04_fence.c
+++ b/drivers/gpu/drm/nouveau/nv04_fence.c
@@ -121,7 +121,6 @@ nv04_fence_create(struct drm_device *dev)
 {
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nv04_fence_priv *priv;
-	int ret;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -136,5 +135,5 @@ nv04_fence_create(struct drm_device *dev)
 	priv->base.sync = nv04_fence_sync;
 	priv->base.read = nv04_fence_read;
 	dev_priv->eng[NVOBJ_ENGINE_FENCE] = &priv->base.engine;
-	return ret;
+	return 0;
 }
-- 
1.7.4.1

