Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1LCIWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:22:35 -0500
Received: from www17.your-server.de ([213.133.104.17]:58089 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1LCIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:20:53 -0500
Subject: [PATCH] drm/radeon: Use kcalloc instead of kzalloc to allocate
 array
From: Thomas Meyer <thomas@m3y3r.de>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.298.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
--- a/drivers/gpu/drm/radeon/radeon_gart.c 2011-11-13 11:07:24.266787250 +0100
+++ b/drivers/gpu/drm/radeon/radeon_gart.c 2011-11-28 19:50:09.760213006 +0100
@@ -274,8 +274,8 @@ int radeon_gart_init(struct radeon_devic
 		radeon_gart_fini(rdev);
 		return -ENOMEM;
 	}
-	rdev->gart.ttm_alloced = kzalloc(sizeof(bool) *
-					 rdev->gart.num_cpu_pages, GFP_KERNEL);
+	rdev->gart.ttm_alloced = kcalloc(rdev->gart.num_cpu_pages,
+					 sizeof(bool), GFP_KERNEL);
 	if (rdev->gart.ttm_alloced == NULL) {
 		radeon_gart_fini(rdev);
 		return -ENOMEM;
diff -u -p a/drivers/gpu/drm/radeon/radeon_test.c b/drivers/gpu/drm/radeon/radeon_test.c
--- a/drivers/gpu/drm/radeon/radeon_test.c 2011-11-13 11:07:24.296787724 +0100
+++ b/drivers/gpu/drm/radeon/radeon_test.c 2011-11-28 19:50:16.026995920 +0100
@@ -49,7 +49,7 @@ void radeon_test_moves(struct radeon_dev
 		n -= rdev->ih.ring_size;
 	n /= size;
 
-	gtt_obj = kzalloc(n * sizeof(*gtt_obj), GFP_KERNEL);
+	gtt_obj = kcalloc(n, sizeof(*gtt_obj), GFP_KERNEL);
 	if (!gtt_obj) {
 		DRM_ERROR("Failed to allocate %d pointers\n", n);
 		r = 1;
