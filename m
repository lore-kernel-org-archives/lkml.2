Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2GKKtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:49:33 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:27884
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757227Ab2GKKta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:49:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M6ZSQ9-02-211-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/7] iommu/omap: Implement DOMAIN_ATTR_GEOMETRY attribute
Date: Wed, 11 Jul 2012 12:49:20 +0200
Message-ID: <1342003763-8139-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
References: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the attribute for the OMAP IOMMU driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/omap-iommu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index e70ee2b..d0b1234 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1148,6 +1148,10 @@ static int omap_iommu_domain_init(struct iommu_domain *domain)
 
 	domain->priv = omap_domain;
 
+	domain->geometry.aperture_start = 0;
+	domain->geometry.aperture_end   = (1ULL << 32) - 1;
+	domain->geometry.force_aperture = true;
+
 	return 0;
 
 fail_nomem:
-- 
1.7.9.5


