Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0DGMs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:48:29 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:16221 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab0DGMsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:09 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i87h6bh2a8h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJQ-02-96S-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/12] x86/amd-iommu: use for_each_pci_dev
Date: Wed, 7 Apr 2010 14:46:46 +0200
Message-ID: <1270644409-10123-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:56.0054 (UTC) FILETIME=[67CA9D60:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

Replace open coded version with for_each_pci_dev

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 71dfc0a..4949568 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2187,7 +2187,7 @@ static void prealloc_protection_domains(void)
 	struct dma_ops_domain *dma_dom;
 	u16 devid;
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev) {
 
 		/* Do we handle this device? */
 		if (!check_device(&dev->dev))
-- 
1.7.0.4


