Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2GSHwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 03:52:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:51996 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab2GSHwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 03:52:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="180303838"
Date: Thu, 19 Jul 2012 15:47:27 +0800
From: Feng Tang <feng.tang@intel.com>
To: Len Brown <len.brown@intel.com>, <linux-kernel@vger.kernel.org>
Cc: <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Donald Dutile <ddutile@redhat.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 2/2] ACPI: remove acpi_get_table_with_size() fucntion
Message-ID: <20120719154727.3306bfe4@feng-i7>
In-Reply-To: <1342683564-2245-2-git-send-email-feng.tang@intel.com>
References: <1342683564-2245-1-git-send-email-feng.tang@intel.com>
	<1342683564-2245-2-git-send-email-feng.tang@intel.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update the commit log.

Thanks,
Feng


>From 61e3349625843bd9e4c353598ec50a2333409986 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Wed, 18 Jul 2012 15:01:18 +0800
Subject: [PATCH 2/2] ACPI: Remove acpi_get_table_with_size() fucntion

Remove the unnecessary acpi_get_table_with_size(), as it could
be well covered by acpi_get_table().

Signed-off-by: Feng Tang <feng.tang@intel.com>
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
index 18f023a..63a4b26 100644
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
