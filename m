Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030446Ab2LIJa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 04:30:27 -0500
Received: from mail.locum.ru ([193.106.93.111]:33903 "EHLO mail.locum.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964910Ab2LIJaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 04:30:19 -0500
X-Greylist: delayed 1357 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2012 04:30:19 EST
Message-ID: <50C454DC.4070207@ubuntu.com>
Date: Sun, 09 Dec 2012 16:07:40 +0700
From: Maia Kozheva <sikon@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB Wi-Fi
 adapter
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-As: maia@lucidfox.org 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

D-Link DWA-125/B1 is a relatively new USB Wi-Fi adapter, using a Ralink chipset supported by the rt2800usb driver. Currently, to work around the problem (it's missing in all present kernel versions, up to and including 3.7.x), I had to add this to /etc/rc.local:

echo 2001 3c1e >> /sys/bus/usb/drivers/rt2800usb/new_id

After that, the device works without problems. Been using it for over a week with no bugs in sight.

The attached patch is trivial and simply adds the new USB ID to the list of devices handled by rt2800usb.


Signed-off-by: Maia Kozheva <sikon@ubuntu.com>
diff -uprN a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
- --- a/drivers/net/wireless/rt2x00/rt2800usb.c	2012-12-09 15:30:39.051951506 +0700
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c	2012-12-09 15:31:07.679951314 +0700
@@ -965,6 +965,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c16) },
 	{ USB_DEVICE(0x2001, 0x3c1b) },
+	{ USB_DEVICE(0x2001, 0x3c1e) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
 	/* DVICO */

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBCAAGBQJQxFTcAAoJEDqDNnQ69yYSg1IIAJbBDufuf1Jp+0flTqrEv9Ti
21g8xQA7f825GreObXW75BOYhP/qtiQm/cYwIBaKn9HsX3HIAShiHJPdlvU8I6hZ
XqOevb8xyqZTOHdub+hM+38eS8DFYiskD72FJL92W0I+/zAusPaos55lECQE8jK1
h+f81f3p97BjxoKgEaR75sDTEuN1NAaobQjbCEd2x12TQqEqBDq213b/VP3rPhBM
+G5mM3QgHYGu8lxndIEcftunRd6G7wrbWe6pU5O2OpkFrwL48ODgdqWCQY/JvHI4
C7kxYyb0e3D+CtAjIzDaTWi8VYlp4FbMcLO+HY0Idnm5EFgeakTCI6QkHjk41wM=
=v9kT
-----END PGP SIGNATURE-----
