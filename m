Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab2GZLcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:32:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48117 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab2GZLcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:32:07 -0400
Date: Thu, 26 Jul 2012 12:32:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 07/21] ASoC: io: Prevent use of regmap if request fails
Message-ID: <20120726113204.GY3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R0SsnouPYaG+7rP6"
Content-Disposition: inline
In-Reply-To: <1343298534-13611-8-git-send-email-lee.jones@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R0SsnouPYaG+7rP6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 26, 2012 at 11:28:40AM +0100, Lee Jones wrote:

> @@ -52,10 +52,13 @@ static unsigned int hw_read(struct snd_soc_codec *cod=
ec, unsigned int reg)
>  		if (codec->cache_only)
>  			return -1;
> =20
> -		ret =3D regmap_read(codec->control_data, reg, &val);
> -		if (ret =3D=3D 0)
> -			return val;
> -		else
> +		if (codec->using_regmap) {
> +			ret =3D regmap_read(codec->control_data, reg, &val);
> +			if (ret =3D=3D 0)
> +				return val;
> +			else
> +				return -1;
> +		} else

No, this makes no sense.  There is no non-regmap I/O support in soc-io,
anything using the soc-io hw_read() function must be using regmap.

>  	case SND_SOC_REGMAP:
>  		/* Device has made its own regmap arrangements */
> -		codec->using_regmap =3D true;

Again, this makes no sense.  If we're explicitly being asked to use
regmap then we should be using regmap or just failing to set up I/O
(which is obviously a catastrophic failure).

--R0SsnouPYaG+7rP6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQESquAAoJEBus8iNuMP3d9DsP/iDnBdEh+CX25QbvBdsNCa6/
KjsDUX0kLU07gIfa8dq+A1k6MLIsHte5h43MhHZS3Tuck3GvxfGD1nPLA2ok4V/5
uLEgzGxPJywXpf3130/2H8pHTsFKXt9lNPPhsGuBNdF3YJcKMtRtRL+JHxY+p4Vc
heIjm9Ap90nDRbU2l6uWlC1T1pBzlY4KwZvJMqtCJja6DwEptnnBklk/vpyl5d2J
CvquDClF76pSZgtbrfN8hpOpi6CLWf0+Ks9a2RXhw9SM9YWRh/x0nNMUfpJjWwZQ
4a+5f5R2DPkO3t8ir8IPL9YQf+gKVfBcPFzi3hc0b2EPIuPJjqIj7j1NjczG9p7z
Pf03Bqj3o34QAVgvL3n7zbE66YK5PjhQlxC5o3e3maejeBoOr8EEGOhkZqvlImeR
chD2O6dTrHWvkck+ethnT2/Sq0fS1kCBg/aBAOZMCnrezYZAf1MU4myLaHbK3678
TIV1pj63qakN18IdwoKVncDC1SgIIMgvCbR5pg7kQYIh4SKusDdDpqbTemfEs4Qc
yZeTXK5ENnriN1jZsIMRIu88rh/XHrHdbtmas1aQHX1vuhnlXD40wDuwPOzxEgBt
0kr+mgXGOoEG4ZVMtXEBp590jxXJs1oZoMy1YhHzmCeqJz4R0gU0G5qf8HmZat3u
+H9v3cdDja4WWYPTLJa/
=mbZQ
-----END PGP SIGNATURE-----

--R0SsnouPYaG+7rP6--
