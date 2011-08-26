Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1HZNU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 09:20:59 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:6313 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab1HZNUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:20:53 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQJEEP-02-7TQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, David Brown <davidb@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] iommu: Remove stub functions for !CONFIG_IOMMU_API
Date: Fri, 26 Aug 2011 15:20:39 +0200
Message-ID: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove most of the stub functions because they are only
allowed to use when CONFIG_IOMMU_API is set anyway. This
will catch missing 'select' entries in kconfig at compile
time already.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/iommu.h |   52 +-----------------------------------------------
 1 files changed, 2 insertions(+), 50 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9940319..296f41a 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -19,6 +19,8 @@
 #ifndef __LINUX_IOMMU_H
 #define __LINUX_IOMMU_H
 
+#ifdef CONFIG_IOMMU_API
+
 #include <linux/errno.h>
 
 #define IOMMU_READ	(1)
@@ -49,8 +51,6 @@ struct iommu_ops {
 			      unsigned long cap);
 };
 
-#ifdef CONFIG_IOMMU_API
-
 extern void register_iommu(struct iommu_ops *ops);
 extern bool iommu_found(void);
 extern struct iommu_domain *iommu_domain_alloc(void);
@@ -70,59 +70,11 @@ extern int iommu_domain_has_cap(struct iommu_domain *domain,
 
 #else /* CONFIG_IOMMU_API */
 
-static inline void register_iommu(struct iommu_ops *ops)
-{
-}
-
 static inline bool iommu_found(void)
 {
 	return false;
 }
 
-static inline struct iommu_domain *iommu_domain_alloc(void)
-{
-	return NULL;
-}
-
-static inline void iommu_domain_free(struct iommu_domain *domain)
-{
-}
-
-static inline int iommu_attach_device(struct iommu_domain *domain,
-				      struct device *dev)
-{
-	return -ENODEV;
-}
-
-static inline void iommu_detach_device(struct iommu_domain *domain,
-				       struct device *dev)
-{
-}
-
-static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
-			    phys_addr_t paddr, int gfp_order, int prot)
-{
-	return -ENODEV;
-}
-
-static inline int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
-			      int gfp_order)
-{
-	return -ENODEV;
-}
-
-static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
-					     unsigned long iova)
-{
-	return 0;
-}
-
-static inline int domain_has_cap(struct iommu_domain *domain,
-				 unsigned long cap)
-{
-	return 0;
-}
-
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */
-- 
1.7.4.1


