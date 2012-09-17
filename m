Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2IQHbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:31:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50751 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2IQHbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:31:05 -0400
Date: Mon, 17 Sep 2012 17:31:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the usb tree with the tty tree
Message-Id: <20120917173103.9805531382847454e2d59bb8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_17_31_03_+1000_9dnvO4uvfkXvDEu9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_17_31_03_+1000_9dnvO4uvfkXvDEu9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/digi_acceleport.c between commit adc8d746caa6 ("tty:
move the termios object into the tty") from the tty tree and commit
f9dfbebb8b39 ("USB: serial: digi_acceleport.c: remove dbg() usage") from
the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/digi_acceleport.c
index afd9d2e,d3a8941..0000000
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@@ -687,8 -685,9 +685,9 @@@ static void digi_set_termios(struct tty
  		struct usb_serial_port *port, struct ktermios *old_termios)
  {
  	struct digi_port *priv =3D usb_get_serial_port_data(port);
+ 	struct device *dev =3D &port->dev;
 -	unsigned int iflag =3D tty->termios->c_iflag;
 -	unsigned int cflag =3D tty->termios->c_cflag;
 +	unsigned int iflag =3D tty->termios.c_iflag;
 +	unsigned int cflag =3D tty->termios.c_cflag;
  	unsigned int old_iflag =3D old_termios->c_iflag;
  	unsigned int old_cflag =3D old_termios->c_cflag;
  	unsigned char buf[32];

--Signature=_Mon__17_Sep_2012_17_31_03_+1000_9dnvO4uvfkXvDEu9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVtG3AAoJEECxmPOUX5FEXNUP+wXNVkPoEStrtGvh+SsSaoTS
i1xoH2hlDeTyjvrcrMEpQ4cY3BZeOXX707exbhoJO2owIxjUUc8shrnRpXBeuMoh
nfCCujhYAXQHQjjGNv5ssJC2kbELx5Sr7upip+pkmlrlPAhJh9rF0C8PppwJLO97
Ny/QelNoqdhwpTcquTW70iwvHVEgKKmOCMRKWkIA3TCjOb9xcjU4os2hY2Mffw0C
OfWRcbToStgoTfyB+c9U0z9Yi+fnVpYhfxpNoM0nNL8KLmBTCbl22w3vtmDjgztZ
nEy4r/cB6tqFDvN+DeWZkYoX3O/0Mcu04aRYpygwdDJs2QcBXLh6ybtrhDM4FW+n
xJJGKZd34ur8D61JY/kS+zljBEHR/nLzmIYlnvc0UtAkema7+GkvvnYgsmKvREka
T5crf+tmGRYsnP+tidmwTlUsleiGEg8w5nKGJqqrgZjcHNP7yNzpZkhlQs+kHTqy
2LkLedD+gsPbHNQk8Y4Rllxqe7szwePKv8sseRGhv/0JGRwDtWgWdCt8mW/XCRaR
yKEIQj3rKcHku480UaNW83JOIb5SkoBFa12+rh92Orp8LF6N2VwTT9xjjjvs+GgO
FdUBUBQlSKLxSV0+IQzWuUMBJAYjqVo/1xXEoeslb3cahuHM+Zd91brSGEG82sys
iJc5TX26SN4Cv5EdsJq/
=ISZi
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_17_31_03_+1000_9dnvO4uvfkXvDEu9--
