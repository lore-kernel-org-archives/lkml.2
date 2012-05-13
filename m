Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2EMRKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 13:10:07 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46312 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2EMRKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 13:10:05 -0400
Date: Sun, 13 May 2012 20:09:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joerg.roedel@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, walter harms <wharms@bfs.de>
Subject: [patch v2] iommu: off by one in dmar_get_fault_reason()
Message-ID: <20120513170938.GA4280@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAE595A.6010605@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fault_reason - 0x20 == ARRAY_SIZE(irq_remap_fault_reasons) is one past
the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: re-arranged slightly for readability

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 5ef65cf..3a74e44 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1057,8 +1057,8 @@ static const char *irq_remap_fault_reasons[] =
 
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
-	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
-				     ARRAY_SIZE(irq_remap_fault_reasons))) {
+	if (fault_reason >= 0x20 && (fault_reason - 0x20 <
+					ARRAY_SIZE(irq_remap_fault_reasons))) {
 		*fault_type = INTR_REMAP;
 		return irq_remap_fault_reasons[fault_reason - 0x20];
 	} else if (fault_reason < ARRAY_SIZE(dma_remap_fault_reasons)) {
