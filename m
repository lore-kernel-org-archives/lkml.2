Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1IVQPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:15:22 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:3161
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab1IVQPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:15:20 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRXMHF-02-J7N-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/10] iommu/core: Define iommu_ops and register_iommu only with CONFIG_IOMMU_API
Date: Thu, 22 Sep 2011 18:14:53 +0200
Message-ID: <1316708102-16250-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316708102-16250-1-git-send-email-joerg.roedel@amd.com>
References: <1316708102-16250-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it impossible to compile an iommu driver into the
kernel without selecting CONFIG_IOMMU_API.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/iommu.h |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9940319..6470cd8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -34,6 +34,8 @@ struct iommu_domain {
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
 #define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
 
+#ifdef CONFIG_IOMMU_API
+
 struct iommu_ops {
 	int (*domain_init)(struct iommu_domain *domain);
 	void (*domain_destroy)(struct iommu_domain *domain);
@@ -49,8 +51,6 @@ struct iommu_ops {
 			      unsigned long cap);
 };
 
-#ifdef CONFIG_IOMMU_API
-
 extern void register_iommu(struct iommu_ops *ops);
 extern bool iommu_found(void);
 extern struct iommu_domain *iommu_domain_alloc(void);
@@ -70,9 +70,7 @@ extern int iommu_domain_has_cap(struct iommu_domain *domain,
 
 #else /* CONFIG_IOMMU_API */
 
-static inline void register_iommu(struct iommu_ops *ops)
-{
-}
+struct iommu_ops {};
 
 static inline bool iommu_found(void)
 {
-- 
1.7.4.1


