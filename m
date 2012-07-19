Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2GSHoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 03:44:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:32317 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab2GSHoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 03:44:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="174129894"
From: Feng Tang <feng.tang@intel.com>
To: Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Donald Dutile <ddutile@redhat.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 2/2] ACPI: remove acpi_get_table_with_size() fucntion
Date: Thu, 19 Jul 2012 15:39:24 +0800
Message-Id: <1342683564-2245-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1342683564-2245-1-git-send-email-feng.tang@intel.com>
References: <1342683564-2245-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/acpi/acpica/tbxface.c |   18 +++---------------
 include/acpi/acpixf.h         |    4 ----
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index abcc641..3daf93d 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -380,7 +380,7 @@ ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_get_table_with_size
+ * FUNCTION:    acpi_get_table
  *
  * PARAMETERS:  Signature           - ACPI signature of needed table
  *              Instance            - Which instance (for SSDTs)
@@ -392,9 +392,8 @@ ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
  *
  ******************************************************************************/
 acpi_status
-acpi_get_table_with_size(char *signature,
-	       u32 instance, struct acpi_table_header **out_table,
-	       acpi_size *tbl_size)
+acpi_get_table(char *signature,
+	       u32 instance, struct acpi_table_header **out_table)
 {
        u32 i;
        u32 j;
@@ -424,7 +423,6 @@ acpi_get_table_with_size(char *signature,
 		    acpi_tb_verify_table(&acpi_gbl_root_table_list.tables[i]);
 		if (ACPI_SUCCESS(status)) {
 			*out_table = acpi_gbl_root_table_list.tables[i].pointer;
-			*tbl_size = acpi_gbl_root_table_list.tables[i].length;
 		}
 
 		if (!acpi_gbl_permanent_mmap) {
@@ -436,16 +434,6 @@ acpi_get_table_with_size(char *signature,
 
 	return (AE_NOT_FOUND);
 }
-
-acpi_status
-acpi_get_table(char *signature,
-	       u32 instance, struct acpi_table_header **out_table)
-{
-	acpi_size tbl_size;
-
-	return acpi_get_table_with_size(signature,
-		       instance, out_table, &tbl_size);
-}
 ACPI_EXPORT_SYMBOL(acpi_get_table)
 
 /*******************************************************************************
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 9821101..56de5a3 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -172,10 +172,6 @@ acpi_get_table_header(acpi_string signature,
 		      struct acpi_table_header *out_table_header);
 
 acpi_status
-acpi_get_table_with_size(acpi_string signature,
-	       u32 instance, struct acpi_table_header **out_table,
-	       acpi_size *tbl_size);
-acpi_status
 acpi_get_table(acpi_string signature,
 	       u32 instance, struct acpi_table_header **out_table);
 
-- 
1.7.1

