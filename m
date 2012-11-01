Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761780Ab2KAOuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:50:16 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:9610 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761590Ab2KAOuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:50:11 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com, prarit@redhat.com,
        bhelgaas@google.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 1/2] ACPI: Export functions for hot-remove
Date: Thu,  1 Nov 2012 08:42:12 -0600
Message-Id: <1351780933-30560-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351780933-30560-1-git-send-email-toshi.kani@hp.com>
References: <1351780933-30560-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exported acpi_os_hotplug_execute() and acpi_bus_hot_remove_device()
so that they can be called from modules for hot-remove operations.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/osl.c  | 1 +
 drivers/acpi/scan.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9eaf708..7dfe91d 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -986,6 +986,7 @@ acpi_status acpi_os_hotplug_execute(acpi_osd_exec_callback function,
 {
 	return __acpi_os_execute(0, function, context, 1);
 }
+EXPORT_SYMBOL(acpi_os_hotplug_execute);
 
 void acpi_os_wait_events_complete(void)
 {
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 1fcb867..a81845e 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -157,6 +157,7 @@ err_out:
 	kfree(context);
 	return;
 }
+EXPORT_SYMBOL(acpi_bus_hot_remove_device);
 
 static ssize_t
 acpi_eject_store(struct device *d, struct device_attribute *attr,
-- 
1.7.11.7

