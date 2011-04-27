Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab1D0KNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:13:33 -0400
Received: from hall.aurel32.net ([88.191.126.93]:49094 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724Ab1D0KNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:13:32 -0400
From: Aurelien Jarno <aurelien@aurel32.net>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>
Subject: [PATCH v2 1/2] drm/radeon: Use pci_dma_mapping_error()
Date: Wed, 27 Apr 2011 12:13:24 +0200
Message-Id: <1303899205-21577-1-git-send-email-aurelien@aurel32.net>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... instead of comparing with DMA_ERROR_CODE, which will only work on
powerpc/sparc/x86.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 drivers/gpu/drm/radeon/radeon_gart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index 8a955bb..4de3fb9 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -183,7 +183,7 @@ int radeon_gart_bind(struct radeon_device *rdev, unsigned offset,
 	for (i = 0; i < pages; i++, p++) {
 		/* On TTM path, we only use the DMA API if TTM_PAGE_FLAG_DMA32
 		 * is requested. */
-		if (dma_addr[i] != DMA_ERROR_CODE) {
+		if (!pci_dma_mapping_error(rdev->pdev, dma_addr[i])) {
 			rdev->gart.ttm_alloced[p] = true;
 			rdev->gart.pages_addr[p] = dma_addr[i];
 		} else {
-- 
1.7.2.3

