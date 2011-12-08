Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab1LHD0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 22:26:01 -0500
Received: from mga03.intel.com ([143.182.124.21]:14032 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650Ab1LHD0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 22:26:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="45071354"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 04/11] ACPI, APEI, Remove table not found message
Date: Thu,  8 Dec 2011 11:25:43 +0800
Message-Id: <1323314750-8185-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323314750-8185-1-git-send-email-ying.huang@intel.com>
References: <1323314750-8185-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because APEI tables are optional, these message may confuse users, for
example,

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/599715

Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/einj.c |    5 ++---
 drivers/acpi/apei/erst.c |    5 ++---
 drivers/acpi/apei/hest.c |    5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

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
