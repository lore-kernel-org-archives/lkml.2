Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0JDSXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:23:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795Ab0JDSXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:23:03 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/5] pci: Export some PCI PM functionality
Date: Mon,  4 Oct 2010 14:22:26 -0400
Message-Id: <1286216549-5438-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1286216549-5438-1-git-send-email-mjg@redhat.com>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's helpful to have some extra PCI power management functions available to
platform code, so move the declarations to an exported header.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/pci/pci.h   |    3 ---
 include/linux/pci.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 6beb11b..f5c7c38 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -63,11 +63,8 @@ struct pci_platform_pm_ops {
 extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
 extern void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
 extern void pci_disable_enabled_device(struct pci_dev *dev);
-extern bool pci_check_pme_status(struct pci_dev *dev);
 extern int pci_finish_runtime_suspend(struct pci_dev *dev);
-extern void pci_wakeup_event(struct pci_dev *dev);
 extern int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
-extern void pci_pme_wakeup_bus(struct pci_bus *bus);
 extern void pci_pm_init(struct pci_dev *dev);
 extern void platform_pci_wakeup_init(struct pci_dev *dev);
 extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c8d95e3..af03f47 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -819,6 +819,9 @@ pci_power_t pci_target_state(struct pci_dev *dev);
 int pci_prepare_to_sleep(struct pci_dev *dev);
 int pci_back_from_sleep(struct pci_dev *dev);
 bool pci_dev_run_wake(struct pci_dev *dev);
+bool pci_check_pme_status(struct pci_dev *dev);
+void pci_wakeup_event(struct pci_dev *dev);
+void pci_pme_wakeup_bus(struct pci_bus *bus);
 
 static inline int pci_enable_wake(struct pci_dev *dev, pci_power_t state,
 				  bool enable)
-- 
1.7.3.1

