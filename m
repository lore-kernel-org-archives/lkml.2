Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1HAXZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:25:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab1HAXYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:50 2011
Message-Id: <20110801232050.784451582@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [02/70] drm/radeon/kms: free ib pool on module unloading
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit ccd6895d401efad0c0e41d0e93fba4ef3085e268 upstream.

ib pool weren't free for various newer asic on module unload.
This doesn't cause much arm but still could be candidate for
stable.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |    1 +
 drivers/gpu/drm/radeon/ni.c        |    1 +
 drivers/gpu/drm/radeon/r600.c      |    1 +
 drivers/gpu/drm/radeon/rv770.c     |    1 +
 4 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3150,6 +3150,7 @@ void evergreen_fini(struct radeon_device
 	r700_cp_fini(rdev);
 	r600_irq_fini(rdev);
 	radeon_wb_fini(rdev);
+	radeon_ib_pool_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	evergreen_pcie_gart_fini(rdev);
 	radeon_gem_fini(rdev);
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1584,6 +1584,7 @@ void cayman_fini(struct radeon_device *r
 	cayman_cp_fini(rdev);
 	r600_irq_fini(rdev);
 	radeon_wb_fini(rdev);
+	radeon_ib_pool_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	cayman_pcie_gart_fini(rdev);
 	radeon_gem_fini(rdev);
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2613,6 +2613,7 @@ void r600_fini(struct radeon_device *rde
 	r600_cp_fini(rdev);
 	r600_irq_fini(rdev);
 	radeon_wb_fini(rdev);
+	radeon_ib_pool_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	r600_pcie_gart_fini(rdev);
 	radeon_agp_fini(rdev);
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1365,6 +1365,7 @@ void rv770_fini(struct radeon_device *rd
 	r700_cp_fini(rdev);
 	r600_irq_fini(rdev);
 	radeon_wb_fini(rdev);
+	radeon_ib_pool_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	rv770_pcie_gart_fini(rdev);
 	rv770_vram_scratch_fini(rdev);


