Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2KGOuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:50:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49860 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762Ab2KGOuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:50:51 -0500
Date: Wed, 7 Nov 2012 15:50:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lrg@ti.com, perex@perex.cz, tiwai@suse.de, yongjun_wei@trendmicro.com.cn,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] ASoC: cs42l52: fix the return value of
 cs42l52_set_fmt()
Message-ID: <20121107145046.GI20844@opensource.wolfsonmicro.com>
References: <CAPgLHd_GJMWGiMbJp=Jd9cevekJm_LpAXuCT_QADbQXqoBoa0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhtSGe8h3+lMyY1M"
Content-Disposition: inline
In-Reply-To: <CAPgLHd_GJMWGiMbJp=Jd9cevekJm_LpAXuCT_QADbQXqoBoa0w@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhtSGe8h3+lMyY1M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 07, 2012 at 08:38:35PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fix the return value of cs42l52_set_fmt() when clock inversion is
> not allowed and also remove the useless variable ret.

Applied, but you need to work on your changelogs:

What is wrong with the return value?

>  	u8 iface =3D 0;
> =20
>  	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
> @@ -822,7 +821,7 @@ static int cs42l52_set_fmt(struct snd_soc_dai *codec_=
dai, unsigned int fmt)
>  	case SND_SOC_DAIFMT_NB_IF:
>  		break;
>  	default:
> -		ret =3D -EINVAL;
> +		return -EINVAL;
>  	}
>  	cs42l52->config.format =3D iface;
>  	snd_soc_write(codec, CS42L52_IFACE_CTL1, cs42l52->config.format);
>=20

This doesn't look like it changes the return value...  the actual issue
here is that we don't pay attention to ret later on, we just always
return 0.

--zhtSGe8h3+lMyY1M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmnUNAAoJELSic+t+oim9nEYQAI5hGAzZm3J2zoDrlPqMNCeJ
FZ3hQyRld1scSWve3YYLeoPjX2MewbKTYBMXWjt4nfmb4Bn+wAJ3UFr9JlYITbh4
TYcUYfsZ5+zwAXHUmLWPcNQ/FJyKt/VaL1XG3HabhDRV2Tvu11IGkoiOAHadHgVx
8vRBR/SNr3IatZ693YL2Bv3gs1H6gkb6kNFIG0aQfL/UegBS1az5QaJ0DEuKA0JA
ZIP2zT0yO43WGFujQklT787dh3YOtSK7iVzoQdHRN9wHWGNeic0A2UP1nUixsFCS
KXgzfJymtRMYud4rObSFSn2I6SB7SYs5ozMyPqZdSJ//gqkDsemQlwnhDmjDD/4j
1Ur/ElazLDMydJrozKz9d6oiQczE/Ew9fWxB0gS8gDT+wrP8XWQaYe4lUmv9AWQT
Qz4ynavS2gRwaxDLZ1086rkCR9Hjm66SLmSpngVyE2ejPOn8ykaXJLotf1VGCcOe
2DNcHk/pxLAUT85LI0A/uLlvGDVSevVYAiU54ZggHTFOhf1NAZeT7bHdv9HO0lYH
KjKBq9NoSsP5DSHl1GmeZviJPAZQsJAxi5vTusYgrmt0i5CV7M2pRCasQ+QF1krh
3JW+t3XJS7RKg2U7GWeSgbVupsMtcaj9ag3lt1j+fe5szmpoa2MtsribCtw0oo+f
Z2c+fgbDDaCkG+dBYrQm
=4E9j
-----END PGP SIGNATURE-----

--zhtSGe8h3+lMyY1M--
