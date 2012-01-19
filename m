Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2ASKtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:49:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60681 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2ASKtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:49:06 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] bq27x00_battery: fix flag register read
Date: Thu, 19 Jan 2012 02:49:03 -0800 (PST)
Message-ID: <12065816.FDViioMQvj@pali>
User-Agent: KMail/4.8 rc2 (Linux/3.2.0-9-generic; KDE/4.7.97; x86_64; ; )
In-Reply-To: <1326574249-31334-1-git-send-email-notasas@gmail.com>
References: <1326574249-31334-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1928388.fJKsZshR1Y"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1928388.fJKsZshR1Y
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Saturday 14 January 2012 22:50:49 Grazvydas Ignotas wrote:
> When reading flags, bq27x00_read() argument is inverted and causes
> reads 2 of bytes for bq27200 and 1 byte for bq27500, while their regi=
ster
> sizes are 1 and 2 bytes respectively. This causes bq27500 upper flag
> bits always to be returned as 0, causing full charge state to never b=
e
> reported correctly, so fix it.
>=20
> Cc: Pali Roh=E1r <pali.rohar@gmail.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---
>  drivers/power/bq27x00_battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/power/bq27x00_battery.c
> b/drivers/power/bq27x00_battery.c index 98bf567..86decb4 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -312,7 +312,7 @@ static void bq27x00_update(struct bq27x00_device_=
info
> *di) struct bq27x00_reg_cache cache =3D {0, };
>  =09bool is_bq27500 =3D di->chip =3D=3D BQ27500;
>=20
> -=09cache.flags =3D bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
> +=09cache.flags =3D bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);=

>  =09if (cache.flags >=3D 0) {
>  =09=09if (!is_bq27500 && (cache.flags & BQ27000_FLAG_CI)) {
>  =09=09=09dev_info(di->dev, "battery is not calibrated! ignoring capa=
city
> values\n");

Yes, you are right, this patch fixing flags register reading.
Anton Vorontsov, can you send this patch to linux 3.3?

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart1928388.fJKsZshR1Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk8X9RwACgkQi/DJPQPkQ1LGzgCfe84mKEyxkLuNoBWUEmeM4Zzj
eFsAn0GzOtHtm4dlGra6stMaMageselw
=tAov
-----END PGP SIGNATURE-----

--nextPart1928388.fJKsZshR1Y--

