Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2HHLH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 07:07:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56031 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab2HHLH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 07:07:28 -0400
Date: Wed, 8 Aug 2012 13:07:13 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Tushar Behera'" <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, patches@linaro.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: Re: [PATCH] ARM: SAMSUNG: Fix compilation error with
 s3c2410_defconfig
Message-ID: <20120808110713.GC20296@avionic-0098.mockup.avionic-design.de>
References: <1344333546-16995-1-git-send-email-tushar.behera@linaro.org>
 <098f01cd7488$0d66d630$28348290$%kim@samsung.com>
 <5020F568.5020204@linaro.org>
 <0a2d01cd7500$53e26c50$fba744f0$%kim@samsung.com>
 <20120808061102.GA22417@avionic-0098.mockup.avionic-design.de>
 <0abe01cd752f$4f96ad80$eec40880$%kim@samsung.com>
 <20120808065046.GA30832@avionic-0098.mockup.avionic-design.de>
 <0af001cd7550$1af66040$50e320c0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ghzN8eJ9Qlbqn3iT"
Content-Disposition: inline
In-Reply-To: <0af001cd7550$1af66040$50e320c0$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:76CtcyPHNruf+n07bh6oXmZnsjYWgPLyDQObmpcylqO
 BC0zoir/BWYn+MX44NBNc1VFKdYfdPLoM4Dn/544YvLkVS0ka8
 CMaXwnzHxFegJj7sUIp41cTr+jfi1HayDSYI7mrcIrpp9P/R5j
 Fm24qBlCKxd5/0W/QQ3W+CG3nnBJ7Zi6VY6Tj2dPh9oes7CbT2
 nwT48XxdKhpeJ3hIFwdw8g6IgO7ORBS0fKMXV6ZqK9jjwsY64u
 vDKGmOfzOzy9wUOY9t3ZX/edqIGfzPc5K+XQjFm5hjyCaMPPOr
 lLnT759IiwOcXL7wQmL6w1YoUkG8amwQ99FFqGxXXpM//cRGXH
 bVjSyFJwzZFVhwHhO0poHxAWuydddATuCl4EvAnIfvtprSMq6i
 J3opoclrEMJ/V/1tLaB1QZOHXCBWdYXd83YJ1gr1OzIcBuBrVF
 7+CWn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ghzN8eJ9Qlbqn3iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 08, 2012 at 07:25:17PM +0900, Kukjin Kim wrote:
> Thierry Reding wrote:
> >=20
> > On Wed, Aug 08, 2012 at 03:30:32PM +0900, Kukjin Kim wrote:
>=20
> [...]
>=20
> > > Yeah, your pointing out is correct, but in this case, it should be
> > 'bool'
> > > not 'tristate' because the PWM driver cannot support module now.
> >=20
> > Is there any reason why that is so?
>=20
> I mean, current pwm-samsung.c does not support module, as you know, the
> pwm_init() of pwm-samsung is called by arch_initcall().
>=20
> > Looking at the driver it seems like
> > it should be easy to turn it into a module.
>=20
> Yeah, I know :)
>=20
> > I know that Jingoo (Cc'ed)
> > has been working on the driver and I've asked him the same question
> > already.
> >=20
> I didn't know, would be helpful to me if you could add me in Cc for
> discussion of pwm-samsung. And he is my team member, so I will talk to him
> about the plan.

He (she?) sent two patches:

	https://lkml.org/lkml/2012/8/2/108
	https://lkml.org/lkml/2012/8/2/109

And followed-up with the following three:

	https://lkml.org/lkml/2012/8/3/47
	https://lkml.org/lkml/2012/8/3/44
	https://lkml.org/lkml/2012/8/3/45

> > Anyway I don't want to force the issue, I just think you should consider
> > it.
> >=20
> Thanks.

I guess it should be fine to go with builtin for now and keep in mind
that it might make sense to make it a proper module eventually.

> > > > solve this problem would be to add a default line, like so:
> > > >
> > > > 	default PLAT_SAMSUNG
> > > >
> > > > I've checked this with a s3c2410_defconfig and this causes PWM_SAMS=
UNG
> > > > to be selected =3Dy, which I guess is what you want.
> > > >
> > > How do you think following, just adding from original one?
> > >
> > > -	tristate "Samsung pwm support"
> > > +	bool "SAMSUNG PWM support"
> > >
> > > Thanks.
> >=20
> > If you convert this to bool anyway, then maybe you can still use
> > def_bool:
> >=20
> > 	config PWM_SAMSUNG
> > 		prompt "SAMSUNG PWM support" if PLAT_SAMSUNG
> > 		def_bool PLAT_SAMSUNG
> >=20
> > Any particular reason why you want "SAMSUNG" capitalized?
> >=20
> No, there is no reason, just because...
>=20
> So, how about following? If PWM is selected on Samsung SoCs, the PWM_SAMS=
UNG
> will be selected automatically. Of course, it can be de-selected in kernel
> menuconfig. Note that, I think, using 'bool <expr>' and 'depends on <expr=
>'
> is more clear than 'prompt <prompt> ["if" <expr>]'. However if any your
> preference here, please kindly let me know.

I do like that much better as well. I just kept the def_bool because it
was proposed earlier in the patch.

> ---
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 8fc3808..c74d055 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -58,14 +58,12 @@ config PWM_PXA
>  	will be called pwm-pxa.
>=20
>  config PWM_SAMSUNG
> -	tristate "Samsung pwm support"
> +	bool "Samsung PWM support"
>  	depends on PLAT_SAMSUNG
> +	default y
>  	help
>  	  Generic PWM framework driver for Samsung.
> =20
> -	  To compile this driver as a module, choose M here: the module
> -	  will be called pwm-samsung.
> -
>  config PWM_TEGRA
>  	tristate "NVIDIA Tegra PWM support"
>  	depends on ARCH_TEGRA
> ---

Yes, that looks good to me. Do you want me to take that through the PWM
tree or would you rather take it through yours?

Thierry

--ghzN8eJ9Qlbqn3iT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQIkhhAAoJEN0jrNd/PrOh368P/jnMRuqpCjcX8Tmea2Um6HNi
jL9dwCgHstMefNBVw9UZLd6haKTP3ZinfyLw8YIy2oXczeyC52m/MUR/eQHZLWQC
aPE0qlIoq/5IgJLYSEFXsq69TGpzW3HhaJ7TQjvLWmtn2q9pnw48Yyd4uXFr0jjy
omqHrCKpwwVf9PybAE2wCdVXHjZJICioqVNDeT0o0cU/Kh8hChTZXcBj9PqICN0U
MJYD6vf2o2lgjld+DbK/9uuf2+YoKMYbJ9oLSpE+QEN+PfP65NE08aLS57eSLg5A
ou3sM5UpybU37kOe8IH8dvF+F6/uRL6b1GaBgIlbe88Q1uchTLvXBV2v9IugxIuC
KdJf7zItCmQQbd3W0zf0MStHhqaSC7PVzr6HRi6S+oaPzpFhqWawXWRZBwptDZ6O
rG8KbCgVx4Hk/8IfENuxrmN4sLqhme4U3fQR9x0oOoWKXpD1H31udsgMrqRgAxT7
0XMFOfwUB3VxD5FHi/4ofxSjamsFmuPMa+x5AwxeZreXIy2A0zSZiBII5VFAo92+
fU1kaMO0pKS2MXMbJJ8ycLYnE30/elOqMOfvRMRDA+iGRRHHbZeMjciYXO/OXyEF
1J8mkd+PMRA0JRWOeSLvgyNyJACTvzzLUOouR1ewtT+FXorswCxzWAQa2LT43zJn
LS4NTQoWNghH9orW4gh8
=J7aU
-----END PGP SIGNATURE-----

--ghzN8eJ9Qlbqn3iT--
