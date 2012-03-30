Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761Ab2C3MWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:22:21 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48615 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760633Ab2C3MSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:25 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 25/76] ACPICA: Move ACPI timer prototypes to public acpixf file
Date: Fri, 30 Mar 2012 06:13:28 -0400
Message-id: <d08310fe0d6bd8c82da94e8d8ef48bdbe14d2bd1.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

These prototypes were incorrectly declared in achware.h.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/achware.h |   12 ------------
 include/acpi/acpixf.h         |   12 ++++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/acpica/achware.h b/drivers/acpi/acpica/achware.h
index 087f710..eed204a 100644
--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -145,16 +145,4 @@ acpi_status
 acpi_hw_derive_pci_id(struct acpi_pci_id *pci_id,
 		      acpi_handle root_pci_device, acpi_handle pci_region);
 
-#ifdef	ACPI_FUTURE_USAGE
-/*
- * hwtimer - ACPI Timer prototypes
- */
-acpi_status acpi_get_timer_resolution(u32 * resolution);
-
-acpi_status acpi_get_timer(u32 * ticks);
-
-acpi_status
-acpi_get_timer_duration(u32 start_ticks, u32 end_ticks, u32 * time_elapsed);
-#endif				/* ACPI_FUTURE_USAGE */
-
 #endif				/* __ACHWARE_H__ */
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index a28da35..67cd51c 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -419,6 +419,18 @@ acpi_status acpi_leave_sleep_state_prep(u8 sleep_state);
 acpi_status acpi_leave_sleep_state(u8 sleep_state);
 
 /*
+ * ACPI Timer interfaces
+ */
+#ifdef ACPI_FUTURE_USAGE
+acpi_status acpi_get_timer_resolution(u32 *resolution);
+
+acpi_status acpi_get_timer(u32 *ticks);
+
+acpi_status
+acpi_get_timer_duration(u32 start_ticks, u32 end_ticks, u32 *time_elapsed);
+#endif				/* ACPI_FUTURE_USAGE */
+
+/*
  * Error/Warning output
  */
 void ACPI_INTERNAL_VAR_XFACE
-- 
1.7.10.rc2.19.gfae9d

