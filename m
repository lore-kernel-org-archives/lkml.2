Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2IQHbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:31:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60557 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2IQHbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:31:02 -0400
Date: Mon, 17 Sep 2012 17:31:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the usb tree with the tty tree
Message-Id: <20120917173100.d41ffb2280225753f3a1d1d1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_17_31_00_+1000_5980ZcD+CN06qIm4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_17_31_00_+1000_5980ZcD+CN06qIm4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/kl5kusb105.c between commit adc8d746caa6 ("tty: move
the termios object into the tty") from the tty tree and commit
1ad7604f69ae ("USB: serial: kl5kusb105.c: remove dbg() usage") from the
usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/kl5kusb105.c
index def9ad2,e4aa6c0..0000000
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@@ -445,9 -445,10 +445,10 @@@ static void klsi_105_set_termios(struc
  				 struct ktermios *old_termios)
  {
  	struct klsi_105_private *priv =3D usb_get_serial_port_data(port);
+ 	struct device *dev =3D &port->dev;
 -	unsigned int iflag =3D tty->termios->c_iflag;
 +	unsigned int iflag =3D tty->termios.c_iflag;
  	unsigned int old_iflag =3D old_termios->c_iflag;
 -	unsigned int cflag =3D tty->termios->c_cflag;
 +	unsigned int cflag =3D tty->termios.c_cflag;
  	unsigned int old_cflag =3D old_termios->c_cflag;
  	struct klsi_105_port_settings *cfg;
  	unsigned long flags;

--Signature=_Mon__17_Sep_2012_17_31_00_+1000_5980ZcD+CN06qIm4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVtG0AAoJEECxmPOUX5FEpuIP/1pLGjzxIbat9O3/DgHtl5Mw
29mRa7QcNiXIARlcq5i7JUbBcdetRCHzO2tT5SOLLhykzNWvoQI8PtewzE4xOcU6
kUgeCBak09gWm9xddsYedFWO76m7Lorl1v8cO1gAHJJYu2oln4vdBvc5A/S5sYy2
KlxjYsh5lQakxDwp3bucXyOuvpMlHQzXhvMlMAqaD2rbkD4xIfbfCFGSagjn/F5b
NOcvZthISMop79VECaLu0alhqLcsNIasuwkUGLwatP3kFTbebCEiG0YmQ1SeJbzy
TGhYr7rd5DV6zq/vFP6Y5DXGz81h5Zf9DEFmh+VS6ylVPJeALsFrrv+9QYusWVDr
s+W/YztFSKlGiPAb1pxr78FsQwOCsMWczAMJzSs+1Va1ByOmidfnsmJinYynYOyF
BQfjd8SNBMlUcMKV4CCF3IIukMCPVqf/jm6x7PLVxupE/UEy/S6VZuFV+hXgZi7c
DjfZ7bfUG+vXzGyzhjk94tjgR2G9ebBLnDj9HsqIsrXpI1koQmctf1vPF0tvm41Z
PTrSDb3CnMmx2b4PhT8bQOGboEshZ2Nny45zmW+RzVEbMxxiMfXuRBSQUkSy1KG8
Mi5ApNhQrH2GVGf4wVU6I8TPLP6pLVhnKzl6D63K+ldfCBkIC3mmRjBGusVKXEdD
6clgemS7uwoIGWPMl4lO
=lOlf
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_17_31_00_+1000_5980ZcD+CN06qIm4--
