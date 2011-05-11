Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1EKUmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:42:05 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:15264 "EHLO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1EKUmC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:42:02 -0400
X-VirusChecked: Checked
X-Env-Sender: Scott.Kilau@digi.com
X-Msg-Ref: server-15.tower-29.messagelabs.com!1305146521!50240389!1
X-StarScan-Version: 6.2.16; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: "Kilau, Scott" <Scott.Kilau@digi.com>
To: "Kilau, Scott" <Scott.Kilau@digi.com>, "'gregkh@suse.de'" <gregkh@suse.de>
CC: "'mreed10@us.ibm.com'" <mreed10@us.ibm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Date: Wed, 11 May 2011 15:41:59 -0500
Subject: RE: [PATCH] 8250_pci: Add support for the Digi/IBM PCIe 2-port
 Adapter
Thread-Topic: [PATCH] 8250_pci: Add support for the Digi/IBM PCIe 2-port
 Adapter
Thread-Index: AcwQDrmV+pdYJh3/SnaWwS6Gf9MhjwAAPefQAALd85A=
Message-ID: <A961E3870077E34C8FEF355D71BFDEAAC77C26CE52@mtk-sms-exch01.digi.com>
References: <A961E3870077E34C8FEF355D71BFDEAAC77C11492C@mtk-sms-exch01.digi.com>
 <A961E3870077E34C8FEF355D71BFDEAAC77C11492E@mtk-sms-exch01.digi.com>
In-Reply-To: <A961E3870077E34C8FEF355D71BFDEAAC77C11492E@mtk-sms-exch01.digi.com>
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


Oxford Semiconductor produces a 2/4/8 port UART (OXPCIe952/OXPCIe954/OXPCIe958) chip
called the Tornado, that can be used to create a very simple serial board product.
The kernel sources currently have just 2 vendors using this chip, which is Oxford and Mainpipe.
This new Digi/IBM serial product now uses it as well.

Rather than create a long running comment of vendors using the chip, the one changed comment
in the patch below now just lists "For Oxford Semiconductor Tornado based devices" to be a
more generic comment for all vendors that end up using the Oxford Tornado chip.


Patch was created against 2.6.38.6


Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Michael Reed <mreed10@us.ibm.com>
Signed-off-by: Scott Kilau <scottk@digi.com>


diff -uprN -X linux-2.6.38.6-vanilla/Documentation/dontdiff linux-2.6.38.6-vanilla/drivers/tty/serial/8250_pci.c linux-2.6.38.6/drivers/tty/serial/8250_pci.c
--- linux-2.6.38.6-vanilla/drivers/tty/serial/8250_pci.c	2011-05-09 17:16:23.000000000 -0500
+++ linux-2.6.38.6/drivers/tty/serial/8250_pci.c	2011-05-11 15:08:51.000000000 -0500
@@ -1012,6 +1012,7 @@ static int skip_tx_en_setup(struct seria
 #define PCI_DEVICE_ID_TITAN_200EI	0xA016
 #define PCI_DEVICE_ID_TITAN_200EISI	0xA017
 #define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
+#define PCIE_DEVICE_ID_NEO_2_OX_IBM	0x00F6
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1412,7 +1413,7 @@ static struct pci_serial_quirk pci_seria
 		.setup		= pci_default_setup,
 	},
 	/*
-	 * For Oxford Semiconductor and Mainpine
+	 * For Oxford Semiconductor Tornado based devices
 	 */
 	{
 		.vendor		= PCI_VENDOR_ID_OXSEMI,
@@ -1430,6 +1431,14 @@ static struct pci_serial_quirk pci_seria
 		.init		= pci_oxsemi_tornado_init,
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
@@ -3075,6 +3084,14 @@ static struct pci_device_id serial_pci_t
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

