Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab1CCJpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:45:46 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39490 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1CCJpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:45:44 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>
Cc: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>,
        Dave Airlie <airlied@redhat.com>, Andy Whitcroft <apw@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 2/2] drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once." has been added to staging queue
Date: Thu,  3 Mar 2011 10:43:41 +0100
Message-Id: <1299145421-4197-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 2/2] drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once.

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 85ee7b145fff78b47c3f70348dc4af0634c3421e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>
Date: Wed, 2 Mar 2011 17:55:07 +0000
Subject: [PATCH 2/2] drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If ttm_bo_init() returns failure, it already destroyed the BO, so we need to
retry from scratch.

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: stable@kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>

BugLink: http://bugs.launchpad.net/bugs/652934

(cherry picked from commit 2b66b50b12cabc05f05543e792d4c9c2465d5702)
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_object.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index f23a199..d856a59 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -101,6 +101,8 @@ int radeon_bo_create(struct radeon_device *rdev, struct drm_gem_object *gobj,
 		type = ttm_bo_type_device;
 	}
 	*bo_ptr = NULL;
+
+retry:
 	bo = kzalloc(sizeof(struct radeon_bo), GFP_KERNEL);
 	if (bo == NULL)
 		return -ENOMEM;
@@ -108,8 +110,6 @@ int radeon_bo_create(struct radeon_device *rdev, struct drm_gem_object *gobj,
 	bo->gobj = gobj;
 	bo->surface_reg = -1;
 	INIT_LIST_HEAD(&bo->list);
-
-retry:
 	radeon_ttm_placement_from_domain(bo, domain);
 	/* Kernel allocation are uninterruptible */
 	r = ttm_bo_init(&rdev->mman.bdev, &bo->tbo, size, type,
--
1.7.0.4

