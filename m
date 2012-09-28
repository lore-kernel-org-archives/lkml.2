Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab2I1NHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:07:55 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:34431 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757772Ab2I1NHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:07:53 -0400
Date: Fri, 28 Sep 2012 16:02:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com
Subject: Re: [PATCH 6/6] usb: dwc3: core: add dt support for dwc3 core
Message-ID: <20120928130240.GN31006@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
 <1348836795-4783-7-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tuFXEhzhBeitrIAu"
Content-Disposition: inline
In-Reply-To: <1348836795-4783-7-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tuFXEhzhBeitrIAu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 28, 2012 at 06:23:15PM +0530, Kishon Vijay Abraham I wrote:
> Added dwc3 support for dwc3 core and update the documentation with
> device tree binding information.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/dwc3.txt |   24 ++++++++++++++++++=
++++++
>  drivers/usb/dwc3/core.c                        |   14 ++++++++++++--
>  2 files changed, 36 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/dwc3.txt
>=20
> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentati=
on/devicetree/bindings/usb/dwc3.txt
> new file mode 100644
> index 0000000..87d5eeb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
> @@ -0,0 +1,24 @@
> +SYNOPSIS DWC3 CORE
> +
> +DWC3- USB3 CONTROLLER
> +
> +Required properties:
> + - compatible: Should be "synopsis,dwc3"

"synopsys" and I think:

- compatible: Must be "synopsys,dwc3" reads a bit better.

> + - reg : Address and length of the register set for the device
> + - interrupts: Interrupts used by the dwc3 controller.
> + - interrupt-parent: the phandle for the interrupt controller that
> +   services interrupts for this device.
> +
> +Optional properties:
> + - tx-fifo-resize: determines if the fifo spaces can be reallocated acco=
rding
> + to use-cases.

actually, this should read: "determines if the FIFO *has* to be
reallocated.

On OMAP5 ES1 the default value is not good enough and we _must_
reallocate FIFO sizes.

> +This is usually a subnode to DWC3 glue to which it is connected.
> +
> +dwc3@4a030000 {
> +	compatible =3D "synopsis,dwc3";

"synopsys"

> +	reg =3D <0x4a030000 0xcfff>;
> +	interrupts =3D <0 92 4>
> +	interrupt-parent =3D <&gic>
> +	tx-fifo-resize;
> +};
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 08a5738..0c17a7a 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -484,8 +484,7 @@ static int __devinit dwc3_probe(struct platform_devic=
e *pdev)
>  	else
>  		dwc->maximum_speed =3D DWC3_DCFG_SUPERSPEED;
> =20
> -	if (of_get_property(node, "tx-fifo-resize", NULL))
> -		dwc->needs_fifo_resize =3D true;
> +	dwc->needs_fifo_resize =3D of_property_read_bool(node, "tx-fifo-resize"=
);
> =20
>  	pm_runtime_enable(dev);
>  	pm_runtime_get_sync(dev);
> @@ -602,11 +601,22 @@ static int __devexit dwc3_remove(struct platform_de=
vice *pdev)
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_OF
> +static const struct of_device_id of_dwc3_matach[] =3D {
> +	{
> +		.compatible =3D "synopsis,dwc3"

"synopsys"

> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, of_dwc3_matach);
> +#endif
> +
>  static struct platform_driver dwc3_driver =3D {
>  	.probe		=3D dwc3_probe,
>  	.remove		=3D __devexit_p(dwc3_remove),
>  	.driver		=3D {
>  		.name	=3D "dwc3",
> +		.of_match_table	=3D of_match_ptr(of_dwc3_matach),
>  	},
>  };
> =20
> --=20
> 1.7.10.4
>=20

--=20
balbi

--tuFXEhzhBeitrIAu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJQZZ/wAAoJEIaOsuA1yqREmosP+N/KUenfb/QwtyQN6aqNjdpz
AMn3vaEOnL8oteiI4HL5CzdBBJAsgn4VEU2JNNX7oEHQUxV5xRnQbp9HRuc0+5yr
gw+xytmk0FOnIYXjs4Z9IxcLRMUZJ8INR9RrESksibBu1I7fgtGgM8cX/K4dhW8e
ojD215QbQlIDOCKRUWZjIq/MUa1jp8D521Lie5pNBQfbmbQb41GcXzVZg4ZepjGY
xvCfeyrczrKqnNLl28WYkS7ncVwgbdEigzuTIsfY/4/0/bG3hIAKEMACWl+uZD90
icPo4CQ28NeGppHVmTTO/GEAsa+nWzxLUWFUtguS+A2F6wmd6wy27CSmk1xKoWLG
bToJqhM2sSoc6yoOxixxzHOgkrJsCrK66PYPyAOJ0RYvxrRhijQcsVhut4qLJrlW
kN38wd530jZ9QKE2VL4y/VqOv3fjaEq+Sc2CMAJ4ZWjKAYU2ca1XZtFxgCDTDCmh
Tjjt5B3tV1NOAKONblBGh3oT95G4Q/SIRr3Y/8YP0voCPJqdnNBITC8NprY/JRZ0
8iaSH/qlWuiXl758MsMwN2etgHHoRY7cG1pwoh8CVzeeaLbqHoS7DOGkMuzkYTVF
mliaLISkskWB1o1gFAlzzvJYctLjax2/2b8v/cR9ye17tmCAf29H/sBS89GOYa9D
9c/4O5Zn6vTZumM/XWU=
=P1G9
-----END PGP SIGNATURE-----

--tuFXEhzhBeitrIAu--
