Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2IWEfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 00:35:23 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49268 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2IWEeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 00:34:20 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 02/23] ACPICA: Enable Scope change to root during module-level code execution.
Date: Sun, 23 Sep 2012 00:33:50 -0400
Message-Id: <28f538b56d321dd5e027267f8240f06ce045e0aa.1348371388.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.1.396.g16eed7c
In-Reply-To: <1348374851-20378-1-git-send-email-lenb@kernel.org>
References: <1348374851-20378-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1348371388.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1348371388.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Allows constructs like this:
    If (XXXX)
        Scope (\)
        ...

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/dswload.c  | 14 ++++++++++++++
 drivers/acpi/acpica/dswload2.c | 14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/acpi/acpica/dswload.c b/drivers/acpi/acpica/dswload.c
index 552aa3a..5575100 100644
--- a/drivers/acpi/acpica/dswload.c
+++ b/drivers/acpi/acpica/dswload.c
@@ -230,6 +230,20 @@ acpi_ds_load1_begin_op(struct acpi_walk_state * walk_state,
 			walk_state->scope_info->common.value = ACPI_TYPE_ANY;
 			break;
 
+		case ACPI_TYPE_METHOD:
+
+			/*
+			 * Allow scope change to root during execution of module-level
+			 * code. Root is typed METHOD during this time.
+			 */
+			if ((node == acpi_gbl_root_node) &&
+			    (walk_state->
+			     parse_flags & ACPI_PARSE_MODULE_LEVEL)) {
+				break;
+			}
+
+			/*lint -fallthrough */
+
 		default:
 
 			/* All other types are an error */
diff --git a/drivers/acpi/acpica/dswload2.c b/drivers/acpi/acpica/dswload2.c
index ae71477..89c0114 100644
--- a/drivers/acpi/acpica/dswload2.c
+++ b/drivers/acpi/acpica/dswload2.c
@@ -230,6 +230,20 @@ acpi_ds_load2_begin_op(struct acpi_walk_state *walk_state,
 			walk_state->scope_info->common.value = ACPI_TYPE_ANY;
 			break;
 
+		case ACPI_TYPE_METHOD:
+
+			/*
+			 * Allow scope change to root during execution of module-level
+			 * code. Root is typed METHOD during this time.
+			 */
+			if ((node == acpi_gbl_root_node) &&
+			    (walk_state->
+			     parse_flags & ACPI_PARSE_MODULE_LEVEL)) {
+				break;
+			}
+
+			/*lint -fallthrough */
+
 		default:
 
 			/* All other types are an error */
-- 
1.7.12.1.396.g16eed7c

