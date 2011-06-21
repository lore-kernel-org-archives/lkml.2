Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1FUT6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:58:05 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:41423 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1FUT6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:58:03 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jun 2011 15:58:03 EDT
Date: Tue, 21 Jun 2011 16:50:39 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Carlos Alberto Lopez Perez <clopez@igalia.com>
Cc: Daniel Oliveira Nascimento <don@syst.com.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/platform: classmate-laptop: Add cmpc_keys
 support for new classmate laptops
Message-ID: <20110621195038.GC2724@nautilus.holoscopio.com>
References: <1308685201-15541-1-git-send-email-clopez@igalia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Content-Disposition: inline
In-Reply-To: <1308685201-15541-1-git-send-email-clopez@igalia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 21, 2011 at 09:40:01PM +0200, Carlos Alberto Lopez Perez wrote:
> The cmpc_keys ACPI driver from the classmate-laptop module fails to
> recognize the device on the 4th generation of classmate laptops (Atom N45=
0)
> because the device ID is named "FNBT0000" (uppercase N) on this laptops.
>=20
> MODALIAS=3Dacpi:FNBT0000:
>=20
> This patch makes the driver cmpc_keys recognize it:
>=20
> input: cmpc_keys as /devices/LNXSYSTM:00/device:00/FNBT0000:00/input/inpu=
t18
>=20
> Signed-off-by: Carlos Alberto Lopez Perez <clopez@igalia.com>
> ---
>  drivers/platform/x86/classmate-laptop.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x=
86/classmate-laptop.c
> index 94f93b6..03896cd 100644
> --- a/drivers/platform/x86/classmate-laptop.c
> +++ b/drivers/platform/x86/classmate-laptop.c
> @@ -40,6 +40,7 @@ struct cmpc_accel {
>  #define CMPC_TABLET_HID		"TBLT0000"
>  #define CMPC_IPML_HID	"IPML200"
>  #define CMPC_KEYS_HID		"FnBT0000"
> +#define CMPC_KEYS_4GEN_HID	"FNBT0000"
> =20
>  /*
>   * Generic input device code.
> @@ -683,6 +684,7 @@ static int cmpc_keys_remove(struct acpi_device *acpi,=
 int type)
> =20
>  static const struct acpi_device_id cmpc_keys_device_ids[] =3D {
>  	{CMPC_KEYS_HID, 0},
> +	{CMPC_KEYS_4GEN_HID, 0},
>  	{"", 0}
>  };
> =20
> @@ -754,6 +756,7 @@ static const struct acpi_device_id cmpc_device_ids[] =
=3D {
>  	{CMPC_TABLET_HID, 0},
>  	{CMPC_IPML_HID, 0},
>  	{CMPC_KEYS_HID, 0},
> +	{CMPC_KEYS_4GEN_HID, 0},
>  	{"", 0}
>  };
> =20
> --=20
> 1.7.5.3
>=20

Not-Acked-By: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Recent Linux versions have "upper-cased" the device names, because ACPI
spec says devices must have upper-case letters. This is probably related
to this change, not because the device name has changed in recent
versions of the device. So the correct fix would be to either revert
this change in Linux or use only a single uppercase name for the device.

Thanks anyway for this report. I have received one report in private a
while back, but was too lazy to discuss this on the list. Any pointers
on that? Easist way to go is to simply replace FnBT for FNBT.

Regards,
Cascardo.

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOAPYOAAoJEEWxSg7udFZI5HgP/jqkclsnpxAZwoZsleELdJ8h
Cyv2762dpKlIfUzGJ+SE4zTKDFFIQJgvJgjo1l0YQlu4+oZgu4B0MCQPCHltWURe
I052QogSd+f/EGrsce87xBbGpK1eiB8ME+INvJlQDM2u4nOlx3Pvjj0+q11y5kz8
gtfk9RK1UIIStD9VQBTm0yJsI0ZwMA1MH0CsPxnyeN0rgg4Ad4Il3WqQI3yZe0ua
yvb4R7IiYgKujOPcrioM1yz7FE71m87SKt3/YBLdAUtmxLkojmWo5n6noSIrNt1q
jPU+m9qAj5L3bcVhCjkFDWthgAF19yFQwKAoLPAQjwDrUdstx0MBUYDllfmDpSgR
113KL8ssP5qKT51htxnKIvUwH2u+tDMw2M9Eynr3gcybLHVyAEk4oH54wrRWDkYc
yf/Dz2tErWMH9oBf9MDziH4ME0GCgo0dRT/MudixOOVvAMLwYzrAjD38ZutmPM11
Y45rxMOT+dZnrZmW5DG+KUJ+W2zb4rnRzBUAjIIKK7jkb9n6+B6crnUCiRNvuFCZ
rYVft6YwWDyzPJFwgwduybhynR9aLtoKEbs91D6NmanZsGcGoLIecAjItYBO1ALJ
YinXWuhUuf+2SLUyEpgC8zl5zj9gsNs289iq8gQkGS1fSF+g+oJyds6Meu+k7oBt
NCrHCslnK1a4siJ3q+MS
=2p7q
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
