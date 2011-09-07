Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1IGQiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:38:20 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:40601
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922Ab1IGQ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:29:15 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR5SYT-01-4HM-02
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
Subject: [PATCH 09/10] iommu/msm: Use bus_set_iommu instead of register_iommu
Date: Wed, 7 Sep 2011 17:41:52 +0200
Message-ID: <1315410113-26608-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the MSM IOMMU driver for ARM to use the new
interface for publishing the iommu_ops.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/msm_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index d1733f6..5865dd2 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -728,7 +728,7 @@ static void __init setup_iommu_tex_classes(void)
 static int __init msm_iommu_init(void)
 {
 	setup_iommu_tex_classes();
-	register_iommu(&msm_iommu_ops);
+	bus_set_iommu(&platform_bus_type, &msm_iommu_ops);
 	return 0;
 }
 
-- 
1.7.4.1


