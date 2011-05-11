Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1EKTH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:07:56 -0400
Received: from mail37.messagelabs.com ([216.82.241.83]:37814 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1EKTHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:07:55 -0400
X-VirusChecked: Checked
X-Env-Sender: Scott.Kilau@digi.com
X-Msg-Ref: server-3.tower-37.messagelabs.com!1305140873!83273527!1
X-StarScan-Version: 6.2.16; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: "Kilau, Scott" <Scott.Kilau@digi.com>
To: "'gregkh@suse.de'" <gregkh@suse.de>
CC: "'mreed10@us.ibm.com'" <mreed10@us.ibm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 11 May 2011 14:07:51 -0500
Subject: [PATCH] 8250_pci: Add support for the Digi/IBM PCIe 2-port Adapter
Thread-Topic: [PATCH] 8250_pci: Add support for the Digi/IBM PCIe 2-port
 Adapter
Thread-Index: AcwQDrmV+pdYJh3/SnaWwS6Gf9Mhjw==
Message-ID: <A961E3870077E34C8FEF355D71BFDEAAC77C26CE28@mtk-sms-exch01.digi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Kilau <scottk@digi.com>

Add support to the 8250 PCI serial driver for the Digi/IBM PCIe 2-port Async EIA-232 Adapter.
Patch was created against 2.6.38.6


Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Michael Reed <mreed10@us.ibm.com>
Signed-off-by: Scott Kilau <scottk@digi.com>


diff -uprN -X linux-2.6.38.6-vanilla/Documentation/dontdiff linux-2.6.38.6-vanilla/drivers/tty/serial/8250_pci.c linux-2.6.38.6/drivers/tty/serial/8250_pci.c
--- linux-2.6.38.6-vanilla/drivers/tty/serial/8250_pci.c	2011-04-21 16:34:46.000000000 -0500
+++ linux-2.6.38.6/drivers/tty/serial/8250_pci.c	2011-04-28 09:12:29.000000000 -0500
@@ -1412,7 +1412,7 @@ static struct pci_serial_quirk pci_seria
 		.setup		= pci_default_setup,
 	},
 	/*
-	 * For Oxford Semiconductor and Mainpine
+	 * For Oxford Semiconductor Tornado based devices
 	 */
 	{
 		.vendor		= PCI_VENDOR_ID_OXSEMI,
@@ -1430,6 +1430,14 @@ static struct pci_serial_quirk pci_seria
 		.init			= pci_oxsemi_tornado_init,
 		.setup		= pci_default_setup,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_DIGI,
+		.device		= PCIE_DEVICE_ID_NEO_2_OX_IBM,
+		.subvendor		= PCI_SUBVENDOR_ID_IBM,
+		.subdevice		= PCI_ANY_ID,
+		.init			= pci_oxsemi_tornado_init,
+		.setup		= pci_default_setup,
+	},
 	/*
 	 * Default "match everything" terminator entry
 	 */
@@ -3075,6 +3083,14 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_MAINPINE, 0x4000,	/* IQ Express 8 Port V.34 Super-G3 Fax */
 		PCI_VENDOR_ID_MAINPINE, 0x4008, 0, 0,
 		pbn_oxsemi_8_4000000 },
+
+	/*
+	 * Digi/IBM PCIe 2-port Async EIA-232 Adapter utilizing OxSemi Tornado
+	 */
+	{	PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_2_OX_IBM,
+		PCI_SUBVENDOR_ID_IBM, PCI_ANY_ID, 0, 0,
+		pbn_oxsemi_2_4000000 },
+
 	/*
 	 * SBS Technologies, Inc. P-Octal and PMC-OCTPRO cards,
 	 * from skokodyn@yahoo.com
diff -uprN -X linux-2.6.38.6-vanilla/Documentation/dontdiff linux-2.6.38.6-vanilla/include/linux/pci_ids.h linux-2.6.38.6/include/linux/pci_ids.h
--- linux-2.6.38.6-vanilla/include/linux/pci_ids.h	2011-04-21 16:34:46.000000000 -0500
+++ linux-2.6.38.6/include/linux/pci_ids.h	2011-04-27 14:56:30.000000000 -0500
@@ -1476,6 +1476,7 @@
 #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA
 #define PCI_DEVICE_ID_NEO_2RJ45PRI      0x00CB
 #define PCIE_DEVICE_ID_NEO_4_IBM        0x00F4
+#define PCIE_DEVICE_ID_NEO_2_OX_IBM     0x00F6
 
 #define PCI_VENDOR_ID_XIRCOM		0x115d
 #define PCI_DEVICE_ID_XIRCOM_RBM56G	0x0101

