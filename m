Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab2ISEQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 00:16:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49365 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2ISEQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 00:16:44 -0400
Date: Wed, 19 Sep 2012 14:16:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the usb tree with the tty tree
Message-Id: <20120919141636.99298d4d5e8501ec377e5594@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Sep_2012_14_16_36_+1000_FBBjimUCklRIAPes"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Sep_2012_14_16_36_+1000_FBBjimUCklRIAPes
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/io_edgeport.c between commit adc8d746caa6 ("tty: move
the termios object into the tty") from the tty tree and commit
984f68683298 ("USB: serial: io_edgeport.c: remove dbg() usage") from the
usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/io_edgeport.c
index f435575,75b7ccd..0000000
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@@ -1516,13 -1497,9 +1497,9 @@@ static void edge_set_termios(struct tty
  	struct edgeport_port *edge_port =3D usb_get_serial_port_data(port);
  	unsigned int cflag;
 =20
 -	cflag =3D tty->termios->c_cflag;
 -	dev_dbg(&port->dev, "%s - clfag %08x iflag %08x\n", __func__, tty->termi=
os->c_cflag, tty->termios->c_iflag);
 +	cflag =3D tty->termios.c_cflag;
- 	dbg("%s - clfag %08x iflag %08x", __func__,
- 	    tty->termios.c_cflag, tty->termios.c_iflag);
- 	dbg("%s - old clfag %08x old iflag %08x", __func__,
- 	    old_termios->c_cflag, old_termios->c_iflag);
-=20
- 	dbg("%s - port %d", __func__, port->number);
++	dev_dbg(&port->dev, "%s - clfag %08x iflag %08x\n", __func__, tty->termi=
os.c_cflag, tty->termios.c_iflag);
+ 	dev_dbg(&port->dev, "%s - old clfag %08x old iflag %08x\n", __func__, ol=
d_termios->c_cflag, old_termios->c_iflag);
 =20
  	if (edge_port =3D=3D NULL)
  		return;

--Signature=_Wed__19_Sep_2012_14_16_36_+1000_FBBjimUCklRIAPes
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWUckAAoJEECxmPOUX5FExGYP/0KaebfE9uv4saZk1MJJHRrr
Z4RsoyYK8qF2Woez1z/6ZnnKB2rpPImqLv7/0qr+3XbPH/KSwSzh3dCe8tut37W+
5L7Cwo9e5LMuolq9e5MAnOno8aXHh6LNCIUz888XLeLRQ5PKfA3Vgqr8G6qtXNFt
FbjFySutIH2lCNTdwuUMHY810hAE0DOcHsnYU88I10RiO1zI8w5CQqjxtlcPgwl2
2mBbmmKOREAHPMh5DtfFCLIVpviqmdXChkpjBvB4Km1Cl94duBpBffuvSPadXWic
rDEkrgMDH17oUAQSA4Y6uS57icA/SOZx1K7Dy/JgIjYwpupFrDtv2ia5fMiCppm/
3EQ48/d4PpyyJoNPPpkWehpQj+fslH7iskQKQr7Mpk6WHEowSQppK2MIDQMIXVzM
CUuDLIAMl85rPxgm+qKubNmuZ/JoaupR5205t/k6vHGY2AHlU9dieZCSwE7ZliJg
wz1ApSeNIVQQbm8M351kgwj9fU36U5vQxkT9fu3pJoDgil27DXRQI9ev6CERTWm3
8cJzhhVi7C6xJDI2EOUOihS/YjpQPYn7kQwsiy4bZJW49SyXRK6c9QJktufpCU6i
wE6j4KstUR8FG6N3BbBXlJi1q5bXFN/DjoeOalrm54B8nn5nOrBTYHIwGLsMSHqt
u2tiKJMRpFdPBawH7ZSN
=xig0
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Sep_2012_14_16_36_+1000_FBBjimUCklRIAPes--
