Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2IFRcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:32:32 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:57160 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932173Ab2IFRca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:32:30 -0400
Date: Thu, 6 Sep 2012 20:28:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        arnd@arndb.de, gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
Subject: Re: [PATCH] arm: omap: hwmod: make *phy_48m* as the main_clk of
 ocp2scp
Message-ID: <20120906172802.GD30717@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1341219337-25815-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eqp4TxRxnD4KrmFZ"
Content-Disposition: inline
In-Reply-To: <1341219337-25815-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 02, 2012 at 02:25:37PM +0530, Kishon Vijay Abraham I wrote:
> Made *ocp2scp_usb_phy_phy_48m* as the main_clk for ocp2scp.
> Since this ocp2scp module does not have any fck but does have a
> single opt_clock, it is added as the main_clk for ocp2scp. Also
> removed phy_48m as the optional clock since it is now made as the
> main clock.

Just one comment here, you failed to note what good does it do from the
driver perspective, other than that, you can add my Reviewed-by as below

> Cc: Beno=EEt Cousson <b-cousson@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

FWIW:

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
> Changes from [RFC PATCH 1/5] arm: omap: hwmod: make *phy_48m* as the main=
_clk
> of ocp2scp:
> * Removed *ocp2scp_usb_phy_phy_48m* as the optional functional clock
>=20
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-o=
map2/omap_hwmod_44xx_data.c
> index f30e861..17cf933 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -2504,14 +2504,11 @@ static struct omap_hwmod_class omap44xx_ocp2scp_h=
wmod_class =3D {
>  };
> =20
>  /* ocp2scp_usb_phy */
> -static struct omap_hwmod_opt_clk ocp2scp_usb_phy_opt_clks[] =3D {
> -	{ .role =3D "phy_48m", .clk =3D "ocp2scp_usb_phy_phy_48m" },
> -};
> -
>  static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod =3D {
>  	.name		=3D "ocp2scp_usb_phy",
>  	.class		=3D &omap44xx_ocp2scp_hwmod_class,
>  	.clkdm_name	=3D "l3_init_clkdm",
> +	.main_clk	=3D "ocp2scp_usb_phy_phy_48m",
>  	.prcm =3D {
>  		.omap4 =3D {
>  			.clkctrl_offs =3D OMAP4_CM_L3INIT_USBPHYOCP2SCP_CLKCTRL_OFFSET,
> @@ -2519,8 +2516,6 @@ static struct omap_hwmod omap44xx_ocp2scp_usb_phy_h=
wmod =3D {
>  			.modulemode   =3D MODULEMODE_HWCTRL,
>  		},
>  	},
> -	.opt_clks	=3D ocp2scp_usb_phy_opt_clks,
> -	.opt_clks_cnt	=3D ARRAY_SIZE(ocp2scp_usb_phy_opt_clks),
>  };
> =20
>  /*
> --=20
> 1.7.5.4
>=20

--=20
balbi

--eqp4TxRxnD4KrmFZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQSN0iAAoJEIaOsuA1yqREabwP/3mdw4eFr9KgcAdFYIeOSmEf
Z7G6g4r6vIK5SOixx9BS5AWEkx9ocv95Gt+RZIMFejMUIoXi+A9qtSJlyVH6ElWm
vx3ia8nsD7HRoe4dGerdOmrm028/Qdai60KSpmcqb0s0YHqikxmajX7z26SPQVLX
U/FMzjaXihBXf/ntjcGtQjszQ5qS98TGzS3GhbMyuUzdSuycu9SUglfLhsz33DpA
W5aUmGS/2B7SC1WnSHSLPj2ed3a2YVDNwWP5syrz8R4eiOdfi1gu95dPxqtKPDeY
g3mzcTZWh/JmZuoqka9SA5whlMpHppLyHNzaLlEH9zCKagLP3d7T4Kz+U1WnX3ya
L936gQFdmoZcPlGpomvFVtnUgg3K4cEv6aRw/Gkft2/Zf9BEVRvhuCt1UEPzzGvT
UQIl79egLWqLqJ2sq9iko3mtURUPONcyKBnkA2eqWTMCUZtEUXKP5bQQI6XSmA3G
wwzvjb7YIARu42AIxXMasAGQWnih3Bdh1q+ZcfzjZU2nfCx3L4Wnonnhob9aNZ/U
sfpydfQ+YnOzsJYrGdSR3PVuS7hI2xwwUu7QoGTuUv65hJOuDJanpqfQkc9eosVc
M0n1uLDWDNZ3jL0+AKikBjSpxzVVt3iB9wASExCRv5ibTEr4ZWj5mGWTaQkhVeA/
Vu34kQrkQDJS6L6mI9M6
=nvYn
-----END PGP SIGNATURE-----

--eqp4TxRxnD4KrmFZ--
