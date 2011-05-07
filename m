Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1EGBuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:50:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55710 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381Ab1EGBuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:50:04 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Dan Rosenberg <drosenberg@vsecurity.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110506001210.350968533@clark.kroah.org>
References: <20110506001210.350968533@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-LbX3NVsBenuvQedb4mbL"
Date: Sat, 07 May 2011 02:49:50 +0100
Message-ID: <1304732990.3203.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [patch 31/38] ARM: 6891/1: prevent heap
 corruption in OABI semtimedop
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LbX3NVsBenuvQedb4mbL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-05-05 at 17:11 -0700, Greg KH wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Dan Rosenberg <drosenberg@vsecurity.com>
>=20
> commit 0f22072ab50cac7983f9660d33974b45184da4f9 upstream.
>=20
> When CONFIG_OABI_COMPAT is set, the wrapper for semtimedop does not
> bound the nsops argument.  A sufficiently large value will cause an
> integer overflow in allocation size, followed by copying too much data
> into the allocated buffer.  Fix this by restricting nsops to SEMOPM.
> Untested.
>=20
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  arch/arm/kernel/sys_oabi-compat.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/arch/arm/kernel/sys_oabi-compat.c
> +++ b/arch/arm/kernel/sys_oabi-compat.c
> @@ -311,7 +311,7 @@ asmlinkage long sys_oabi_semtimedop(int
>  	long err;
>  	int i;
> =20
> -	if (nsops < 1)
> +	if (nsops < 1 || nsops > SEMOPM)
>  		return -EINVAL;

It's not that important, but the manual page says the error code should
E2BIG in the latter case.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-LbX3NVsBenuvQedb4mbL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATcSlPee/yOyVhhEJAQpKEhAAu7dOL9Gj2pxp2+3zFGeR2Ax0Ecr8v6FL
XJFDb0/dCpn/701LfTAWgvbIJkNUKbvZrdc1qRt1a/gcTqdXrGvVUyF2dU3orluL
G6HpZMLoeB0Phx3WTjNzsepgJXXtTpIZjbqZF0RG9Q37Y+c7lhXRT6E0mfOnKxtW
OwF6O3bo7b0RqaFP1DLtrkB2UjLDXFLv5MID0NwTQ5ZNJltuNlKT07PD/9cSNOxR
et0P5ZoC8z4R5VOabMfMAtyt+FtR8e66XPB9/XMlHMg/Fu4Zb0Kw1Ri1cxJDhuyi
p7leD5KZXDk9cH2ZWFZ198PD3MuJ4ca3NCXzYHD5HiqwRGg9bGtQtXVye+JgaA7v
VI7TH1/cJBoliYW67K2R0vgv84g9eOU6W5cvglSQTSpESLiUXzWMuVn3G6RJbPxB
5XZ4V+OjPHsZ3GrMNrjQ0vS+7t8goVXPk0iCu7Dp9Z12NeK0Hee1M6Ilw7Sb0PPb
Wo439OGkl1lcu34oKA0V3qYfjl16XT4oSJnRqC8Wl2ZT3DEwHXer/lhtCQkdtIOt
hEYW/07V/ryKoBH0Cmz//PKCfb3lmCntESNWNgizadeC/n2Sz8YPQal4iJMtNd5+
fgtpFO8PUR/6u+zoAQBLhD2ysT8MCv13eecEpnrnIm9hPeTY2ZL3loOx/dpAkqZ+
ZerNpq3+yIY=
=j7Ni
-----END PGP SIGNATURE-----

--=-LbX3NVsBenuvQedb4mbL--
