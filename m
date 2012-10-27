Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab2J0QMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:12:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57759 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759160Ab2J0QML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:12:11 -0400
Message-ID: <1351354318.4834.7.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 16/85] use clamp_t in UNAME26 fix
From: Ben Hutchings <ben@decadent.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 27 Oct 2012 17:11:58 +0100
In-Reply-To: <20121026000032.757987970@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
	 <20121026000032.757987970@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5ojaOH6nVuCd5n4dzaGx"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5ojaOH6nVuCd5n4dzaGx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-25 at 17:05 -0700, Greg Kroah-Hartman wrote:
> 3.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Kees Cook <keescook@chromium.org>
>=20
> commit 31fd84b95eb211d5db460a1dda85e004800a7b52 upstream.
>=20
> The min/max call needed to have explicit types on some architectures
> (e.g. mn10300). Use clamp_t instead to avoid the warning:
>=20
>   kernel/sys.c: In function 'override_release':
>   kernel/sys.c:1287:10: warning: comparison of distinct pointer types lac=
ks a cast [enabled by default]

While this change makes the code more readable, I think the bug is
really in the type definitions for those architectures:

[...]
> -		copy =3D min(sizeof(buf), max_t(size_t, 1, len));
> +		copy =3D clamp_t(size_t, len, 1, sizeof(buf));
[...]

1. sizeof(buf) yields a value of type size_t, by definition.
2. max_t(size_t, 1, len) yields a value of type size_t.
3. Therefore min(sizeof(buf), max_t(size_t, 1, len)) is valid.

The only way I see to get this warning is to define size_t wrongly, so
that (1) is not true.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-5ojaOH6nVuCd5n4dzaGx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUIwHzue/yOyVhhEJAQpmDw/+IqkF71J8iEx4Q/ej2lbSikB8V742JGe+
TnJkCFJvm9Ij6Dfr2+C4tGSm+FZKBv53IWkqxkU3zn9R5IFPt7ZcLkXKo20bL89r
XI9fuTM4s9gvhBy1jgLo7BgEAiMgLRkdTuhbikDlrFYwUD9wGM2rv2bRpSUoTDPU
O42BbAP+gIEpWJ7S2SbYKPE4lEWiOBWyrjUdd87F8HFWOaTHlHRPP9nzna2ddDRo
y9ORXRhyDWqOhSLN4CKNfJiJLfT060PXQIm2VCi27Ihlt0NAMxMR/XDELauBIu0q
NxGHQ4dz7swsB90vAg14KJzZCpXj7r9J6URjrmNZzQwXj2CvwLwFF2icmRNUuWw0
atw1bzQ1ksNxgZWvy58EnYtN2BQke75ygSKkhNUeCU2A4PDM3g3XLOpMJnpBd6r7
XKTJ0VhbRoT/LOtSNcBx4zl0XLLI42YILRNC7VTecwNien8gwDBoaTMyg9Asqqmw
93itsVwTxZhfkk/2lACo1m2ddR/vM/Lo5nQxjUQ+CQibdTR8RN7ZUfXW+Zkh1GZr
IsCU2YiBz0Oc9fwH7Y6FS6uAO34gLFd17zgB3qo/i7Xz0q1djuxMWWMDzU9BMVDK
n7X6g5gbcjWWVwljPF48ozPPHBSSs1Mx5GvbDgaviASWtFpoBAWW07AZXcXvw1ua
2N2SoIort2k=
=3ZY5
-----END PGP SIGNATURE-----

--=-5ojaOH6nVuCd5n4dzaGx--
