Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2GTJxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:53:03 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:36184 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab2GTJw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:52:59 -0400
Date: Fri, 20 Jul 2012 12:49:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com,
        av.tikhomirov@samsung.com
Subject: Re: [PATCH 1/2 v3] USB: dwc3-exynos: Add support for device tree
Message-ID: <20120720094953.GF24414@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1342418259-23802-1-git-send-email-gautam.vivek@samsung.com>
 <1342418259-23802-2-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UKNXkkdQCYZ6W5l3"
Content-Disposition: inline
In-Reply-To: <1342418259-23802-2-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UKNXkkdQCYZ6W5l3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 16, 2012 at 11:27:38AM +0530, Vivek Gautam wrote:
> This patch adds support to parse probe data for
> dwc3 driver for exynos using device tree
>=20
> Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/dwc3/dwc3-exynos.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exyno=
s.c
> index b8f0038..a293c69 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -19,6 +19,7 @@
>  #include <linux/platform_data/dwc3-exynos.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/clk.h>
> +#include <linux/of.h>
> =20
>  #include "core.h"
> =20
> @@ -29,6 +30,8 @@ struct dwc3_exynos {
>  	struct clk		*clk;
>  };
> =20
> +static u64 dwc3_exynos_dma_mask =3D DMA_BIT_MASK(32);
> +
>  static int __devinit dwc3_exynos_probe(struct platform_device *pdev)
>  {
>  	struct dwc3_exynos_data	*pdata =3D pdev->dev.platform_data;
> @@ -45,6 +48,16 @@ static int __devinit dwc3_exynos_probe(struct platform=
_device *pdev)
>  		goto err0;
>  	}
> =20
> +	/*
> +	 * Right now device-tree probed devices don't get dma_mask set.
> +	 * Since shared usb code relies on it, set it here for now.
> +	 * Once we move to full device tree support this will vanish off.
> +	 */
> +	if (!pdev->dev.dma_mask)
> +		pdev->dev.dma_mask =3D &dwc3_exynos_dma_mask;
> +	if (!pdev->dev.coherent_dma_mask)
> +		pdev->dev.coherent_dma_mask =3D DMA_BIT_MASK(32);
> +
>  	platform_set_drvdata(pdev, exynos);
> =20
>  	devid =3D dwc3_get_device_id();
> @@ -134,11 +147,20 @@ static int __devexit dwc3_exynos_remove(struct plat=
form_device *pdev)
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_OF
> +static const struct of_device_id exynos_xhci_match[] =3D {
> +	{ .compatible =3D "samsung,exynos-xhci" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_xhci_match);

this is not an xhci device. It contains one inside of it, but it's not
an xhci device.

--=20
balbi

--UKNXkkdQCYZ6W5l3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQCSnBAAoJEIaOsuA1yqREoRUP/At/inO013H0bVrld9rE0pnv
/hqDtw2eHzawN+ozDV6xvEfWYwVIT0sXDv2ces0WoSyP79kKu84UeX2JNR23c6E6
QfONYP3YpG8W4oi3JhSxXBZVJY2AsIJcU2dETj9vT1CCLrjoz5dgC4Op+Lk9g/T7
cmtIqlyVbWaY5Uyt4umqw/Ic+8K6CglHXeCBYSz4RU/d/68A24iUFYF7xDWjE07F
zP0UCu2xC4Uo0PcT8Oo2py7tzmdWcw/p+v0E4wqoLAWoqhouZJCqvYlTv4SCP/AF
kOXgB/jtR4hw9irKJ4w6jiFCa4j2Npfo8wcEiUrlhlSOK0DTw5n+x80G2PM5sdw8
HVRxHc3q2vm6iusLBexKaO9J+gmfWkdLnbS7Hx6t24Kyy9OFwlmQISIQQwsc1gTy
UiEAYYceYmLvqUgtFgsgEi3LsnRY163IFrViyx8ulZubZRkAjEEgNUOp4bp+B+sZ
lTunSzDvnThMIIbLyTr9yk5R7fK8hyqvnO8Ru+oi/sET02KNDWqxNb3UsGbPNWcs
TkPz8tj/Kmyo2Z4qa3zD+KV/WeEMN5uma3uT0PwWiX4cDpv284EfVjms4WOuEb8v
r5T19nemSLlo+RJ34TLncvmTJkpyZfrJa+l8dtTAUYDIV86noxK2oUVLEytaeUdy
fqTtWyqH6pbLVPpV/gUQ
=zisS
-----END PGP SIGNATURE-----

--UKNXkkdQCYZ6W5l3--
