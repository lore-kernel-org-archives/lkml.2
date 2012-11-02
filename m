Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab2KBTZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:25:23 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:12805 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757048Ab2KBTYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:24:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+FHH1MhuTOYu72fsQO7+nn
Subject: [PATCH 5/6] ARM: OMAP2+: Make some definitions local
To: linux-kernel@vger.kernel.org
From: Tony Lindgren <tony@atomide.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joro@8bytes.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, linux-omap@vger.kernel.org,
        Ido Yariv <ido@wizery.com>, linux-arm-kernel@lists.infradead.org
Date: Fri, 02 Nov 2012 12:24:09 -0700
Message-ID: <20121102192409.4253.78461.stgit@muffinssi.local>
In-Reply-To: <20121102192221.4253.34303.stgit@muffinssi.local>
References: <20121102192221.4253.34303.stgit@muffinssi.local>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ido Yariv <ido@wizery.com>

Move some of the definitions in omap-iommu.h that can be made local to
either drivers/iommu.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Signed-off-by: Ido Yariv <ido@wizery.com>
[tony@atomide.com: updated for header changes in the series]
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/iommu/omap-iommu.c  |   15 +++++++++++++++
 drivers/iommu/omap-iommu.h  |   33 +++------------------------------
 drivers/iommu/omap-iommu2.c |    6 ++++++
 3 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 4db86e1..df84087 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -54,6 +54,21 @@ struct omap_iommu_domain {
 	spinlock_t lock;
 };
 
+#define MMU_LOCK_BASE_SHIFT	10
+#define MMU_LOCK_BASE_MASK	(0x1f << MMU_LOCK_BASE_SHIFT)
+#define MMU_LOCK_BASE(x)	\
+	((x & MMU_LOCK_BASE_MASK) >> MMU_LOCK_BASE_SHIFT)
+
+#define MMU_LOCK_VICT_SHIFT	4
+#define MMU_LOCK_VICT_MASK	(0x1f << MMU_LOCK_VICT_SHIFT)
+#define MMU_LOCK_VICT(x)	\
+	((x & MMU_LOCK_VICT_MASK) >> MMU_LOCK_VICT_SHIFT)
+
+struct iotlb_lock {
+	short base;
+	short vict;
+};
+
 /* accommodate the difference between omap1 and omap2/3 */
 static const struct iommu_functions *arch_iommu;
 
diff --git a/drivers/iommu/omap-iommu.h b/drivers/iommu/omap-iommu.h
index 8c3378d..2b5f3c0 100644
--- a/drivers/iommu/omap-iommu.h
+++ b/drivers/iommu/omap-iommu.h
@@ -72,11 +72,6 @@ struct cr_regs {
 	};
 };
 
-struct iotlb_lock {
-	short base;
-	short vict;
-};
-
 /* architecture specific functions */
 struct iommu_functions {
 	unsigned long	version;
@@ -117,13 +112,6 @@ static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
 }
 #endif
 
-/* IOMMU errors */
-#define OMAP_IOMMU_ERR_TLB_MISS		(1 << 0)
-#define OMAP_IOMMU_ERR_TRANS_FAULT	(1 << 1)
-#define OMAP_IOMMU_ERR_EMU_MISS		(1 << 2)
-#define OMAP_IOMMU_ERR_TBLWALK_FAULT	(1 << 3)
-#define OMAP_IOMMU_ERR_MULTIHIT_FAULT	(1 << 4)
-
 /*
  * MMU Register offsets
  */
@@ -151,16 +139,6 @@ static inline struct omap_iommu *dev_to_omap_iommu(struct device *dev)
 /*
  * MMU Register bit definitions
  */
-#define MMU_LOCK_BASE_SHIFT	10
-#define MMU_LOCK_BASE_MASK	(0x1f << MMU_LOCK_BASE_SHIFT)
-#define MMU_LOCK_BASE(x)	\
-	((x & MMU_LOCK_BASE_MASK) >> MMU_LOCK_BASE_SHIFT)
-
-#define MMU_LOCK_VICT_SHIFT	4
-#define MMU_LOCK_VICT_MASK	(0x1f << MMU_LOCK_VICT_SHIFT)
-#define MMU_LOCK_VICT(x)	\
-	((x & MMU_LOCK_VICT_MASK) >> MMU_LOCK_VICT_SHIFT)
-
 #define MMU_CAM_VATAG_SHIFT	12
 #define MMU_CAM_VATAG_MASK \
 	((~0UL >> MMU_CAM_VATAG_SHIFT) << MMU_CAM_VATAG_SHIFT)
@@ -222,20 +200,15 @@ extern void omap_iotlb_cr_to_e(struct cr_regs *cr, struct iotlb_entry *e);
 extern int
 omap_iopgtable_store_entry(struct omap_iommu *obj, struct iotlb_entry *e);
 
-extern int omap_iommu_set_isr(const char *name,
-		 int (*isr)(struct omap_iommu *obj, u32 da, u32 iommu_errs,
-				    void *priv),
-			 void *isr_priv);
-
 extern void omap_iommu_save_ctx(struct device *dev);
 extern void omap_iommu_restore_ctx(struct device *dev);
 
-extern int omap_install_iommu_arch(const struct iommu_functions *ops);
-extern void omap_uninstall_iommu_arch(const struct iommu_functions *ops);
-
 extern int omap_foreach_iommu_device(void *data,
 				int (*fn)(struct device *, void *));
 
+extern int omap_install_iommu_arch(const struct iommu_functions *ops);
+extern void omap_uninstall_iommu_arch(const struct iommu_functions *ops);
+
 extern ssize_t
 omap_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t len);
 extern size_t
diff --git a/drivers/iommu/omap-iommu2.c b/drivers/iommu/omap-iommu2.c
index f97c386..29e98a2 100644
--- a/drivers/iommu/omap-iommu2.c
+++ b/drivers/iommu/omap-iommu2.c
@@ -68,6 +68,12 @@
 	 ((pgsz) == MMU_CAM_PGSZ_64K) ? 0xffff0000 :	\
 	 ((pgsz) == MMU_CAM_PGSZ_4K)  ? 0xfffff000 : 0)
 
+/* IOMMU errors */
+#define OMAP_IOMMU_ERR_TLB_MISS		(1 << 0)
+#define OMAP_IOMMU_ERR_TRANS_FAULT	(1 << 1)
+#define OMAP_IOMMU_ERR_EMU_MISS		(1 << 2)
+#define OMAP_IOMMU_ERR_TBLWALK_FAULT	(1 << 3)
+#define OMAP_IOMMU_ERR_MULTIHIT_FAULT	(1 << 4)
 
 static void __iommu_set_twl(struct omap_iommu *obj, bool on)
 {

