Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1HBWQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:16:01 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:57785 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1HBWPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:15:40 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Thomas Renninger <trenn@novell.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 05/19] ACPI, APEI, Use apei_exec_run_optional in APEI EINJ and
 ERST
Date: Tue, 02 Aug 2011 18:14:38 -0400
Message-id: <392913de7cc7446531922f29c0a4382d8d09626c.1312323131.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-reply-to: <1312323292-2986-1-git-send-email-lenb@kernel.org>
References: <1312323292-2986-1-git-send-email-lenb@kernel.org>
In-reply-to: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
References: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

This patch changes APEI EINJ and ERST to use apei_exec_run for
mandatory actions, and apei_exec_run_optional for optional actions.

Cc: Thomas Renninger <trenn@novell.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/einj.c |    4 ++--
 drivers/acpi/apei/erst.c |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index f74b2ea..ab821f1 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -285,7 +285,7 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 
 	einj_exec_ctx_init(&ctx);
 
-	rc = apei_exec_run(&ctx, ACPI_EINJ_BEGIN_OPERATION);
+	rc = apei_exec_run_optional(&ctx, ACPI_EINJ_BEGIN_OPERATION);
 	if (rc)
 		return rc;
 	apei_exec_ctx_set_input(&ctx, type);
@@ -323,7 +323,7 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 	rc = __einj_error_trigger(trigger_paddr);
 	if (rc)
 		return rc;
-	rc = apei_exec_run(&ctx, ACPI_EINJ_END_OPERATION);
+	rc = apei_exec_run_optional(&ctx, ACPI_EINJ_END_OPERATION);
 
 	return rc;
 }
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index e6cef8e..c8ba9da 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -642,7 +642,7 @@ static int __erst_write_to_storage(u64 offset)
 	int rc;
 
 	erst_exec_ctx_init(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_BEGIN_WRITE);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_BEGIN_WRITE);
 	if (rc)
 		return rc;
 	apei_exec_ctx_set_input(&ctx, offset);
@@ -666,7 +666,7 @@ static int __erst_write_to_storage(u64 offset)
 	if (rc)
 		return rc;
 	val = apei_exec_ctx_get_output(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_END);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_END);
 	if (rc)
 		return rc;
 
@@ -681,7 +681,7 @@ static int __erst_read_from_storage(u64 record_id, u64 offset)
 	int rc;
 
 	erst_exec_ctx_init(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_BEGIN_READ);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_BEGIN_READ);
 	if (rc)
 		return rc;
 	apei_exec_ctx_set_input(&ctx, offset);
@@ -709,7 +709,7 @@ static int __erst_read_from_storage(u64 record_id, u64 offset)
 	if (rc)
 		return rc;
 	val = apei_exec_ctx_get_output(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_END);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_END);
 	if (rc)
 		return rc;
 
@@ -724,7 +724,7 @@ static int __erst_clear_from_storage(u64 record_id)
 	int rc;
 
 	erst_exec_ctx_init(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_BEGIN_CLEAR);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_BEGIN_CLEAR);
 	if (rc)
 		return rc;
 	apei_exec_ctx_set_input(&ctx, record_id);
@@ -748,7 +748,7 @@ static int __erst_clear_from_storage(u64 record_id)
 	if (rc)
 		return rc;
 	val = apei_exec_ctx_get_output(&ctx);
-	rc = apei_exec_run(&ctx, ACPI_ERST_END);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_END);
 	if (rc)
 		return rc;
 
-- 
1.7.6.396.ge0613

