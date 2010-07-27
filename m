Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab0G0Ql5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:41:57 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:44745
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281Ab0G0Ql4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:41:56 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L686DJ-01-4IF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>, <x86@kernel.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] x86/amd-iommu: Export cache-coherency capability
Date: Tue, 27 Jul 2010 18:43:50 +0200
Message-ID: <1280249030-21332-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280249030-21332-1-git-send-email-joerg.roedel@amd.com>
References: <1280249030-21332-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports the capability of the AMD IOMMU to force
cache coherency of DMA transactions through the IOMMU-API.
This is required to disable some nasty hacks in KVM when
this capability is not available.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 29dd3b9..fa044e1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2572,6 +2572,11 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 static int amd_iommu_domain_has_cap(struct iommu_domain *domain,
 				    unsigned long cap)
 {
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
+		return 1;
+	}
+
 	return 0;
 }
 
-- 
1.7.0.4


