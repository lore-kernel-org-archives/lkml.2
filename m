Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab2CSF7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:59:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29521 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161538Ab2CSFsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:11 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH -v3 32/47] PCI, ACPI: Make kacpi_hotplug_wq static
Date: Sun, 18 Mar 2012 22:46:21 -0700
Message-Id: <1332135996-13860-33-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F66C898.0076,ss=1,re=0.000,fgs=0
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
index fdcf4a5..09be602 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -81,8 +81,7 @@ static acpi_osd_handler acpi_irq_handler;
 static void *acpi_irq_context;
 static struct workqueue_struct *kacpid_wq;
 static struct workqueue_struct *kacpi_notify_wq;
-struct workqueue_struct *kacpi_hotplug_wq;
-EXPORT_SYMBOL(kacpi_hotplug_wq);
+static struct workqueue_struct *kacpi_hotplug_wq;
 
 /*
  * This list of permanent mappings is for memory that may be accessed from
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 62326ae..2326622 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -189,8 +189,6 @@ void acpi_os_fixed_event_count(u32 fixed_event_number);
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

