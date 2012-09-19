Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2ISEbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 00:31:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47706 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2ISEbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 00:31:46 -0400
Date: Wed, 19 Sep 2012 14:31:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the usb tree
Message-Id: <20120919143136.46dd2318963c0d8524492041@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Sep_2012_14_31_36_+1000_6_zg4=x9TP1pEa09"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Sep_2012_14_31_36_+1000_6_zg4=x9TP1pEa09
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/usb/serial/vizzini.c: In function 'vizzini_set_termios':
drivers/usb/serial/vizzini.c:454:22: error: invalid type argument of '->' (=
have 'struct ktermios')

Caused by commit c05fecb1d57e ("USB: serial: add vizzini driver")
interacting with commit adc8d746caa6 ("tty: move the termios object into
the tty") from the tty tree.

I added the following merge fix patch and can carry it as necessary:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 19 Sep 2012 14:27:39 +1000
Subject: [PATCH] USB: serial: fix vizzini driver for move of the termios
 object

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/usb/serial/vizzini.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/vizzini.c b/drivers/usb/serial/vizzini.c
index 2ac48fe..253eaf8 100644
--- a/drivers/usb/serial/vizzini.c
+++ b/drivers/usb/serial/vizzini.c
@@ -451,7 +451,7 @@ static void vizzini_set_termios(struct tty_struct *tty_=
param,
 	unsigned int             format_size, format_parity, format_stop, flow, g=
pio_mode;
 	struct tty_struct       *tty =3D port->port.tty;
=20
-	cflag =3D tty->termios->c_cflag;
+	cflag =3D tty->termios.c_cflag;
=20
 	portdata->clocal =3D ((cflag & CLOCAL) !=3D 0);
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__19_Sep_2012_14_31_36_+1000_6_zg4=x9TP1pEa09
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWUqoAAoJEECxmPOUX5FED7AP/0Yyle9P1PxY6Tbj8nF+M8lm
wD3C/9388FFdOk7m9IiAKX97Np/dD/2WroIxEZnOX1r9YE1zOU23OlSFxQ8XLeqW
8sThRLJjrJfcx88GEw+yVxOpcseHIy/S6/vrM5SV5N5Cqw1Tl8FF8qzaxrsiU9nt
XHplBO1a1RaIpBYMdoac/UmX20P0mpGEBzg9yaVR8XZ/EGl8gJ29zNSb+OLPVALz
UV1riJwzuVmHks5XFXV7p1CXXmLhwO6NlyEkHb009QSR9L7vWR8A9cmBsyCL403J
7jTHtXjYeeqO2A/hzkvHNv3JrWpycCB2DKUDqVIlULK3irVpwBe1FMoOuT2Bpwvl
5XYdU5hm1waTZJcQKXVwPNrAdyhJjf6+L+TBY8MiaKbIIf6/zMF8M0DE8KLVfEDp
1qfHYWcpHaqmY7X9oMTTu7C1UhqOuhpk2hGdaiqzUQYH8mWXewBW4Cf1yyWe9GNF
wXpcYVeDPEuF8JCQq7eLCZeN3aGLaqifeyOwqPsIz2Uou7wTEfPM/PpZW5e/ivNn
ZbLGtyM7HQY6Si25yZwyYfFLZIjxze6fjOIWyAolJ2y6rs460XJfv5nV651LoAYj
MQEXXLot12RL0XoF8YLxpcYYBj+Qs20ho9NbpQcubYErneArDKLiWqB6lsyKZbH5
8Gj+/l8Lgjf6gJE9m4wy
=eGF5
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Sep_2012_14_31_36_+1000_6_zg4=x9TP1pEa09--
