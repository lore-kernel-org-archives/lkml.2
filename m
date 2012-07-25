Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2GYDmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:42:10 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52413 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab2GYDmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:06 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 03/52] ACPICA: Lint fixes for acpi_write, no functional changes
Date: Tue, 24 Jul 2012 23:40:59 -0400
Message-Id: <5134abfcfb4a8a9ef42c82dabad05762fbf04376.1343187617.git.len.brown@intel.com>
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

acpi_write was widened to 64-bit data, this change eliminates some
lint warnings.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/hwesleep.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index 29e8592..3680c45 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -117,7 +117,8 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state, u8 flags)
 
 	/* Clear wake status (WAK_STS) */
 
-	status = acpi_write(ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
+	status =
+	    acpi_write((u64)ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
@@ -147,7 +148,7 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state, u8 flags)
 	    ((acpi_gbl_sleep_type_a << ACPI_X_SLEEP_TYPE_POSITION) &
 	     ACPI_X_SLEEP_TYPE_MASK);
 
-	status = acpi_write((sleep_type_value | ACPI_X_SLEEP_ENABLE),
+	status = acpi_write((u64)(sleep_type_value | ACPI_X_SLEEP_ENABLE),
 			    &acpi_gbl_FADT.sleep_control);
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
@@ -195,7 +196,7 @@ acpi_status acpi_hw_extended_wake_prep(u8 sleep_state, u8 flags)
 		    ((acpi_gbl_sleep_type_a << ACPI_X_SLEEP_TYPE_POSITION) &
 		     ACPI_X_SLEEP_TYPE_MASK);
 
-		(void)acpi_write((sleep_type_value | ACPI_X_SLEEP_ENABLE),
+		(void)acpi_write((u64)(sleep_type_value | ACPI_X_SLEEP_ENABLE),
 				 &acpi_gbl_FADT.sleep_control);
 	}
 
@@ -239,7 +240,7 @@ acpi_status acpi_hw_extended_wake(u8 sleep_state, u8 flags)
 	 * and use it to determine whether the system is rebooting or
 	 * resuming. Clear WAK_STS for compatibility.
 	 */
-	(void)acpi_write(ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
+	(void)acpi_write((u64)ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
 	acpi_gbl_system_awake_and_running = TRUE;
 
 	acpi_hw_execute_sleep_method(METHOD_PATHNAME__SST, ACPI_SST_WORKING);
-- 
1.7.12.rc0

