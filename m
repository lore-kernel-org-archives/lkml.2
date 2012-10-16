Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2JPEE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:04:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:56145 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab2JPEE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="204878215"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] ACPI: fix the wrong #ifdef for acpi_no_s4_hw_signature
Date: Tue, 16 Oct 2012 12:05:03 +0800
Message-Id: <1350360303-14883-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_no_s4_hw_signature is defined in #ifdef CONFIG_HIBERNATION block,
but the current code put the declare in #ifdef CONFIG_PM_SLEEP block.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 include/linux/acpi.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 90be989..a468429 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -257,8 +257,11 @@ int acpi_check_region(resource_size_t start, resource_size_t n,
 
 int acpi_resources_are_enforced(void);
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_HIBERNATION
 void __init acpi_no_s4_hw_signature(void);
+#endif
+
+#ifdef CONFIG_PM_SLEEP
 void __init acpi_old_suspend_ordering(void);
 void __init acpi_nvs_nosave(void);
 #endif /* CONFIG_PM_SLEEP */
-- 
1.7.7.6

