Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2IQHch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:32:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48344 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2IQHbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:31:00 -0400
Date: Mon, 17 Sep 2012 17:30:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the usb tree with the tty tree
Message-Id: <20120917173058.e4d3f65bdc3751283766295c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_17_30_58_+1000_69.pOhoOXKU2aRBi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_17_30_58_+1000_69.pOhoOXKU2aRBi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/mos7720.c between commit adc8d746caa6 ("tty: move the
termios object into the tty") from the tty tree and commit 9eecf8085473
("USB: serial: mos7720.c: remove dbg() usage") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/mos7720.c
index 012f67b,192191c..0000000
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@@ -1751,19 -1708,15 +1708,15 @@@ static void mos7720_set_termios(struct=20
  		return;
  	}
 =20
- 	dbg("%s\n", "setting termios - ASPIRE");
+ 	dev_dbg(&port->dev, "setting termios - ASPIRE\n");
 =20
 -	cflag =3D tty->termios->c_cflag;
 +	cflag =3D tty->termios.c_cflag;
 =20
- 	dbg("%s - cflag %08x iflag %08x", __func__,
- 	    tty->termios.c_cflag,
- 	    RELEVANT_IFLAG(tty->termios.c_iflag));
+ 	dev_dbg(&port->dev, "%s - cflag %08x iflag %08x\n", __func__,
 -		tty->termios->c_cflag, RELEVANT_IFLAG(tty->termios->c_iflag));
++		tty->termios.c_cflag, RELEVANT_IFLAG(tty->termios.c_iflag));
 =20
- 	dbg("%s - old cflag %08x old iflag %08x", __func__,
- 	    old_termios->c_cflag,
- 	    RELEVANT_IFLAG(old_termios->c_iflag));
-=20
- 	dbg("%s - port %d", __func__, port->number);
+ 	dev_dbg(&port->dev, "%s - old cflag %08x old iflag %08x\n", __func__,
+ 		old_termios->c_cflag, RELEVANT_IFLAG(old_termios->c_iflag));
 =20
  	/* change the port settings to the new ones specified */
  	change_port_settings(tty, mos7720_port, old_termios);

--Signature=_Mon__17_Sep_2012_17_30_58_+1000_69.pOhoOXKU2aRBi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVtGyAAoJEECxmPOUX5FEkL4P/3rMOnZnWZpJt4FSWOaqwYjH
ETNmGMrnoi1bpoEfHbYdtoEDk9q2NqIKINRqjJyDfpUC05mtK0awM9lLBwJYBdGG
DWkB7zwJ41LM/uN5Ho/TqUHvQMNOO0CGaLeBYz3INO98x0C7XLwGUmAbZei0NiXn
183GKDwyLxphLJW/cGXhPJGXYfTZ+mGmuVALzVCAUS4/nfmDiOXyxD7h/xa2gYZM
CXkLrliO69VBakPdv3BDgWmkNm67S1JJzBtgAJu5jklR2HbtKkiN/k6J9+kpV1d9
NZSD1unnqNvmil/R620+z1RGULb49KO3UDI8WVjtqJMfmCi/PrMTa53wDlZPrfSt
cJzKAG7H2UI0Xvyrum2H2EtJHf63MytaX4W0LO/+Rd3aTZyxaR959ag96ecG1LmY
EX2RWp3zIal4hWioZ0EjfkGCel1fG4EQACvLYL+yVIgANotnGA7pWqJ85zUPlnsn
t1B2mK6QSA59hw/cKsRC9/UsSLHtlETqrbpOut4WebB88u6VsS/EeXl38I9IerxO
QXa73meTrrnQ+XwLpApnxcblU/KrzINcuk8nqYRaOTVhXwjpiSDKNjcQz2I+4OUG
ISbB96cOrrpGOnploQU+kZItlYwwTxnvqW+k+8AuPdj2By0KsFhPSuW1viHO/fzQ
ohZSkHCB33jxwgSzs93a
=NvpF
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_17_30_58_+1000_69.pOhoOXKU2aRBi--
