Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab2F3FH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 01:07:56 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50180 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2F3FHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 01:07:54 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pavel Vasilyev <pavel@pavlinux.ru>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 1/8] ACPI sysfs.c strlen fix
Date: Sat, 30 Jun 2012 01:07:28 -0400
Message-Id: <9f132652d94c96476b0b0a8caf0c10e96ab10fa8.1341032550.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.1.104.ge7b44f1
In-Reply-To: <1341032855-27139-1-git-send-email-lenb@kernel.org>
References: <1341032855-27139-1-git-send-email-lenb@kernel.org>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Vasilyev <pavel@pavlinux.ru>

Current code is ignoring the last character of "enable" and "disable"
in comparisons.

https://bugzilla.kernel.org/show_bug.cgi?id=33732

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 9f66181..240a244 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -173,7 +173,7 @@ static int param_set_trace_state(const char *val, struct kernel_param *kp)
 {
 	int result = 0;
 
-	if (!strncmp(val, "enable", strlen("enable") - 1)) {
+	if (!strncmp(val, "enable", strlen("enable"))) {
 		result = acpi_debug_trace(trace_method_name, trace_debug_level,
 					  trace_debug_layer, 0);
 		if (result)
@@ -181,7 +181,7 @@ static int param_set_trace_state(const char *val, struct kernel_param *kp)
 		goto exit;
 	}
 
-	if (!strncmp(val, "disable", strlen("disable") - 1)) {
+	if (!strncmp(val, "disable", strlen("disable"))) {
 		int name = 0;
 		result = acpi_debug_trace((char *)&name, trace_debug_level,
 					  trace_debug_layer, 0);
-- 
1.7.11.1.104.ge7b44f1

