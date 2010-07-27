Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0G0Ql7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:41:59 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:44745
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424Ab0G0Ql4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:41:56 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L686DJ-01-4IE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>, <x86@kernel.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] x86/amd-iommu: Use for_each_pci_dev()
Date: Tue, 27 Jul 2010 18:43:48 +0200
Message-ID: <1280249030-21332-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280249030-21332-1-git-send-email-joerg.roedel@amd.com>
References: <1280249030-21332-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0d20286..29dd3b9 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2609,8 +2609,7 @@ int __init amd_iommu_init_passthrough(void)
 
 	pt_domain->mode |= PAGE_MODE_NONE;
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-
+	for_each_pci_dev(dev) {
 		if (!check_device(&dev->dev))
 			continue;
 
-- 
1.7.0.4


