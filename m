Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2JOQmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:42:14 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4908 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2JOQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:42:12 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, isimatu.yasuaki@jp.fujitsu.com,
        liuj97@gmail.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/2] ACPI: Remove unused lockable in acpi_device_flags
Date: Mon, 15 Oct 2012 10:34:30 -0600
Message-Id: <1350318870-5700-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350318870-5700-1-git-send-email-toshi.kani@hp.com>
References: <1350318870-5700-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed lockable in struct acpi_device_flags since it is no
longer used by any code. acpi_bus_hot_remove_device() cannot
use this flag because acpi_bus_trim() frees up its acpi_device
object. Furthermore, the dock driver calls _LCK method without
using this lockable flag.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/scan.c     | 5 -----
 include/acpi/acpi_bus.h | 3 +--
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index ed87f43..19d3d4a 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1017,11 +1017,6 @@ static int acpi_bus_get_flags(struct acpi_device *device)
 			device->flags.ejectable = 1;
 	}
 
-	/* Presence of _LCK indicates 'lockable' */
-	status = acpi_get_handle(device->handle, "_LCK", &temp);
-	if (ACPI_SUCCESS(status))
-		device->flags.lockable = 1;
-
 	/* Power resources cannot be power manageable. */
 	if (device->device_type == ACPI_BUS_TYPE_POWER)
 		return 0;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 0daa0fb..e8b2877 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -144,12 +144,11 @@ struct acpi_device_flags {
 	u32 bus_address:1;
 	u32 removable:1;
 	u32 ejectable:1;
-	u32 lockable:1;
 	u32 suprise_removal_ok:1;
 	u32 power_manageable:1;
 	u32 performance_manageable:1;
 	u32 eject_pending:1;
-	u32 reserved:23;
+	u32 reserved:24;
 };
 
 /* File System */
-- 
1.7.11.7

