Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab1CIL7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:59:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48757 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab1CIL7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:59:49 -0500
Message-ID: <4D776BAD.1020307@pengutronix.de>
Date: Wed, 09 Mar 2011 12:59:41 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com,
        Kevin Hilman <khilman@ti.com>, sachi@mistralsolutions.com,
        Russell King <linux@arm.linux.org.uk>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/7] da850: pruss board specific additions.
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-4-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1299592667-21367-4-git-send-email-subhasish@mistralsolutions.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig30EB3043CDAB0E847C9081F4"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig30EB3043CDAB0E847C9081F4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/08/2011 02:57 PM, Subhasish Ghosh wrote:
> This patch adds board specific initializations and setup routines.
>=20
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c |   25 +++++++++++++++++++++++=
++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-da=
vinci/board-da850-evm.c
> index 11f986b..c614c82 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -1053,6 +1053,26 @@ static __init int da850_evm_init_cpufreq(void)
>  static __init int da850_evm_init_cpufreq(void) { return 0; }
>  #endif
> =20
> +static struct da8xx_pruss_devices pruss_devices[] =3D {
> +	{.dev_name =3D NULL,},
> +};
> +
> +static int __init da8xx_evm_setup_pruss(void)
> +{
> +	u32 ret =3D 0;
your functions returns an int, not an u32
> +	u32 count;

use "int i" for loop counter.

> +
> +	for (count =3D 0; count < ARRAY_SIZE(pruss_devices); count++) {
> +		if (pruss_devices[count].setup !=3D NULL) {

you may omit the "!=3D NULL"

> +			ret =3D pruss_devices[count].setup();
> +			if (ret)
> +				return ret;

in case of an error you don't clean up correct

> +		}
> +	}
> +
> +	return da8xx_register_pruss_mfd(pruss_devices);
> +}
> +
>  static __init void da850_evm_init(void)
>  {
>  	int ret;
> @@ -1127,6 +1147,11 @@ static __init void da850_evm_init(void)
> =20
>  	da8xx_register_mcasp(0, &da850_evm_snd_data);
> =20
> +	ret =3D da8xx_evm_setup_pruss();
> +	if (ret)
> +		pr_warning("%s: pruss initialization failed: %d\n",
> +				__func__, ret);
> +
>  	ret =3D davinci_cfg_reg_list(da850_lcdcntl_pins);
>  	if (ret)
>  		pr_warning("da850_evm_init: lcdcntl mux setup failed: %d\n",


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig30EB3043CDAB0E847C9081F4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk13a60ACgkQjTAFq1RaXHMzXgCeMaNHoqSKqAIWIAtj7Aq62ORZ
0swAn0dKYKPAq0ChyPqtz6Hssuh0qt41
=kYSS
-----END PGP SIGNATURE-----

--------------enig30EB3043CDAB0E847C9081F4--
