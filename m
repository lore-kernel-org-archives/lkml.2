Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab2EOQFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:05:40 -0400
Received: from ns.omikk.bme.hu ([152.66.114.1]:51560 "EHLO
	webmail.omikk.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896Ab2EOQFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:05:38 -0400
Message-ID: <4FB27ED0.40906@users.sourceforge.net>
Date: Tue, 15 May 2012 18:05:36 +0200
From: Jozsef Marton <jmarton@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Rob Landley <rob@landley.net>, Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
        torvalds@linux-foundation.org
Subject: [PATCH] media: add support to gspca/pac7302.c for 093a:2627 (Genius
 FaceCam 300)
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jozsef Marton <jmarton@users.sourceforge.net>

gspca_pac7302 module supports the webcam with usb id: 093a:2627.
It is a Genius FaceCam 300.
The module does not need any changes but listing the usb id along with a vertical flip flag.
The included patch adds this to the module source.

Signed-off-by: Jozsef Marton <jmarton@users.sourceforge.net>
---
diff -uprN -X dontdiff linux-3.4-rc7-vanilla/Documentation/video4linux/gspca.txt linux-3.4-rc7/Documentation/video4linux/gspca.txt
--- linux-3.4-rc7-vanilla/Documentation/video4linux/gspca.txt	2012-05-13 03:37:47.000000000 +0200
+++ linux-3.4-rc7/Documentation/video4linux/gspca.txt	2012-05-15 16:56:55.603514846 +0200
@@ -276,6 +276,7 @@ pac7302		093a:2622	Genius Eye 312
 pac7302		093a:2624	PAC7302
 pac7302		093a:2625	Genius iSlim 310
 pac7302		093a:2626	Labtec 2200
+pac7302		093a:2627	Genius FaceCam 300
 pac7302		093a:2628	Genius iLook 300
 pac7302		093a:2629	Genious iSlim 300
 pac7302		093a:262a	Webcam 300k
diff -uprN -X dontdiff linux-3.4-rc7-vanilla/drivers/media/video/gspca/pac7302.c linux-3.4-rc7/drivers/media/video/gspca/pac7302.c
--- linux-3.4-rc7-vanilla/drivers/media/video/gspca/pac7302.c	2012-05-13 03:37:47.000000000 +0200
+++ linux-3.4-rc7/drivers/media/video/gspca/pac7302.c	2012-05-15 15:15:03.355624405 +0200
@@ -940,6 +940,7 @@ static const struct usb_device_id device
 	{USB_DEVICE(0x093a, 0x2624), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2625)},
 	{USB_DEVICE(0x093a, 0x2626)},
+	{USB_DEVICE(0x093a, 0x2627), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2628)},
 	{USB_DEVICE(0x093a, 0x2629), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x262a)},
