Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055Ab2C3KYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:24:36 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52238 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674Ab2C3KSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:42 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alex He <alex.he@amd.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 70/76] ACPI: Clean redundant codes in scan.c
Date: Fri, 30 Mar 2012 06:14:13 -0400
Message-id: <37239978778806ecba54da60676abb46870acebb.1333101989.git.len.brown@intel.com>
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

From: Alex He <alex.he@amd.com>

Clean the redundant codes of apci_bus_get_power_flags().

Signed-off-by: Alex He <alex.he@amd.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/scan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 8ab80ba..5d24a17 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -880,7 +880,6 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
 			int j;
 
 			device->power.flags.power_resources = 1;
-			ps->flags.valid = 1;
 			for (j = 0; j < ps->resources.count; j++)
 				acpi_bus_add_power_resource(ps->resources.handles[j]);
 		}
@@ -888,10 +887,8 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
 		/* Evaluate "_PSx" to see if we can do explicit sets */
 		object_name[2] = 'S';
 		status = acpi_get_handle(device->handle, object_name, &handle);
-		if (ACPI_SUCCESS(status)) {
+		if (ACPI_SUCCESS(status))
 			ps->flags.explicit_set = 1;
-			ps->flags.valid = 1;
-		}
 
 		/* State is valid if we have some power control */
 		if (ps->resources.count || ps->flags.explicit_set)
-- 
1.7.10.rc2.19.gfae9d

