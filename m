Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1KSRWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 12:22:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57788 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab1KSRWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 12:22:32 -0500
Message-ID: <1321723330.2885.145.camel@deadeye>
Subject: Re: [17/26] b43: refuse to load unsupported firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, greg@kroah.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, roman-vl@meta.ua,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Sat, 19 Nov 2011 17:22:10 +0000
In-Reply-To: <20111119000329.419617905@clark.kroah.org>
References: <20111119000329.419617905@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-7pTkfw2jr7NOBXYU6h1w"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7pTkfw2jr7NOBXYU6h1w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-11-18 at 16:02 -0800, Greg KH wrote:
> 3.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> [This patch is supposed to be applied in 3.1 (and maybe older) branches o=
nly.]
>=20
> New kernels support newer firmware that users may try to incorrectly use
> with older kernels. Display error and explain the problem in such a case
>=20
> Signed-off-by: Rafa=C3=85=C2=82 Mi=C3=85=C2=82ecki <zajec5@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  drivers/net/wireless/b43/main.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -2508,6 +2508,13 @@ static int b43_upload_microcode(struct b
>  		b43_print_fw_helptext(dev->wl, 1);
>  		err =3D -EOPNOTSUPP;
>  		goto error;
> +	} else if (fwrev >=3D 598) {
> +		b43err(dev->wl, "YOUR FIRMWARE IS TOO NEW. Support for "
> +		       "firmware 598 and up requires kernel 3.2 or newer. You "
> +		       "have to install older firmware or upgrade kernel.\n");
> +		b43_print_fw_helptext(dev->wl, 1);
> +		err =3D -EOPNOTSUPP;
> +		goto error;
[...]

Again, I strongly object to this way of handling the incompatibility.
The revision check is fine, but the solution must be to assign a
different filename for the newer revisions.  The changes to 3.0/3.1
should be deferred until this is resolved.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-7pTkfw2jr7NOBXYU6h1w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATsflwue/yOyVhhEJAQoCxQ/+LyPm8CYGaZS2PqwImKx0IVIi8yo8FHr+
Ylsf6YqJKwA80dsXqdXS/DHVEzhIuaO1KZl9eJdxoQSN1fSfLzEdPuA+8fIquqVd
Ms3AviWpwkXzRX2tkrVcjKoaVlrfkAczkubmto3O3Xj7rRtCfayJhXuI6zuhWHVw
7TlDOX8CFTKYMglYyIZgFG+w89HF7eXKmm8pPhE+G80aULbfe/GpD9adjw7/n2Jn
17LcuslbaP6OSwx0CvgIfE5elXtlblcsiYzRktiQZaZKL0vWptfHNxGExfjpHl3O
K0HXBakNvuFsMaxmNsrdpMz9GK3iTzfOdjW2x9ZAJXLAnZiszoI4ALPqdHgnEJrY
qTFJjH4Y7tQ+DB8t+dqWT3bDiJTz2exHN4blGc1z+YowJ5uuw54iM5SgpYREn8fc
Bc/nZrDoSOUYHzqq0htcxtYeQm8GxjzS+a/qFZnP5bm8CW56fDDEFvJdH04todR6
oYSskXZHSTQbUvzmi1EtsWukVBC8YBltBBE3J6VNlhHBraFx1qXomUz1IMwjqM4c
CmuZpWDJfawskOGPqsYy5qOrNFaEZsRt37htB33hEvHZzuast5Ig2GyrhYG5+yH6
sVbfpNYMhIxT63Wel3oCFqwbWGe0QJhMx7WWbgl/4OBlrWXn1RdD1mFq0tvGRWXP
J3D0IcIKKe4=
=pv0H
-----END PGP SIGNATURE-----

--=-7pTkfw2jr7NOBXYU6h1w--
