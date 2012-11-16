Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2KPIXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:23:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32808 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab2KPIXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:23:42 -0500
Date: Fri, 16 Nov 2012 10:17:19 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: core: move dwc3_cache_hwparams before
 dwc3_alloc_event_buffers
Message-ID: <20121116081719.GA16568@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1353047874-4981-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <1353047874-4981-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 16, 2012 at 12:07:54PM +0530, Kishon Vijay Abraham I wrote:
> commit 392142 moved event buffer allocation out of dwc3_core_init() but
> event buffer allocation uses the cached copy of hwparams to determine
> the number of event buffers and the caching is done in dwc3_core_init.
> So moved dwc3_cache_hwparams function before dwc3_alloc_event_buffers so
> that dwc3_alloc_event_buffers sees the correct number of event buffers.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

My bad, what a regression I caused :-)

Greg, can you take this one ?

Signed-off-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/dwc3/core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index b923183..88e8d31 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -356,8 +356,6 @@ static int __devinit dwc3_core_init(struct dwc3 *dwc)
> =20
>  	dwc3_core_soft_reset(dwc);
> =20
> -	dwc3_cache_hwparams(dwc);
> -
>  	reg =3D dwc3_readl(dwc->regs, DWC3_GCTL);
>  	reg &=3D ~DWC3_GCTL_SCALEDOWN_MASK;
>  	reg &=3D ~DWC3_GCTL_DISSCRAMBLE;
> @@ -498,6 +496,8 @@ static int __devinit dwc3_probe(struct platform_devic=
e *pdev)
>  	pm_runtime_get_sync(dev);
>  	pm_runtime_forbid(dev);
> =20
> +	dwc3_cache_hwparams(dwc);
> +
>  	ret =3D dwc3_alloc_event_buffers(dwc, DWC3_EVENT_BUFFERS_SIZE);
>  	if (ret) {
>  		dev_err(dwc->dev, "failed to allocate event buffers\n");
> --=20
> 1.7.9.5
>=20

--=20
balbi

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpfaPAAoJEIaOsuA1yqRE3d0P/RlUg2jnaz1Fpgu7yEpphSV5
KrS9f3XiCh9BSXjjCxX1qLPdyEM1j8827uURONlmFwJr3y+vNp8stDncY8BBWlkb
SjXsLdSNA1XWVfOm5y2grZvD4GpJST83mLItfP79mOgi5VwkIYrTqFM/wdwCop1F
d4IePRE83HB/olI+Eq3iDfC2naN2YZgCoTP1mApWoH4vq2wLPeJMaVSumjRvQyuW
hRGEjfckSj0BQprVc55JgiH4Yg6Ipr1yoYfiCleoGeKfKd0LoMhXwzPtTzka9xmJ
k7FkvBGQSt2fT5DlexV50jKDufx+tddlhwSOjuAH9Ull2j3bJ+btyqb7voHYfBwG
y2IrtL40nq3yrXDPhMrtbX9sqJ5ttviAPjQDhXRWltKOXVVWYM5ybFIc1lVSKjH2
n6Ez06+tzpHYAsYeXkUcCn1caR5saDGUW67N3Vq+wRQBkfXn2supMvaWcuv8mcd/
R7TDGUy4Dd+orEDfJMhcXZHJtf6kxMIF6nLbg02WdsHP33oKZEYGDwvl7M3yWE3v
YvCGHbqFFlN2tZXgmkXHtdYlH6KLbvIasMJcwWJ8xHlVeCXbE/VuYEEg5XQzVrIs
VZunouqFQYzDNGflbAXRKaoKaZHcnkF5uJCAw7EJoiarq/dMrtlsiXbL/0UIMdq/
4HabG60qOmCIaWixDyNn
=UXX7
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
