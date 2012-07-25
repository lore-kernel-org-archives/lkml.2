Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab2GYDyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:54:04 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62253 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab2GYDmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:17 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 09/52] ACPICA: Remove argument of acpi_os_wait_events_complete
Date: Tue, 24 Jul 2012 23:41:05 -0400
Message-Id: <bd6f10a5f984e48cb56a39f2698cd58e7a33d56b.1343187617.git.len.brown@intel.com>
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

From: Lin Ming <ming.m.lin@intel.com>

Remove the unused argument of acpi_os_wait_events_complete.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/evxface.c | 4 ++--
 drivers/acpi/osl.c            | 4 ++--
 drivers/acpi/sleep.c          | 2 +-
 include/acpi/acpiosxf.h       | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index 90ae6d1..6a8b537 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -251,7 +251,7 @@ acpi_remove_notify_handler(acpi_handle device,
 	}
 	/* Make sure all deferred tasks are completed */
 
-	acpi_os_wait_events_complete(NULL);
+	acpi_os_wait_events_complete();
 
 	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
 	if (ACPI_FAILURE(status)) {
@@ -699,7 +699,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 
 	/* Make sure all deferred tasks are completed */
 
-	acpi_os_wait_events_complete(NULL);
+	acpi_os_wait_events_complete();
 
 	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
 	if (ACPI_FAILURE(status)) {
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index c3881b2..9eaf708 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -891,7 +891,7 @@ static void acpi_os_execute_deferred(struct work_struct *work)
 	struct acpi_os_dpc *dpc = container_of(work, struct acpi_os_dpc, work);
 
 	if (dpc->wait)
-		acpi_os_wait_events_complete(NULL);
+		acpi_os_wait_events_complete();
 
 	dpc->function(dpc->context);
 	kfree(dpc);
@@ -987,7 +987,7 @@ acpi_status acpi_os_hotplug_execute(acpi_osd_exec_callback function,
 	return __acpi_os_execute(0, function, context, 1);
 }
 
-void acpi_os_wait_events_complete(void *context)
+void acpi_os_wait_events_complete(void)
 {
 	flush_workqueue(kacpid_wq);
 	flush_workqueue(kacpi_notify_wq);
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index eb6fd23..9a14f90 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -144,7 +144,7 @@ void __init acpi_old_suspend_ordering(void)
 static int acpi_pm_freeze(void)
 {
 	acpi_disable_all_gpes();
-	acpi_os_wait_events_complete(NULL);
+	acpi_os_wait_events_complete();
 	acpi_ec_block_transactions();
 	return 0;
 }
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 21a5548..f3746f7 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -205,7 +205,7 @@ acpi_os_execute(acpi_execute_type type,
 acpi_status
 acpi_os_hotplug_execute(acpi_osd_exec_callback function, void *context);
 
-void acpi_os_wait_events_complete(void *context);
+void acpi_os_wait_events_complete(void);
 
 void acpi_os_sleep(u64 milliseconds);
 
-- 
1.7.12.rc0

