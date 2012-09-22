Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2IVAEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 20:04:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab2IVAEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 20:04:43 -0400
From: Flavio Leitner <fbl@redhat.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Flavio Leitner <fbl@redhat.com>
Subject: [PATCH v2] serial: set correct baud_base for EXSYS EX-41092 Dual 16950
Date: Fri, 21 Sep 2012 21:04:34 -0300
Message-Id: <1348272274-19269-1-git-send-email-fbl@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently the same card model has two IDs, so this patch
complements the commit 39aced68d664291db3324d0fcf0985ab5626aac2
adding the missing one.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 drivers/tty/serial/8250/8250_pci.c | 9 +++++++--
 include/linux/pci_ids.h            | 1 -
 2 files changed, 7 insertions(+), 3 deletions(-)

Changelog:
V2
	moved IDs from pci_ids.h to 8250_pci.c
        requested by greg k-h

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 28e7c7c..6b8fcb4 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1164,6 +1164,8 @@ pci_xr17c154_setup(struct serial_private *priv,
 #define PCI_SUBDEVICE_ID_OCTPRO422	0x0208
 #define PCI_SUBDEVICE_ID_POCTAL232	0x0308
 #define PCI_SUBDEVICE_ID_POCTAL422	0x0408
+#define PCI_SUBDEVICE_ID_SIIG_DUAL_00	0x2500
+#define PCI_SUBDEVICE_ID_SIIG_DUAL_30	0x2530
 #define PCI_VENDOR_ID_ADVANTECH		0x13fe
 #define PCI_DEVICE_ID_INTEL_CE4100_UART 0x2e66
 #define PCI_DEVICE_ID_ADVANTECH_PCI3620	0x3620
@@ -3232,8 +3234,11 @@ static struct pci_device_id serial_pci_tbl[] = {
 		 * For now just used the hex ID 0x950a.
 		 */
 	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
-		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL, 0, 0,
-		pbn_b0_2_115200 },
+		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_DUAL_00,
+		0, 0, pbn_b0_2_115200 },
+	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
+		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_DUAL_30,
+		0, 0, pbn_b0_2_115200 },
 	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_2_1130000 },
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6b4565c..8d3c427 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1847,7 +1847,6 @@
 #define PCI_DEVICE_ID_SIIG_8S_20x_650	0x2081
 #define PCI_DEVICE_ID_SIIG_8S_20x_850	0x2082
 #define PCI_SUBDEVICE_ID_SIIG_QUARTET_SERIAL	0x2050
-#define PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL	0x2530
 
 #define PCI_VENDOR_ID_RADISYS		0x1331
 
-- 
1.7.11.4

