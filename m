Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2AQMaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:30:09 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:43729 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2AQMWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:07 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 03/50] ACPICA: Update for GCC 4
Date: Tue, 17 Jan 2012 07:20:55 -0500
Message-id: <42f5284306465dc263ce227b0c5bd2c7dcd43cdf.1326802229.git.len.brown@intel.com>
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

Fixes several issues with GCC 4.6 related to the new checks for
unused variables.

http://www.acpica.org/bugzilla/show_bug.cgi?id=935

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/utmutex.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpica/utmutex.c b/drivers/acpi/acpica/utmutex.c
index 7d797e2..302c74e 100644
--- a/drivers/acpi/acpica/utmutex.c
+++ b/drivers/acpi/acpica/utmutex.c
@@ -293,14 +293,10 @@ acpi_status acpi_ut_acquire_mutex(acpi_mutex_handle mutex_id)
 
 acpi_status acpi_ut_release_mutex(acpi_mutex_handle mutex_id)
 {
-	acpi_thread_id this_thread_id;
-
 	ACPI_FUNCTION_NAME(ut_release_mutex);
 
-	this_thread_id = acpi_os_get_thread_id();
-
 	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Thread %u releasing Mutex [%s]\n",
-			  (u32)this_thread_id,
+			  (u32)acpi_os_get_thread_id(),
 			  acpi_ut_get_mutex_name(mutex_id)));
 
 	if (mutex_id > ACPI_MAX_MUTEX) {
@@ -329,7 +325,8 @@ acpi_status acpi_ut_release_mutex(acpi_mutex_handle mutex_id)
 		 * the ACPI subsystem code.
 		 */
 		for (i = mutex_id; i < ACPI_NUM_MUTEX; i++) {
-			if (acpi_gbl_mutex_info[i].thread_id == this_thread_id) {
+			if (acpi_gbl_mutex_info[i].thread_id ==
+			    acpi_os_get_thread_id()) {
 				if (i == mutex_id) {
 					continue;
 				}
-- 
1.7.9.rc1

