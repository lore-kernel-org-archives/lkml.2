Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1LBDDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 22:03:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64883 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab1LBDDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 22:03:09 -0500
Message-ID: <1322794977.25851.1.camel@phoenix>
Subject: [PATCH] MISC: Convert to DEFINE_PCI_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        David Altobelli <david.altobelli@hp.com>,
        Brent Casavant <bcasavan@sgi.com>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Date: Fri, 02 Dec 2011 11:02:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
tables. Also convert to the PCI_DEVICE/PCI_VDEVICE macros for better
readablity.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: David Altobelli <david.altobelli@hp.com>
Cc: Brent Casavant <bcasavan@sgi.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/hpilo.c     |    2 +-
 drivers/misc/ioc4.c      |    6 +++---
 drivers/misc/pch_phub.c  |    2 +-
 drivers/misc/phantom.c   |    2 +-
 drivers/misc/pti.c       |    2 +-
 drivers/misc/tifm_7xx1.c |   11 ++++-------
 6 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index fffc227..f705cbb 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -828,7 +828,7 @@ out:
 	return error;
 }
 
-static struct pci_device_id ilo_devices[] = {
+static DEFINE_PCI_DEVICE_TABLE(ilo_devices) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB204) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3307) },
 	{ }
diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
index df03dd3..46adc36 100644
--- a/drivers/misc/ioc4.c
+++ b/drivers/misc/ioc4.c
@@ -456,9 +456,9 @@ ioc4_remove(struct pci_dev *pdev)
 	kfree(idd);
 }
 
-static struct pci_device_id ioc4_id_table[] = {
-	{PCI_VENDOR_ID_SGI, PCI_DEVICE_ID_SGI_IOC4, PCI_ANY_ID,
-	 PCI_ANY_ID, 0x0b4000, 0xFFFFFF},
+static DEFINE_PCI_DEVICE_TABLE(ioc4_id_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_SGI, PCI_DEVICE_ID_SGI_IOC4),
+	  .class = 0x0b4000, .class_mask = 0xFFFFFF },
 	{0}
 };
 
diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 10fc478..daa19c2 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -878,7 +878,7 @@ static int pch_phub_resume(struct pci_dev *pdev)
 #define pch_phub_resume NULL
 #endif /* CONFIG_PM */
 
-static struct pci_device_id pch_phub_pcidev_id[] = {
+static DEFINE_PCI_DEVICE_TABLE(pch_phub_pcidev_id) = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_PCH1_PHUB),       1,  },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7213_PHUB), 2,  },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ROHM_ML7223_mPHUB), 3,  },
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 21b28fc..7f12ee6 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -487,7 +487,7 @@ static int phantom_resume(struct pci_dev *pdev)
 #define phantom_resume	NULL
 #endif
 
-static struct pci_device_id phantom_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(phantom_pci_tbl) = {
 	{ .vendor = PCI_VENDOR_ID_PLX, .device = PCI_DEVICE_ID_PLX_9050,
 	  .subvendor = PCI_VENDOR_ID_PLX, .subdevice = PCI_DEVICE_ID_PLX_9050,
 	  .class = PCI_CLASS_BRIDGE_OTHER << 8, .class_mask = 0xffff00 },
diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 0b56e3f..03843e3 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -76,7 +76,7 @@ struct pti_dev {
  */
 static DEFINE_MUTEX(alloclock);
 
-static struct pci_device_id pci_ids[] __devinitconst = {
+static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
 		{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x82B)},
 		{0}
 };
diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index ba24790..a93adcca 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -415,13 +415,10 @@ static void tifm_7xx1_remove(struct pci_dev *dev)
 	tifm_free_adapter(fm);
 }
 
-static struct pci_device_id tifm_7xx1_pci_tbl [] = {
-	{ PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_XX21_XX11_FM, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, 0, 0 }, /* xx21 - the one I have */
-        { PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_XX12_FM, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_XX20_FM, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, 0, 0 },
+static DEFINE_PCI_DEVICE_TABLE(tifm_7xx1_pci_tbl) = {
+	{ PCI_VDEVICE(TI, PCI_DEVICE_ID_TI_XX21_XX11_FM) },
+	{ PCI_VDEVICE(TI, PCI_DEVICE_ID_TI_XX12_FM) },
+	{ PCI_VDEVICE(TI, PCI_DEVICE_ID_TI_XX20_FM) },
 	{ }
 };
 
-- 
1.7.5.4



