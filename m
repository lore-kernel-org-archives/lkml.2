Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0DGMsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:48:06 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33988 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718Ab0DGMsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:01 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6d525hz32i6bh2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJL-02-96L-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/12] x86/amd-iommu: Remove double NULL check in check_device
Date: Wed, 7 Apr 2010 14:46:38 +0200
Message-ID: <1270644409-10123-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:55.0773 (UTC) FILETIME=[679FBCD0:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

dev was tested just above, so drop the second test.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index adb0ba0..2c4a501 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -118,7 +118,7 @@ static bool check_device(struct device *dev)
 		return false;
 
 	/* No device or no PCI device */
-	if (!dev || dev->bus != &pci_bus_type)
+	if (dev->bus != &pci_bus_type)
 		return false;
 
 	devid = get_device_id(dev);
-- 
1.7.0.4


