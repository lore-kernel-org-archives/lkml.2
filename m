Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1IWPsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:48:55 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:56256
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910Ab1IWPsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:48:52 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRZFSS-02-2CI-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/10] iommu/vt-d: Use bus_set_iommu instead of register_iommu
Date: Fri, 23 Sep 2011 17:45:53 +0200
Message-ID: <1316792756-3395-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the Intel IOMMU driver to use the new interface for
publishing the iommu_ops.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/intel-iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c621c98..2d53c3d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3486,7 +3486,7 @@ int __init intel_iommu_init(void)
 
 	init_iommu_pm_ops();
 
-	register_iommu(&intel_iommu_ops);
+	bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
 
 	bus_register_notifier(&pci_bus_type, &device_nb);
 
-- 
1.7.4.1


