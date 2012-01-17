Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2AQM3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:29:24 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:43729 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab2AQMWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:08 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 06/50] ACPICA: Add error msg for Index/Bank field registers
 out-of-range
Date: Tue, 17 Jan 2012 07:20:58 -0500
Message-id: <46dfb09c024a1a92ead63b40f6993dcb5eb7d153.1326802229.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Supplement the exception code with an actual message.

Found during ACPICA debugging.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/exfldio.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpica/exfldio.c b/drivers/acpi/acpica/exfldio.c
index f915a7f..19df8ce 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -316,6 +316,7 @@ acpi_ex_access_region(union acpi_operand_object *obj_desc,
 static u8
 acpi_ex_register_overflow(union acpi_operand_object *obj_desc, u64 value)
 {
+	ACPI_FUNCTION_NAME(ex_register_overflow);
 
 	if (obj_desc->common_field.bit_length >= ACPI_INTEGER_BIT_SIZE) {
 		/*
@@ -330,6 +331,11 @@ acpi_ex_register_overflow(union acpi_operand_object *obj_desc, u64 value)
 		 * The Value is larger than the maximum value that can fit into
 		 * the register.
 		 */
+		ACPI_ERROR((AE_INFO,
+			    "Index value 0x%8.8X%8.8X overflows field width 0x%X",
+			    ACPI_FORMAT_UINT64(value),
+			    obj_desc->common_field.bit_length));
+
 		return (TRUE);
 	}
 
-- 
1.7.9.rc1

