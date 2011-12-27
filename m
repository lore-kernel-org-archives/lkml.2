Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1L0ISA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 03:18:00 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50746 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1L0IRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 03:17:54 -0500
Message-ID: <1324973866.2351.3.camel@phoenix>
Subject: [PATCH] pcmcia: Convert to DEFINE_PCI_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Maxime Bizon <mbizon@freebox.fr>, Arjan Van De Ven <arjanv@redhat.com>,
        Jun Komuro <komurojun-mbn@nifty.com>,
        Yoichi Yuasa <yuasa@linux-mips.org>,
        Dominik Brodowski <linux@brodo.de>, linux-pcmcia@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 27 Dec 2011 16:17:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
tables. Also convert to use PCI_DEVICE macro for better readablity.

Cc: Maxime Bizon <mbizon@freebox.fr>
Cc: Arjan Van De Ven <arjanv@redhat.com>
Cc: Jun Komuro <komurojun-mbn@nifty.com>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Dominik Brodowski <linux@brodo.de>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/pcmcia/bcm63xx_pcmcia.c |    2 +-
 drivers/pcmcia/i82092.c         |   11 +++--------
 drivers/pcmcia/pd6729.c         |    9 ++-------
 drivers/pcmcia/vrc4173_cardu.c  |    7 ++-----
 drivers/pcmcia/yenta_socket.c   |    2 +-
 5 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/pcmcia/bcm63xx_pcmcia.c b/drivers/pcmcia/bcm63xx_pcmcia.c
index 693577e..c2e997a 100644
--- a/drivers/pcmcia/bcm63xx_pcmcia.c
+++ b/drivers/pcmcia/bcm63xx_pcmcia.c
@@ -475,7 +475,7 @@ static void __devexit bcm63xx_cb_exit(struct pci_dev *dev)
 	bcm63xx_cb_dev = NULL;
 }
 
-static struct pci_device_id bcm63xx_cb_table[] = {
+static DEFINE_PCI_DEVICE_TABLE(bcm63xx_cb_table) = {
 	{
 		.vendor		= PCI_VENDOR_ID_BROADCOM,
 		.device		= BCM6348_CPU_ID,
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index 3e447d0..1703523 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -26,14 +26,9 @@
 MODULE_LICENSE("GPL");
 
 /* PCI core routines */
-static struct pci_device_id i82092aa_pci_ids[] = {
-	{
-	      .vendor = PCI_VENDOR_ID_INTEL,
-	      .device = PCI_DEVICE_ID_INTEL_82092AA_0,
-	      .subvendor = PCI_ANY_ID,
-	      .subdevice = PCI_ANY_ID,
-	 },
-	 {} 
+static DEFINE_PCI_DEVICE_TABLE(i82092aa_pci_ids) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82092AA_0) },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, i82092aa_pci_ids);
 
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index 96c72e9..5928247 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -763,13 +763,8 @@ static void __devexit pd6729_pci_remove(struct pci_dev *dev)
 	kfree(socket);
 }
 
-static struct pci_device_id pd6729_pci_ids[] = {
-	{
-		.vendor		= PCI_VENDOR_ID_CIRRUS,
-		.device		= PCI_DEVICE_ID_CIRRUS_6729,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-	},
+static DEFINE_PCI_DEVICE_TABLE(pd6729_pci_ids) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_6729) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, pd6729_pci_ids);
diff --git a/drivers/pcmcia/vrc4173_cardu.c b/drivers/pcmcia/vrc4173_cardu.c
index c6d36b3..cd0a315 100644
--- a/drivers/pcmcia/vrc4173_cardu.c
+++ b/drivers/pcmcia/vrc4173_cardu.c
@@ -563,11 +563,8 @@ static int __devinit vrc4173_cardu_setup(char *options)
 
 __setup("vrc4173_cardu=", vrc4173_cardu_setup);
 
-static struct pci_device_id vrc4173_cardu_id_table[] __devinitdata = {
-	{	.vendor		= PCI_VENDOR_ID_NEC,
-		.device		= PCI_DEVICE_ID_NEC_NAPCCARD,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID, },
+static DEFINE_PCI_DEVICE_TABLE(vrc4173_cardu_id_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NEC, PCI_DEVICE_ID_NEC_NAPCCARD) },
         {0, }
 };
 
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 9dc565c..9dcff7f 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1352,7 +1352,7 @@ static const struct dev_pm_ops yenta_pm_ops = {
 		.driver_data	= CARDBUS_TYPE_##type,	\
 	}
 
-static struct pci_device_id yenta_table[] = {
+static DEFINE_PCI_DEVICE_TABLE(yenta_table) = {
 	CB_ID(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_1031, TI),
 
 	/*
-- 
1.7.5.4



