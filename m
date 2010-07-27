Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0G0XxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:53:25 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44613 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0G0XwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:52:01 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 13/15] Use "decoding" instead of "sourcing"
Date: Tue, 27 Jul 2010 17:51:01 -0600
Message-Id: <1280274663-9160-14-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The term "decoding" more clearly explains what hpwdt is doing. It isn't
just finding the source of the interrupt, but rather aids in decoding what
the interrupt means.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 482785e..00aea69 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -127,7 +127,7 @@ static struct pci_device_id hpwdt_devices[] = {
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
 
-static unsigned int hpwdt_nmi_sourcing;
+static unsigned int hpwdt_nmi_decoding;
 static unsigned int priority;		/* hpwdt at end of die_notify list */
 static DEFINE_SPINLOCK(rom_lock);
 static void *cru_rom_addr;
@@ -466,7 +466,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
 		goto out;
 
-	if (!hpwdt_nmi_sourcing)
+	if (!hpwdt_nmi_decoding)
 		goto out;
 
 	spin_lock_irqsave(&rom_lock, rom_pl);
@@ -633,23 +633,23 @@ static struct notifier_block die_notifier = {
  */
 
 #ifdef ARCH_HAS_NMI_WATCHDOG
-static void __devinit hpwdt_check_nmi_sourcing(struct pci_dev *dev)
+static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
 {
 	/*
 	 * If nmi_watchdog is turned off then we can turn on
-	 * our nmi sourcing capability.
+	 * our nmi decoding capability.
 	 */
 	if (!nmi_watchdog_active())
-		hpwdt_nmi_sourcing = 1;
+		hpwdt_nmi_decoding = 1;
 	else
-		dev_warn(&dev->dev, "NMI sourcing is disabled. To enable this "
+		dev_warn(&dev->dev, "NMI decoding is disabled. To enable this "
 			"functionality you must reboot with nmi_watchdog=0 "
 			"and load the hpwdt driver with priority=1.\n");
 }
 #else
-static void __devinit hpwdt_check_nmi_sourcing(struct pci_dev *dev)
+static void __devinit hpwdt_check_nmi_decoding(struct pci_dev *dev)
 {
-	dev_warn(&dev->dev, "NMI sourcing is disabled. "
+	dev_warn(&dev->dev, "NMI decoding is disabled. "
 		"Your kernel does not support a NMI Watchdog.\n");
 }
 #endif
@@ -661,9 +661,9 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	char *buf;
 
 	/*
-	 * Check if we can do NMI sourcing or not
+	 * Check if we can do NMI decoding or not
 	 */
-	hpwdt_check_nmi_sourcing(dev);
+	hpwdt_check_nmi_decoding(dev);
 
 	/*
 	 * First let's find out if we are on an iLO2+ server. We will
-- 
1.7.1

