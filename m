Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab2LMQzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:55:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40111 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2LMQzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:55:37 -0500
Date: Fri, 14 Dec 2012 00:55:57 +0800
From: Wang YanQing <udknight@gmail.com>
To: joerg.roedel@amd.com
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH]iommu: make return value consistence
Message-ID: <20121213165557.GB10948@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, joerg.roedel@amd.com,
	alex.williamson@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if we don't define CONFIG_IOMMU_API the
dummy functions alway return -ENODEV
or -EINVAL except three function, so convert
them to the same behavior to make consistence

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 include/linux/iommu.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f4a49a6..16e84f6 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -210,7 +210,7 @@ static inline bool iommu_present(struct bus_type *bus)
 
 static inline struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline void iommu_domain_free(struct iommu_domain *domain)
@@ -275,7 +275,7 @@ static inline struct iommu_group *iommu_group_alloc(void)
 
 static inline void *iommu_group_get_iommudata(struct iommu_group *group)
 {
-	return NULL;
+	return ERR_PTR(-EINVAL);
 }
 
 static inline void iommu_group_set_iommudata(struct iommu_group *group,
@@ -309,7 +309,7 @@ static inline int iommu_group_for_each_dev(struct iommu_group *group,
 
 static inline struct iommu_group *iommu_group_get(struct device *dev)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline void iommu_group_put(struct iommu_group *group)
-- 
1.7.11.1.116.g8228a23
