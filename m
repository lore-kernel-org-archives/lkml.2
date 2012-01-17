Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2AQMWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:22:32 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:56487 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2AQMWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:22 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 28/50] ACPI, APEI, Remove table not found message
Date: Tue, 17 Jan 2012 07:21:20 -0500
Message-id: <ad6861547b52ad7c31eacc336b79ac91d7fded75.1326802230.git.len.brown@intel.com>
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

From: Huang Ying <ying.huang@intel.com>

Because APEI tables are optional, these message may confuse users, for
example,

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/599715

Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/einj.c |    5 ++---
 drivers/acpi/apei/erst.c |    5 ++---
 drivers/acpi/apei/hest.c |    5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index d253902..43eeb2e 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -466,10 +466,9 @@ static int __init einj_init(void)
 
 	status = acpi_get_table(ACPI_SIG_EINJ, 0,
 				(struct acpi_table_header **)&einj_tab);
-	if (status == AE_NOT_FOUND) {
-		pr_info(EINJ_PFX "Table is not found!\n");
+	if (status == AE_NOT_FOUND)
 		return -ENODEV;
-	} else if (ACPI_FAILURE(status)) {
+	else if (ACPI_FAILURE(status)) {
 		const char *msg = acpi_format_exception(status);
 		pr_err(EINJ_PFX "Failed to get table, %s\n", msg);
 		return -EINVAL;
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 631b947..8e8d786 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -1125,10 +1125,9 @@ static int __init erst_init(void)
 
 	status = acpi_get_table(ACPI_SIG_ERST, 0,
 				(struct acpi_table_header **)&erst_tab);
-	if (status == AE_NOT_FOUND) {
-		pr_info(ERST_PFX "Table is not found!\n");
+	if (status == AE_NOT_FOUND)
 		goto err;
-	} else if (ACPI_FAILURE(status)) {
+	else if (ACPI_FAILURE(status)) {
 		const char *msg = acpi_format_exception(status);
 		pr_err(ERST_PFX "Failed to get table, %s\n", msg);
 		rc = -EINVAL;
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index 05fee06..f709269 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -221,10 +221,9 @@ void __init acpi_hest_init(void)
 
 	status = acpi_get_table(ACPI_SIG_HEST, 0,
 				(struct acpi_table_header **)&hest_tab);
-	if (status == AE_NOT_FOUND) {
-		pr_info(HEST_PFX "Table not found.\n");
+	if (status == AE_NOT_FOUND)
 		goto err;
-	} else if (ACPI_FAILURE(status)) {
+	else if (ACPI_FAILURE(status)) {
 		const char *msg = acpi_format_exception(status);
 		pr_err(HEST_PFX "Failed to get table, %s\n", msg);
 		rc = -EINVAL;
-- 
1.7.9.rc1

