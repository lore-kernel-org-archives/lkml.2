Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab1GCLIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 07:08:14 -0400
Received: from mail.gw90.de ([188.40.100.199]:38337 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab1GCLIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 07:08:09 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jul 2011 07:08:09 EDT
Subject: Re: [PATCH] nouveau: Do not leak in nv20_graph_create
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1107031224030.16316@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107031224030.16316@swampdragon.chaosbits.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BQ+fUV5upBHNEss0EG2E"
Date: Sun, 03 Jul 2011 12:51:51 +0200
Message-ID: <1309690311.20270.27.camel@mattotaupa>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BQ+fUV5upBHNEss0EG2E
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Jesper,


Am Sonntag, den 03.07.2011, 12:25 +0200 schrieb Jesper Juhl:
> If we return due to an unknown chipset in=20
> drivers/gpu/drm/nouveau/nv20_graph.c:nv20_graph_create() we'll leak the=
=20
> memory allocated to 'pgraph'.
>=20
> This patch should fix the leak and it also disambiguates the "PGRAPH:
> unknown chipset\n" error message - it's nice to be able to tell which
> branch created the error which is impossible if the error messages are
> 100% identical.
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/gpu/drm/nouveau/nv20_graph.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
>   Don't have the hardware, so compile tested only.
>=20
> diff --git a/drivers/gpu/drm/nouveau/nv20_graph.c b/drivers/gpu/drm/nouve=
au/nv20_graph.c
> index affc7d7..059ad65 100644
> --- a/drivers/gpu/drm/nouveau/nv20_graph.c
> +++ b/drivers/gpu/drm/nouveau/nv20_graph.c
> @@ -752,6 +752,7 @@ nv20_graph_create(struct drm_device *dev)
>  			pgraph->grctx_user =3D 0x0000;
>  			break;
>  		default:
> +			kfree(pgraph);
>  			NV_ERROR(dev, "PGRAPH: unknown chipset\n");
>  			return 0;
>  		}
> @@ -773,7 +774,8 @@ nv20_graph_create(struct drm_device *dev)
>  			pgraph->grctx_size =3D NV35_36_GRCTX_SIZE;
>  			break;
>  		default:
> -			NV_ERROR(dev, "PGRAPH: unknown chipset\n");
> +			kfree(pgraph);
> +			NV_ERROR(dev, "PGRAPH: unknown chipset.\n");

so the only disambiguation is the full stop at the end?

>  			return 0;
>  		}
>  	}
> --=20
> 1.7.6


Thanks,

Paul

--=-BQ+fUV5upBHNEss0EG2E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEABECAAYFAk4QSccACgkQPX1aK2wOHVheBwCVEs8WOncc+mF218URHfDcbG35
4QCaAhj0FZwryY9OaJ5FxqovdKi6Tfg=
=Y6f3
-----END PGP SIGNATURE-----

--=-BQ+fUV5upBHNEss0EG2E--

