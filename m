Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2LKHBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:01:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2LKHBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:01:20 -0500
Date: Tue, 11 Dec 2012 08:00:59 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v3 3/4] pwm: core: Export of_pwm_request() so client
 drivers can also use it
Message-ID: <20121211070059.GA8294@avionic-0098.adnet.avionic-design.de>
References: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com>
 <1355133637-2784-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <1355133637-2784-4-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2fpheBloGYjuxQ6VSdbBnZYwSbp0TQlbBRuuCFT9Fqv
 G2cIZETYdBtJj2OO+lX4+38JQT7NHk4g3payhq8+YOZHrU8jsh
 VnBQdP7WILLW8GqV1rgWNvmmuS0OlmT6JscvE3Hl1pZnhWDalo
 Tv+qK1oZyVuDO+n/MgRHhvzgHqnDDfV6wolo3ILXICqrEoM9at
 H7JtS/+b2KNvF90Ky24Y271mWUEjVDOT3F4cDsIb90GlA6E9oG
 8BMSmHL+4uvLzrJuor92JK0xAHtXJ8V+/KMMuEo9QL1tOQuLXN
 dErZqhz2jYED7xj4pZ8ELWqyU0Lo4QwVJxki/U/qYgIOacdjQ+
 5ifKKtuGCBi3ECzyGYYGRusj5fYaPGyYJiZNpy+zoiJo7i72BH
 GVEGbHtuwCs0E25Z6W8MuWOeSylOwu0NgE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 10, 2012 at 11:00:36AM +0100, Peter Ujfalusi wrote:
> Allow client driver to use of_pwm_request() to get the pwm they need. This
> is needed for drivers which handle more than one pwm separately, like
> leds-pwm driver which have:

Hi Peter,

I really was hoping that we didn't have to export this function, but I
can't think of any other way to solve the problem at hand either. I'd
prefer to rename the function to of_pwm_get() at the same time to keep
consistent with other subsystems that provide similar functionality.
Also, please use all-caps for PWM in prose. And while at it, you can
drop the "core:" and "so client drivers can also use it" from the
subject line.

> pwmleds {
> 	compatible =3D "pwm-leds";
> 	kpad {
> 		label =3D "omap4::keypad";
> 		pwms =3D <&twl_pwm 0 7812500>;
> 		max-brightness =3D <127>;
> 	};
>=20
> 	charging {
> 		label =3D "omap4:green:chrg";
> 		pwms =3D <&twl_pwmled 0 7812500>;
> 		max-brightness =3D <255>;
> 	};
> };
>=20
> in the dts files.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/pwm/core.c  | 2 +-
>  include/linux/pwm.h | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index 903138b..3a7ebcc 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -486,7 +486,7 @@ static struct pwm_chip *of_node_to_pwmchip(struct dev=
ice_node *np)
>   * becomes mandatory for devices that look up the PWM device via the con=
_id
>   * parameter.
>   */
> -static struct pwm_device *of_pwm_request(struct device_node *np,
> +struct pwm_device *of_pwm_request(struct device_node *np,
>  					 const char *con_id)
>  {
>  	struct pwm_device *pwm =3D NULL;

This is missing an EXPORT_SYMBOL_GPL.

> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 6d661f3..d70ffe3 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -175,6 +175,7 @@ struct pwm_device *of_pwm_xlate_with_flags(struct pwm=
_chip *pc,
>  		const struct of_phandle_args *args);
> =20
>  struct pwm_device *pwm_get(struct device *dev, const char *consumer);
> +struct pwm_device *of_pwm_request(struct device_node *np, const char *co=
n_id);

While at it, maybe rename the con_id parameter as well to match
pwm_get().

Thierry

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxtorAAoJEN0jrNd/PrOhcNgP/iJ7T4DBj/cHTTczpOm8huIc
Q3cw7TWMPn8KDsO26u9DlbsQDT7dwLnyvaP0b5IP4mP8yH5VNWrE3Fm7a7hNhPKA
8GrfJJXjoUu9bERzuP6ChDNFW93IDRwUVOczENpGe7x9+33Eu3XkImk/caQi3Tpr
xc5IJ873Gg2JGBIZUPHUvBPnh6Melq/GXZyGWeXUvNDlBgpUdNRSPMdVj3lA2skL
lZFTKJs2baZ7mnXqQ+LUtOkuOUawJiDhNm2IbtPI2zccgoPfuDZD0WaAHLCK9C8q
ysPa4d5iU1TwdH/7/lVnTC0gSQIyeRCQ6/HEYyq34+c2+Q2DahmgTU6cCAWdv40o
wsOSdCBiF0gYPoC4MU+wJlIWcj4sd/uyhVX4UIecrCPEzPKhGJqoezYuNss8IrnN
6UheWs6kUYHAoZAGnZLZh2EAEsTVFQA7bByixUOhiFBEKnafZeTeAWg4YIpvQb0S
fjlgHkSc/QyFptV5HRNu7KF4p6q4DeFL958/FTL1pzYKjvFjil3+7z0mbmXCkjbN
m/4KxIZL+HcFXdJmUw2sjGwnPUMRg5wOpaCO9axOmzw8HgMbfGOnCOt5Oj9FP/Y8
Y/qmCv24lPZNjz1kryw95nVTkyEfqkkN4p3Zh5GV93J5vdrY1EQ9em7I5FG9Mk3U
oxD1az+ckzDskKVzAZS2
=Ei8w
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
