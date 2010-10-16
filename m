Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0JPLAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 07:00:25 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:34239 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0JPLAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 07:00:23 -0400
Message-ID: <4CB985BB.5080804@web.de>
Date: Sat, 16 Oct 2010 13:00:11 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Karsten Keil <isdn@linux-pingi.de>, Armin Schindler <mac@melware.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2.6.36-rc7 1/2] isdn/capi: unregister capictr notifier
 after init failure
References: <4CB84C4C.6040204@kernel.org>
In-Reply-To: <4CB84C4C.6040204@kernel.org>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig58915161159D6154FDB3C5B8"
X-Provags-ID: V01U2FsdGVkX1+QVyll2G1bibzjzPaIZbkZMpzgioYqVYqp7d5I
	KG+maQols/ELSsVnHO53U4zqIsWt9Et/F0PKkLpKrRwXDwIs/m
	KJenMikuw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig58915161159D6154FDB3C5B8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.10.2010 14:42, Tejun Heo wrote:
> capidrv_init() could leave capictr notifier dangling after init
> failure.  Fix it.

Good catch!

I assume David will pick these two up for net-next. Adding him to CC.

Acked-by: Jan Kiszka <jan.kiszka@web.de>

>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/isdn/capi/capidrv.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> Index: work/drivers/isdn/capi/capidrv.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- work.orig/drivers/isdn/capi/capidrv.c
> +++ work/drivers/isdn/capi/capidrv.c
> @@ -2288,6 +2288,7 @@ static int __init capidrv_init(void)
>=20
>  	errcode =3D capi20_get_profile(0, &profile);
>  	if (errcode !=3D CAPI_NOERROR) {
> +		unregister_capictr_notifier(&capictr_nb);
>  		capi20_release(&global.ap);
>  		return -EIO;
>  	}



--------------enig58915161159D6154FDB3C5B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAky5hcQACgkQitSsb3rl5xR+8wCdGKFQVOPqfZ+iTP6MNJ/SDoor
BBgAoNjrGKw7FsvjAijmsRJRbH68gTq6
=qFfy
-----END PGP SIGNATURE-----

--------------enig58915161159D6154FDB3C5B8--
