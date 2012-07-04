Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2GDF6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:58:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2GDF6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:58:38 -0400
Date: Wed, 4 Jul 2012 07:58:28 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pwm: fix used-uninitialized warning in pwm_get()
Message-ID: <20120704055828.GC18779@avionic-0098.mockup.avionic-design.de>
References: <1341347661-26567-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UoPmpPX/dBe4BELn"
Content-Disposition: inline
In-Reply-To: <1341347661-26567-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:37D58e/XPEap+78ZLbm69aFOAdhdrijXKb6SeMu8izT
 ODYOWcPeXMKEoN//YruFSvx0nALVhtnAHrOg/qKXliHx3bZW5X
 d/eRVRT0/DznUbrNc6ZG+U9aN5iqRS9Mi2bQw1E2GUEgsLLqUg
 0YYKdCg8cRitN7/OF7JD7z35YWf2W8qVr/U1T5dBWad27dz3yC
 Z0rD0HYfaZoQTTudnc9PkAyAK5gRwM/a+wq1qISbanp1hS1wjl
 mIjp1/aDrf/jNJ6Qy9rA2kulUAzcKfekonSO5mtRa/yOvpGa4+
 SohR94Vvy8uDGd3R1V029LtBqj844iA0xkJJ540E6FVOtnOsH9
 2tpVAAjFA4K//boJojyq5Lf90U/W0lWWP1Hxi1xm6uDBhhdE1q
 eaHqUWXuPfmE9gUsL/rqq/ytHRcL89kpp4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UoPmpPX/dBe4BELn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2012 at 02:34:21PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> This fixes:
> drivers/pwm/core.c: In function 'pwm_get':
> drivers/pwm/core.c:534:15: warning: 'index' may be used uninitialized in =
this function
>=20
> The addition to the if condition at end of the function isn't strictly
> necessary to solve the warning, but does make it more obvious that the
> initialization of "index" to a dummy value isn't just hiding the
> problem.

Actually this seems to be a false positive, and one that I don't see (I
use GCC 4.6.3). index will be initialized when chip is set in the loop.
My guess is that GCC 4.6.3 actually notices while your version doesn't.

Thierry

> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/pwm/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index dbab530..2b401c0 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -531,7 +531,7 @@ struct pwm_device *pwm_get(struct device *dev, const =
char *con_id)
>  	struct pwm_chip *chip =3D NULL;
>  	unsigned int best =3D 0;
>  	struct pwm_lookup *p;
> -	unsigned int index;
> +	unsigned int index =3D -1;
>  	unsigned int match;
> =20
>  	/* look up via DT first */
> @@ -588,7 +588,7 @@ struct pwm_device *pwm_get(struct device *dev, const =
char *con_id)
>  		}
>  	}
> =20
> -	if (chip)
> +	if (chip && index !=3D -1)
>  		pwm =3D pwm_request_from_chip(chip, index, con_id ?: dev_id);
> =20
>  	mutex_unlock(&pwm_lookup_lock);
> --=20
> 1.7.0.4
>=20
>=20
>=20

--UoPmpPX/dBe4BELn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP89uEAAoJEN0jrNd/PrOhCqoP/Ary4L/GYYMhbCP/wQgZSoot
jw/hGKLGRcmKcfNI+GV8eiCRMZvg7lybYScmpNJL9GltYbF0FuwSh3I/Cf7a5d7M
cvP6JUWxxDcE2WEAEQPed6rN0JfdLcCcwT4ZAeh6IztPov4YOZuRmLVhhGOXqwFh
9HWL8yxaPY/Fc1cKB5yFsqFT0VMIs7BdfHOnhTR0RLqRv+3k/csYcb/bZP9hJtPb
lIueZA/sd+7UtuJgJcdZTrnez8mhcyoFGSskyboFdTDWFOjiteKcssnjT54ciSL2
wnx/H3VnE7OYJ/hj6VmQOxkYEtzM0kxDQx653Yx+9ah29Lp+7pcTe1/p3tUbpESn
ju3IftHeSlxkRNDsUAGnGRMcgv+IFp1MuLrhHFZAUvhaXeGzmThWEorWlUPeq1yd
buVgbOFmepESZl02Jdz+tguMuZVHgKsoTIknWlA93kssQqe/O57FzeBFjee4cMur
TEJ/xHc38Jwqp5kiX8Ee8ai36rWDxBZyo34EhipuJRfiwwnZomJJ5gV7oPtFHSv8
6PbdrduFbkoonL+/enIRIDIy98hdJcpNdIwRAvMFzjWMYGCBwGaweXR0/C+TkqNT
PT9DQE9b8D25fdlWjo2nHAUCqZ2qvtXANEDO/pmIWSIEk3yuyRpYIVN+pd7bT2e7
2CJzdigW0cztQEsswsh4
=7cJH
-----END PGP SIGNATURE-----

--UoPmpPX/dBe4BELn--
