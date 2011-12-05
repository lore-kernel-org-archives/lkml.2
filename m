Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1LENfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:35:11 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:44829
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932301Ab1LENfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:06 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEB-02-AU8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/22] iommu/amd: Enable GT mode when supported by IOMMU
Date: Mon, 5 Dec 2011 14:34:20 +0100
Message-ID: <1323092077-25501-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature needs to be enabled before IOMMUv2 DTEs can be
set up.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c  |    9 +++++++++
 drivers/iommu/amd_iommu_types.h |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 60716ce..2c25ae3 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -623,6 +623,14 @@ static void __init free_ppr_log(struct amd_iommu *iommu)
 	free_pages((unsigned long)iommu->ppr_log, get_order(PPR_LOG_SIZE));
 }
 
+static void iommu_enable_gt(struct amd_iommu *iommu)
+{
+	if (!iommu_feature(iommu, FEATURE_GT))
+		return;
+
+	iommu_feature_enable(iommu, CONTROL_GT_EN);
+}
+
 /* sets a specific bit in the device table entry. */
 static void set_dev_entry_bit(u16 devid, u8 bit)
 {
@@ -1338,6 +1346,7 @@ static void enable_iommus(void)
 		iommu_enable_command_buffer(iommu);
 		iommu_enable_event_buffer(iommu);
 		iommu_enable_ppr_log(iommu);
+		iommu_enable_gt(iommu);
 		iommu_set_exclusion_range(iommu);
 		iommu_init_msi(iommu);
 		iommu_enable(iommu);
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 59405c8..c26a16d 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -129,6 +129,7 @@
 #define CONTROL_PPFLOG_EN       0x0dULL
 #define CONTROL_PPFINT_EN       0x0eULL
 #define CONTROL_PPR_EN          0x0fULL
+#define CONTROL_GT_EN           0x10ULL
 
 /* command specific defines */
 #define CMD_COMPL_WAIT          0x01
-- 
1.7.5.4


