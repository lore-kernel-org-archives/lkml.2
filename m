Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2J2JY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:24:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:5725 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab2J2JYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:24:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,670,1344236400"; 
   d="scan'208";a="161816563"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, fenghua.yu@intel.com, len.brown@intel.com,
        rjw@sisk.pl, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/2] ACPI, x86: export acpi_[un]register_gsi()
Date: Mon, 29 Oct 2012 11:26:31 +0200
Message-Id: <1351502792-13221-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

These functions might be called from modules as well so make sure they are
exported. In addition we implement empty version of acpi_unregister_gsi() and
remove the one from pci_irq.c.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Although there are no modules that use this currently, we are working on
ACPI 5 device enumeration support that is going to use these functions and
some of that code can be compiled as a module.

 arch/x86/kernel/acpi/boot.c | 6 ++++++
 drivers/acpi/pci_irq.c      | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index e651f7a..2616d2b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -574,6 +574,12 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 
 	return irq;
 }
+EXPORT_SYMBOL(acpi_register_gsi);
+
+void acpi_unregister_gsi(u32 gsi)
+{
+}
+EXPORT_SYMBOL(acpi_unregister_gsi);
 
 void __init acpi_set_irq_model_pic(void)
 {
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 0eefa12..1be25a5 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -495,11 +495,6 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	return 0;
 }
 
-/* FIXME: implement x86/x86_64 version */
-void __attribute__ ((weak)) acpi_unregister_gsi(u32 i)
-{
-}
-
 void acpi_pci_irq_disable(struct pci_dev *dev)
 {
 	struct acpi_prt_entry *entry;
-- 
1.7.12.4

