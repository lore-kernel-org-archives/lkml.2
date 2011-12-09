Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1LIXxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:53:12 -0500
Received: from home.keithp.com ([63.227.221.253]:59588 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab1LIXxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:53:11 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Ted Phelps <phelps@gnusto.com>, Peter <pab1612@gmail.com>,
        Lukas Hejtmanek <xhejtman@fi.muni.cz>,
        Andrew Lutomirski <luto@mit.edu>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 1/2] iommu: Export intel_iommu_enabled to signal when iommu is in use
Date: Fri,  9 Dec 2011 15:53:48 -0800
Message-Id: <1323474829-2501-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323474829-2501-1-git-send-email-keithp@keithp.com>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
 <1323474829-2501-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

In i915 driver, we do not enable either rc6 or semaphores on SNB when dmar
is enabled. The new 'intel_iommu_enabled' variable signals when the
iommu code is in operation.

Cc: Ted Phelps <phelps@gnusto.com>
Cc: Peter <pab1612@gmail.com>
Cc: Lukas Hejtmanek <xhejtman@fi.muni.cz>
Cc: Andrew Lutomirski <luto@mit.edu>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/iommu/intel-iommu.c   |    5 +++++
 include/linux/dma_remapping.h |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c0c7820..8dc19b8 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -405,6 +405,9 @@ int dmar_disabled = 0;
 int dmar_disabled = 1;
 #endif /*CONFIG_INTEL_IOMMU_DEFAULT_ON*/
 
+int intel_iommu_enabled = 0;
+EXPORT_SYMBOL_GPL(intel_iommu_enabled);
+
 static int dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
@@ -3647,6 +3650,8 @@ int __init intel_iommu_init(void)
 
 	bus_register_notifier(&pci_bus_type, &device_nb);
 
+	intel_iommu_enabled = 1;
+
 	return 0;
 }
 
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index ef90cbd..57c9a8a 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -31,6 +31,7 @@ extern void free_dmar_iommu(struct intel_iommu *iommu);
 extern int iommu_calculate_agaw(struct intel_iommu *iommu);
 extern int iommu_calculate_max_sagaw(struct intel_iommu *iommu);
 extern int dmar_disabled;
+extern int intel_iommu_enabled;
 #else
 static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
 {
@@ -44,6 +45,7 @@ static inline void free_dmar_iommu(struct intel_iommu *iommu)
 {
 }
 #define dmar_disabled	(1)
+#define intel_iommu_enabled (0)
 #endif
 
 
-- 
1.7.7.3

