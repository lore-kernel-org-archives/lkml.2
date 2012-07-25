Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab2GYDnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:43:07 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33308 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab2GYDm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:59 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 31/52] ACPICA: Disassembler: Emit descriptions for ACPI predefined names
Date: Tue, 24 Jul 2012 23:41:27 -0400
Message-Id: <40cdb368d3698ea21f03fcde32461d98ad3a12a2.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

For each predefined name, emit a short description within
a comment.

https://www.acpica.org/bugzilla/show_bug.cgi?id=959

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/acglobal.h |  8 ++++++++
 drivers/acpi/acpica/aclocal.h  | 15 +++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index dec7994..92fab6a 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -462,4 +462,12 @@ ACPI_EXTERN u32 acpi_gbl_size_of_acpi_objects;
 
 #endif				/* ACPI_DEBUGGER */
 
+/*****************************************************************************
+ *
+ * Info/help support
+ *
+ ****************************************************************************/
+
+extern const struct ah_predefined_name asl_predefined_info[];
+
 #endif				/* __ACGLOBAL_H__ */
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 28f6778..af7330f 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -796,6 +796,7 @@ struct acpi_parse_state {
 #define ACPI_PARSEOP_IGNORE             0x01
 #define ACPI_PARSEOP_PARAMLIST          0x02
 #define ACPI_PARSEOP_EMPTY_TERMLIST     0x04
+#define ACPI_PARSEOP_PREDEF_CHECKED     0x08
 #define ACPI_PARSEOP_SPECIAL            0x10
 
 /*****************************************************************************
@@ -1084,4 +1085,18 @@ struct acpi_debug_mem_block {
 #define ACPI_MEM_LIST_MAX               1
 #define ACPI_NUM_MEM_LISTS              2
 
+/*****************************************************************************
+ *
+ * Info/help support
+ *
+ ****************************************************************************/
+
+struct ah_predefined_name {
+	char *name;
+	char *description;
+#ifndef ACPI_ASL_COMPILER
+	char *action;
+#endif
+};
+
 #endif				/* __ACLOCAL_H__ */
-- 
1.7.12.rc0

