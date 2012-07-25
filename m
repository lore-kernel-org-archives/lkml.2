Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2GYDmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:42:20 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52413 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754Ab2GYDmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:16 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 08/52] ACPICA: iASL: Improved pathname support
Date: Tue, 24 Jul 2012 23:41:04 -0400
Message-Id: <c6e1733e6fc384ff1a219d7dfcb8b072030ae792.1343187617.git.len.brown@intel.com>
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

For include files, merge the prefix pathname with the file
pathname.  Convert backslashes in all pathnames to forward
slashes, for readability.  Include file pathname changes affect
both #include and Include() type operators.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/acutils.h |  2 ++
 drivers/acpi/acpica/utmisc.c  | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
index 925ccf2..5035327 100644
--- a/drivers/acpi/acpica/acutils.h
+++ b/drivers/acpi/acpica/acutils.h
@@ -460,6 +460,8 @@ acpi_ut_short_divide(u64 in_dividend,
 /*
  * utmisc
  */
+void ut_convert_backslashes(char *pathname);
+
 const char *acpi_ut_validate_exception(acpi_status status);
 
 u8 acpi_ut_is_pci_root_bridge(char *id);
diff --git a/drivers/acpi/acpica/utmisc.c b/drivers/acpi/acpica/utmisc.c
index 86f19db..e86f897 100644
--- a/drivers/acpi/acpica/utmisc.c
+++ b/drivers/acpi/acpica/utmisc.c
@@ -52,6 +52,34 @@ ACPI_MODULE_NAME("utmisc")
 
 /*******************************************************************************
  *
+ * FUNCTION:    ut_convert_backslashes
+ *
+ * PARAMETERS:  Pathname        - File pathname string to be converted
+ *
+ * RETURN:      Modifies the input Pathname
+ *
+ * DESCRIPTION: Convert all backslashes (0x5C) to forward slashes (0x2F) within
+ *              the entire input file pathname string.
+ *
+ ******************************************************************************/
+void ut_convert_backslashes(char *pathname)
+{
+
+	if (!pathname) {
+		return;
+	}
+
+	while (*pathname) {
+		if (*pathname == '\\') {
+			*pathname = '/';
+		}
+
+		pathname++;
+	}
+}
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_ut_validate_exception
  *
  * PARAMETERS:  Status       - The acpi_status code to be formatted
@@ -63,6 +91,7 @@ ACPI_MODULE_NAME("utmisc")
  *              an ASCII string.
  *
  ******************************************************************************/
+
 const char *acpi_ut_validate_exception(acpi_status status)
 {
 	u32 sub_status;
-- 
1.7.12.rc0

