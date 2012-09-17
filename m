Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2IQHbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:31:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60737 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab2IQHbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:31:03 -0400
Date: Mon, 17 Sep 2012 17:31:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the usb tree with the tty tree
Message-Id: <20120917173101.da4643d96b6378c1c9fd1436@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_17_31_01_+1000_kHygcE1qDzCDnIYK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_17_31_01_+1000_kHygcE1qDzCDnIYK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/io_ti.c between commit adc8d746caa6 ("tty: move the
termios object into the tty") from the tty tree and commit 67e6da702753
("USB: serial: io_ti.c: remove dbg() usage") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/io_ti.c
index 765978a,54916d7..0000000
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@@ -2272,9 -2224,8 +2224,8 @@@ static void change_port_settings(struc
 =20
  	config =3D kmalloc (sizeof (*config), GFP_KERNEL);
  	if (!config) {
 -		*tty->termios =3D *old_termios;
 +		tty->termios =3D *old_termios;
- 		dev_err(&edge_port->port->dev, "%s - out of memory\n",
- 								__func__);
+ 		dev_err(dev, "%s - out of memory\n", __func__);
  		return;
  	}
 =20
@@@ -2357,12 -2308,12 +2308,12 @@@
  	/* if we are implementing OUTBOUND XON/XOFF */
  	if (I_IXON(tty)) {
  		config->wFlags |=3D UMP_MASK_UART_FLAGS_OUT_X;
- 		dbg("%s - OUTBOUND XON/XOFF is enabled, XON =3D %2x, XOFF =3D %2x",
- 		     __func__, config->cXon, config->cXoff);
+ 		dev_dbg(dev, "%s - OUTBOUND XON/XOFF is enabled, XON =3D %2x, XOFF =3D =
%2x\n",
+ 			__func__, config->cXon, config->cXoff);
  	} else
- 		dbg("%s - OUTBOUND XON/XOFF is disabled", __func__);
+ 		dev_dbg(dev, "%s - OUTBOUND XON/XOFF is disabled\n", __func__);
 =20
 -	tty->termios->c_cflag &=3D ~CMSPAR;
 +	tty->termios.c_cflag &=3D ~CMSPAR;
 =20
  	/* Round the baud rate */
  	baud =3D tty_get_baud_rate(tty);
@@@ -2408,13 -2358,13 +2358,13 @@@ static void edge_set_termios(struct tty
  	struct edgeport_port *edge_port =3D usb_get_serial_port_data(port);
  	unsigned int cflag;
 =20
 -	cflag =3D tty->termios->c_cflag;
 +	cflag =3D tty->termios.c_cflag;
 =20
- 	dbg("%s - clfag %08x iflag %08x", __func__,
- 	    tty->termios.c_cflag, tty->termios.c_iflag);
- 	dbg("%s - old clfag %08x old iflag %08x", __func__,
- 	    old_termios->c_cflag, old_termios->c_iflag);
- 	dbg("%s - port %d", __func__, port->number);
+ 	dev_dbg(&port->dev, "%s - clfag %08x iflag %08x\n", __func__,
 -		tty->termios->c_cflag, tty->termios->c_iflag);
++		tty->termios.c_cflag, tty->termios.c_iflag);
+ 	dev_dbg(&port->dev, "%s - old clfag %08x old iflag %08x\n", __func__,
+ 		old_termios->c_cflag, old_termios->c_iflag);
+ 	dev_dbg(&port->dev, "%s - port %d\n", __func__, port->number);
 =20
  	if (edge_port =3D=3D NULL)
  		return;

--Signature=_Mon__17_Sep_2012_17_31_01_+1000_kHygcE1qDzCDnIYK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVtG1AAoJEECxmPOUX5FEHBMP/3IK3LUa+FFYfwL+SDdJEp21
YcGFvUM2DVrXWieROvv2s+zM/6ilulf4fcZrmDaY7cyyggb7/rDfmTfYMyNp1Ygg
uF6LRCZlcin8LTA1kGrNHT4qmv1dhxaCy5fOFjCaq3g6Qew00w75ti6KCfl9a/V+
UonytZeHu1epQ8s3SmCorQeo0zIY0jgo1VGP7OnrXfPjCVK5mZ5cB9Ob8XluOXfa
HL0o9NXKzkDxCgGMlpvfzxNpjl7q7tyW0h8jkQtfuXpjGVC5uRSVr1VialhM7pcD
bKHLim/TIfjl9HXWakzVX50XQjKHgsymX4yZZFq8VwBNNArMN8b90sjyFXqHB8YA
XVc38PFJZW1ZggYFVwdU4W7yWJtdnsKqap6wPJQGmhd7ZATk2nEkf5g8ZYEwf+iH
9rYwH9qmp53G8TBG08R7Dsq6Cc/Ejzzq9C9wBBqEtmxHvvChJT0StvgOGtiiL3Fa
zig6SNQhqHTIvhScw1e8B5/QMqfMkddr1YdE0lnjCN8juWJdJna4e5AUcrG8bSdh
88xuJDRJvP0bGEAvNjU9bOxyOyzKmbD4mMk6dTE6WsIL9853NJK5Cj3WIXlLTwFe
D7dW7lRj7LB7g4ezYIjKAbM/GCEWIuWHlEO8Me3laCzoR21QAHJXS/aPfB81XNp/
6kAdssa3BpmcV2lFFa6P
=JX/C
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_17_31_01_+1000_kHygcE1qDzCDnIYK--
