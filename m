Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934525Ab0GOTJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:09:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:43709 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934489Ab0GOTJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:09:27 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19XHMVSfb5XdB2Nvn1BM2hWEpvQrESUMeJ88VBmUA
	c19CoS+zN74D+X
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 25/25] message/fusion: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 21:09:24 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com,
        James Bottomley <James.Bottomley@suse.de>,
        Kashyap Desai <kashyap.desai@lsi.com>, Tejun Heo <tj@kernel.org>,
        Michael Reed <mdr@sgi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152109.25219.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
.subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
PCI_VDEVICE macro, and thus improves readability.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/message/fusion/mptfc.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index b5f03ad..19dad15 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -139,24 +139,15 @@ static struct scsi_host_template mptfc_driver_template = {
  */
 
 static struct pci_device_id mptfc_pci_table[] = {
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC909,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC929,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919X,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC929X,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC939X,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949X,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949E,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_BROCADE, MPI_MANUFACTPAGE_DEVICEID_FC949E,
-		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC909), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC929), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919X), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC929X), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC939X), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949X), },
+	{ PCI_VDEVICE(LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949E), },
+	{ PCI_VDEVICE(BROCADE, MPI_MANUFACTPAGE_DEVICEID_FC949E), },
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mptfc_pci_table);
-- 
1.7.1

