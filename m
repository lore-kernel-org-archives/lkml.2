Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab2GKKtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:49:35 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:51556
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757228Ab2GKKtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:49:31 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M6ZSQB-02-216-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/7] iommu/exynos: Implement DOMAIN_ATTR_GEOMETRY attribute
Date: Wed, 11 Jul 2012 12:49:23 +0200
Message-ID: <1342003763-8139-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
References: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the attribute for the Samsung Exynos IOMMU driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/exynos-iommu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 9a114b9..5c40937 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -732,6 +732,10 @@ static int exynos_iommu_domain_init(struct iommu_domain *domain)
 	spin_lock_init(&priv->pgtablelock);
 	INIT_LIST_HEAD(&priv->clients);
 
+	dom->geometry.aperture_start = 0;
+	dom->geometry.aperture_end   = ~0UL;
+	dom->geometry.force_aperture = true;
+
 	domain->priv = priv;
 	return 0;
 
-- 
1.7.9.5


