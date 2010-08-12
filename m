Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab0HLAIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:08:12 -0400
Received: from kroah.org ([198.145.64.141]:60482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046Ab0HLAIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:00 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:13 2010
Message-Id: <20100812000613.854304247@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lytochkin Boris <lytboris@gmail.com>,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: [13/67] serial: add support for OX16PCI958 card
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lytochkin Boris <lytboris@gmail.com>

commit e847003f00d5eca3e3b3a6a1199f82b51293faf6 upstream.

Signed-off-by: Lytochkin Boris <lytboris@gmail.com>
Tested-by: Lytochkin Boris <lytboris@gmail.com>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250_pci.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -994,6 +994,7 @@ static int skip_tx_en_setup(struct seria
 #define PCI_DEVICE_ID_TITAN_800E	0xA014
 #define PCI_DEVICE_ID_TITAN_200EI	0xA016
 #define PCI_DEVICE_ID_TITAN_200EISI	0xA017
+#define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1542,6 +1543,8 @@ enum pci_board_num_t {
 	pbn_b2_4_921600,
 	pbn_b2_8_921600,
 
+	pbn_b2_8_1152000,
+
 	pbn_b2_bt_1_115200,
 	pbn_b2_bt_2_115200,
 	pbn_b2_bt_4_115200,
@@ -1960,6 +1963,13 @@ static struct pciserial_board pci_boards
 		.uart_offset	= 8,
 	},
 
+	[pbn_b2_8_1152000] = {
+		.flags		= FL_BASE2,
+		.num_ports	= 8,
+		.base_baud	= 1152000,
+		.uart_offset	= 8,
+	},
+
 	[pbn_b2_bt_1_115200] = {
 		.flags		= FL_BASE2|FL_BASE_BARS,
 		.num_ports	= 1,
@@ -2875,6 +2885,9 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI952,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_bt_2_921600 },
+	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI958,
+		PCI_ANY_ID , PCI_ANY_ID, 0, 0,
+		pbn_b2_8_1152000 },
 
 	/*
 	 * Oxford Semiconductor Inc. Tornado PCI express device range.


