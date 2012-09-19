Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2ISOud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:50:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49601 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2ISOub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:50:31 -0400
Message-ID: <5059DBA4.5010906@pengutronix.de>
Date: Wed, 19 Sep 2012 16:50:12 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: Kishon Vijay Abraham I <kishon@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] usb: phy: omap-usb2: enable 960Mhz clock for omap5
References: <1348054229-27362-1-git-send-email-kishon@ti.com> <1348054229-27362-5-git-send-email-kishon@ti.com> <20120919115647.GI3772@arwen.pp.htv.fi> <5059DA6D.4070205@pengutronix.de> <20120919144247.GB7004@arwen.pp.htv.fi>
In-Reply-To: <20120919144247.GB7004@arwen.pp.htv.fi>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB3CF75A3AD14BF42133A3BDE"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB3CF75A3AD14BF42133A3BDE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/19/2012 04:42 PM, Felipe Balbi wrote:
> On Wed, Sep 19, 2012 at 04:45:01PM +0200, Marc Kleine-Budde wrote:
>> On 09/19/2012 01:56 PM, Felipe Balbi wrote:
>>> On Wed, Sep 19, 2012 at 05:00:29PM +0530, Kishon Vijay Abraham I wrot=
e:
>>>> "usb_otg_ss_refclk960m" is needed by usb2 phy present in omap5. For
>>>> omap4, the clk_get of this clock will fail since it does not have th=
is
>>>> clock.
>>>>
>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>> ---
>>>>  Documentation/devicetree/bindings/usb/usb-phy.txt |    3 +++
>>>>  drivers/usb/phy/omap-usb2.c                       |   28 ++++++++++=
++++++++++-
>>>>  2 files changed, 30 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Doc=
umentation/devicetree/bindings/usb/usb-phy.txt
>>>> index 7c5fd89..d5626de 100644
>>>> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
>>>> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
>>>> @@ -24,6 +24,9 @@ Required properties:
>>>>  add the address of control module phy power register until a driver=
 for
>>>>  control module is added
>>>> =20
>>>> +Optional properties:
>>>> + - has960mhzclk: should be added if the phy needs 960mhz clock
>>>> +
>>>>  This is usually a subnode of ocp2scp to which it is connected.
>>>> =20
>>>>  usb3phy@4a084400 {
>>>> diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2=
=2Ec
>>>> index d36c282..d6612ba 100644
>>>> --- a/drivers/usb/phy/omap-usb2.c
>>>> +++ b/drivers/usb/phy/omap-usb2.c
>>>> @@ -146,6 +146,7 @@ static int __devinit omap_usb2_probe(struct plat=
form_device *pdev)
>>>>  	struct omap_usb			*phy;
>>>>  	struct usb_otg			*otg;
>>>>  	struct resource			*res;
>>>> +	struct device_node		*np =3D pdev->dev.of_node;
>>>> =20
>>>>  	phy =3D devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
>>>>  	if (!phy) {
>>>> @@ -190,6 +191,15 @@ static int __devinit omap_usb2_probe(struct pla=
tform_device *pdev)
>>>>  	}
>>>>  	clk_prepare(phy->wkupclk);
>>>> =20
>>>> +	if (of_property_read_bool(np, "has960mhzclk")) {
>>>> +		phy->optclk =3D devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
>>>> +		if (IS_ERR(phy->optclk)) {
>>>> +			dev_err(&pdev->dev, "unable to get refclk960m\n");
>>>> +			return PTR_ERR(phy->optclk);
>>>> +		}
>>>> +		clk_prepare(phy->optclk);
>>>> +	}
>>>
>>> instead, can't you just always try to get the clock but ignore the er=
ror
>>> if it fails ?
>>
>> On imx we add no-op dummy clocks, so that the drivers will always find=

>> all needed clocks. If a clk_get fails it's an error.
>=20
> It's an error from a clk API point of view, it doesn't mean device can'=
t
> work without that optional clock. Drivers are free to treat errors
> however they like, even by ignoring it and defaulting to some other
> behavior.

Sure.

> Adding dummy clocks just bloats the kernel with useless data IMHO.

Just wanted to point out there's more than one way to do it.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigB3CF75A3AD14BF42133A3BDE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBZ26QACgkQjTAFq1RaXHNidACgiQOB957xoy/7jcqi73SjGClP
9MEAmQE9zu7t4GFsHTiTINrqyDesLx0G
=EMT4
-----END PGP SIGNATURE-----

--------------enigB3CF75A3AD14BF42133A3BDE--
