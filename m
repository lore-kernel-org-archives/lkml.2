Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab2KIIao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:30:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2KIIak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:30:40 -0500
Date: Fri, 9 Nov 2012 09:30:28 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH] pwm: Device tree support for PWM polarity.
Message-ID: <20121109083028.GD26007@avionic-0098.mockup.avionic-design.de>
References: <1351532427-19881-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2Z2K0IlrPCVsbNpk"
Content-Disposition: inline
In-Reply-To: <1351532427-19881-1-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:apSTDu47oTSjiIOI3rUkx15zuyEYweHACssdJOeKmmx
 QjWnNdIjJ3U5PeEdgzJnCVOGQh10Y8gT3aC9CccQlu6HerfInl
 8/ejOXmQ8ieESGCMN3yLvEirsQxXqkbTbMCymVPBo7af40kjdK
 HJdbSVC15ulhVUysuSA5xF/Wm+J/WXzy1QpVsVcDTGu/mmXYpc
 2puv8QHHb8b/mtxb5bnEJdXeyh7UCOEcHKjYYwWgPNdkh2aVsu
 aPQb0M+vaLmzBll+PCrANTpxJZE8gXDxUJfQ7kgLJWGlAMvOJX
 4NL4uM+mapzYfecRgy3p1hwwmdZcsz3oErXJi5MjU5n7k3BB5i
 kl3vnowY5tFaTv7LLqWxSI3JCnSHI/3Gnio+PJ2elY8xgxhqrv
 NzSSguk2nb5IPHhzRPCehIax/IvCSaGvsE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 29, 2012 at 11:10:27PM +0530, Philip, Avinash wrote:
> From: "Philip, Avinash" <avinashphilip@ti.com>
>=20
> Adds support for 3rd cell in pwm-specifier. PWM polarity is encoded in
> device tree support in bit encoded form. Platforms require polarity of
> PWM device initialized during PWM device initialization has to encode
> polarity in 3rd cell of pwm-specifier.
>=20
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> ---
> :100644 100644 73ec962... e522c59... M	Documentation/devicetree/bindings/=
pwm/pwm.txt
> :100644 100644 f5acdaa... 1c6d50b... M	drivers/pwm/core.c
> :100644 100644 112b314... d77c5b3... M	include/linux/pwm.h
>  Documentation/devicetree/bindings/pwm/pwm.txt |   22 +++++++++++++++++++=
---
>  drivers/pwm/core.c                            |   13 ++++++++++++-
>  include/linux/pwm.h                           |    7 +++++++
>  3 files changed, 38 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/pwm.txt b/Documentatio=
n/devicetree/bindings/pwm/pwm.txt
> index 73ec962..e522c59 100644
> --- a/Documentation/devicetree/bindings/pwm/pwm.txt
> +++ b/Documentation/devicetree/bindings/pwm/pwm.txt
> @@ -37,10 +37,26 @@ device:
>  		pwm-names =3D "backlight";
>  	};
> =20
> +Note that in the example above, specifying the "pwm-names" is redundant
> +because the name "backlight" would be used as fallback anyway.
> +
>  pwm-specifier typically encodes the chip-relative PWM number and the PWM
> -period in nanoseconds. Note that in the example above, specifying the
> -"pwm-names" is redundant because the name "backlight" would be used as
> -fallback anyway.
> +period in nanoseconds.

Can you separate this by a blank line, please?

> +Optional pwm-specifier can be encoded in 3rd cell in bit encoded form.
> + -------------------------------------------------------------
> +|     Property   |  BIT position | Encoding                   |
> +|-------------------------------------------------------------|
> +| Polarity       |   0           | Set   -> Polarity inversed |
> +|                |               | Clear -> Polarity Normal   |
> + -------------------------------------------------------------
> +

Using this kind of table isn't very common in device tree documentation
and the description above the table is a little vague. Maybe something
like this would be more explicit:

---[snip]---

Optionally, the pwm-specifier can encode a number of flags in a third
cell:
  - bit 0: PWM signal polarity (0: normal polarity, 1: inverse polarity)

---[snip]---

> +Exapmple with optional PWM specifier for inversed polarity

"Example"

> +
> +	bl: backlight {
> +		pwms =3D <&pwm 0 5000000 1>;
> +		pwm-names =3D "backlight";
> +	};
> +
> =20
>  2) PWM controller nodes
>  -----------------------
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index f5acdaa..1c6d50b 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -146,6 +146,15 @@ of_pwm_simple_xlate(struct pwm_chip *pc, const struc=
t of_phandle_args *args)
> =20
>  	pwm_set_period(pwm, args->args[1]);
> =20
> +	if (pc->of_pwm_n_cells > 2) {
> +		enum pwm_polarity polarity;
> +
> +		/* Initialize polarity of PWM device */
> +		polarity =3D args->args[2] & POLARITY_BIT ?
> +			PWM_POLARITY_INVERSED : PWM_POLARITY_NORMAL;

Can we rewrite this as:

	if (args->args[2] & POLARITY_BIT)
		pwm_set_polarity(pwm, PWM_POLARITY_INVERSED);
	else
		pwm_set_polarity(pwm, PWM_POLARITY_NORMAL);

?

> +		pwm_set_polarity(pwm, polarity);
> +	}
> +
>  	return pwm;
>  }
> =20
> @@ -156,7 +165,9 @@ static void of_pwmchip_add(struct pwm_chip *chip)
> =20
>  	if (!chip->of_xlate) {
>  		chip->of_xlate =3D of_pwm_simple_xlate;
> -		chip->of_pwm_n_cells =3D 2;
> +
> +		if (chip->of_pwm_n_cells !=3D 3)
> +			chip->of_pwm_n_cells =3D 2;
>  	}

I don't like the implicitness in this code. I think we should make this
more explicit for driver writers, so that if .of_xlate is set to NULL,
the default of_pwm_simple_xlate() is used. For all other cases we should
export of_pwm_xlate_with_flags(), so that the driver can explicitly set
the .of_xlate field to that function.

That will of course imply that the extra code that you added to
of_pwm_simple_xlate() is moved into a separate function.

> =20
>  	of_node_get(chip->dev->of_node);
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 112b314..d77c5b3 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -78,6 +78,13 @@ enum {
>  	PWMF_ENABLED =3D 1 << 1,
>  };
> =20
> +/*
> + * DT Platform property support.
> + * POLARITY - set bit 0 in DT platform property
> + */
> +
> +#define POLARITY_BIT	BIT(0)
> +

This doesn't belong in a public header. It should be defined in the
core.c source file. Maybe rename it to something like PWM_SPEC_POLARITY
to make it more obvious that it defines a bit in the PWM specifier. You
can reduce the comment to a single line, because the second doesn't add
any additional information. Something like this:

/* flags in the third cell of the DT PWM specifier */
#define PWM_SPEC_POLARITY (1 << 0)

Thierry

--2Z2K0IlrPCVsbNpk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnL8kAAoJEN0jrNd/PrOhx+MQAJwW6aUkmtchc4hiSDv+T/Qi
W65vbyBf+QknHNL9Rnn6qSVN+i6X4EUhOHH24yZ7btTGrdLbp/F6VVhU0Ij9i6mW
lB/u8oxalsdNOafwL1lzJ4hlN7aVDyK4R5HWGKFpKFdolW6cI3C9R+6hVJWzIRYX
rpSsSza+oD5SUaqn/0e6NiCZ6Mqp7ujn+xoVGKNjf8vm/GkKOVr+eLCr2crSvkDD
/Lp1iHqGNJXtCOcsLBjjE1du4rXBHgB+6cBJVGFn4rAqigJfxFdL4MYSx8uapIzy
4i57C7XlsgyERy3J9w2KTZ3PneoHVHUvbmwVVNBVngcK0/5bAovzrOkCTmAEGqkL
AK0PqUNCwoYrTAFA1P+RTof99EqjtcQ9J68Qv5wBEJMYWeP/9P+4nbIDtCJkbE11
SjNx5PCixUUX6cap8JBts7g7jLyUO4Cs5ux8W9ulLiX1Z6a/5FaY9nHGfbk19Bmz
eVJKSEZP2VskWQcqQy88yKz/YBh+9HGG0JMYJys7Yh0NKuIKwRVYot9WDa7E8Vfm
M8PrfipPBZIE4cPq6XFV7rHCL2J4wQ3nFSsty0UBinnPbcxN+9yTmZDr9BNkawG7
V2AETYDEF9FLtiNO4DpGkaDH2TOfBu4J1nSNUHeyTIGLc1qyR2ID7r8QfyKrLsNI
jwCQKN/SRMD6VGpRbvVl
=o+t1
-----END PGP SIGNATURE-----

--2Z2K0IlrPCVsbNpk--
