Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab2C3MSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:18:30 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48597 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799Ab2C3MSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:20 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 36/76] ACPICA: Debugger: Add missing object info to namespace
 dump
Date: Fri, 30 Mar 2012 06:13:39 -0400
Message-id: <4acb6884b5568f19bd47173cba8bc1f2289d6baa.1333101989.git.len.brown@intel.com>
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

Many namespace node types must have an attached object. For
these node types, print a message about a missing object during
a namespace dump.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/nsdump.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/nsdump.c b/drivers/acpi/acpica/nsdump.c
index b7f2b3b..3f7f3f6 100644
--- a/drivers/acpi/acpica/nsdump.c
+++ b/drivers/acpi/acpica/nsdump.c
@@ -242,7 +242,20 @@ acpi_ns_dump_one_object(acpi_handle obj_handle,
 
 		if (!obj_desc) {
 
-			/* No attached object, we are done */
+			/* No attached object. Some types should always have an object */
+
+			switch (type) {
+			case ACPI_TYPE_INTEGER:
+			case ACPI_TYPE_PACKAGE:
+			case ACPI_TYPE_BUFFER:
+			case ACPI_TYPE_STRING:
+			case ACPI_TYPE_METHOD:
+				acpi_os_printf("<No attached object>");
+				break;
+
+			default:
+				break;
+			}
 
 			acpi_os_printf("\n");
 			return (AE_OK);
-- 
1.7.10.rc2.19.gfae9d

