Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2LOWQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 17:16:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50210 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2LOWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 17:16:22 -0500
Date: Sun, 16 Dec 2012 09:16:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arvind R <arvino55@gmail.com>
Cc: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: [PATCH 3.7.0 5/9] i82975x_edac: optimise mode detection
Message-Id: <20121216091620.9a2cc610d18d848317eb9dad@canb.auug.org.au>
In-Reply-To: <CAA_L+UPvp8i6SaATD=uQmvYeEp6vbYGBFM=LRE1MWCMGff5JkA@mail.gmail.com>
References: <CAA_L+UPvp8i6SaATD=uQmvYeEp6vbYGBFM=LRE1MWCMGff5JkA@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__16_Dec_2012_09_16_20_+1100_oYD0N.zmCjy0IZfe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__16_Dec_2012_09_16_20_+1100_oYD0N.zmCjy0IZfe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 16 Dec 2012 02:12:51 +0530 Arvind R <arvino55@gmail.com> wrote:
>
> Subject: [PATCH 3.7.0 5/9] i82975x_edac: optimise mode detection
>=20
> Minor optimisation of dual channel symmetric operation. Return
> value changed to bool.

And you moved the function for no reason that is obvious form the patch.

> +/* Return 1 if dual channel mode is active.  Else return 0. */

The comment is no longer correct i.e. you are no returning true/false not
0/1.

> +static bool dual_channel_active(void __iomem *mch_window)
> +{
> +	/*
> +	 * We treat interleaved-symmetric configuration as dual-channel.
> +	 * All other configurations are virtual single channel mode.
> +	 * bit-0 of EAP always provides the real channel in error.
> +	 */
> +	u8	drb[2];
> +	int	row;
> +	bool    dualch;
> +
> +	for (dualch =3D 1, row =3D 0; dualch &&

um	dualch =3D true

> +			(row < I82975X_NR_CSROWS_PER_CHANNEL); row++) {
> +		drb[0] =3D readb(mch_window + I82975X_DRB + row);
> +		drb[1] =3D readb(mch_window + I82975X_DRB + row + 0x80);
> +		dualch &=3D (drb[0] =3D=3D drb[1]);

Don't do bit operations on a bool.

> +	}
> +	return dualch;
> +}

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__16_Dec_2012_09_16_20_+1100_oYD0N.zmCjy0IZfe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQzPa0AAoJEECxmPOUX5FE8lkP/jLX48KzXduqHrui58PKuk5F
OePMDt2/QV0T/LCY+QvUPKvnzGVYBSaq6TzRcQv0rgjcpiGDyd96VqdUEzzXOx7c
gvyY++I1NQDKo+WVBtdQ05AorhDNuXD6TudkfOdJCTuSXWpyFmYDg7mVKfzB7lJp
pZFqOC9S8uzGNX8xQKzb4egFJPc03dXkxNcR0GqY/ERcIXH38wWYlJatYzBiiIYN
XSfTwtxDwkY3GugeE5RfsfciatvdW8onJ1dXPni9lSmy5+XOzpJYgbe9lKCdH6Jv
URo+nPriA3bH1oiUG8zrnzT86kYy6BhQ4binkMdY+jL58WAjIseeBfu/P7mz3UBp
pCad1JIJJGqqcxlBLLPBxO4dyH6SyzjtgiaIXab77ZoS/5nm02L8370qGaXnMzC9
WmIWsNNgdjnB+zkJTkgMuQUgFeRz9boWT0ufeYhHscfniYD4GzveUMPMdyKjPBJy
ep9OJDgpZqR7zvAd6wOR6j/TLbkAdP+lOsJNiba7JtlrTuwot+D6ooK9D8N9XA5O
29YB6VrPZOfP/+g7A4Pf40w6a+H/UUkgFGsV/zmlHuY3pl+m2b54qiFnp4ollTa+
6XO6SJ5bj7+rIK2Ajd0Vd7wbvRn2PJ38eJJFvnp/DLTsL7j3TJQz3M2o7BDGmCga
s/lT04EGJ/dF8v9uwMoc
=IkVq
-----END PGP SIGNATURE-----

--Signature=_Sun__16_Dec_2012_09_16_20_+1100_oYD0N.zmCjy0IZfe--
