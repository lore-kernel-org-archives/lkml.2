Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0KEDRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:17:46 -0400
Received: from mail.perches.com ([173.55.12.10]:4057 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab0KEDIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:41 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/49] drivers/gpu: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:34 -0700
Message-Id: <82d9fb31aa5f4e28acfda333331a30ef382d27b9.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/via/via_dmablit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
index 9b5b4d9..3e038a3 100644
--- a/drivers/gpu/drm/via/via_dmablit.c
+++ b/drivers/gpu/drm/via/via_dmablit.c
@@ -235,9 +235,9 @@ via_lock_all_dma_pages(drm_via_sg_info_t *vsg,  drm_via_dmablit_t *xfer)
 	vsg->num_pages = VIA_PFN(xfer->mem_addr + (xfer->num_lines * xfer->mem_stride - 1)) -
 		first_pfn + 1;
 
-	if (NULL == (vsg->pages = vmalloc(sizeof(struct page *) * vsg->num_pages)))
+	vsg->pages = vzalloc(sizeof(struct page *) * vsg->num_pages);
+	if (NULL == vsg->pages)
 		return -ENOMEM;
-	memset(vsg->pages, 0, sizeof(struct page *) * vsg->num_pages);
 	down_read(&current->mm->mmap_sem);
 	ret = get_user_pages(current, current->mm,
 			     (unsigned long)xfer->mem_addr,
-- 
1.7.3.1.g432b3.dirty

