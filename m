Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1IGQ3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:29:49 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:17752
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483Ab1IGQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:29:46 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR5SYO-02-DXW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/10] iommu/omap: Use bus_set_iommu instead of register_iommu
Date: Wed, 7 Sep 2011 17:41:51 +0200
Message-ID: <1315410113-26608-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the OMAP IOMMU driver on ARM to use the new
interface for publishing the iommu_ops.

Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/omap-iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index bd5f606..16d5b76 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1250,7 +1250,7 @@ static int __init omap_iommu_init(void)
 		return -ENOMEM;
 	iopte_cachep = p;
 
-	register_iommu(&omap_iommu_ops);
+	bus_set_iommu(&platform_bus_type, &omap_iommu_ops);
 
 	return platform_driver_register(&omap_iommu_driver);
 }
-- 
1.7.4.1


