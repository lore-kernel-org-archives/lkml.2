Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab0DVUSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:18:33 -0400
Received: from kroah.org ([198.145.64.141]:59790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874Ab0DVUAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:42 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:11 2010
Message-Id: <20100422195411.781654432@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [070/139] drm/radeon/kms: fix rs600 tlb flush
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 30f69f3fb20bd719b5e1bf879339914063d38f47 upstream.

Typo in in flush leaded to no flush of the RS600 tlb which
ultimately leaded to massive system ram corruption, with
this patch everythings seems to work properly.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/rs600.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -175,7 +175,7 @@ void rs600_gart_tlb_flush(struct radeon_
 	WREG32_MC(R_000100_MC_PT0_CNTL, tmp);
 
 	tmp = RREG32_MC(R_000100_MC_PT0_CNTL);
-	tmp |= S_000100_INVALIDATE_ALL_L1_TLBS(1) & S_000100_INVALIDATE_L2_CACHE(1);
+	tmp |= S_000100_INVALIDATE_ALL_L1_TLBS(1) | S_000100_INVALIDATE_L2_CACHE(1);
 	WREG32_MC(R_000100_MC_PT0_CNTL, tmp);
 
 	tmp = RREG32_MC(R_000100_MC_PT0_CNTL);


