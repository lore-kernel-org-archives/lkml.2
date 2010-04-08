Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab0DHTAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:00:36 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:61909 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab0DHTAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:00:34 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, David.Woodhouse@intel.com
Cc: fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/6] pci/dmar: Fix link warning
Date: Thu,  8 Apr 2010 11:58:26 -0700
Message-Id: <1270753107-15881-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BBE27B4.005D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could make it to be __init to remove the linking section mismatch warning.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/dmar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 550f0a9..a9310ed 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1467,7 +1467,7 @@ int dmar_reenable_qi(struct intel_iommu *iommu)
 /*
  * Check interrupt remapping support in DMAR table description.
  */
-int dmar_ir_support(void)
+int __init dmar_ir_support(void)
 {
 	struct acpi_table_dmar *dmar;
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
-- 
1.6.4.2

