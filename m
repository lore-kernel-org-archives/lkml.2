Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2JNOwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:52:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46682 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932180Ab2JNOnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:53 -0400
Message-Id: <20121014143539.400695306@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        =?ISO-8859-15?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 041/147] USB: qcaux: add Pantech vendor class match
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit c638eb2872b3af079501e7ee44cbb8a5cce9b4b5 upstream.

The three Pantech devices UML190 (106c:3716), UML290 (106c:3718) and
P4200 (106c:3721) all use the same subclasses to identify vendor
specific functions.  Replace the existing device specific entries
with generic vendor matching, adding support for the P4200.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Thomas Schäfer <tschaefer@t-online.de>
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/qcaux.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/qcaux.c b/drivers/usb/serial/qcaux.c
index a4edc7e..9b1b96f 100644
--- a/drivers/usb/serial/qcaux.c
+++ b/drivers/usb/serial/qcaux.c
@@ -36,8 +36,6 @@
 #define UTSTARCOM_PRODUCT_UM175_V1		0x3712
 #define UTSTARCOM_PRODUCT_UM175_V2		0x3714
 #define UTSTARCOM_PRODUCT_UM175_ALLTEL		0x3715
-#define PANTECH_PRODUCT_UML190_VZW		0x3716
-#define PANTECH_PRODUCT_UML290_VZW		0x3718
 
 /* CMOTECH devices */
 #define CMOTECH_VENDOR_ID			0x16d8
@@ -68,11 +66,9 @@ static struct usb_device_id id_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(LG_VENDOR_ID, LG_PRODUCT_VX4400_6000, 0xff, 0xff, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SANYO_VENDOR_ID, SANYO_PRODUCT_KATANA_LX, 0xff, 0xff, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_U520, 0xff, 0x00, 0x00) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML190_VZW, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML190_VZW, 0xff, 0xfe, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML290_VZW, 0xff, 0xfd, 0xff) },  /* NMEA */
-	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML290_VZW, 0xff, 0xfe, 0xff) },  /* WMC */
-	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, PANTECH_PRODUCT_UML290_VZW, 0xff, 0xff, 0xff) },  /* DIAG */
+	{ USB_VENDOR_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, 0xff, 0xfd, 0xff) },  /* NMEA */
+	{ USB_VENDOR_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, 0xff, 0xfe, 0xff) },  /* WMC */
+	{ USB_VENDOR_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, 0xff, 0xff, 0xff) },  /* DIAG */
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


