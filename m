Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0G0Xxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:53:34 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:38908 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab0G0XwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:52:00 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 09/15] Despecificate driver from iLO2
Date: Tue, 27 Jul 2010 17:50:57 -0600
Message-Id: <1280274663-9160-10-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports both iLO2 and iLO3, but our user-visible strings
currently only reference iLO2. Let's just call it "iLO" to avoid having
to update strings for each iLO generation. This driver doesn't support
iLO ASICs prior to iLO2, but that is sufficiently explained in Kconfig.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/Kconfig |    2 +-
 drivers/watchdog/hpwdt.c |   14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index afcfacc..cde31f9 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -556,7 +556,7 @@ config IT87_WDT
 	  be called it87_wdt.
 
 config HP_WATCHDOG
-	tristate "HP Proliant iLO 2 Hardware Watchdog Timer"
+	tristate "HP Proliant iLO Hardware Watchdog Timer"
 	depends on X86
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index cedcc61..a6b37fe 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -121,8 +121,8 @@ static unsigned long __iomem *hpwdt_timer_reg;
 static unsigned long __iomem *hpwdt_timer_con;
 
 static struct pci_device_id hpwdt_devices[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3306) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },	/* iLO2 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3306) },	/* iLO3 */
 	{0},			/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
@@ -557,7 +557,7 @@ static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT |
 		   WDIOF_KEEPALIVEPING |
 		   WDIOF_MAGICCLOSE,
-	.identity = "HP iLO2 HW Watchdog Timer",
+	.identity = "HP iLO HW Watchdog Timer",
 };
 
 static long hpwdt_ioctl(struct file *file, unsigned int cmd,
@@ -667,13 +667,13 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	hpwdt_check_nmi_sourcing(dev);
 
 	/*
-	 * First let's find out if we are on an iLO2 server. We will
+	 * First let's find out if we are on an iLO2+ server. We will
 	 * not run on a legacy ASM box.
 	 * So we only support the G5 ProLiant servers and higher.
 	 */
 	if (dev->subsystem_vendor != PCI_VENDOR_ID_HP) {
-		dev_warn(&dev->dev,
-			"This server does not have an iLO2 ASIC.\n");
+		dev_warn(&dev->dev, "This server does not have an iLO ASIC"
+			 " version 2 or greater.\n");
 		return -ENODEV;
 	}
 
@@ -687,7 +687,7 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	pci_mem_addr = pci_iomap(dev, 1, 0x80);
 	if (!pci_mem_addr) {
 		dev_warn(&dev->dev,
-			"Unable to detect the iLO2 server memory.\n");
+			"Unable to detect the iLO server memory.\n");
 		retval = -ENOMEM;
 		goto error_pci_iomap;
 	}
-- 
1.7.1

