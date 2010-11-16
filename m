Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab0KPOV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:21:28 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:56121 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758346Ab0KPOV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:21:26 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 2/2] drm/ttm: Use kref_sub instead of repeatedly calling kref_put
Date: Tue, 16 Nov 2010 15:21:08 +0100
Message-Id: <1289917268-4922-3-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1289917268-4922-2-git-send-email-thellstrom@vmware.com>
References: <1289917268-4922-1-git-send-email-thellstrom@vmware.com>
 <1289917268-4922-2-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index a586378..9ef893d 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -266,10 +266,8 @@ static void ttm_bo_ref_bug(struct kref *list_kref)
 void ttm_bo_list_ref_sub(struct ttm_buffer_object *bo, int count,
 			 bool never_free)
 {
-	while (count--)
-		kref_put(&bo->list_kref,
-			 (never_free || (count >= 0)) ? ttm_bo_ref_bug :
-			 ttm_bo_release_list);
+	kref_sub(&bo->list_kref, count,
+		 (never_free) ? ttm_bo_ref_bug : ttm_bo_release_list);
 }
 
 int ttm_bo_reserve(struct ttm_buffer_object *bo,
-- 
1.6.2.5

