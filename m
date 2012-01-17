Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2AQM3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:29:22 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:56401 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2AQMWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:09 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 18/50] ACPI 5.0: Allow _AEI method in walk resources
Date: Tue, 17 Jan 2012 07:21:10 -0500
Message-id: <25169b77f7c33b363db7d099d67491e977cdefc7.1326802229.git.len.brown@intel.com>
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

From: Zhang Rui <rui.zhang@intel.com>

_AEI contains a resource template, this change adds support for
the walk resources function.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/rsxface.c |   10 ++++++----
 include/acpi/acnames.h        |    1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/rsxface.c b/drivers/acpi/acpica/rsxface.c
index 45a9e5e..f6cceac 100644
--- a/drivers/acpi/acpica/rsxface.c
+++ b/drivers/acpi/acpica/rsxface.c
@@ -526,8 +526,9 @@ acpi_rs_match_vendor_resource(struct acpi_resource *resource, void *context)
  *
  * PARAMETERS:  device_handle   - Handle to the device object for the
  *                                device we are querying
- *              Name            - Method name of the resources we want
- *                                (METHOD_NAME__CRS or METHOD_NAME__PRS)
+ *              Name            - Method name of the resources we want.
+ *                                (METHOD_NAME__CRS, METHOD_NAME__PRS, or
+ *                                METHOD_NAME__AEI)
  *              user_function   - Called for each resource
  *              Context         - Passed to user_function
  *
@@ -554,11 +555,12 @@ acpi_walk_resources(acpi_handle device_handle,
 
 	if (!device_handle || !user_function || !name ||
 	    (!ACPI_COMPARE_NAME(name, METHOD_NAME__CRS) &&
-	     !ACPI_COMPARE_NAME(name, METHOD_NAME__PRS))) {
+	     !ACPI_COMPARE_NAME(name, METHOD_NAME__PRS) &&
+	     !ACPI_COMPARE_NAME(name, METHOD_NAME__AEI))) {
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	/* Get the _CRS or _PRS resource list */
+	/* Get the _CRS/_PRS/_AEI resource list */
 
 	buffer.length = ACPI_ALLOCATE_LOCAL_BUFFER;
 	status = acpi_rs_get_method_data(device_handle, name, &buffer);
diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
index fc1575f..5b5af0d 100644
--- a/include/acpi/acnames.h
+++ b/include/acpi/acnames.h
@@ -58,6 +58,7 @@
 #define METHOD_NAME__PRT        "_PRT"
 #define METHOD_NAME__CRS        "_CRS"
 #define METHOD_NAME__PRS        "_PRS"
+#define METHOD_NAME__AEI        "_AEI"
 #define METHOD_NAME__PRW        "_PRW"
 #define METHOD_NAME__SRS        "_SRS"
 
-- 
1.7.9.rc1

