Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381Ab2C3MUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:20:47 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48688 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760691Ab2C3MSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:44 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 34/76] ACPICA: Clarify METHOD_NAME* defines for full-pathname
 cases
Date: Fri, 30 Mar 2012 06:13:37 -0400
Message-id: <4efeeecd884de36b77c64489dee7eb7ca4d6bed0.1333101989.git.len.brown@intel.com>
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

Changed the METHOD_NAME* defines that define a full pathname to
the method to METHOD_PATHNAME* in order to make it clear that
it is not a simple 4-character ACPI name. Used for the various
sleep/wake methods.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/hwesleep.c  |   22 +++++++++++-----------
 drivers/acpi/acpica/hwsleep.c   |   10 +++++-----
 drivers/acpi/acpica/hwxfsleep.c |    5 +++--
 drivers/acpi/acpica/nsdumpdv.c  |    2 +-
 drivers/acpi/sleep.c            |    4 ++--
 include/acpi/acnames.h          |   12 ++++++------
 6 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index 9e44c6c..6cbc4e1 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -59,7 +59,7 @@ MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
  *
  * FUNCTION:    acpi_hw_execute_sleep_method
  *
- * PARAMETERS:  method_name         - Pathname of method to execute
+ * PARAMETERS:  method_pathname     - Pathname of method to execute
  *              integer_argument    - Argument to pass to the method
  *
  * RETURN:      None
@@ -68,7 +68,7 @@ MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
  *              and no return value.
  *
  ******************************************************************************/
-void acpi_hw_execute_sleep_method(char *method_name, u32 integer_argument)
+void acpi_hw_execute_sleep_method(char *method_pathname, u32 integer_argument)
 {
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
@@ -76,10 +76,10 @@ void acpi_hw_execute_sleep_method(char *method_name, u32 integer_argument)
 
 	ACPI_FUNCTION_TRACE(hw_execute_sleep_method);
 
-	if (!ACPI_STRCMP(METHOD_NAME__GTS, method_name) && !gts)
+	if (!ACPI_STRCMP(METHOD_PATHNAME__GTS, method_pathname) && !gts)
 		return_VOID;
 
-	if (!ACPI_STRCMP(METHOD_NAME__BFS, method_name) && !bfs)
+	if (!ACPI_STRCMP(METHOD_PATHNAME__BFS, method_pathname) && !bfs)
 		return_VOID;
 
 	/* One argument, integer_argument; No return value expected */
@@ -89,10 +89,10 @@ void acpi_hw_execute_sleep_method(char *method_name, u32 integer_argument)
 	arg.type = ACPI_TYPE_INTEGER;
 	arg.integer.value = (u64)integer_argument;
 
-	status = acpi_evaluate_object(NULL, method_name, &arg_list, NULL);
+	status = acpi_evaluate_object(NULL, method_pathname, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "While executing method %s",
-				method_name));
+				method_pathname));
 	}
 
 	return_VOID;
@@ -138,7 +138,7 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
 	/* Execute the _GTS method (Going To Sleep) */
 
-	acpi_hw_execute_sleep_method(METHOD_NAME__GTS, sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__GTS, sleep_state);
 
 	/* Flush caches, as per ACPI specification */
 
@@ -208,7 +208,7 @@ acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)
 				 &acpi_gbl_FADT.sleep_control);
 	}
 
-	acpi_hw_execute_sleep_method(METHOD_NAME__BFS, sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__BFS, sleep_state);
 	return_ACPI_STATUS(AE_OK);
 }
 
@@ -235,8 +235,8 @@ acpi_status acpi_hw_extended_wake(u8 sleep_state)
 
 	/* Execute the wake methods */
 
-	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WAKING);
-	acpi_hw_execute_sleep_method(METHOD_NAME__WAK, sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__SST, ACPI_SST_WAKING);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__WAK, sleep_state);
 
 	/*
 	 * Some BIOS code assumes that WAK_STS will be cleared on resume
@@ -246,6 +246,6 @@ acpi_status acpi_hw_extended_wake(u8 sleep_state)
 	(void)acpi_write(ACPI_X_WAKE_STATUS, &acpi_gbl_FADT.sleep_status);
 	acpi_gbl_system_awake_and_running = TRUE;
 
-	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WORKING);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__SST, ACPI_SST_WORKING);
 	return_ACPI_STATUS(AE_OK);
 }
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index b96d41b..aba3634 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -123,7 +123,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 
 	/* Execute the _GTS method (Going To Sleep) */
 
-	acpi_hw_execute_sleep_method(METHOD_NAME__GTS, sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__GTS, sleep_state);
 
 	/* Get current value of PM1A control */
 
@@ -279,7 +279,7 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 		}
 	}
 
-	acpi_hw_execute_sleep_method(METHOD_NAME__BFS, sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__BFS, sleep_state);
 	return_ACPI_STATUS(status);
 }
 
@@ -305,7 +305,7 @@ acpi_status acpi_hw_legacy_wake(u8 sleep_state)
 	/* Ensure enter_sleep_state_prep -> enter_sleep_state ordering */
 
 	acpi_gbl_sleep_type_a = ACPI_SLEEP_TYPE_INVALID;
-	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WAKING);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__SST, ACPI_SST_WAKING);
 
 	/*
 	 * GPEs must be enabled before _WAK is called as GPEs
@@ -329,7 +329,7 @@ acpi_status acpi_hw_legacy_wake(u8 sleep_state)
 	 * Now we can execute _WAK, etc. Some machines require that the GPEs
 	 * are enabled before the wake methods are executed.
 	 */
-	acpi_hw_execute_sleep_method(METHOD_NAME__WAK, sleep_state);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__WAK, sleep_state);
 
 	/*
 	 * Some BIOS code assumes that WAK_STS will be cleared on resume
@@ -361,7 +361,7 @@ acpi_status acpi_hw_legacy_wake(u8 sleep_state)
 		return_ACPI_STATUS(status);
 	}
 
-	acpi_hw_execute_sleep_method(METHOD_NAME__SST, ACPI_SST_WORKING);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__SST, ACPI_SST_WORKING);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index b711f97..cf0168e 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -306,7 +306,8 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
 	arg.type = ACPI_TYPE_INTEGER;
 	arg.integer.value = sleep_state;
 
-	status = acpi_evaluate_object(NULL, METHOD_NAME__PTS, &arg_list, NULL);
+	status =
+	    acpi_evaluate_object(NULL, METHOD_PATHNAME__PTS, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		return_ACPI_STATUS(status);
 	}
@@ -337,7 +338,7 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
 	 * Set the system indicators to show the desired sleep state.
 	 * _SST is an optional method (return no error if not found)
 	 */
-	acpi_hw_execute_sleep_method(METHOD_NAME__SST, sst_value);
+	acpi_hw_execute_sleep_method(METHOD_PATHNAME__SST, sst_value);
 	return_ACPI_STATUS(AE_OK);
 }
 
diff --git a/drivers/acpi/acpica/nsdumpdv.c b/drivers/acpi/acpica/nsdumpdv.c
index 30ea5bc..3b5acb0 100644
--- a/drivers/acpi/acpica/nsdumpdv.c
+++ b/drivers/acpi/acpica/nsdumpdv.c
@@ -121,7 +121,7 @@ void acpi_ns_dump_root_devices(void)
 		return;
 	}
 
-	status = acpi_get_handle(NULL, ACPI_NS_SYSTEM_BUS, &sys_bus_handle);
+	status = acpi_get_handle(NULL, METHOD_NAME__SB_, &sys_bus_handle);
 	if (ACPI_FAILURE(status)) {
 		return;
 	}
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index ca191ff..4fda549 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -788,13 +788,13 @@ static void __init acpi_gts_bfs_check(void)
 {
 	acpi_handle dummy;
 
-	if (ACPI_SUCCESS(acpi_get_handle(ACPI_ROOT_OBJECT, METHOD_NAME__GTS, &dummy)))
+	if (ACPI_SUCCESS(acpi_get_handle(ACPI_ROOT_OBJECT, METHOD_PATHNAME__GTS, &dummy)))
 	{
 		printk(KERN_NOTICE PREFIX "BIOS offers _GTS\n");
 		printk(KERN_NOTICE PREFIX "If \"acpi.gts=1\" improves suspend, "
 			"please notify linux-acpi@vger.kernel.org\n");
 	}
-	if (ACPI_SUCCESS(acpi_get_handle(ACPI_ROOT_OBJECT, METHOD_NAME__BFS, &dummy)))
+	if (ACPI_SUCCESS(acpi_get_handle(ACPI_ROOT_OBJECT, METHOD_PATHNAME__BFS, &dummy)))
 	{
 		printk(KERN_NOTICE PREFIX "BIOS offers _BFS\n");
 		printk(KERN_NOTICE PREFIX "If \"acpi.bfs=1\" improves resume, "
diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
index 5b5af0d..38f5088 100644
--- a/include/acpi/acnames.h
+++ b/include/acpi/acnames.h
@@ -46,6 +46,7 @@
 
 /* Method names - these methods can appear anywhere in the namespace */
 
+#define METHOD_NAME__SB_        "_SB_"
 #define METHOD_NAME__HID        "_HID"
 #define METHOD_NAME__CID        "_CID"
 #define METHOD_NAME__UID        "_UID"
@@ -64,11 +65,11 @@
 
 /* Method names - these methods must appear at the namespace root */
 
-#define METHOD_NAME__BFS        "\\_BFS"
-#define METHOD_NAME__GTS        "\\_GTS"
-#define METHOD_NAME__PTS        "\\_PTS"
-#define METHOD_NAME__SST        "\\_SI._SST"
-#define METHOD_NAME__WAK        "\\_WAK"
+#define METHOD_PATHNAME__BFS    "\\_BFS"
+#define METHOD_PATHNAME__GTS    "\\_GTS"
+#define METHOD_PATHNAME__PTS    "\\_PTS"
+#define METHOD_PATHNAME__SST    "\\_SI._SST"
+#define METHOD_PATHNAME__WAK    "\\_WAK"
 
 /* Definitions of the predefined namespace names  */
 
@@ -79,6 +80,5 @@
 #define ACPI_PREFIX_LOWER       (u32) 0x69706361	/* "acpi" */
 
 #define ACPI_NS_ROOT_PATH       "\\"
-#define ACPI_NS_SYSTEM_BUS      "_SB_"
 
 #endif				/* __ACNAMES_H__  */
-- 
1.7.10.rc2.19.gfae9d

