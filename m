Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab2GIGaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:30:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50504 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2GIGaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:30:10 -0400
Date: Mon, 9 Jul 2012 08:30:06 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCHv3] pwm_backlight: pass correct brightness to callback
Message-ID: <20120709063006.GC10484@avionic-0098.mockup.avionic-design.de>
References: <4FFA6BCA.2040101@nvidia.com>
 <1341813863-18822-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Content-Disposition: inline
In-Reply-To: <1341813863-18822-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:azRmROfoer2tcsjnL3CHktyuXgDk818dBpcaIrDYadf
 ISxEFeAH2iPy4ooJG8yUAc6P9fmjRJZNFyHZjXkJ0Ou8Z/FL/I
 E2eFnaLdAdg09ToSycQ9T5jnDWgWti/D2/LoS4amiyr85AK12Y
 W4YG/6Z8hA1WKrrYKdxDGq63fzanNUbjXwp+WZApWT2Vlo3RKb
 dxgScGchz6apZcXq/yKWWRYPp8h+ITxfNCqc2st5pSXZn0yd5z
 Yyn+GneAJKpTwzDvKqfNqZUgZwHRMfHQlqnPRIQOIP2olX6gVQ
 a1cGF7tKy8gCIMYaQOUey569gPn1wWYC508LDWojnd3ta6tm/b
 S9Di1g+gDNizBiUKO0iY1IwsS7YiNc/beNrOS7iX5R8MMvOJtu
 7HQnKl9S1dF8m40D/qfhdnOwU1YFR1G0AM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2012 at 03:04:23PM +0900, Alexandre Courbot wrote:
> pwm_backlight_update_status calls the notify() and notify_after()
> callbacks before and after applying the new PWM settings. However, if
> brightness levels are used, the brightness value will be changed from
> the index into the levels array to the PWM duty cycle length before
> being passed to notify_after(), which results in inconsistent behavior.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/video/backlight/pwm_bl.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Applied, with a minor stylistic fixup adding a blank line after the
duty_cycle variable declaration. Thanks.

Thierry

> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
> index 057389d..be48517 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -54,14 +54,17 @@ static int pwm_backlight_update_status(struct backlig=
ht_device *bl)
>  		pwm_config(pb->pwm, 0, pb->period);
>  		pwm_disable(pb->pwm);
>  	} else {
> +		int duty_cycle;
>  		if (pb->levels) {
> -			brightness =3D pb->levels[brightness];
> +			duty_cycle =3D pb->levels[brightness];
>  			max =3D pb->levels[max];
> +		} else {
> +			duty_cycle =3D brightness;
>  		}
> =20
> -		brightness =3D pb->lth_brightness +
> -			(brightness * (pb->period - pb->lth_brightness) / max);
> -		pwm_config(pb->pwm, brightness, pb->period);
> +		duty_cycle =3D pb->lth_brightness +
> +		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
> +		pwm_config(pb->pwm, duty_cycle, pb->period);
>  		pwm_enable(pb->pwm);
>  	}
> =20
> --=20
> 1.7.11.1
>=20
>=20
>=20

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP+npuAAoJEN0jrNd/PrOh5vkQAKflVsxfdx4bRYdwaLIYB+uL
p5nuaIo8MLTE/3s+3Usg/jkcuAt+hpkZX0dtYsKe7Pb8hQ7dekNruoFMgfgHRyJc
PEI0jZKGKt9kgq9+Uf2BYy18J/ul6NZYAtWrCGFCTX11SQIFr676U5od3uTIX6oo
JFZ/pyIBZDDjScMuF2RnOJwj2kfH/7k1dNdRpPD+/dgtI04TaA8TrZj3fXug9DSc
EvmShniBwxvlxOU/2LZk6blyOuLAKbZK4zfQVNQdSr9miBNHklmjopXCRqdZmBYU
V39ShYFpuSKmGbyimZWWFzMgtnsWWPfn/u6NsaxLIOKzSaDwprOD6hG8Hl6Wu9cc
7BK+XuXHZlZPdNJRQoBYhsV4DPUsn8pS7zdS9MN3ck/P5LoSP/BvW0Msf2yrSa5/
zz0SBNkuEopmKX9um8nyE/VD0DLx+Tdaq1clIik9THqu1j/Yxs5fkB9rIJ3w0uX/
gEiymgazuAaPaEw36NVcNXT4ajQAOt3U+hYAOEEA9pHZhVV1XeG5TodaMMniuF5x
6bfP0hGw0CqFXxF8x93x8uGYpAtt+y/WC3dX6eYGseZ1De0m0tvnYVlaSCyX0Y1T
Kf8C5z0jbI8EWsQYC2CIjlWS7wFnRcNDXM+TdV4eOM68esoBjYwiZNgF20nCOlUy
jlWkimu+b5e0gmiEEsZR
=BlhH
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
