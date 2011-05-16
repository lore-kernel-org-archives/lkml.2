Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1EPM3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:29:35 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:36215 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668Ab1EPM3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:29:33 -0400
Date: Mon, 16 May 2011 15:29:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, axel.lin@gmail.com
Subject: Re: [PATCH v1] mfd: Fix omap_usbhs_alloc_children error handling
Message-ID: <20110516122926.GE11339@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305548647-19849-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hNrJFWHEm0TKGkuH"
Content-Disposition: inline
In-Reply-To: <1305548647-19849-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hNrJFWHEm0TKGkuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2011 at 05:54:07PM +0530, Keshava Munegowda wrote:
> From: Axel Lin <axel.lin@gmail.com>
>=20
> rebased on top of hwmod and runtime pm patch series of usbhs
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Tested-by: Keshava Munegowda <keshava_mgowda@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/mfd/omap-usb-host.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index e1bc3b5..32d19e2 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -282,6 +282,7 @@ static int omap_usbhs_alloc_children(struct platform_=
device *pdev)
> =20
>  	if (!ehci) {
>  		dev_err(dev, "omap_usbhs_alloc_child failed\n");
> +		ret =3D -ENOMEM;
>  		goto err_end;
>  	}
> =20
> @@ -305,13 +306,14 @@ static int omap_usbhs_alloc_children(struct platfor=
m_device *pdev)
>  		sizeof(*ohci_data), dev);
>  	if (!ohci) {
>  		dev_err(dev, "omap_usbhs_alloc_child failed\n");
> +		ret =3D -ENOMEM;
>  		goto err_ehci;
>  	}
> =20
>  	return 0;
> =20
>  err_ehci:
> -	platform_device_put(ehci);
> +	platform_device_unregister(ehci);
> =20
>  err_end:
>  	return ret;
> --=20
> 1.6.0.4
>=20

--=20
balbi

--hNrJFWHEm0TKGkuH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEbBAEBAgAGBQJN0RimAAoJEAv8Txj19kN1U00H+POq+JVOV56mvU/Z/r4AT5ew
tsPUqIsd8N4LfX4vgj6TfpiyxOz1iDsheH8RmV29O3XNOAxcPWqscOXzXm2oPBi9
oFfIgSA4LPb3TuEliWLwPE3HFCCRzyIGON/EbTHvWnoLIzy1wpfOITD8WNCUtdeR
UaqO3Wtwl5Jy5Y5hfCaSjzSvrC6rY2dBybxJMUCUsobQmZOZSgtw9HfV1xFa3l8s
HEOuuZVSG2ijkGVdmTWZdalNx66yrAs816zrrckXwJJeEgfwQyCul2X3CLb4EQPi
FPgZOrvpF4+bcjiMZxivB6Ups9A9dVADqIOAaMozvA82tDW1j+uHo7UWYw52HQ==
=8FgX
-----END PGP SIGNATURE-----

--hNrJFWHEm0TKGkuH--
