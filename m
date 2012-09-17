Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2IQHbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:31:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35711 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2IQHa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:30:59 -0400
Date: Mon, 17 Sep 2012 17:30:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the usb tree with the tty tree
Message-Id: <20120917173050.37b0c68a7a371017d0ed73ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_17_30_50_+1000_3aQB.5YGLX6UAZ8m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_17_30_50_+1000_3aQB.5YGLX6UAZ8m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/mos7840.c between commit adc8d746caa6 ("tty: move the
termios object into the tty") from the tty tree and commit 9c134a14f2da
("USB: serial: mos7840.c: remove dbg() usage") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/mos7840.c
index 402c32d,ffbe4ee..0000000
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@@ -2159,15 -2086,15 +2086,15 @@@ static void mos7840_set_termios(struct=20
  		return;
  	}
 =20
- 	dbg("%s", "setting termios - ");
+ 	dev_dbg(&port->dev, "%s", "setting termios - \n");
 =20
 -	cflag =3D tty->termios->c_cflag;
 +	cflag =3D tty->termios.c_cflag;
 =20
- 	dbg("%s - clfag %08x iflag %08x", __func__,
- 	    tty->termios.c_cflag, RELEVANT_IFLAG(tty->termios.c_iflag));
- 	dbg("%s - old clfag %08x old iflag %08x", __func__,
- 	    old_termios->c_cflag, RELEVANT_IFLAG(old_termios->c_iflag));
- 	dbg("%s - port %d", __func__, port->number);
+ 	dev_dbg(&port->dev, "%s - clfag %08x iflag %08x\n", __func__,
 -		tty->termios->c_cflag, RELEVANT_IFLAG(tty->termios->c_iflag));
++		tty->termios.c_cflag, RELEVANT_IFLAG(tty->termios.c_iflag));
+ 	dev_dbg(&port->dev, "%s - old clfag %08x old iflag %08x\n", __func__,
+ 		old_termios->c_cflag, RELEVANT_IFLAG(old_termios->c_iflag));
+ 	dev_dbg(&port->dev, "%s - port %d\n", __func__, port->number);
 =20
  	/* change the port settings to the new ones specified */
 =20

--Signature=_Mon__17_Sep_2012_17_30_50_+1000_3aQB.5YGLX6UAZ8m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVtGqAAoJEECxmPOUX5FEOskP/i+4gefK3iaqns5jpDZTN/qr
vrQXExg9cRpoXb4xczF09QNYhl3KDIld16xiR8SE87m4shao81oAQes5PAKTBO6n
+Y34sayDA42FtmqAKLOEATJmE1GbJ5LoTN8sPehqguZnzdoTfWIDn9f2XO+yAoG6
NSi8cN5P/XrBcOE/ypgLblT8XHWGcgJqs4GS1dq+ruJgUinRI9+Jxj7oLVgSII+j
+lYg2jfz7q6ARlzPr6J3EY1WLVrK8FSFKqionHB74o7me+ijFXRyarNv06RrktHU
JKoHgm13lnHkP4uObiS8tziZodmjSxBX5a4mrdz3oRdCHhjoaqvPRcWJon1qGqKB
PYPfiqx7iUnZoDGTWozOlu5NGaHXOp4eoNnIRgrQI90prAyRKjkoZdQw97QT7lGW
arRpp/FFHwqEfFS70lz/RrcCCPSFvempHD4ZVTnbk54Ll5mB3sfz/GNrbCB+nK98
SCWGulc4qq2ZGfTDd1O9gPs4Q9IxKRiusL52cL/YSzJYTRjNfUoI9lulgx+JXrmm
kZFYFMfWXQhD8mya9aDZPXrhqypGXFjx6x7neYWMIRwZ/C6Z/8u4CHxnTMPSmCsE
vSJsb0JLZP58H+DKfZiq71qsS9AUB5wKDQJlN5V7n/QzfsHe1JMp5J74eOrOulWr
K2fV0Dj7/i15cjp/mCcX
=uyMO
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_17_30_50_+1000_3aQB.5YGLX6UAZ8m--
