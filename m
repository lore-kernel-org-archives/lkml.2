Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab0G0Qme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:42:34 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:31649
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751655Ab0G0Ql5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:41:57 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L686DG-01-4IB-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>, <x86@kernel.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] iommu-api: Extension to check for interrupt remapping
Date: Tue, 27 Jul 2010 18:43:49 +0200
Message-ID: <1280249030-21332-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280249030-21332-1-git-send-email-joerg.roedel@amd.com>
References: <1280249030-21332-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Lyon <pugs@cisco.com>

This patch allows IOMMU users to determine whether the
hardware and software support safe, isolated interrupt
remapping.  Not all Intel IOMMUs have the hardware, and the
software for AMD is not there yet.

Signed-off-by: Tom Lyon <pugs@cisco.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c |    2 ++
 include/linux/iommu.h     |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index c9171be..6a5af18 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3698,6 +3698,8 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
 		return dmar_domain->iommu_snooping;
+	if (cap == IOMMU_CAP_INTR_REMAP)
+		return intr_remapping_enabled;
 
 	return 0;
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index be22ad8..0a2ba40 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -30,6 +30,7 @@ struct iommu_domain {
 };
 
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
+#define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
 
 struct iommu_ops {
 	int (*domain_init)(struct iommu_domain *domain);
-- 
1.7.0.4


