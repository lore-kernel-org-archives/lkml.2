Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab2ISOrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:47:39 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:41187 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490Ab2ISOrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:47:35 -0400
Date: Wed, 19 Sep 2012 17:42:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: balbi@ti.com, Kishon Vijay Abraham I <kishon@ti.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] usb: phy: omap-usb2: enable 960Mhz clock for omap5
Message-ID: <20120919144247.GB7004@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
 <1348054229-27362-5-git-send-email-kishon@ti.com>
 <20120919115647.GI3772@arwen.pp.htv.fi>
 <5059DA6D.4070205@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <5059DA6D.4070205@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 19, 2012 at 04:45:01PM +0200, Marc Kleine-Budde wrote:
> On 09/19/2012 01:56 PM, Felipe Balbi wrote:
> > On Wed, Sep 19, 2012 at 05:00:29PM +0530, Kishon Vijay Abraham I wrote:
> >> "usb_otg_ss_refclk960m" is needed by usb2 phy present in omap5. For
> >> omap4, the clk_get of this clock will fail since it does not have this
> >> clock.
> >>
> >> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >> ---
> >>  Documentation/devicetree/bindings/usb/usb-phy.txt |    3 +++
> >>  drivers/usb/phy/omap-usb2.c                       |   28 ++++++++++++=
++++++++-
> >>  2 files changed, 30 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Docum=
entation/devicetree/bindings/usb/usb-phy.txt
> >> index 7c5fd89..d5626de 100644
> >> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> >> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> >> @@ -24,6 +24,9 @@ Required properties:
> >>  add the address of control module phy power register until a driver f=
or
> >>  control module is added
> >> =20
> >> +Optional properties:
> >> + - has960mhzclk: should be added if the phy needs 960mhz clock
> >> +
> >>  This is usually a subnode of ocp2scp to which it is connected.
> >> =20
> >>  usb3phy@4a084400 {
> >> diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
> >> index d36c282..d6612ba 100644
> >> --- a/drivers/usb/phy/omap-usb2.c
> >> +++ b/drivers/usb/phy/omap-usb2.c
> >> @@ -146,6 +146,7 @@ static int __devinit omap_usb2_probe(struct platfo=
rm_device *pdev)
> >>  	struct omap_usb			*phy;
> >>  	struct usb_otg			*otg;
> >>  	struct resource			*res;
> >> +	struct device_node		*np =3D pdev->dev.of_node;
> >> =20
> >>  	phy =3D devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
> >>  	if (!phy) {
> >> @@ -190,6 +191,15 @@ static int __devinit omap_usb2_probe(struct platf=
orm_device *pdev)
> >>  	}
> >>  	clk_prepare(phy->wkupclk);
> >> =20
> >> +	if (of_property_read_bool(np, "has960mhzclk")) {
> >> +		phy->optclk =3D devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
> >> +		if (IS_ERR(phy->optclk)) {
> >> +			dev_err(&pdev->dev, "unable to get refclk960m\n");
> >> +			return PTR_ERR(phy->optclk);
> >> +		}
> >> +		clk_prepare(phy->optclk);
> >> +	}
> >=20
> > instead, can't you just always try to get the clock but ignore the error
> > if it fails ?
>=20
> On imx we add no-op dummy clocks, so that the drivers will always find
> all needed clocks. If a clk_get fails it's an error.

It's an error from a clk API point of view, it doesn't mean device can't
work without that optional clock. Drivers are free to treat errors
however they like, even by ignoring it and defaulting to some other
behavior.

Adding dummy clocks just bloats the kernel with useless data IMHO.

my 2 cents.

--=20
balbi

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWdnnAAoJEIaOsuA1yqRE2moQAIC69bYUfeCAKXjVZUhQNLuN
zjEH0oacrXZkQZG1tovtawIBxEoS2pR5r71ILaf4sc03ZV8d98KXYS7ZO6BDFZCi
zUZ9zw32MLGK/NTjkOgm0HL8OgPrLyMvQXeKw5XgiYPqig6wrqw3kb6cvHdwlJd6
hxDdtqehTU+u2IPRORZccC3fLIMTzNhE1AhDCOGpx7UujDN2qGPv3l6YFLwF/JtB
1E0pm/8ox1EMZuDi9LeacIB3Qg8Of2n1y2xpnXwBnVVtxK4gXBPTj69C9yDUq2XU
uDMb6fZxFHgDVbH5jlJgJsO7dUMenhjj1VgeHiJaS+BaA30j4nmKFfsxus4ftzJH
E4GbDnPuAkswqml0nJI9yAQtu9Umd4dQQCjcKfhdvSpoSjiU5Ynzg9mb8MdcEYXu
PZsO1FgGZDBQRVQPfAXnufPtYwFTAQKSzawCMycSGO07z+flmpPmcXz+bbvmy2T+
HoUyHsV7S/xlZEAXNCUXWPKLR/lYiPW2zjiF+HGHW7F3dDvATCw0X7lE8Dxe9auv
5Ao6jawkpvTXUtSyNXyuc+gN4i21GoADU/82aUm4ldg8AQ7yGps0W3q/M4jz6vYo
0fe8VuffyPP8uJlPeefDHFIqu/6kbfZU6hgFNhZJbLCGQt4kfvURgauN5rNBBY8V
gTuC6gxlovuOzgniIIhl
=alp/
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
