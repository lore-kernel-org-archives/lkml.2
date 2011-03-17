Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1CQLn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:43:58 -0400
Received: from mail.ibhsoftec-plc.com ([217.6.220.162]:30852 "EHLO
	ENTWMAIL.ENTWDOM.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752910Ab1CQLn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:43:56 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Mar 2011 07:43:56 EDT
From: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>
To: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Hans J. Koch" <hjk@hansjkoch.de>, Manuel Traut <manut@linutronix.de>
Subject: [PATCH] uio_netx: Add support for netPLC cards
Thread-Topic: [PATCH] uio_netx: Add support for netPLC cards
Thread-Index: AcvkmC8kDicOpdCmTKKNS/x1z906uA==
Date: Thu, 17 Mar 2011 11:40:59 +0000
Message-ID: <F988B291A6BAC142A66450B2FED7EF55852377B3@ENTWMAIL.ENTWDOM.local>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Hilscher / IBHsoftec netPLC cards to uio_netx userspace IO driver.

Signed-off-by: Daniel Trautmann <dtrautmann@ibhsoftec-sps.de>
---
 drivers/uio/uio_netx.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
index 5ffdb48..7921190 100644
--- a/drivers/uio/uio_netx.c
+++ b/drivers/uio/uio_netx.c
@@ -18,6 +18,9 @@
 
 #define PCI_VENDOR_ID_HILSCHER         0x15CF
 #define PCI_DEVICE_ID_HILSCHER_NETX    0x0000
+#define PCI_DEVICE_ID_HILSCHER_NETPLC  0x0010
+#define PCI_SUBDEVICE_ID_NETPLC_RAM    0x0000
+#define PCI_SUBDEVICE_ID_NETPLC_FLASH  0x0001
 #define PCI_SUBDEVICE_ID_NXSB_PCA      0x3235
 #define PCI_SUBDEVICE_ID_NXPCA         0x3335
 
@@ -66,6 +69,10 @@ static int __devinit netx_pci_probe(struct pci_dev *dev,
                bar = 0;
                info->name = "netx";
                break;
+       case PCI_DEVICE_ID_HILSCHER_NETPLC:
+               bar = 0;
+               info->name = "netplc";
+               break;
        default:
                bar = 2;
                info->name = "netx_plx";
@@ -133,6 +140,18 @@ static struct pci_device_id netx_pci_ids[] = {
                .subvendor =    0,
                .subdevice =    0,
        },
+        {
+                .vendor =       PCI_VENDOR_ID_HILSCHER,
+                .device =       PCI_DEVICE_ID_HILSCHER_NETPLC,
+                .subvendor =    PCI_VENDOR_ID_HILSCHER,
+                .subdevice =    PCI_SUBDEVICE_ID_NETPLC_RAM,
+        },
+        {
+                .vendor =       PCI_VENDOR_ID_HILSCHER,
+                .device =       PCI_DEVICE_ID_HILSCHER_NETPLC,
+                .subvendor =    PCI_VENDOR_ID_HILSCHER,
+                .subdevice =    PCI_SUBDEVICE_ID_NETPLC_FLASH,
+        },
        {
                .vendor =       PCI_VENDOR_ID_PLX,
                .device =       PCI_DEVICE_ID_PLX_9030,
