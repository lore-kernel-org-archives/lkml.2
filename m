Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1EBRAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:00:36 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:55685 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab1EBRAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:00:35 -0400
Date: Mon, 2 May 2011 18:59:50 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        hirofuchi@users.sourceforge.net, arjan.mels@gmx.net, rjw@sisk.pl,
        Stanislav SCHATTKE <schattke@linuxbox.cz>
Subject: Re: [regression?] d199c96d41d80a567493e12b8e96ea056a1350c1 breaks
	usbip
Message-ID: <20110502165950.GA2550@nik-comp.lan>
References: <20110501192725.GA28466@kroah.com> <Pine.LNX.4.44L0.1105021008491.2106-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1105021008491.2106-100000@iolanthe.rowland.org>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5072169 records (last update: 20110502)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Here's a patch which should fix the problem.  Nikola, can you test it?
>=20
> Alan Stern
>=20
>=20
>=20
> Index: usb-2.6/drivers/staging/usbip/vhci_hcd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-2.6.orig/drivers/staging/usbip/vhci_hcd.c
> +++ usb-2.6/drivers/staging/usbip/vhci_hcd.c
> @@ -1139,7 +1139,7 @@ static int vhci_hcd_probe(struct platfor
>  		usbip_uerr("create hcd failed\n");
>  		return -ENOMEM;
>  	}
> -
> +	hcd->has_tt =3D 1;
> =20
>  	/* this is private data for vhci_hcd */
>  	the_controller =3D hcd_to_vhci(hcd);
>=20
Yes, it does!
thanks Alan! I'll now try bisect as Greg suggested to see where usbip got b=
roken in latest git...
Greg, will You please push this to stable once it reaches upstream?
cheers!
n.



--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2+4wYACgkQ3xdJJrLygV5eNACg6L0aavHPYe6FdjOkGJIxCe9v
/QUAn0TCg2ZJ+FqQ1DLraVwz1wg/8jxF
=6nI0
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
