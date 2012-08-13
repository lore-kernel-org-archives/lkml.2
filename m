Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2HMOgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:36:24 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:38176 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab2HMOgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:36:21 -0400
Date: Mon, 13 Aug 2012 17:32:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: NeilBrown <neilb@suse.de>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Infinite looping in omap2430.c USB driver
Message-ID: <20120813143233.GJ14781@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120707083949.2cf91eeb@notabene.brown>
 <20120809111549.GT12174@arwen.pp.htv.fi>
 <20120813123453.4cba14ca@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Hr//EUsa8//ouuB"
Content-Disposition: inline
In-Reply-To: <20120813123453.4cba14ca@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+Hr//EUsa8//ouuB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 13, 2012 at 12:34:53PM +1000, NeilBrown wrote:
> On Thu, 9 Aug 2012 14:15:51 +0300 Felipe Balbi <balbi@ti.com> wrote:
>=20
>=20
> > hehe, that's nasty. Please send a patch converting to a try count and a
> > udelay_range(), or something.
> >=20
>=20
> how's this?
>=20
> Thanks,
> NeilBrown
>=20
>=20
> From: NeilBrown <neilb@suse.de>
> Date: Mon, 13 Aug 2012 12:32:58 +1000
> Subject: [PATCH] omap2430: don't loop indefinitely in interrupt.
>=20
> When called during resume_irqs, omap2430_musb_set_vbus() is run with
> interrupts disabled,  In that case 'jiffies' never changes so the loop
> can loop forever.
>=20
> So impose a maximum loop count and add an 'mdelay' to ensure we wait
> a reasonable amount of time for bit to be cleared.
>=20
> This fixes a hang on resume.
>=20
> Signed-of-by: NeilBrown <neilb@suse.de>
>=20
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index c7785e8..8a93381 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -34,6 +34,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/err.h>
> +#include <linux/delay.h>
> =20
>  #include "musb_core.h"
>  #include "omap2430.h"
> @@ -145,6 +146,7 @@ static void omap2430_musb_set_vbus(struct musb *musb,=
 int is_on)
> =20
>  	if (is_on) {
>  		if (musb->xceiv->state =3D=3D OTG_STATE_A_IDLE) {
> +			int loops =3D 100;
>  			/* start the session */
>  			devctl |=3D MUSB_DEVCTL_SESSION;
>  			musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
> @@ -154,9 +156,11 @@ static void omap2430_musb_set_vbus(struct musb *musb=
, int is_on)
>  			 */
>  			while (musb_readb(musb->mregs, MUSB_DEVCTL) & 0x80) {
> =20
> +				mdelay(5);

I would prefer udelay_range() as it will let scheduler group timers.
Something like:

udelay_range(3000, 5000);

should do, I gues...

--=20
balbi

--+Hr//EUsa8//ouuB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQKRAAAAoJEIaOsuA1yqREYkYP/3eO3fpTDiSZv5iLdR2jmj9O
1Q1Fp0ry7ZhDdqeQfGNprnYKfSRQB9YR7hbjvpZNOAmLxCiC4qV9jNDC0bSmYeov
d9fP0+MR4/iyvMU+unzd6iRAnDaTrfh3FkTmln/fkrC4SUmfPh+JWT1vU+x7M/qg
Lla4KUQCAaMQCNaJLxknMTFcfA3L5ytt1kgNPpjWUVStfZXofn8MIgXdXJ/aPhDR
WQ6K9BuPYr/L5waE3eftU6jo4m5LhiDCWmm8HEsQbnOuDZ/g1RVUVOswvVW/O7/k
PnYnHroOk3ZeG3DtvoP14yNqx5QB2faDLPuyqyG9f+i1bfrPinaoStndGwZlRrmg
3hhBCWZEzGImZQI4n96qlFWlKhGBy4CmSBjVhplHsFZ8u8VV1HLg2MLz+VhZ5ExZ
qkDWY42X6Uf9B24OzzizqA3CvcTqzFKPm3+d5hMuO2rfxp/r/15lIayxmIIikXRa
mLLsCcTgL1bSsUbzN7ZKYc9u5ikwYNVGUxWuJBy0S4dIgOfXxwJAQKPXJkp7ITdT
ADkF/gvbveYccZgdhksYD8AIBFmKy0GIwcXxYHiZDDokjt67Tf9CQw0nTR8brFum
52aO4WpATwbkOqcM3aA7/xr+g7yG8gcw/iYXRvLl0AAjBn2SHZWzcfIoUxHEuKWM
BuuwcjdpOf/C+CFzHKzw
=vOt8
-----END PGP SIGNATURE-----

--+Hr//EUsa8//ouuB--
