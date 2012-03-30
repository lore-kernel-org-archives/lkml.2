Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244Ab2C3LU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:20:27 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:51544 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934115Ab2C3LSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:18:54 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 35/76] ACPICA: Change exception code for invalid pathname in
 acpi_evaluate_object
Date: Fri, 30 Mar 2012 06:13:38 -0400
Message-id: <a1acd22f7c6032e8394df7d8adee1a7cdad28b74.1333101989.git.len.brown@intel.com>
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

Change the returned exception code from AE_BAD_PARAMETER to the
more appropriate AE_BAD_PATHNAME, when the input pathname to
evaluate object is invalid.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/nsutils.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/nsutils.c b/drivers/acpi/acpica/nsutils.c
index a535b7a..7511375 100644
--- a/drivers/acpi/acpica/nsutils.c
+++ b/drivers/acpi/acpica/nsutils.c
@@ -341,7 +341,7 @@ acpi_status acpi_ns_build_internal_name(struct acpi_namestring_info *info)
 
 		if (!acpi_ns_valid_path_separator(*external_name) &&
 		    (*external_name != 0)) {
-			return_ACPI_STATUS(AE_BAD_PARAMETER);
+			return_ACPI_STATUS(AE_BAD_PATHNAME);
 		}
 
 		/* Move on the next segment */
-- 
1.7.10.rc2.19.gfae9d

