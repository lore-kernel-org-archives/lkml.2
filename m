Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2GTJyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:54:40 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:58792 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab2GTJyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:54:38 -0400
Date: Fri, 20 Jul 2012 12:51:35 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com,
        av.tikhomirov@samsung.com
Subject: Re: [PATCH 2/2 v3] USB: dwc3-exynos: Add vbus setup function to the
 exynos dwc3 glue layer
Message-ID: <20120720095134.GG24414@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1342418259-23802-1-git-send-email-gautam.vivek@samsung.com>
 <1342418259-23802-3-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIIRZ1HQ6FgrlPgb"
Content-Disposition: inline
In-Reply-To: <1342418259-23802-3-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIIRZ1HQ6FgrlPgb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 16, 2012 at 11:27:39AM +0530, Vivek Gautam wrote:
> This patch retrieves and configures the vbus control gpio via
> the device tree. The suspend/resume callbacks will be later
> modified for vbus control.
>=20
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/dwc3/dwc3-exynos.c |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exyno=
s.c
> index a293c69..9b0238f 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -20,6 +20,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/clk.h>
>  #include <linux/of.h>
> +#include <linux/of_gpio.h>
> =20
>  #include "core.h"
> =20
> @@ -30,6 +31,28 @@ struct dwc3_exynos {
>  	struct clk		*clk;
>  };
> =20
> +static int dwc3_setup_vbus_gpio(struct platform_device *pdev)
> +{
> +	int err;
> +	int gpio;
> +
> +	if (!pdev->dev.of_node)
> +		return 0;
> +
> +	gpio =3D of_get_named_gpio(pdev->dev.of_node,
> +				"samsung,vbus-gpio", 0);
> +	if (!gpio_is_valid(gpio))
> +		return 0;
> +
> +	err =3D gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "dwc3_vbus_gpio");
> +	if (err) {
> +		dev_err(&pdev->dev, "can't request dwc3 vbus gpio %d", gpio);
> +		return err;
> +	}
> +
> +	return err;
> +}
> +
>  static u64 dwc3_exynos_dma_mask =3D DMA_BIT_MASK(32);
> =20
>  static int __devinit dwc3_exynos_probe(struct platform_device *pdev)
> @@ -58,6 +81,8 @@ static int __devinit dwc3_exynos_probe(struct platform_=
device *pdev)
>  	if (!pdev->dev.coherent_dma_mask)
>  		pdev->dev.coherent_dma_mask =3D DMA_BIT_MASK(32);
> =20
> +	dwc3_setup_vbus_gpio(pdev);

I think this should be handled by the gpio-vbus transceiver. No ?

--=20
balbi

--WIIRZ1HQ6FgrlPgb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQCSomAAoJEIaOsuA1yqRE7J8P/A29Zx7roSCMCj5yXegDFuEI
MtlFlhaFIPZyN9uvzwjOiuUzOO2ZgDq3uie3Ve8bZLGReU+qyHvb1IkxjzVm/cOa
c6Pl+69bMJZXC7qCX2IDF+TTGnoCEpgr3DRSJgY12UkZlcAuQuHI8QMq8IpVJbao
rDoUoCYOEy+gKHJgNHRa/+F9JUPIY+AIKHUxVFBVumb2KpfLNHkBpSwwiFGy3Ilc
Qb0bAmkycT3oTyLiw1d6fIoUiuR01PNC+uMzkwbZc6LGqI6Dg18JQo/68In46vj/
wuCzHomCPwCzzt05OQy53ESXyw/i4RBbSrv+r09sTuJ77mEMBl/P+YqJuFp6VMHi
P6P/b2H+R0/06Fz7AGeHyE02BiiKxbnRzboerpoXtgztMaHsYiR7B13chWhqSd/A
NLFCNJBCRK4seRz2X7CgyCwqeWh79A4KkGj+3TY/pDJsBTrIfppcGHHfMfPjDzl2
KNJZmMnOYeVJBgvUGcX8gjPEQ3YMATV/QuVssP5aYM6hN1LAi2D8T5pCvUtVR98x
+Oym+9Wr73m5nFoMMBkP8qlstsE39BUUF456bRuYWka5APZBi0uZCIlHBXWI1ufB
O5Ks8/K3Bc6AXAzMrbqwMxCpxffefRdXKe4plHtx9kfDukw2fRqjpdbvgSAKR4q0
xywia9jHrOTw0ZeDXar4
=JdIW
-----END PGP SIGNATURE-----

--WIIRZ1HQ6FgrlPgb--
