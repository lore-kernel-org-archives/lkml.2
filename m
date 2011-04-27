Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab1D0KNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:13:35 -0400
Received: from hall.aurel32.net ([88.191.126.93]:49097 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757638Ab1D0KNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:13:33 -0400
From: Aurelien Jarno <aurelien@aurel32.net>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>
Subject: [PATCH v2 2/2] drm/nouveau: Use pci_dma_mapping_error()
Date: Wed, 27 Apr 2011 12:13:25 +0200
Message-Id: <1303899205-21577-2-git-send-email-aurelien@aurel32.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1303899205-21577-1-git-send-email-aurelien@aurel32.net>
References: <1303899205-21577-1-git-send-email-aurelien@aurel32.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... instead of comparing with DMA_ERROR_CODE, which will only work on
powerpc/sparc/x86.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index 4bce801..6a04ac9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -42,7 +42,8 @@ nouveau_sgdma_populate(struct ttm_backend *be, unsigned long num_pages,
 
 	nvbe->nr_pages = 0;
 	while (num_pages--) {
-		if (dma_addrs[nvbe->nr_pages] != DMA_ERROR_CODE) {
+		if (!pci_dma_mapping_error(dev->pdev,
+					   dma_addrs[nvbe->nr_pages])) {
 			nvbe->pages[nvbe->nr_pages] =
 					dma_addrs[nvbe->nr_pages];
 		 	nvbe->ttm_alloced[nvbe->nr_pages] = true;
-- 
1.7.2.3

