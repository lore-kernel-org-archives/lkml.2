Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2I1NDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:03:45 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:41042 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932111Ab2I1NDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:03:42 -0400
Date: Fri, 28 Sep 2012 15:58:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com
Subject: Re: [PATCH 2/6] usb: dwc3-omap: use runtime API's to enable clocks
Message-ID: <20120928125840.GL31006@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
 <1348836795-4783-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYjWXklH5JTzT8n9"
Content-Disposition: inline
In-Reply-To: <1348836795-4783-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TYjWXklH5JTzT8n9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 28, 2012 at 06:23:11PM +0530, Kishon Vijay Abraham I wrote:
> Before accessing any register, runtime API's should be invoked to enable
> the clocks. runtime API's are added here to prevent abort during register
> access.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/dwc3/dwc3-omap.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index 34578de..6a0e17f 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -43,6 +43,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/platform_device.h>
>  #include <linux/platform_data/dwc3-omap.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/ioport.h>
>  #include <linux/io.h>
> @@ -281,6 +282,13 @@ static int __devinit dwc3_omap_probe(struct platform=
_device *pdev)
>  	omap->irq	=3D irq;
>  	omap->base	=3D base;
> =20
> +	pm_runtime_enable(dev);
> +	ret =3D pm_runtime_get_sync(dev);
> +	if (ret < 0) {
> +		dev_err(dev, "get_sync failed with err %d\n", ret);
> +			goto err1;
> +	}
> +
>  	reg =3D dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
> =20
>  	utmi_mode =3D of_get_property(node, "utmi-mode", &size);
> @@ -354,6 +362,8 @@ err1:
>  static int __devexit dwc3_omap_remove(struct platform_device *pdev)
>  {
>  	device_for_each_child(&pdev->dev, NULL, dwc3_remove_core);
> +	pm_runtime_put(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);

You're going to disable pm_runtime here, so it's better to use
pm_runtime_put_sync(), I guess ??

--=20
balbi

--TYjWXklH5JTzT8n9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZZ8AAAoJEIaOsuA1yqRExVsQAINWv8An6bXBHVghOUvxdPKO
5JSEWQgADox1Viau5wFikgbLdejiBdCcGLJmhhVuG6RynBvICM82A+ZEIC6AopXe
aQ8qRrhimQCLEkLw9j50qPV/l8uFkCtM1OEt2oHCddhuLTrY4HPKnOJ3002vp6bp
uTYRqpwbsWjj/Z7G7OGD1L87YzUEMdcO9Tvd1SaFnkRPABxXwqaCfxn2kfTtgQUO
GlMNn5A7zT6bjJXGaI0v7kipbaYhta5HS4wilFMv7uOFd9MhqQhsbcol9RqvsHWd
U8dVB3EQ0Xt+uNe704AdBp5KKujqUI6IXvghrB2+y/z/n+13HJ/GIVi3SpPrCQOv
+hqx7uwASzsNYRmK5gnnEJevqQ10Bi0LHAka5BbWJB5r6Zm6xWb0vyf1MHcyRLeq
/N2iS/C+vpPMeoGTJfUfAi/7HE8XB1fCd3l71Mow0dWS68/k+UxgyglUQV/DHttp
vegMad9ltwMjaFmEQnyTHj6PmBgFKS1u/Ux0cMGkzvkCdyAtGtlHNvNQ4OisUUa8
RilZLItmqAymtobtJmXPfhZH+KilujGMq/Rq3z/SanEOafj+P0QL5fmdkaiCO2rp
LhIOIBOWReFf1mXRYyvx+rKXBbLYs+WjzLLLcD8EpB2w+jKDNHy7tcvlpeFPrdFR
4tZNv3I57SpR/w5k+pu/
=8l0X
-----END PGP SIGNATURE-----

--TYjWXklH5JTzT8n9--
