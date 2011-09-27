Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab1I0V7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:59:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60078 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab1I0V7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:59:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / PM: Remove unnecessary error variable from acpi_dev_run_wake()
Date: Wed, 28 Sep 2011 00:01:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109280001.28857.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The error variable in acpi_dev_run_wake() is not really used, so
remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-acpi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -282,7 +282,6 @@ static int acpi_dev_run_wake(struct devi
 {
 	struct acpi_device *dev;
 	acpi_handle handle;
-	int error = -ENODEV;
 
 	if (!device_run_wake(phys_dev))
 		return -EINVAL;
@@ -302,7 +301,7 @@ static int acpi_dev_run_wake(struct devi
 		acpi_disable_wakeup_device_power(dev);
 	}
 
-	return error;
+	return 0;
 }
 
 static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
