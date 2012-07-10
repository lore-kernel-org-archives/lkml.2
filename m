Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2GJK7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:59:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55256 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2GJK60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:58:26 -0400
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [RFC PATCH 4/8] nouveau: add nouveau_bo_vma_add_access
Date: Tue, 10 Jul 2012 12:57:47 +0200
Message-Id: <1341917871-2512-5-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
References: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

This is needed to allow creation of read-only vm mappings
in fence objects.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c  |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_drv.h |    6 ++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 7f80ed5..4318320 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1443,15 +1443,15 @@ nouveau_bo_vma_find(struct nouveau_bo *nvbo, struct nouveau_vm *vm)
 }
 
 int
-nouveau_bo_vma_add(struct nouveau_bo *nvbo, struct nouveau_vm *vm,
-		   struct nouveau_vma *vma)
+nouveau_bo_vma_add_access(struct nouveau_bo *nvbo, struct nouveau_vm *vm,
+			  struct nouveau_vma *vma, u32 access)
 {
 	const u32 size = nvbo->bo.mem.num_pages << PAGE_SHIFT;
 	struct nouveau_mem *node = nvbo->bo.mem.mm_node;
 	int ret;
 
 	ret = nouveau_vm_get(vm, size, nvbo->page_shift,
-			     NV_MEM_ACCESS_RW, vma);
+			     access, vma);
 	if (ret)
 		return ret;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 7c52eba..2c17989 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -1350,8 +1350,10 @@ extern int nouveau_bo_validate(struct nouveau_bo *, bool interruptible,
 
 extern struct nouveau_vma *
 nouveau_bo_vma_find(struct nouveau_bo *, struct nouveau_vm *);
-extern int  nouveau_bo_vma_add(struct nouveau_bo *, struct nouveau_vm *,
-			       struct nouveau_vma *);
+#define nouveau_bo_vma_add(nvbo, vm, vma) \
+	nouveau_bo_vma_add_access((nvbo), (vm), (vma), NV_MEM_ACCESS_RW)
+extern int nouveau_bo_vma_add_access(struct nouveau_bo *, struct nouveau_vm *,
+				     struct nouveau_vma *, u32 access);
 extern void nouveau_bo_vma_del(struct nouveau_bo *, struct nouveau_vma *);
 
 /* nouveau_gem.c */
-- 
1.7.9.5

