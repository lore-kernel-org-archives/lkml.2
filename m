Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab2GEMjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:39:45 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:31556
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932554Ab2GEMhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:04 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPO-01-2V7-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/28] iommu/amd: Block all interrupts by default with irq-remapping enabled
Date: Thu, 5 Jul 2012 14:36:36 +0200
Message-ID: <1341491808-23083-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When IRQ remapping is enabled all interrupts must be blocked
by default to be secure. Single interrupts are enabled on
demand later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index ed4e690..e663f1d 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1390,6 +1390,9 @@ static void init_device_table(void)
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
 		set_dev_entry_bit(devid, DEV_ENTRY_TRANSLATION);
+
+		if (amd_iommu_irq_remap)
+			set_dev_entry_bit(devid, DEV_ENTRY_IRQ_TBL_EN);
 	}
 }
 
-- 
1.7.9.5


