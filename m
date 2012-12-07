Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946108Ab2LGGZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:25:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003Ab2LGGZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:25:56 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 10/15] PCI/acpiphp: Change acpiphp_add_bridge() to return void
	instead of 0
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:25:54 -0700
Message-ID: <20121207062554.11051.74801.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpiphp_add_bridge() always returns 0.  This patch changes the return
type from an 'int' to 'void'.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/hotplug/acpiphp_glue.c |    8 +++-----
 include/linux/pci-acpi.h           |    4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index a4218cb..fe2aac6 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -489,7 +489,7 @@ find_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 
 /* find hot-pluggable slots, and then find P2P bridge */
-int acpiphp_add_bridge(struct acpi_pci_root *root)
+void acpiphp_add_bridge(struct acpi_pci_root *root)
 {
 	acpi_status status;
 	unsigned long long tmp;
@@ -502,11 +502,11 @@ int acpiphp_add_bridge(struct acpi_pci_root *root)
 		status = acpi_evaluate_integer(handle, "_STA", NULL, &tmp);
 		if (ACPI_FAILURE(status)) {
 			dbg("%s: _STA evaluation failure\n", __func__);
-			return 0;
+			return;
 		}
 		if ((tmp & ACPI_STA_FUNCTIONING) == 0)
 			/* don't register this object */
-			return 0;
+			return;
 	}
 
 	/* check if this bridge has ejectable slots */
@@ -521,8 +521,6 @@ int acpiphp_add_bridge(struct acpi_pci_root *root)
 
 	if (ACPI_FAILURE(status))
 		warn("find_p2p_bridge failed (error code = 0x%x)\n", status);
-
-	return 0;
 }
 
 static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index 3197070..bc5b763 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -50,10 +50,10 @@ static inline bool aer_acpi_firmware_first(void) { return false; }
 #endif
 
 #ifdef CONFIG_HOTPLUG_PCI_ACPI
-extern int acpiphp_add_bridge(struct acpi_pci_root *root);
+extern void acpiphp_add_bridge(struct acpi_pci_root *root);
 extern void acpiphp_remove_bridge(struct acpi_pci_root *root);
 #else /* !CONFIG_HOTPLUG_PCI_ACPI */
-static inline int acpiphp_add_bridge(struct acpi_pci_root *) { return 0; }
+static inline void acpiphp_add_bridge(struct acpi_pci_root *) { }
 static inline void acpiphp_remove_bridge(struct acpi_pci_root *) { }
 #endif /* !CONFIG_HOTPLUG_PCI_ACPI */
 

