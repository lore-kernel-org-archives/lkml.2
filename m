Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0LLXr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36574 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab0LLXry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:54 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: d.belimov@gmail.com, d.belimov@gmail.com, mchehab@redhat.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [169/223] saa7134: Fix autodetect for Behold A7 and H7 TV cards
Message-Id: <20101212234753.96C4FB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dmitri Belimov <d.belimov@gmail.com>

commit 35bbe587d0959712b69540077c9e0fd27d3e6baf upstream.

The entries for those cards are after the generic entries,
so they don't work, in practice. Moving them to happen before the
generic entres fix the issue.

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/saa7134/saa7134-cards.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

Index: linux/drivers/media/video/saa7134/saa7134-cards.c
===================================================================
--- linux.orig/drivers/media/video/saa7134/saa7134-cards.c
+++ linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -6631,6 +6631,18 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subdevice    = 0x6655,
 		.driver_data  = SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7190,
+		.driver_data  = SAA7134_BOARD_BEHOLD_H7,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
+		.subdevice    = 0x7090,
+		.driver_data  = SAA7134_BOARD_BEHOLD_A7,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -6668,18 +6680,6 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subvendor    = PCI_ANY_ID,
 		.subdevice    = PCI_ANY_ID,
 		.driver_data  = SAA7134_BOARD_UNKNOWN,
-	}, {
-		.vendor       = PCI_VENDOR_ID_PHILIPS,
-		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
-		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
-		.subdevice    = 0x7190,
-		.driver_data  = SAA7134_BOARD_BEHOLD_H7,
-	}, {
-		.vendor       = PCI_VENDOR_ID_PHILIPS,
-		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
-		.subvendor    = 0x5ace, /* Beholder Intl. Ltd. */
-		.subdevice    = 0x7090,
-		.driver_data  = SAA7134_BOARD_BEHOLD_A7,
 	},{
 		/* --- end of list --- */
 	}
