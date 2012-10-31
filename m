Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab2JaJeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:34:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48152 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab2JaJeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:34:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 list <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 3/5] ACPI / x86: Export acpi_[un]register_gsi()
Date: Wed, 31 Oct 2012 10:34:21 +0100
Message-ID: <1371890.suMCXUWu9X@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1421417.rIOjExM5Pt@vostro.rjw.lan>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

These functions might be called from modules as well so make sure
they are exported.

In addition, implement empty version of acpi_unregister_gsi() and
remove the one from pci_irq.c.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/x86/kernel/acpi/boot.c |    6 ++++++
 drivers/acpi/pci_irq.c      |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux.orig/arch/x86/kernel/acpi/boot.c
+++ linux/arch/x86/kernel/acpi/boot.c
@@ -574,6 +574,12 @@ int acpi_register_gsi(struct device *dev
 
 	return irq;
 }
+EXPORT_SYMBOL_GPL(acpi_register_gsi);
+
+void acpi_unregister_gsi(u32 gsi)
+{
+}
+EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
 
 void __init acpi_set_irq_model_pic(void)
 {
Index: linux/drivers/acpi/pci_irq.c
===================================================================
--- linux.orig/drivers/acpi/pci_irq.c
+++ linux/drivers/acpi/pci_irq.c
@@ -495,11 +495,6 @@ int acpi_pci_irq_enable(struct pci_dev *
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

