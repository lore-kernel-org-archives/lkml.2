Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1CUOx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:53:29 -0400
Received: from mailout06.t-online.de ([194.25.134.19]:56701 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1CUOx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:53:27 -0400
X-Greylist: delayed 979 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Mar 2011 10:53:27 EDT
Subject: [PATCH v2] uio_netx: Add support for netPLC cards
From: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, hjk@hansjkoch.de, manut@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 15:36:35 +0100
Message-ID: <1300718195.3457.43.camel@ubuntu-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-ID: rCR67-ZAQt6ENjiatI6RlzURPSBlK5t2TmGbh96urKOHKrc9gnjt8KEss3vJ9U9HFOZjAjFO8D
X-TOI-MSGID: 8d44253c-87a3-4c37-a0eb-ba6d4ba252ab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Hilscher / IBHsoftec netPLC cards to uio_netx userspace IO driver.

Changes from v1 -> v2:
Fixed whitespace errors reported by scripts/checkpatch.pl which were caused by email client.

Signed-off-by: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>
---
 drivers/uio/uio_netx.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
index 5ffdb48..a879fd5 100644
--- a/drivers/uio/uio_netx.c
+++ b/drivers/uio/uio_netx.c
@@ -18,6 +18,9 @@
 
 #define PCI_VENDOR_ID_HILSCHER		0x15CF
 #define PCI_DEVICE_ID_HILSCHER_NETX	0x0000
+#define PCI_DEVICE_ID_HILSCHER_NETPLC	0x0010
+#define PCI_SUBDEVICE_ID_NETPLC_RAM	0x0000
+#define PCI_SUBDEVICE_ID_NETPLC_FLASH	0x0001
 #define PCI_SUBDEVICE_ID_NXSB_PCA	0x3235
 #define PCI_SUBDEVICE_ID_NXPCA		0x3335
 
@@ -66,6 +69,10 @@ static int __devinit netx_pci_probe(struct pci_dev *dev,
 		bar = 0;
 		info->name = "netx";
 		break;
+	case PCI_DEVICE_ID_HILSCHER_NETPLC:
+		bar = 0;
+		info->name = "netplc";
+		break;
 	default:
 		bar = 2;
 		info->name = "netx_plx";
@@ -134,6 +141,18 @@ static struct pci_device_id netx_pci_ids[] = {
 		.subdevice =	0,
 	},
 	{
+		.vendor =       PCI_VENDOR_ID_HILSCHER,
+		.device =       PCI_DEVICE_ID_HILSCHER_NETPLC,
+		.subvendor =    PCI_VENDOR_ID_HILSCHER,
+		.subdevice =    PCI_SUBDEVICE_ID_NETPLC_RAM,
+	},
+	{
+		.vendor =       PCI_VENDOR_ID_HILSCHER,
+		.device =       PCI_DEVICE_ID_HILSCHER_NETPLC,
+		.subvendor =    PCI_VENDOR_ID_HILSCHER,
+		.subdevice =    PCI_SUBDEVICE_ID_NETPLC_FLASH,
+	},
+	{
 		.vendor =	PCI_VENDOR_ID_PLX,
 		.device =	PCI_DEVICE_ID_PLX_9030,
 		.subvendor =	PCI_VENDOR_ID_PLX,


