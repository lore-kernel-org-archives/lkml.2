Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2GTDdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:33:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53391 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2GTDdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:33:51 -0400
Date: Fri, 20 Jul 2012 13:33:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20120720133349.b71eeca40aa1758a12725dea@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Jul_2012_13_33_49_+1000_s8hXdft_=Kmird.T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jul_2012_13_33_49_+1000_s8hXdft_=Kmird.T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/staging/serqt_usb2/serqt_usb2.c: In function 'qt_set_termios':
drivers/staging/serqt_usb2/serqt_usb2.c:1198:29: error: incompatible types =
when initializing type 'struct ktermios *' using type 'struct ktermios'
drivers/staging/serqt_usb2/serqt_usb2.c:1304:14: error: invalid type argume=
nt of '->' (have 'struct ktermios')

Presumably caused by commit adc8d746caa6 ("tty: move the termios object
into the tty").

Under previous instructions about staging drivers, I have added the
following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 Jul 2012 13:31:39 +1000
Subject: [PATCH] disable USB_SERIAL_QUATECH2 broken by tty update

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/serqt_usb2/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/serqt_usb2/Kconfig b/drivers/staging/serqt_usb=
2/Kconfig
index f4fed40..dc624a4 100644
--- a/drivers/staging/serqt_usb2/Kconfig
+++ b/drivers/staging/serqt_usb2/Kconfig
@@ -1,6 +1,7 @@
 config USB_SERIAL_QUATECH2
 	tristate "USB Quatech ESU-100 8 Port Serial Driver"
 	depends on USB_SERIAL
+	depends on BROKEN
 	help
 	  Say Y here if you want to use the Quatech ESU-100 8 port usb to
 	  serial adapter.
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Jul_2012_13_33_49_+1000_s8hXdft_=Kmird.T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQCNGdAAoJEECxmPOUX5FEgagP/2ICWrLFVTbDarB+cTC9fsqP
C/bFL1Za2HzaMxLPKx7V1faG2LUyN02yMt+jSE0opZeKfNtBYMGBOEFB0zx0CRul
i6Prwkv+aeMmJwtjC67Tb7d9pfqlt2lWGQYacvcw6Aclnf3JFinYurrTteRi8Tx7
lPcI8Uf7K2OihcllsY8jCyPpi1BAwBxpIw+V4mAujjo9rV/tOx4ql1vWhyWGMGH+
2oT+abHYk2iw2LKHQ2nJn1l3h5/r75BreGirXkymtuBCuiIZQN1RBdgrYN/Mqhhu
hyNylUgfwW7mnxPutpOdahdwgvwK8IhceNmbCUiZdPYvzWmL30JlRteNOAw/N7ke
hyBsJuJjCO11K4gxLPESA16KfR6MlOERb7tHsBN1kY18PUe4Y88lITJ8Qi22KBVE
P+VOB0dl2AsC4XWQrZNT5wRkw2/FjhLwhdb6JMOxtbInXPVdNtHApdjyC3PW1Zld
Nibr6sBorUBPTjOtiRMFC/jGwTZcKXZnJhCVUe3CL43hhxQnGin4wi/QUzjcBPBb
39wvjrKrqQNvWUPxBtR8pZ0/iht24nEl6k2u3x/CbWO3ETON7DI9NcgG+xvgz8x+
CtJ9Ulxj8Q92z4WYM5/3LwbNeTUOP3zqS+jBEUsOw8O+UyozZLsakDgtYrERlkak
wGajCS2SBijf6MifpA9T
=L0Ea
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jul_2012_13_33_49_+1000_s8hXdft_=Kmird.T--
