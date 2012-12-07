Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946002Ab2LGGZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:25:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945986Ab2LGGZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:25:22 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 04/15] PCI/acpiphp: Change acpiphp_glue_init() to return void
	instead of 0
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:25:19 -0700
Message-ID: <20121207062519.11051.61163.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpiphp_glue_init() always returns 0.  This patch changes the return
type from an 'int' to 'void'.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/hotplug/acpiphp.h      |    2 +-
 drivers/pci/hotplug/acpiphp_core.c |    4 +++-
 drivers/pci/hotplug/acpiphp_glue.c |    4 +---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index 4b798e9..ecd772c 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -191,7 +191,7 @@ extern int acpiphp_register_hotplug_slot(struct acpiphp_slot *slot);
 extern void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
 
 /* acpiphp_glue.c */
-extern int acpiphp_glue_init(void);
+extern void acpiphp_glue_init(void);
 extern void acpiphp_glue_exit(void);
 typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
 
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 3350b09..011a538 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -274,7 +274,9 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 static int __init init_acpi(void)
 {
 	/* initialize internal data structure etc. */
-	return acpiphp_glue_init();
+	acpiphp_glue_init();
+
+	return 0;
 }
 
 /**
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index a378a48..50b58cb 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1415,11 +1415,9 @@ static struct acpi_pci_driver acpi_pci_hp_driver = {
 /**
  * acpiphp_glue_init - initializes all PCI hotplug - ACPI glue data structures
  */
-int __init acpiphp_glue_init(void)
+void __init acpiphp_glue_init(void)
 {
 	acpi_pci_register_driver(&acpi_pci_hp_driver);
-
-	return 0;
 }
 
 

