Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab1EPLMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:12:34 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:44151 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727Ab1EPLMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:12:33 -0400
Date: Mon, 16 May 2011 14:12:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Fix omap_usbhs_alloc_children error handling
Message-ID: <20110516111227.GX11339@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305353736.11286.2.camel@phoenix>
 <BANLkTinQkekfnR=zc4TJfU3qSHarKQsUcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lBR2yNlwcY132B3M"
Content-Disposition: inline
In-Reply-To: <BANLkTinQkekfnR=zc4TJfU3qSHarKQsUcg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lBR2yNlwcY132B3M
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 16, 2011 at 04:33:58PM +0530, Munegowda, Keshava wrote:
> On Sat, May 14, 2011 at 11:45 AM, Axel Lin <axel.lin@gmail.com> wrote:
> > 1. Return proper error if omap_usbhs_alloc_child fails
> > 2. In the case of goto err_ehci, we should call platform_device_unregis=
ter(ehci)
> > =A0 instead of platform_device_put(ehci) because we have already added =
the
> > =A0 platform device to device hierarchy.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> > =A0drivers/mfd/omap-usb-host.c | =A0 =A04 +++-
> > =A01 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> > index 3ab9ffa..344f518 100644
> > --- a/drivers/mfd/omap-usb-host.c
> > +++ b/drivers/mfd/omap-usb-host.c
> > @@ -281,6 +281,7 @@ static int omap_usbhs_alloc_children(struct platfor=
m_device *pdev)
> >
> > =A0 =A0 =A0 =A0if (!ehci) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_err(dev, "omap_usbhs_alloc_child fai=
led\n");
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOMEM;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_end;
> > =A0 =A0 =A0 =A0}
> >
> > @@ -304,13 +305,14 @@ static int omap_usbhs_alloc_children(struct platf=
orm_device *pdev)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(*ohci_data), dev);
> > =A0 =A0 =A0 =A0if (!ohci) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_err(dev, "omap_usbhs_alloc_child fai=
led\n");
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOMEM;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_ehci;
> > =A0 =A0 =A0 =A0}
> >
> > =A0 =A0 =A0 =A0return 0;
> >
> > =A0err_ehci:
> > - =A0 =A0 =A0 platform_device_put(ehci);
> > + =A0 =A0 =A0 platform_device_unregister(ehci);
> >
> > =A0err_end:
> > =A0 =A0 =A0 =A0return ret;
> > --
> > 1.7.1
> >
>=20
> Looks goo to me;
>=20
> Balbi,
>       I will take this patch on top of hwmod and runtime pm patches?
> is it OK for you.

It's ok. Just be sure to split the series correctly:

arch/arm/*omap*/ -> to Tony
drivers/mfd/* -> to Samuel

--=20
balbi

--lBR2yNlwcY132B3M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN0QabAAoJEAv8Txj19kN1K28H/jHVxUgYmiGMDjPH/hDAN5GV
SHjZwJRZxZweoHDA7V4MpxHSSXSx8wvjtme1UJ26ZCMSwN/WMa/dW4wDXfCLhKIw
6fUGKu1OvamHtQKzo0hy6gOBtu2Aqz3JtdyF+SfQB/yJhXK9rajlNzyteHSv0ZZj
4lYznWxJhfzcCPbCjZN039qDI6Po50CY8FfUpYpjR94qAu+T9SL6mnRoSJuvvpip
jQrAu6aGhUQx13WmmUWsrssvz78KhjR18QpzIWbK8DzMBfVJh/pqbTy7nQu2kEft
e7ECtnV8LmEdeZSK6L4kCI0+w4/X7DfUZ92ghqhRkVXSntQiv6oFXwHa+P2eyVs=
=rb+l
-----END PGP SIGNATURE-----

--lBR2yNlwcY132B3M--
