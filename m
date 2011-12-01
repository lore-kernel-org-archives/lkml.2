Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1LABlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 20:41:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57697 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1LABlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 20:41:15 -0500
Message-ID: <1322703663.11560.1.camel@phoenix>
Subject: [PATCH] mfd: Convert to DEFINE_PCI_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andres Salomon <dilinger@queued.net>,
        Denis Turischev <denis@compulab.co.il>, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Mocean Laboratories <info@mocean-labs.com>,
        Harald Welte <HaraldWelte@viatech.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 01 Dec 2011 09:41:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
tables.

Cc: Andres Salomon <dilinger@queued.net>
Cc: Denis Turischev <denis@compulab.co.il>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Vincent Sanders <vince@simtec.co.uk>
Cc: Mocean Laboratories <info@mocean-labs.com>
Cc: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/cs5535-mfd.c |    2 +-
 drivers/mfd/lpc_sch.c    |    2 +-
 drivers/mfd/sm501.c      |    2 +-
 drivers/mfd/timberdale.c |    2 +-
 drivers/mfd/vx855.c      |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index 155fa04..3d968a7 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -172,7 +172,7 @@ static void __devexit cs5535_mfd_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static struct pci_device_id cs5535_mfd_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(cs5535_mfd_pci_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_ISA) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
 	{ 0, }
diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index ea1169b..abc4213 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -74,7 +74,7 @@ static struct mfd_cell tunnelcreek_cells[] = {
 	},
 };
 
-static struct pci_device_id lpc_sch_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(lpc_sch_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ITC_LPC) },
 	{ 0, }
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index df3702c..f4d8611 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1720,7 +1720,7 @@ static int sm501_plat_remove(struct platform_device *dev)
 	return 0;
 }
 
-static struct pci_device_id sm501_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(sm501_pci_tbl) = {
 	{ 0x126f, 0x0501, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ 0, },
 };
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 02d6569..0ba26fb 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -857,7 +857,7 @@ static void __devexit timb_remove(struct pci_dev *dev)
 	kfree(priv);
 }
 
-static struct pci_device_id timberdale_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(timberdale_pci_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TIMB, PCI_DEVICE_ID_TIMB) },
 	{ 0 }
 };
diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
index d698703..b73cc15 100644
--- a/drivers/mfd/vx855.c
+++ b/drivers/mfd/vx855.c
@@ -118,7 +118,7 @@ static void __devexit vx855_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static struct pci_device_id vx855_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(vx855_pci_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
 	{ 0, }
 };
-- 
1.7.5.4



