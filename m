Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2HBXIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 19:08:15 -0400
Received: from trem.minaslivre.org ([74.50.53.205]:35515 "EHLO
	grilo.cascardo.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2HBXIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 19:08:12 -0400
Date: Thu, 2 Aug 2012 20:06:54 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Carlos Alberto Lopez Perez <clopez@igalia.com>
Cc: Daniel Oliveira Nascimento <don@syst.com.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] classmate-laptop: always call input_sync() after
 input_report_switch()
Message-ID: <20120802230653.GB31058@nautilus.holoscopio.com>
References: <1343929821-18054-1-git-send-email-clopez@igalia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <1343929821-18054-1-git-send-email-clopez@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 02, 2012 at 07:50:21PM +0200, Carlos Alberto Lopez Perez wrote:
> Due to commit cdda911c34006f1089f3c87b1a1f31ab3a4722f2 evdev only
> becomes readable when the buffer contains an EV_SYN/SYN_REPORT event.
>=20
> So in order to read the tablet sensor data as it happens we need to
> ensure that we always call input_sync() after input_report_switch()
>=20
> Signed-off-by: Carlos Alberto Lopez Perez <clopez@igalia.com>

Thanks, Carlos.

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

> ---
>  drivers/platform/x86/classmate-laptop.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x=
86/classmate-laptop.c
> index 2ca7dd1..0667aa9 100644
> --- a/drivers/platform/x86/classmate-laptop.c
> +++ b/drivers/platform/x86/classmate-laptop.c
> @@ -723,8 +723,10 @@ static void cmpc_tablet_handler(struct acpi_device *=
dev, u32 event)
>  	struct input_dev *inputdev =3D dev_get_drvdata(&dev->dev);
> =20
>  	if (event =3D=3D 0x81) {
> -		if (ACPI_SUCCESS(cmpc_get_tablet(dev->handle, &val)))
> +		if (ACPI_SUCCESS(cmpc_get_tablet(dev->handle, &val))) {
>  			input_report_switch(inputdev, SW_TABLET_MODE, !val);
> +			input_sync(inputdev);
> +		}
>  	}
>  }
> =20
> @@ -737,8 +739,10 @@ static void cmpc_tablet_idev_init(struct input_dev *=
inputdev)
>  	set_bit(SW_TABLET_MODE, inputdev->swbit);
> =20
>  	acpi =3D to_acpi_device(inputdev->dev.parent);
> -	if (ACPI_SUCCESS(cmpc_get_tablet(acpi->handle, &val)))
> +	if (ACPI_SUCCESS(cmpc_get_tablet(acpi->handle, &val))) {
>  		input_report_switch(inputdev, SW_TABLET_MODE, !val);
> +		input_sync(inputdev);
> +	}
>  }
> =20
>  static int cmpc_tablet_add(struct acpi_device *acpi)
> @@ -757,8 +761,10 @@ static int cmpc_tablet_resume(struct device *dev)
>  	struct input_dev *inputdev =3D dev_get_drvdata(dev);
> =20
>  	unsigned long long val =3D 0;
> -	if (ACPI_SUCCESS(cmpc_get_tablet(to_acpi_device(dev)->handle, &val)))
> +	if (ACPI_SUCCESS(cmpc_get_tablet(to_acpi_device(dev)->handle, &val))) {
>  		input_report_switch(inputdev, SW_TABLET_MODE, !val);
> +		input_sync(inputdev);
> +	}
>  	return 0;
>  }
> =20
> --=20
> 1.7.10.4
>=20

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQGwgMAAoJEAq6ZQNy/ZVxjnwP/334VoWgA/rjVtgNX0p2hsvC
HaEayHZc3mKT0Wro9N+8yUDvP7wd32obZpYVs26UuaVXq9Zt/9JulMJsZ7krE9Oy
9znrbdOHxd7kPYgDxmbsiIeYV6Zp+4CUGVkm60dbfjlHd+557PQPI0AhuYlCCgmF
pQiGtw//SAbil63p/PQcP/8TVDjoAwhJcvjh1Mxi/CeNua8inkiFMszMcVCw9Ohw
RlL7GCOAhWwb22K3p1D3OSJNsqqiinY9b3CkEd+fvJnsvRkdSI5HOnl8U6iYzgmJ
IAQ7PRtJnCzlcHlXJsgUTnATnxqo/XK0A9x/rS1MR2FgGxtXR48hpSJEuOMskVd+
KXb7c6k6fhZEdJqochZRIRO3r+S09woNYzhLyQyWyw+mDysdTbZT3SHe6wNcP59P
PSIVmAq1W2zGHRsXZTUih/smMaYP04gIsXFXo794IYrj6L8lQI7RVvhKyvBehXph
8IBlK2UaDrCK30kunf2F42EZ12jFZwZsQwal0rJPWFnZxXLmgg5CjtYAifCgYbri
MSr45xMsJu/g10pe/eILqtyWpavyS4ErAyCuVk0MSJizcjwV7agTOYpTWB8hEAb7
ZotusP9aarZf1KwFUu+sOlJL01nPIGjQRN0kw+6Q5fOHwsZV3pZ1oWkxl60Awl/m
r0FDE7+SOgLbIDlCj3Sd
=gcub
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
