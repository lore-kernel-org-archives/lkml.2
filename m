Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2LSPtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:49:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab2LSPtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:49:14 -0500
Date: Wed, 19 Dec 2012 16:48:35 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rtc-pcf8523: Add low battery voltage support
Message-ID: <20121219154828.GA32019@avionic-0098.adnet.avionic-design.de>
References: <20121219140456.GA14217@axis.com>
 <20121219144225.GB7837@avionic-0098.adnet.avionic-design.de>
 <20121219151054.GB14217@axis.com>
 <20121219151937.GA21212@avionic-0098.adnet.avionic-design.de>
 <20121219153432.GC14217@axis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20121219153432.GC14217@axis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:qgyT3jGE+N1Dppor0PaQaNmNYGz8RLVzu01yZrAHDFy
 t1rCZzcGeNi/C0Vwdiz4/eKpGYWVnQ9k6Ozz7S27k121AQxfz1
 FH1Z67AnlKX1KObt2T2nCJ0ClieZx68t5bLdCkMboq3EyyaV0b
 lPmyGEgaysBqjWbLxfVIQc2nzECrJndt7v8TGcW/fpa2xZbvF3
 PRtaNtG0HOnKhWVYpM8m5JSaB+i7RNuwazEA+au5qDRvylX3Md
 QeJCJB7ASym1QgZmz4rOjWmBMZZh7NHUgh4dWf8M6Mz33lv71x
 sf9yta3k/FeVGVlEBc7U3rOe6FiTvPJ6emubxM8elR1b13Esns
 N0FZFHOGVqX/qttwtFbMkeci8wT+S2lC4b+iNpGYelNOAgMaBF
 g56swPdZnzDISXDv+qOmC2a4ljzheoIO/U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 19, 2012 at 04:34:32PM +0100, Jesper Nilsson wrote:
> This patch implements reading of the battery voltage low signal for
> rtc-pcf8523.
>=20
> The bit is read-only and cannot be cleared by software, so no
> clear-function is implemented.
>=20
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> ---
> diff --git a/drivers/rtc/rtc-pcf8523.c b/drivers/rtc/rtc-pcf8523.c
> index be05a64..62905fb 100644
> --- a/drivers/rtc/rtc-pcf8523.c
> +++ b/drivers/rtc/rtc-pcf8523.c
> @@ -23,6 +23,7 @@
>  #define REG_CONTROL3_PM_VDD (1 << 6) /* switch-over disabled */
>  #define REG_CONTROL3_PM_DSM (1 << 5) /* direct switching mode */
>  #define REG_CONTROL3_PM_MASK 0xe0
> +#define REG_CONTROL3_BLF (1 << 2) /* battery low bit, read-only */
> =20
>  #define REG_SECONDS  0x03
>  #define REG_SECONDS_OS (1 << 7)
> @@ -250,9 +252,36 @@ static int pcf8523_rtc_set_time(struct device *dev, =
struct rtc_time *tm)
>  	return pcf8523_start_rtc(client);
>  }
> =20
> +static int
> +pcf8523_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar=
g)

You should keep the modifier and return type on the same line as the
function name and wrap the arguments instead. That is:

static int pcf8523_rtc_ioctl(struct device *dev, unsigned int cmd,
			     unsigned long arg)
{
	...
}

> +{
> +	struct i2c_client *client =3D to_i2c_client(dev);
> +	u8 value;
> +	int err;
> +	int ret =3D 0;

You can probably collapse the two integers in one line, like so:

	int ret =3D 0, err;

Other than that, looks good:

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ0eHMAAoJEN0jrNd/PrOhagIP/3QAw1fv4UTdFZYhseQ8pzy6
Q+Uhxwk3vneSfs9a3xu7wbQhwHG4soAmVSDJy0aPdCSM01xnVHtK0bq1zGrXLeFC
A9PtnpHMx6Lvt+E6rvoKoIExacnMe4uR4AUC/T+iQgfC2Ge5Hti5fikpMgE5Z48Z
NDJoS2aIHAEo23oZgnhYcTdnlwfMkiPwIrqxwsnXzYzoW+GBkwK/5mhMYq33+QS2
quO3cxezkZnrhh+JAIOLkdJXieHPvGPOPbkC1FbeVDmJ/ITdZd+tlKe2WR27lste
nom5zrHB4hEBOPCxE3xVyvzXtxxwUS0QXR1zEEluCbfUMtZL8zhcaGVnMhw41qaJ
Z9Els23n5aHSg3yYAyP3uKv+yA0BIgFrb9YxRjHVkQ/lfZvA3Zh9krfmvkn/fgnU
DM8RcbhKmMFmMrgtR9FPSs5T9BW1nndLCfqKTimpjVopuVwAkSsS6kaiVKqdqOyN
fuaYRROTekKCnlGjlvyY+mwqkrw1yPdD7TzOcxRBPynVdlmalantVGRuzn6tcfQ+
8Z7SiypfHgf2JUiSt2CcLd/DoOScRL95u+y+H98KuYt9WCMfZI51ya83i+uroYtm
MNGVqYgmLhfWm5RfdIWxj3gxnyfU2yjNHVM/5LjZtvAhCyhNbZ3vnihMg6eNkZDk
je8JcSApnzzFzFuiHlks
=quNw
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
