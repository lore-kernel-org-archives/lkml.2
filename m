Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1I2HJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:09:02 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:37733 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab1I2HJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:09:00 -0400
Date: Thu, 29 Sep 2011 10:08:53 +0300
From: Felipe Balbi <balbi@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] usb: musb: OMAP4430: Remove a redundant
 omap4430_phy_init call in usb_musb_init
Message-ID: <20110929070849.GA27987@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1316508629.14514.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1316508629.14514.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2011 at 04:50:29PM +0800, Axel Lin wrote:
> Current code calls omap4430_phy_init() twice in usb_musb_init().
> Calling omap4430_phy_init() once is enough.
> This patch removes the first omap4430_phy_init() call, which using an
> uninitialized pointer as parameter.
>=20
> This patch elimates below build warning:
> arch/arm/mach-omap2/usb-musb.c: In function 'usb_musb_init':
> arch/arm/mach-omap2/usb-musb.c:141: warning: 'dev' may be used uninitiali=
zed in this function
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/mach-omap2/usb-musb.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-mus=
b.c
> index a65145b..19e4dac 100644
> --- a/arch/arm/mach-omap2/usb-musb.c
> +++ b/arch/arm/mach-omap2/usb-musb.c
> @@ -137,9 +137,6 @@ void __init usb_musb_init(struct omap_musb_board_data=
 *musb_board_data)
>  	musb_plat.mode =3D board_data->mode;
>  	musb_plat.extvbus =3D board_data->extvbus;
> =20
> -	if (cpu_is_omap44xx())
> -		omap4430_phy_init(dev);
> -
>  	if (cpu_is_omap3517() || cpu_is_omap3505()) {
>  		oh_name =3D "am35x_otg_hs";
>  		name =3D "musb-am35x";
> --=20
> 1.7.4.1
>=20
>=20
>=20

--=20
balbi

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhBmBAAoJEAv8Txj19kN1iO4H/jWNVErbCJPLOlooNGIW9xkV
dZvxmOryPNCn49maS6j1QFnC/bEqQi+FEDTT2Y1a+6uztUAbh+YGwB63R+Y1fLrr
wQnMIQnkoV0g0DqfuBo9BRV9A2je0BuwtdajMdKD091qxyy9W1yTyLOeyU3BCBSX
vxUP/eQz38Tk2NSdU8i3voODFpmEeT7Tqu+svvfn9nVi60nmEuiZwsHPazR2iHc4
19cICsf1Wmoc81p5afZ9nhUdd0aYytHvbnPp2BjTqol5rOLg1Uvd/vWKfu7byanf
i50DPUhZh24V/flKMQHVCIWf3fiAgg4lhOOoytPeBlwH/ex4r+yfHlbDr/90Va4=
=cYnb
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
