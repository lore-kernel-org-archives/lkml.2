Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2GYD4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:56:20 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33308 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2GYDmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:03 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 01/52] ACPICA: AML Parser: Fix two possible memory leaks in error path
Date: Tue, 24 Jul 2012 23:40:57 -0400
Message-Id: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

Fixes a couple of memory leaks in the error recovery path.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/psargs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 5ac36ab..a683d66 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -618,6 +618,7 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 
 				arg = acpi_ps_alloc_op(AML_INT_BYTELIST_OP);
 				if (!arg) {
+					acpi_ps_free_op(field);
 					return_PTR(NULL);
 				}
 
@@ -662,6 +663,7 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 		} else {
 			arg = acpi_ps_alloc_op(AML_INT_NAMEPATH_OP);
 			if (!arg) {
+				acpi_ps_free_op(field);
 				return_PTR(NULL);
 			}
 
-- 
1.7.12.rc0

