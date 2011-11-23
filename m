Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab1KWSm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:42:26 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:49474 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751088Ab1KWSmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:42:25 -0500
From: Eugeni Dodonov <eugeni.dodonov@intel.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Keith Packard <keithp@keithp.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] iommu: export no_iommu and dmar_disabled symbols
Date: Wed, 23 Nov 2011 16:42:14 -0200
Message-Id: <1322073734-26840-1-git-send-email-eugeni.dodonov@intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321684889-18691-1-git-send-email-keithp@keithp.com>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
X-Identified-User: {669:box335.bluehost.com:dodonovn:dodonov.net} {sentby:smtp auth 200.188.217.18 authed with eugeni@dodonov.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those are needed by the rc6 and semaphores support in i915 driver.

In i915 driver, we do not enable either rc6 or semaphores on SNB when dmar
is enabled. So we use those variables to check the io remapping and iommu
status.

CC: Keith Packard <keithp@keithp.com>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
---
 arch/x86/kernel/pci-dma.c   |    1 +
 drivers/iommu/intel-iommu.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 80dc793..4c9191e 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -33,6 +33,7 @@ int force_iommu __read_mostly = 0;
 int iommu_merge __read_mostly = 0;
 
 int no_iommu __read_mostly;
+EXPORT_SYMBOL_GPL(no_iommu);
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly = 0;
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c0c7820..dfe5fd3 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -404,6 +404,7 @@ int dmar_disabled = 0;
 #else
 int dmar_disabled = 1;
 #endif /*CONFIG_INTEL_IOMMU_DEFAULT_ON*/
+EXPORT_SYMBOL_GPL(dmar_disabled);
 
 static int dmar_map_gfx = 1;
 static int dmar_forcedac;
-- 
1.7.7.4

