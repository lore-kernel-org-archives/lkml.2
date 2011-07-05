Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab1GEGHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 02:07:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:22073 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab1GEGHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 02:07:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,477,1304319600"; 
   d="scan'208";a="23821804"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Thomas Renninger <trenn@novell.com>
Subject: [RFC 2/2] ACPI, APEI, Use apei_exec_run_optional in APEI EINJ and ERST
Date: Tue,  5 Jul 2011 14:07:03 +0800
Message-Id: <1309846023-16459-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309846023-16459-1-git-send-email-ying.huang@intel.com>
References: <1309846023-16459-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes APEI EINJ and ERST to use apei_exec_run for
mandatory actions, and apei_exec_run_optional for optional actions.

Cc: Thomas Renninger <trenn@novell.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/einj.c |    4 ++--
 drivers/acpi/apei/erst.c |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -307,7 +307,7 @@ static int __einj_error_inject(u32 type,
 
 	einj_exec_ctx_init(&ctx);
 
-	rc = apei_exec_run(&ctx, ACPI_EINJ_BEGIN_OPERATION);
+	rc = apei_exec_run_optional(&ctx, ACPI_EINJ_BEGIN_OPERATION);
 	if (rc)
 		return rc;
 	apei_exec_ctx_set_input(&ctx, type);
@@ -345,7 +345,7 @@ static int __einj_error_inject(u32 type,
 	rc = __einj_error_trigger(trigger_paddr);
 	if (rc)
 		return rc;
-	rc = apei_exec_run(&ctx, ACPI_EINJ_END_OPERATION);
+	rc = apei_exec_run_optional(&ctx, ACPI_EINJ_END_OPERATION);
 
 	return rc;
 }
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -642,7 +642,7 @@ static int __erst_write_to_storage(u64 o
 	int rc;
 
 	erst_exec_ctx_init(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_BEGIN_WRITE);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_BEGIN_WRITE);
 	if (rc)
 		return rc;
 	apei_exec_ctx_set_input(&ctx, offset);
@@ -666,7 +666,7 @@ static int __erst_write_to_storage(u64 o
 	if (rc)
 		return rc;
 	val = apei_exec_ctx_get_output(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_END);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_END);
 	if (rc)
 		return rc;
 
@@ -681,7 +681,7 @@ static int __erst_read_from_storage(u64
 	int rc;
 
 	erst_exec_ctx_init(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_BEGIN_READ);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_BEGIN_READ);
 	if (rc)
 		return rc;
 	apei_exec_ctx_set_input(&ctx, offset);
@@ -709,7 +709,7 @@ static int __erst_read_from_storage(u64
 	if (rc)
 		return rc;
 	val = apei_exec_ctx_get_output(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_END);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_END);
 	if (rc)
 		return rc;
 
@@ -724,7 +724,7 @@ static int __erst_clear_from_storage(u64
 	int rc;
 
 	erst_exec_ctx_init(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_BEGIN_CLEAR);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_BEGIN_CLEAR);
 	if (rc)
 		return rc;
 	apei_exec_ctx_set_input(&ctx, record_id);
@@ -748,7 +748,7 @@ static int __erst_clear_from_storage(u64
 	if (rc)
 		return rc;
 	val = apei_exec_ctx_get_output(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_END);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_END);
 	if (rc)
 		return rc;
 
