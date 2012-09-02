Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2IBVzC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:55:02 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23796 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab2IBVyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:54:49 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <lenb@kernel.org>
Subject: [PATCH part4 11/11] PCI, ACPI: Make kacpi_hotplug_wq static
Date: Sun,  2 Sep 2012 14:54:21 -0700
Message-Id: <1346622861-30865-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
References: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No external user anymore.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/osl.c      |    3 +--
 include/acpi/acpiosxf.h |    2 --
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 0719fa7..311a921 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -84,8 +84,7 @@ static acpi_osd_handler acpi_irq_handler;
 static void *acpi_irq_context;
 static struct workqueue_struct *kacpid_wq;
 static struct workqueue_struct *kacpi_notify_wq;
-struct workqueue_struct *kacpi_hotplug_wq;
-EXPORT_SYMBOL(kacpi_hotplug_wq);
+static struct workqueue_struct *kacpi_hotplug_wq;
 
 /*
  * This list of permanent mappings is for memory that may be accessed from
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 6ff92ea..9f68f69 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -194,8 +194,6 @@ void acpi_os_fixed_event_count(u32 fixed_event_number);
 /*
  * Threads and Scheduling
  */
-extern struct workqueue_struct *kacpi_hotplug_wq;
-
 struct acpi_hp_work {
 	struct work_struct work;
 	acpi_handle handle;
-- 
1.7.7

