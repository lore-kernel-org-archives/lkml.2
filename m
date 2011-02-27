Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab1B0Aek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 19:34:40 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:55507 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1B0Aei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 19:34:38 -0500
Subject: [PATCH] [TRIVIAL] drm: minor kref_put() nits
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 27 Feb 2011 01:34:08 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1298766877.1828.22.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to pass kref_put() the address of a function (just the
function will do just fine) nor to cast its unused return to void.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/gpu/drm/radeon/radeon_fence.c |    2 +-
 drivers/gpu/drm/ttm/ttm_object.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 171b0b2..a1d3ae6 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -324,7 +324,7 @@ void radeon_fence_unref(struct radeon_fence **fence)
 
 	*fence = NULL;
 	if (tmp) {
-		kref_put(&tmp->kref, &radeon_fence_destroy);
+		kref_put(&tmp->kref, radeon_fence_destroy);
 	}
 }
 
diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
index 75e9d6f..ebddd44 100644
--- a/drivers/gpu/drm/ttm/ttm_object.c
+++ b/drivers/gpu/drm/ttm/ttm_object.c
@@ -206,7 +206,7 @@ void ttm_base_object_unref(struct ttm_base_object **p_base)
 	 */
 
 	write_lock(&tdev->object_lock);
-	(void)kref_put(&base->refcount, &ttm_release_base);
+	kref_put(&base->refcount, ttm_release_base);
 	write_unlock(&tdev->object_lock);
 }
 EXPORT_SYMBOL(ttm_base_object_unref);
-- 
1.7.4.1

