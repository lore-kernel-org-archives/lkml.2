Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2GaFFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:05:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48568 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab2GaEuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:09 -0400
Message-Id: <20120731044322.255149125@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jerome Glisse <jglisse@redhat.com>,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        =?ISO-8859-15?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 68/73] drm/radeon: fix bo creation retry path
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit d1c7871ddb1f588b8eb35affd9ee1a3d5e11cd0c upstream.

Retry label was at wrong place in function leading to memory
leak.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_object.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -117,7 +117,6 @@ int radeon_bo_create(struct radeon_devic
 		return -ENOMEM;
 	}
 
-retry:
 	bo = kzalloc(sizeof(struct radeon_bo), GFP_KERNEL);
 	if (bo == NULL)
 		return -ENOMEM;
@@ -130,6 +129,8 @@ retry:
 	bo->gem_base.driver_private = NULL;
 	bo->surface_reg = -1;
 	INIT_LIST_HEAD(&bo->list);
+
+retry:
 	radeon_ttm_placement_from_domain(bo, domain);
 	/* Kernel allocation are uninterruptible */
 	mutex_lock(&rdev->vram_mutex);


