Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1KFXyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:54:12 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45708 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752126Ab1KFXyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:54:11 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX187WlU+f/Q7fsaday16T+vhfE63tQRk8mY8ciU7Ry
	m9IKREOV6v4GJn
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/9] staging/comedi/jr3: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Mon,  7 Nov 2011 00:53:59 +0100
Message-Id: <1320623647-5108-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts pci_table entries to use the PCI_DEVICE macro,
if .subvendor and .subdevice are set to PCI_ANY_ID,
and thus improves readablity.

Since the driver_data field isn't used anywhere we can also drop the
assignments for class, class_mask and driver_data.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/jr3_pci.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 8d98cf4..56f7e26 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -71,18 +71,12 @@ static struct comedi_driver driver_jr3_pci = {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(jr3_pci_pci_table) = {
-	{
-	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL_NEW,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_2_CHANNEL,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_3_CHANNEL,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_4_CHANNEL,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL_NEW) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_2_CHANNEL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_3_CHANNEL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_4_CHANNEL) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, jr3_pci_pci_table);
-- 
1.7.3.4

