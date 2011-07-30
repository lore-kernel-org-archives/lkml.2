Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab1G3KlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 06:41:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55863 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1G3KlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 06:41:09 -0400
Date: Sat, 30 Jul 2011 12:41:01 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: riyer@nvidia.com
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, olof@lixom.net,
        amartin@nvidia.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v1] Input: tegra-kbc - fix computation of polling time
Message-ID: <20110730104101.GA12309@avionic-0098.mockup.avionic-design.de>
References: <1311981417-31865-1-git-send-email-riyer@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <1311981417-31865-1-git-send-email-riyer@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:brLniJB8DxtO1s9cP/ChYwGQw9SMsk40F/ezIo8lUiN
 Lq0B/4HR3ziIKq8LMtYBxsZGdOA7/xjO90XVgsv8JgRcbc1Exx
 2LJyBdPSvIyuRKgfuDm+OBzq8eIO/D+VerXd9gf/y7Ox/giZuq
 9dGVdmfUc5H+zc5zfHkB3gJI63lYWAemprxH+OL6HxCXFfDDIG
 nwX9LXW5C/jCYwf8AOT5kTla5X1lI/g4oiaa+OdBrU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* riyer@nvidia.com wrote:
> From: Rakesh Iyer <riyer@nvidia.com>
>=20
> Fix a constant definition and computation of polling time.
>=20
> Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> ---
>  drivers/input/keyboard/tegra-kbc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/=
tegra-kbc.c
> index da3828f..263f6fc 100644
> --- a/drivers/input/keyboard/tegra-kbc.c
> +++ b/drivers/input/keyboard/tegra-kbc.c
> @@ -37,7 +37,7 @@
>  #define KBC_ROW_SCAN_DLY	5
> =20
>  /* KBC uses a 32KHz clock so a cycle =3D 1/32Khz */
> -#define KBC_CYCLE_USEC	32
> +#define KBC_CYCLE_MS	32
> =20
>  /* KBC Registers */
> =20
> @@ -647,7 +647,7 @@ static int __devinit tegra_kbc_probe(struct platform_=
device *pdev)
>  	debounce_cnt =3D min(pdata->debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
>  	scan_time_rows =3D (KBC_ROW_SCAN_TIME + debounce_cnt) * num_rows;
>  	kbc->repoll_dly =3D KBC_ROW_SCAN_DLY + scan_time_rows + pdata->repeat_c=
nt;
> -	kbc->repoll_dly =3D ((kbc->repoll_dly * KBC_CYCLE_USEC) + 999) / 1000;
> +	kbc->repoll_dly =3D (kbc->repoll_dly + KBC_CYCLE_MS - 1) / KBC_CYCLE_MS;

You might want to consider using DIV_ROUND_UP for this.

Thierry

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4z370ACgkQZ+BJyKLjJp/VAQCdErLNgpcMILcKCw0KA3gt0nxx
gp8An2HcQjGUKBukFxMuYBMURUZCTAhX
=7O7h
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
