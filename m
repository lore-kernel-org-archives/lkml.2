Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0FDUtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:49:05 -0400
Received: from kroah.org ([198.145.64.141]:44039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab0FDUsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:48:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Yegor Yefremov <yegor_sub1@visionsystems.de>,
       Yegor Yefremov <yegorslists@googlemail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/11] serial: add support for various Titan PCI cards
Date: Fri,  4 Jun 2010 13:47:57 -0700
Message-Id: <1275684477-20172-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204445.GB19761@kroah.com>
References: <20100604204445.GB19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yegor Yefremov <yegor_sub1@visionsystems.de>

serial: add support for various Titan PCI cards

Models: 200I, 400I, 800I, 400EH, 800EH, 800EHB,
        100E, 200E, 400E, 800E, 200EI, 200EISI

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250_pci.c |   71 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 01c012d..746a446 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -982,6 +982,18 @@ static int skip_tx_en_setup(struct serial_private *priv,
 #define PCI_SUBDEVICE_ID_POCTAL422	0x0408
 #define PCI_VENDOR_ID_ADVANTECH		0x13fe
 #define PCI_DEVICE_ID_ADVANTECH_PCI3620	0x3620
+#define PCI_DEVICE_ID_TITAN_200I	0x8028
+#define PCI_DEVICE_ID_TITAN_400I	0x8048
+#define PCI_DEVICE_ID_TITAN_800I	0x8088
+#define PCI_DEVICE_ID_TITAN_800EH	0xA007
+#define PCI_DEVICE_ID_TITAN_800EHB	0xA008
+#define PCI_DEVICE_ID_TITAN_400EH	0xA009
+#define PCI_DEVICE_ID_TITAN_100E	0xA010
+#define PCI_DEVICE_ID_TITAN_200E	0xA012
+#define PCI_DEVICE_ID_TITAN_400E	0xA013
+#define PCI_DEVICE_ID_TITAN_800E	0xA014
+#define PCI_DEVICE_ID_TITAN_200EI	0xA016
+#define PCI_DEVICE_ID_TITAN_200EISI	0xA017
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1541,6 +1553,10 @@ enum pci_board_num_t {
 	pbn_b3_4_115200,
 	pbn_b3_8_115200,
 
+	pbn_b4_bt_2_921600,
+	pbn_b4_bt_4_921600,
+	pbn_b4_bt_8_921600,
+
 	/*
 	 * Board-specific versions.
 	 */
@@ -1995,6 +2011,25 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.uart_offset	= 8,
 	},
 
+	[pbn_b4_bt_2_921600] = {
+		.flags		= FL_BASE4,
+		.num_ports	= 2,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[pbn_b4_bt_4_921600] = {
+		.flags		= FL_BASE4,
+		.num_ports	= 4,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[pbn_b4_bt_8_921600] = {
+		.flags		= FL_BASE4,
+		.num_ports	= 8,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+
 	/*
 	 * Entries following this are board-specific.
 	 */
@@ -3043,6 +3078,42 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_800L,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_bt_8_921600 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200I,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b4_bt_2_921600 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_400I,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b4_bt_4_921600 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_800I,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b4_bt_8_921600 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_400EH,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_4_921600 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_800EH,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_4_921600 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_800EHB,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_4_921600 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_100E,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_oxsemi_1_4000000 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200E,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_oxsemi_2_4000000 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_400E,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_oxsemi_4_4000000 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_800E,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_oxsemi_8_4000000 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200EI,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_oxsemi_2_4000000 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200EISI,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_oxsemi_2_4000000 },
 
 	{	PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_1S_10x_550,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-- 
1.7.1

