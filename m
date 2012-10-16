Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2JPFYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:24:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:24911 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab2JPFYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:24:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235542558"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH v2] ACPI: move acpi_no_s4_hw_signature() declaration into #ifdef CONFIG_HIBERNATION
Date: Tue, 16 Oct 2012 13:24:12 +0800
Message-Id: <1350365052-27304-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_no_s4_hw_signature is defined in #ifdef CONFIG_HIBERNATION block,
but the current code put the declaration in #ifdef CONFIG_PM_SLEEP block.

I happened to meet this issue when I turned off PM_SLEEP config manually:
arch/x86/kernel/acpi/sleep.c:100:4: error: implicit declaration of function ‘acpi_no_s4_hw_signature’ [-Werror=implicit-function-declaration]

v2: take better title and add build error message suggested by Fengguang

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
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

