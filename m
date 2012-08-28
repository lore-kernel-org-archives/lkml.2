Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2H1Jxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 05:53:40 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:55880 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869Ab2H1Jxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 05:53:37 -0400
Date: Tue, 28 Aug 2012 12:49:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: ccross@android.com, olof@lixom.net, swarren@wwwdotorg.org,
        linux@arm.linux.org.uk, stern@rowland.harvard.edu,
        gregkh@linuxfoundation.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: tegra: moving phy driver into drivers directory
Message-ID: <20120828094924.GT27166@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1346146338-4996-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L2YZAWjVjAQ1Un1Q"
Content-Disposition: inline
In-Reply-To: <1346146338-4996-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L2YZAWjVjAQ1Un1Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 28, 2012 at 03:02:18PM +0530, Venu Byravarasu wrote:
> In order to keep up with the USB driver files organization,
> moving USB phy driver from mach-tegra to drivers/USB directory.
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  arch/arm/mach-tegra/Makefile                       |    1 -
>  arch/arm/mach-tegra/devices.c                      |    8 +-------
>  arch/arm/mach-tegra/devices.h                      |    2 --
>  drivers/usb/host/ehci-tegra.c                      |    2 +-
>  drivers/usb/phy/Makefile                           |    1 +
>  .../usb_phy.c =3D> drivers/usb/phy/tegra_usb_phy.c   |    4 +---
>  .../usb_phy.h =3D> drivers/usb/phy/tegra_usb_phy.h   |    2 --
>  7 files changed, 4 insertions(+), 16 deletions(-)
>  rename arch/arm/mach-tegra/usb_phy.c =3D> drivers/usb/phy/tegra_usb_phy.=
c (99%)
>  rename arch/arm/mach-tegra/include/mach/usb_phy.h =3D> drivers/usb/phy/t=
egra_usb_phy.h (97%)
>=20
> diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
> index b94858f..b542dac 100644
> --- a/arch/arm/mach-tegra/Makefile
> +++ b/arch/arm/mach-tegra/Makefile
> @@ -25,7 +25,6 @@ obj-$(CONFIG_HOTPLUG_CPU)               +=3D hotplug.o
>  obj-$(CONFIG_TEGRA_SYSTEM_DMA)		+=3D dma.o
>  obj-$(CONFIG_CPU_FREQ)                  +=3D cpu-tegra.o
>  obj-$(CONFIG_TEGRA_PCI)			+=3D pcie.o
> -obj-$(CONFIG_USB_SUPPORT)		+=3D usb_phy.o
> =20
>  obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+=3D board-dt-tegra20.o
>  obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+=3D board-dt-tegra30.o
> diff --git a/arch/arm/mach-tegra/devices.c b/arch/arm/mach-tegra/devices.c
> index 61e9603..232d7e1 100644
> --- a/arch/arm/mach-tegra/devices.c
> +++ b/arch/arm/mach-tegra/devices.c
> @@ -26,7 +26,6 @@
>  #include <mach/irqs.h>
>  #include <mach/iomap.h>
>  #include <mach/dma.h>
> -#include <mach/usb_phy.h>
> =20
>  #include "gpio-names.h"
>  #include "devices.h"
> @@ -438,11 +437,6 @@ static struct resource tegra_usb3_resources[] =3D {
>  	},
>  };
> =20
> -struct tegra_ulpi_config tegra_ehci2_ulpi_phy_config =3D {
> -	.reset_gpio =3D -1,
> -	.clk =3D "cdev2",
> -};
> -
>  struct tegra_ehci_platform_data tegra_ehci1_pdata =3D {
>  	.operating_mode =3D TEGRA_USB_OTG,
>  	.power_down_on_bus_suspend =3D 1,
> @@ -450,7 +444,7 @@ struct tegra_ehci_platform_data tegra_ehci1_pdata =3D=
 {
>  };
> =20
>  struct tegra_ehci_platform_data tegra_ehci2_pdata =3D {
> -	.phy_config =3D &tegra_ehci2_ulpi_phy_config,
> +	.phy_config =3D NULL,
>  	.operating_mode =3D TEGRA_USB_HOST,
>  	.power_down_on_bus_suspend =3D 1,
>  	.vbus_gpio =3D -1,
> diff --git a/arch/arm/mach-tegra/devices.h b/arch/arm/mach-tegra/devices.h
> index 4f50527..6bac5e6 100644
> --- a/arch/arm/mach-tegra/devices.h
> +++ b/arch/arm/mach-tegra/devices.h
> @@ -22,8 +22,6 @@
>  #include <linux/platform_device.h>
>  #include <linux/platform_data/tegra_usb.h>
> =20
> -#include <mach/usb_phy.h>
> -
>  extern struct tegra_ulpi_config tegra_ehci2_ulpi_phy_config;
> =20
>  extern struct tegra_ehci_platform_data tegra_ehci1_pdata;
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 75eca42..a03e279 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -27,7 +27,7 @@
>  #include <linux/of_gpio.h>
>  #include <linux/pm_runtime.h>
> =20
> -#include <mach/usb_phy.h>
> +#include "../phy/tegra_usb_phy.h"
>  #include <mach/iomap.h>
> =20
>  #define TEGRA_USB_DMA_ALIGN 32
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index eca095b..663164f 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -5,3 +5,4 @@
>  ccflags-$(CONFIG_USB_DEBUG) :=3D -DDEBUG
> =20
>  obj-$(CONFIG_USB_ISP1301)		+=3D isp1301.o
> +obj-$(CONFIG_USB_EHCI_TEGRA)		+=3D tegra_usb_phy.o
> diff --git a/arch/arm/mach-tegra/usb_phy.c b/drivers/usb/phy/tegra_usb_ph=
y.c
> similarity index 99%
> rename from arch/arm/mach-tegra/usb_phy.c
> rename to drivers/usb/phy/tegra_usb_phy.c
> index 022b33a..c856716 100644
> --- a/arch/arm/mach-tegra/usb_phy.c
> +++ b/drivers/usb/phy/tegra_usb_phy.c
> @@ -1,6 +1,4 @@
>  /*
> - * arch/arm/mach-tegra/usb_phy.c
> - *
>   * Copyright (C) 2010 Google, Inc.
>   *
>   * Author:
> @@ -31,7 +29,7 @@
>  #include <linux/usb/ulpi.h>
>  #include <asm/mach-types.h>
>  #include <mach/gpio-tegra.h>
> -#include <mach/usb_phy.h>
> +#include "tegra_usb_phy.h"
>  #include <mach/iomap.h>
> =20
>  #define ULPI_VIEWPORT		0x170

NAK, needs to be converted to proper PHY driver (misnamed as
include/linux/usb/otg.h). You will need proper phy->init, phy->suspend,
phy->resume, etc callbacks.

--=20
balbi

--L2YZAWjVjAQ1Un1Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQPJQkAAoJEIaOsuA1yqREceMP/21DQjQdbSgEPw8/6zS+DQ5E
EMXf0wtHCBNTl6F57vQa5pmymBmK2kIg9QxjlHx+ARNZuQrU9cITi2xrICGyWPbW
iIFUkeJiAb4haPCcEGvf0E+8bLYADCT05NDgcEvQ+uGMDkcHH0zVI1BXSMDqrv3C
wVI1wLPbwxX8jZbd0XSbAY86dFXgIn8UqbUOOLT4scWTSNeOedx5EOTeXQrQM98e
CeRnnNgRXNXQ3QBTRXYPbZfULzoevMhSZAclBH4/dO8AR3LTAlY/eJMuF37qZAbN
VsyCORw9ZjtmPUdRX3K61yeUKQTSrpf4MqoDcsWILOD1T/phpqQa5punB067XUOv
MKScpvzlluo+kEpCOMzUvp9OSowuuhE5FxX4cK/nrqu8r/gZ68FoZ7t38iiBYRf6
2oZCp/+WuUweDQXiihmSB6JRIdXDucg8Cpx6vwpsE3oyJQkTPRBQrqGeX7rntQfh
JUtUq2S+6DDBtbJxce4SVaPvMdRCeu4kyNYSYZCyPAf81KK5RM6brrTGETmDikw+
8AP1a2genhXWwRCUNvk/eZhp0/pC3iNw8yX9MfORtuFJEFu81NmIriEdq0kDxTYy
TQJRCA1ARzNKLdPnj8qhTL7Tilb9NSuOQRWn+OokqQwTB4AjZF2E3OjZgocwT/EM
TD2Bg4nNVnbqAAF5Oi0C
=IFvN
-----END PGP SIGNATURE-----

--L2YZAWjVjAQ1Un1Q--
