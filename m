Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1DYUW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:22:57 -0400
Received: from 1wt.eu ([62.212.114.60]:33684 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1DYUW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:22:56 -0400
Message-Id: <20110425200233.948162234@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 022/173] USB: serial: pl2303: Hybrid reader Uniform HCR331
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Simone Contini <s.contini@oltrelinux.com>

commit 18344a1cd5889d48dac67229fcf024ed300030d5 upstream.

I tried a magnetic stripe reader
(http://www.kimaldi.com/kimaldi_eng/productos/lectores_de_tarjetas/lectores_tarjeta_chip_y_dni/lector_hibrido_uniform_hcr_331)
and I see that it is interfaced with a PL2303. I wrote a patch to use
your driver which simply adds the product ID for the device and it
seems working fine.


From: Simone Contini <s.contini@oltrelinux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -59,6 +59,7 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_ALDIGA) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MMX) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_GPRS) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_HCR331) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_RSAQ5) },
 	{ USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -20,6 +20,7 @@
 #define PL2303_PRODUCT_ID_ALDIGA	0x0611
 #define PL2303_PRODUCT_ID_MMX		0x0612
 #define PL2303_PRODUCT_ID_GPRS		0x0609
+#define PL2303_PRODUCT_ID_HCR331	0x331a
 
 #define ATEN_VENDOR_ID		0x0557
 #define ATEN_VENDOR_ID2		0x0547


