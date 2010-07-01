Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0GAI3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:29:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:52873 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab0GAI3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:29:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,518,1272870000"; 
   d="scan'208";a="581752823"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX 1/2] ACPI, APEI, Fix a typo of error path of apei_resources_request
Date: Thu,  1 Jul 2010 16:29:02 +0800
Message-Id: <1277972943-1475-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277972943-1475-1-git-send-email-ying.huang@intel.com>
References: <1277972943-1475-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo of error path of apei_resources_request. release_mem_region
and release_region should be interchange.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/apei-base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -481,14 +481,14 @@ err_unmap_ioport:
 	list_for_each_entry(res, &resources->ioport, list) {
 		if (res == res_bak)
 			break;
-		release_mem_region(res->start, res->end - res->start);
+		release_region(res->start, res->end - res->start);
 	}
 	res_bak = NULL;
 err_unmap_iomem:
 	list_for_each_entry(res, &resources->iomem, list) {
 		if (res == res_bak)
 			break;
-		release_region(res->start, res->end - res->start);
+		release_mem_region(res->start, res->end - res->start);
 	}
 	return -EINVAL;
 }
