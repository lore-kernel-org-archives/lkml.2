Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab2KEVDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:03:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2KEVDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:03:22 -0500
Date: Mon, 5 Nov 2012 22:03:17 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH] pwm: lpc32xx - Fix the PWM polarity
Message-ID: <20121105210317.GA9930@avionic-0098.mockup.avionic-design.de>
References: <1352134125-22405-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1352134125-22405-1-git-send-email-alban.bedel@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:jxvQQYjTL5tCFp8t7p3IIfmHqFFIYg+brgKh4g0w2Cc
 /E8AViKXW/+zQVLg4DMGvXN8RtmQ/S0DtMtB5ENZdUf8HNsv4m
 en8zXFdBJ+60x+Y5d+cy8MfBb+hNrgsYPPYXziVuj756gg0bHr
 CaG6hkL4txy1BZrsZq3Z84hlW56YV9plF5NCh7SsVdmknrpsNB
 gcnlQr6WjCuB9YXNqCdAsU7CHHyAEXXFlQm/nstMJIq8KjEFOi
 2hoMCxVRuqSe7gQ0vKzDK3BAEp40pq0xcyVaEUD32CfZIF7+KH
 iXQdWT1K52CfM6cDV87Nk71gXtDoyrQ+Ugm0UtjnL7OOXf2E2Y
 cFxhClswLStMFknE2q1zk0ZNnSAT2mowyUO8bjLMqQnkY1MyiH
 HkaVGp9Cww21DJw1CBLY65rkdHFcwXEGtOcUTtL8ZbcKpek3ib
 piXwJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Cc'ing Roland and Alexandre. What do you guys think?

On Mon, Nov 05, 2012 at 05:48:45PM +0100, Alban Bedel wrote:
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---
>  drivers/pwm/pwm-lpc32xx.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
> index adb87f0..a2704b8 100644
> --- a/drivers/pwm/pwm-lpc32xx.c
> +++ b/drivers/pwm/pwm-lpc32xx.c
> @@ -51,7 +51,11 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, s=
truct pwm_device *pwm,
> =20
>  	c =3D 256 * duty_ns;
>  	do_div(c, period_ns);
> -	duty_cycles =3D c;
> +	if (c > 255)
> +		c =3D 255;
> +	if (c < 1)
> +		c =3D 1;
> +	duty_cycles =3D 256 - c;
> =20
>  	writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
>  		lpc32xx->base + (pwm->hwpwm << 2));

Shouldn't duty_cycles rather be 255 - c, such that it can still be 0?

Thierry

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQmCmVAAoJEN0jrNd/PrOhyrQP/2LGf9yREng+jNyJjM3fS2SL
20ILC2Ni87Xe3jSlcqopwDhMtD0EuN+E1OzAQUpRRcvLJ3vYN+zWLXJrZITCkwNp
T/oBEBkXj36XWY5qNHFJqKurV+Pfjy2LkMn0YOiBfTSB908njutqKRTo+bayKsEp
y728zBo23Rffxx4sTD3/5AQOGViju1psJv6FYeMEhrTZuIonmriDeOXTZ70o0cpZ
s1i2W3bCbpiMHc3BApJuRS/o4Nr2iH/CDStGfRcw5SDem0LWvgfQzveSfyiGADOJ
2xmZcNPKp5VYkjBiorA8xKfryhrZOxQOhDXtr7tBNwaAeN8jZ4601cbDRkBtFBdV
WlUiIK+6NI4t6FwL6eUrI/+VtQNdFp78NSz/l1ff1HBKmbKoNIfR4BRY2mAoErKw
GkHXnF86bQFQVOVPgUvrefDsNXCSyaIAfoo7aSeghOECNMsr5Xv1Mv5eEzQMqIwO
dyKvh2tZi+6//5gwjWtTjYUpaOy9Tq8aZRG8PvtIZXNSlMDHYMnGORATEoTv5H9o
KQHmZFq1X41/w7wm62+gPO/qvmX9Gm6/exS3vuD99jDD0zKbFwlHfYWjNmvo4HF7
V9K0OY7vPeEgQ9Q0kX5KtbQ1nfiZMJTuxdlJsAZb3XzfF93xry9FgnpO+O342hUN
vwTdH6YcamMjWkIR0hmd
=1XrB
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
