Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab2GYDmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:42:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2GYDmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:04 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 02/52] ACPICA: Object dump routines: Use common function for string output
Date: Tue, 24 Jul 2012 23:40:58 -0400
Message-Id: <579e3820bd1381d36b2c41485e9e7a94216bb7ed.1343187617.git.len.brown@intel.com>
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

For ACPI string objects, always use the common string dump
function, acpi_ut_print_string. This function surrounds the string
with quotes and handles allowed escape sequences.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/exdump.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/exdump.c b/drivers/acpi/acpica/exdump.c
index 2a6ac0a..836fe76 100644
--- a/drivers/acpi/acpica/exdump.c
+++ b/drivers/acpi/acpica/exdump.c
@@ -926,9 +926,7 @@ acpi_ex_dump_package_obj(union acpi_operand_object *obj_desc,
 	case ACPI_TYPE_STRING:
 
 		acpi_os_printf("[String] Value: ");
-		for (i = 0; i < obj_desc->string.length; i++) {
-			acpi_os_printf("%c", obj_desc->string.pointer[i]);
-		}
+		acpi_ut_print_string(obj_desc->string.pointer, ACPI_UINT8_MAX);
 		acpi_os_printf("\n");
 		break;
 
-- 
1.7.12.rc0

