Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab2HGXJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:09:10 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64842 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030546Ab2HGWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:39:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: =?UTF-8?q?=5B=20058/109=5D=20drm/radeon=3A=20fix=20bo=20creation=20retry=20path?=
Date: Tue,  7 Aug 2012 15:35:17 -0700
Message-Id: <20120807222048.186074626@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit d1c7871ddb1f588b8eb35affd9ee1a3d5e11cd0c upstream.

Retry label was at wrong place in function leading to memory
leak.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_object.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -136,7 +136,6 @@ int radeon_bo_create(struct radeon_devic
 	acc_size = ttm_bo_dma_acc_size(&rdev->mman.bdev, size,
 				       sizeof(struct radeon_bo));
 
-retry:
 	bo = kzalloc(sizeof(struct radeon_bo), GFP_KERNEL);
 	if (bo == NULL)
 		return -ENOMEM;
@@ -150,6 +149,8 @@ retry:
 	bo->surface_reg = -1;
 	INIT_LIST_HEAD(&bo->list);
 	INIT_LIST_HEAD(&bo->va);
+
+retry:
 	radeon_ttm_placement_from_domain(bo, domain);
 	/* Kernel allocation are uninterruptible */
 	mutex_lock(&rdev->vram_mutex);


