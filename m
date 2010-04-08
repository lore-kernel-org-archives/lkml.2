Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab0DHTBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:01:09 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:24546 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab0DHTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:01:08 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, David.Woodhouse@intel.com
Cc: fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/6] pci/dmar: Don't complain that IOPAIC is not supported
Date: Thu,  8 Apr 2010 11:58:22 -0700
Message-Id: <1270753107-15881-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BBE27E1.0155,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INTR_REMAP handle that type, so if that is used, we should not complain that

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/dmar.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 33ead97..3bd013f 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -131,9 +131,13 @@ static int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
 			(*cnt)++;
-		else
-			printk(KERN_WARNING PREFIX
-				"Unsupported device scope\n");
+		else  {
+#ifdef CONFIG_INTR_REMAP
+			if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC)
+#endif
+				printk(KERN_WARNING PREFIX
+					"Unsupported device scope\n");
+		}
 		start += scope->length;
 	}
 	if (*cnt == 0)
-- 
1.6.4.2

