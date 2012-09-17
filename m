Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2IQSyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab2IQSyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:54:10 -0400
From: Flavio Leitner <fbl@redhat.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Niels de Vos <niels.devos@wincor-nixdorf.com>,
        Alan Cox <alan@linux.intel.com>, Flavio Leitner <fbl@redhat.com>
Subject: [PATCH] serial: set correct baud_base for EXSYS EX-41092 Dual 16950
Date: Mon, 17 Sep 2012 15:53:41 -0300
Message-Id: <1347908021-13570-1-git-send-email-fbl@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently the same card model has two IDs, so this patch
complements the commit 39aced68d664291db3324d0fcf0985ab5626aac2
adding the missing one.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 drivers/tty/serial/8250/8250_pci.c | 7 +++++--
 include/linux/pci_ids.h            | 3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 28e7c7c..6fe88e6 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -3232,8 +3232,11 @@ static struct pci_device_id serial_pci_tbl[] = {
 		 * For now just used the hex ID 0x950a.
 		 */
 	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
-		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL, 0, 0,
-		pbn_b0_2_115200 },
+		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL_00,
+		0, 0, pbn_b0_2_115200 },
+	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
+		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL_30,
+		0, 0, pbn_b0_2_115200 },
 	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_2_1130000 },
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6b4565c..4242013 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1847,7 +1847,8 @@
 #define PCI_DEVICE_ID_SIIG_8S_20x_650	0x2081
 #define PCI_DEVICE_ID_SIIG_8S_20x_850	0x2082
 #define PCI_SUBDEVICE_ID_SIIG_QUARTET_SERIAL	0x2050
-#define PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL	0x2530
+#define PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL_00	0x2500
+#define PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL_30	0x2530
 
 #define PCI_VENDOR_ID_RADISYS		0x1331
 
-- 
1.7.11.4

