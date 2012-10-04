Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946324Ab2JDV1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:27:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42952 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946298Ab2JDV1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:27:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        =?UTF-8?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        Dan Williams <dcbw@redhat.com>
Subject: =?UTF-8?q?=5B=2005/33=5D=20USB=3A=20qcaux=3A=20add=20Pantech=20vendor=20class=20match?=
Date: Thu,  4 Oct 2012 14:26:27 -0700
Message-Id: <20121004210559.129822522@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210558.383865383@linuxfoundation.org>
References: <20121004210558.383865383@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/qcaux.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

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
@@ -68,11 +66,9 @@ static struct usb_device_id id_table[] =
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


