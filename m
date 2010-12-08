Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab0LHBRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:17:43 -0500
Received: from kroah.org ([198.145.64.141]:33662 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab0LHBDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:18 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:43 2010
Message-Id: <20101208005743.851192067@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [224/289] [media] saa7134: Fix autodetect for Behold A7 and H7 TV cards
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitri Belimov <d.belimov@gmail.com>

commit 35bbe587d0959712b69540077c9e0fd27d3e6baf upstream.

The entries for those cards are after the generic entries,
so they don't work, in practice. Moving them to happen before the
generic entres fix the issue.

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/saa7134/saa7134-cards.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -6661,6 +6661,18 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subdevice    = 0x2804,
 		.driver_data  = SAA7134_BOARD_TECHNOTREND_BUDGET_T3000,
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
@@ -6698,18 +6710,6 @@ struct pci_device_id saa7134_pci_tbl[] =
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


