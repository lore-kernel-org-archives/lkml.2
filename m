Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213Ab2JDVYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:24:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934182Ab2JDVY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:24:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Flavio Leitner <fbl@redhat.com>
Subject: [ 21/52] serial: set correct baud_base for EXSYS EX-41092 Dual 16950
Date: Thu,  4 Oct 2012 14:21:12 -0700
Message-Id: <20121004210637.987333559@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Flavio Leitner <fbl@redhat.com>

commit 26e8220adb0aec43b7acafa0f1431760eee28522 upstream.

Apparently the same card model has two IDs, so this patch
complements the commit 39aced68d664291db3324d0fcf0985ab5626aac2
adding the missing one.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_pci.c |    9 +++++++--
 include/linux/pci_ids.h            |    1 -
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1125,6 +1125,8 @@ pci_xr17c154_setup(struct serial_private
 #define PCI_SUBDEVICE_ID_OCTPRO422	0x0208
 #define PCI_SUBDEVICE_ID_POCTAL232	0x0308
 #define PCI_SUBDEVICE_ID_POCTAL422	0x0408
+#define PCI_SUBDEVICE_ID_SIIG_DUAL_00	0x2500
+#define PCI_SUBDEVICE_ID_SIIG_DUAL_30	0x2530
 #define PCI_VENDOR_ID_ADVANTECH		0x13fe
 #define PCI_DEVICE_ID_INTEL_CE4100_UART 0x2e66
 #define PCI_DEVICE_ID_ADVANTECH_PCI3620	0x3620
@@ -3187,8 +3189,11 @@ static struct pci_device_id serial_pci_t
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
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1846,7 +1846,6 @@
 #define PCI_DEVICE_ID_SIIG_8S_20x_650	0x2081
 #define PCI_DEVICE_ID_SIIG_8S_20x_850	0x2082
 #define PCI_SUBDEVICE_ID_SIIG_QUARTET_SERIAL	0x2050
-#define PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL	0x2530
 
 #define PCI_VENDOR_ID_RADISYS		0x1331
 


