Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2J2JYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:24:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:46397 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab2J2JYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:24:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,670,1344236400"; 
   d="scan'208";a="212387345"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, fenghua.yu@intel.com, len.brown@intel.com,
        rjw@sisk.pl, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/2] ACPI, ia64: export acpi_[un]register_gsi()
Date: Mon, 29 Oct 2012 11:26:32 +0200
Message-Id: <1351502792-13221-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1351502792-13221-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1351502792-13221-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions might be called from modules as well so make sure they are
exported.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 arch/ia64/kernel/acpi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 44057885..bd86e39 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -633,6 +633,7 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int triggering, int polarity)
 				      ACPI_EDGE_SENSITIVE) ? IOSAPIC_EDGE :
 				     IOSAPIC_LEVEL);
 }
+EXPORT_SYMBOL(acpi_register_gsi);
 
 void acpi_unregister_gsi(u32 gsi)
 {
@@ -644,6 +645,7 @@ void acpi_unregister_gsi(u32 gsi)
 
 	iosapic_unregister_intr(gsi);
 }
+EXPORT_SYMBOL(acpi_unregister_gsi);
 
 static int __init acpi_parse_fadt(struct acpi_table_header *table)
 {
-- 
1.7.12.4

