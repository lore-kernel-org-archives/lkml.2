Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1BVWVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:14 -0500
Received: from kroah.org ([198.145.64.141]:46562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab1BVWVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:37 2011
Message-Id: <20110222221837.651481879@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [06/70] drm/radeon: fix memory debugging since d961db75ce86a84f1f04e91ad1014653ed7d9f46
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 16f9fdcbcce74102bed9a4b7ccc1fb05b5dd6ca3 upstream.

The old code dereferenced a value, the new code just needs to pass
the ptr.

fixes an oops looking at files in debugfs.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_ttm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -787,9 +787,9 @@ static int radeon_ttm_debugfs_init(struc
 		radeon_mem_types_list[i].show = &radeon_mm_dump_table;
 		radeon_mem_types_list[i].driver_features = 0;
 		if (i == 0)
-			radeon_mem_types_list[i].data = &rdev->mman.bdev.man[TTM_PL_VRAM].priv;
+			radeon_mem_types_list[i].data = rdev->mman.bdev.man[TTM_PL_VRAM].priv;
 		else
-			radeon_mem_types_list[i].data = &rdev->mman.bdev.man[TTM_PL_TT].priv;
+			radeon_mem_types_list[i].data = rdev->mman.bdev.man[TTM_PL_TT].priv;
 
 	}
 	/* Add ttm page pool to debugfs */


