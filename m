Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946052Ab2LGGZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:25:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003Ab2LGGZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:25:39 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 07/15] PCI/acpiphp: Declare acpi_{add,
	remove}_bridge() as external functions
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:25:36 -0700
Message-ID: <20121207062536.11051.78679.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames, and changes to external function types, add_bridge()
and remove_bridge() so that they can used directly as the add and remove
interfaces of "acpiphp".

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/hotplug/acpiphp.h      |    3 +++
 drivers/pci/hotplug/acpiphp_glue.c |   10 +++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index ecd772c..37f968e 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -191,6 +191,9 @@ extern int acpiphp_register_hotplug_slot(struct acpiphp_slot *slot);
 extern void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
 
 /* acpiphp_glue.c */
+extern struct acpi_pci_driver acpi_pci_hp_driver;
+extern int acpiphp_add_bridge(struct acpi_pci_root *root);
+extern void acpiphp_remove_bridge(struct acpi_pci_root *root);
 extern void acpiphp_glue_init(void);
 extern void acpiphp_glue_exit(void);
 typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 50b58cb..f96b13c 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -489,7 +489,7 @@ find_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 
 /* find hot-pluggable slots, and then find P2P bridge */
-static int add_bridge(struct acpi_pci_root *root)
+int acpiphp_add_bridge(struct acpi_pci_root *root)
 {
 	acpi_status status;
 	unsigned long long tmp;
@@ -613,7 +613,7 @@ cleanup_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK;
 }
 
-static void remove_bridge(struct acpi_pci_root *root)
+void acpiphp_remove_bridge(struct acpi_pci_root *root)
 {
 	struct acpiphp_bridge *bridge;
 	acpi_handle handle = root->device->handle;
@@ -1407,9 +1407,9 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
 			      _handle_hotplug_event_func);
 }
 
-static struct acpi_pci_driver acpi_pci_hp_driver = {
-	.add =		add_bridge,
-	.remove =	remove_bridge,
+struct acpi_pci_driver acpi_pci_hp_driver = {
+	.add =		acpiphp_add_bridge,
+	.remove =	acpiphp_remove_bridge,
 };
 
 /**

