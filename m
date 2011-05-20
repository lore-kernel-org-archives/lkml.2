Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475Ab1ETALV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50492 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933416Ab1ETALT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:19 -0400
X-Sasl-enc: B1UZnPMKEoVf37wDHG8n266HZHx/fdLHbRovO7I470t0 1305850278
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/44] uio_netx: Add support for netPLC cards
Date: Thu, 19 May 2011 17:10:26 -0700
Message-Id: <1305850262-9575-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>

This patch adds support for Hilscher / IBHsoftec netPLC cards to uio_netx userspace IO driver.

Changes from v1 -> v2:
Fixed whitespace errors reported by scripts/checkpatch.pl which were caused by email client.

Signed-off-by: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>
Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
-- 
1.7.4.2

