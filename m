Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2ISMBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:01:38 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:42498 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab2ISMBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 08:01:35 -0400
Date: Wed, 19 Sep 2012 14:56:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] usb: phy: omap-usb2: enable 960Mhz clock for omap5
Message-ID: <20120919115647.GI3772@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
 <1348054229-27362-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2uG6jHjFLimDtBY"
Content-Disposition: inline
In-Reply-To: <1348054229-27362-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2uG6jHjFLimDtBY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 19, 2012 at 05:00:29PM +0530, Kishon Vijay Abraham I wrote:
> "usb_otg_ss_refclk960m" is needed by usb2 phy present in omap5. For
> omap4, the clk_get of this clock will fail since it does not have this
> clock.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/usb-phy.txt |    3 +++
>  drivers/usb/phy/omap-usb2.c                       |   28 +++++++++++++++=
+++++-
>  2 files changed, 30 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Document=
ation/devicetree/bindings/usb/usb-phy.txt
> index 7c5fd89..d5626de 100644
> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> @@ -24,6 +24,9 @@ Required properties:
>  add the address of control module phy power register until a driver for
>  control module is added
> =20
> +Optional properties:
> + - has960mhzclk: should be added if the phy needs 960mhz clock
> +
>  This is usually a subnode of ocp2scp to which it is connected.
> =20
>  usb3phy@4a084400 {
> diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
> index d36c282..d6612ba 100644
> --- a/drivers/usb/phy/omap-usb2.c
> +++ b/drivers/usb/phy/omap-usb2.c
> @@ -146,6 +146,7 @@ static int __devinit omap_usb2_probe(struct platform_=
device *pdev)
>  	struct omap_usb			*phy;
>  	struct usb_otg			*otg;
>  	struct resource			*res;
> +	struct device_node		*np =3D pdev->dev.of_node;
> =20
>  	phy =3D devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
>  	if (!phy) {
> @@ -190,6 +191,15 @@ static int __devinit omap_usb2_probe(struct platform=
_device *pdev)
>  	}
>  	clk_prepare(phy->wkupclk);
> =20
> +	if (of_property_read_bool(np, "has960mhzclk")) {
> +		phy->optclk =3D devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
> +		if (IS_ERR(phy->optclk)) {
> +			dev_err(&pdev->dev, "unable to get refclk960m\n");
> +			return PTR_ERR(phy->optclk);
> +		}
> +		clk_prepare(phy->optclk);
> +	}

instead, can't you just always try to get the clock but ignore the error
if it fails ?

If it works you can set a flag to let you know that you can use that
optional clock.

--=20
balbi

--J2uG6jHjFLimDtBY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWbL/AAoJEIaOsuA1yqREtrUP/2PImIswhxKJFOZKryi1J5i9
GaPsZarphgZle12njovv8uECnzUxuxfCwYQWPnP8KnQpMnya6AsW+YbWDMun0hc7
Wcefsg7187QQrsChrLG+ap7X1uiz3sdLv1AMIJ0+uIUkcUica5d77sOofd/iAERm
WB8y5sLgF7tZ00XE6+7PpoFtvwkF9atFM6T6943vJrISPkKXxA/Sli2vXH/X3w7P
7KyJZayhDJdmcOiWuJuAlO9rBzux3ebXTanx7kP2MOFAMgTKuQzSaPR+38ib+qS0
vTf34vFv1s7NJTsvYUQ9b+/VG89bHKO9Yxmb7dq/26qPHclqSI500rZclo8Fjyzl
hvGZF8qqxIOWRMSdJdP23RSX7MCgQnMEygO/G9Nb4nIpA7EWjKusi3CQB1peo04j
VIHc3fQKLWVy/FaHH8Gy24hQRR/kaFXoLzLOtgSIaqxnoT1HXooj9nN45u1ZEoj0
DQKC5rJX+jnjoYU6IJgQqyBGBCYlpBPoiQq9TtlbX4zgyQ5svNU64y9upNQhcjSL
G3bMYbtZMc6PKBh5Z3/O+/fxZbg8DH96LuNJcxWGgNWSRNNiYKesIbrxjlnuhkA7
aAopJtJdhxTHpy0qso5GdZnJXO5ZZ/ZHbuMvrkiN/BvDwhguANaMjWpVstc+RlIh
KMwBS2ETHqITdOm65YMA
=oCi/
-----END PGP SIGNATURE-----

--J2uG6jHjFLimDtBY--
