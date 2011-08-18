Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1HRWCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 18:02:30 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:46734 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754812Ab1HRWC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:02:29 -0400
Date: Fri, 19 Aug 2011 01:02:25 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ARM: davinci: da850, omapl138: introduce new
 board-omapl138-heliosv1
Message-ID: <20110818220224.GE21064@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
 <f31e949dcaac301b40a0f6c0b611e84f57636ef0.1313702401.git.bengardiner@nanometrics.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wchHw8dVAp53YPj8"
Content-Disposition: inline
In-Reply-To: <f31e949dcaac301b40a0f6c0b611e84f57636ef0.1313702401.git.bengardiner@nanometrics.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wchHw8dVAp53YPj8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 18, 2011 at 05:50:51PM -0400, Ben Gardiner wrote:
> Add support for the Nanometrics Helios Platform V1 Hardware. Initially
> support includes only serial console and watchdog support.
>=20
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> Reviewed-by: James Nuss <jamesnuss@nanometrics.ca>
> ---
>  arch/arm/mach-davinci/Kconfig                   |    9 ++++
>  arch/arm/mach-davinci/Makefile                  |    1 +
>  arch/arm/mach-davinci/board-omapl138-heliosv1.c |   51 +++++++++++++++++=
++++++
>  3 files changed, 61 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-davinci/board-omapl138-heliosv1.c
>=20
> diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
> index c0deaca..21a8ce9 100644
> --- a/arch/arm/mach-davinci/Kconfig
> +++ b/arch/arm/mach-davinci/Kconfig
> @@ -224,6 +224,15 @@ config MACH_OMAPL138_HAWKBOARD
>  	  Information of this board may be found at
>  	  http://www.hawkboard.org/
> =20
> +config MACH_HELIOS_V1
> +	bool "Nanometrics OMAPL-138 Helios V1 platform"
> +	depends on ARCH_DAVINCI_DA850
> +	help
> +	  Say Y here to select the Nanometrics OMAPL-138 Helios V1 platform.
> +	  This is a development system based on the DA850 EVM baseboard.
> +	  It is the first Helios hardware platform upon which other platforms i=
n the
> +	  Helios product family are based.
> +
>  config DAVINCI_MUX
>  	bool "DAVINCI multiplexing support"
>  	depends on ARCH_DAVINCI
> diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makef=
ile
> index 9a01441..96d74c9 100644
> --- a/arch/arm/mach-davinci/Makefile
> +++ b/arch/arm/mach-davinci/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_MACH_DAVINCI_DA850_EVM)	+=3D board-da850-e=
vm.o
>  obj-$(CONFIG_MACH_TNETV107X)		+=3D board-tnetv107x-evm.o
>  obj-$(CONFIG_MACH_MITYOMAPL138)		+=3D board-mityomapl138.o
>  obj-$(CONFIG_MACH_OMAPL138_HAWKBOARD)	+=3D board-omapl138-hawk.o
> +obj-$(CONFIG_MACH_HELIOS_V1)		+=3D board-omapl138-heliosv1.o
> =20
>  # Power Management
>  obj-$(CONFIG_CPU_FREQ)			+=3D cpufreq.o
> diff --git a/arch/arm/mach-davinci/board-omapl138-heliosv1.c b/arch/arm/m=
ach-davinci/board-omapl138-heliosv1.c
> new file mode 100644
> index 0000000..73cc0a9
> --- /dev/null
> +++ b/arch/arm/mach-davinci/board-omapl138-heliosv1.c
> @@ -0,0 +1,51 @@
> +/*
> + * Nanometrics OMAPL-138 Helios V1 platform.
> + *
> + * Copyright (C) 2011 Nanometrics Inc.
> + * This file is licensed under the terms of the GNU General Public Licen=
se
> + * version 2. This program is licensed "as is" without any warranty of
> + * any kind, whether express or implied.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/console.h>
> +#include <linux/gpio.h>
> +
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +
> +#include <mach/cp_intc.h>
> +#include <mach/da8xx.h>
> +#include <mach/da850-reference.h>
> +
> +static __init void helios_v1_init(void)
> +{
> +	int ret;
> +
> +	da850_reference_serial_init();
> +
> +	ret =3D da8xx_register_watchdog();
> +	if (ret)
> +		pr_warning("%s: watchdog registration failed: %d\n",
> +			__func__, ret);
> +}
> +
> +#ifdef CONFIG_SERIAL_8250_CONSOLE
> +static int __init helios_v1_console_init(void)
> +{
> +	if (!machine_is_helios_v1())
> +		return 0;
> +
> +	return da850_reference_add_preferred_console();
> +}
> +console_initcall(helios_v1_console_init);
> +#endif
> +
> +MACHINE_START(HELIOS_V1, "Nanometrics OMAPL-138 Helios V1 platform")
> +	.boot_params	=3D DA850_REFERENCE_BOOT_PARAMS,
> +	.map_io		=3D da850_reference_map_io,
> +	.init_irq	=3D cp_intc_init,
> +	.timer		=3D &davinci_timer,
> +	.init_machine	=3D helios_v1_init,
> +MACHINE_END

since this also omapl138-based, can't you re-use the
board-omapl138-hawk.c board-file ? I mean, this is only initializing
console and that's it. What else does this board have ? Does it have
USB, that EMAC/MDIO device ?

To me it looks like you could re-use that board-file and just add a few
machine checks for the different part (??)

> --=20
> 1.7.4.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--wchHw8dVAp53YPj8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTYvwAAoJEAv8Txj19kN193kIAJwGNLNdxBzzg+CHQwmh/UnF
Q3A56qKjX0uEZ0K/vu1Rk9hBXj8hCSqD9OLpvOcjMV2kCyPcpDNnwZGgzs7x3g2c
nQ5RF+0zE/vvwc2NDy2AUFunSNrCUUV/zEcKaqk+4WkQdLX8rwi/s4R/4CCMjU1f
K+aXJq2jlLtRlCAFshXiTjBSyYtPyDZFgbsJe/9s/PO4K/N+KA+lEGcj/+qCnGTp
3w9UFz0t4OLwGFoKM6ZujNq+uJ9Xv+xwnI9k63imF1B2k81wQn/s5NnJlSf8dcAV
MKqfrr18RquGXicXOhKp7UvOcfb3RJuH0yMMH9DPG1CkaUNkpPjkbTO5u75Yrl8=
=n08o
-----END PGP SIGNATURE-----

--wchHw8dVAp53YPj8--
