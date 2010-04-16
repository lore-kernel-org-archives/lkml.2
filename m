Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab0DPQAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:00:44 -0400
Received: from nox2.protox.org ([95.130.11.66]:52901 "EHLO protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab0DPQAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:00:43 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2010 12:00:42 EDT
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: fix rs600 tlb flush
Date: Fri, 16 Apr 2010 18:46:35 +0200
Message-Id: <1271436395-9898-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typo in in flush leaded to no flush of the RS600 tlb which
ultimately leaded to massive system ram corruption, with
this patch everythings seems to work properly.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Cc: stable <stable@kernel.org>
---
 drivers/gpu/drm/radeon/rs600.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index a16d9d7..5e3f218 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -231,7 +231,7 @@ void rs600_gart_tlb_flush(struct radeon_device *rdev)
 	WREG32_MC(R_000100_MC_PT0_CNTL, tmp);
 
 	tmp = RREG32_MC(R_000100_MC_PT0_CNTL);
-	tmp |= S_000100_INVALIDATE_ALL_L1_TLBS(1) & S_000100_INVALIDATE_L2_CACHE(1);
+	tmp |= S_000100_INVALIDATE_ALL_L1_TLBS(1) | S_000100_INVALIDATE_L2_CACHE(1);
 	WREG32_MC(R_000100_MC_PT0_CNTL, tmp);
 
 	tmp = RREG32_MC(R_000100_MC_PT0_CNTL);
-- 
1.7.0.1

