Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2ELLAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 07:00:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43651 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2ELLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 07:00:04 -0400
Date: Sat, 12 May 2012 13:59:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joerg.roedel@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] iommu: off by one in dmar_get_fault_reason()
Message-ID: <20120512105935.GA19472@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fault_reason == ARRAY_SIZE(irq_remap_fault_reasons) + 0x20 - 0x20 is one
past the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 5ef65cf..9390f3f 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1057,7 +1057,7 @@ static const char *irq_remap_fault_reasons[] =
 
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
-	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
+	if (fault_reason >= 0x20 && (fault_reason < 0x20 +
 				     ARRAY_SIZE(irq_remap_fault_reasons))) {
 		*fault_type = INTR_REMAP;
 		return irq_remap_fault_reasons[fault_reason - 0x20];
