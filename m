Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2G3G6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 02:58:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2G3G6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 02:58:51 -0400
Date: Mon, 30 Jul 2012 08:58:05 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        rpurdie@rpsys.net, broonie@opensource.wolfsonmicro.com,
        shawn.guo@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH] pwm_backlight: Add device tree support for Low Threshold
 Brightness
Message-ID: <20120730065805.GB15245@avionic-0098.mockup.avionic-design.de>
References: <1343219042-4371-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <1343219042-4371-1-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Esyhs6O7/ELVv8b6T3AnDTI/26lsdFCu9VMma6miZqi
 ZqgZ9tsjAZcWxf47vXywT/lWiQQxchoi/xmV/7P2Jala29IaE6
 k1VncGBcvckI3EIY9oZ3tXMwGVNEdG7lCtYmacKm/lRKstHG8e
 xxgJuLS3y6CnElZya9tmdGf9oGZOWAV5jbf+p/r51f6EoGtZwQ
 soAoAxNUvDpd0EO9+j5fOv1puHg6RWMDNTldRuKOBFD8q275wd
 YpsFai/4jV5xkebikMyyNZP1SyZ0Vw3rwtsOS5p6vVs3dLHYw4
 mBllx3JchY6W1EfRAw6+rG8SQOSCkZpLysu76MxPcxL0t6G8jd
 Ut8yJP9zCUyZK2yymOlwKpWRiYIGFuuNgxAV6xLwtExAMP3+Xf
 5Me88+YcimaCRMJwreNsoi958Ef9PCv2XuCh/FEigfO0Lx6wIo
 FHR+N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 25, 2012 at 05:54:02PM +0530, Philip, Avinash wrote:
> Low Threshold Brightness should be configured to have a linear relation
> in brightness scale. This patch adds device tree support for low
> threshold brightness as optional one for pwm_backlight.

I think this should be more explicit as to why this is required, perhaps
something like this:

	Some backlights perform poorly when driven by a PWM with a short
	duty-cycle. For such devices, the low threshold can be used to
	specify a lower bound for the duty-cycle and should be chosen to
	exclude the problematic range.

	This patch adds support for an optional low-threshold-brightness
	property.

Perhaps a similar explanation should be given somewhere else instead of
just the changelog. It took me some time to understand what exactly this
low threshold means and I think it'd make sense to write this kind of
information down somewhere. I'll see if I can make time to add a bit of
documentation somewhere below Documentation/backlight perhaps.

> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> ---
> :100644 100644 1e4fc72... 5c54380... M	Documentation/devicetree/bindings/=
video/backlight/pwm-backlight.txt
> :100644 100644 995f016... 4965408... M	drivers/video/backlight/pwm_bl.c
>  .../bindings/video/backlight/pwm-backlight.txt     |   21 ++++++++++++++=
++++++
>  drivers/video/backlight/pwm_bl.c                   |    5 ++++
>  2 files changed, 26 insertions(+), 0 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backli=
ght.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.t=
xt
> index 1e4fc72..5c54380 100644
> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> @@ -14,6 +14,8 @@ Required properties:
>  Optional properties:
>    - pwm-names: a list of names for the PWM devices specified in the
>                 "pwms" property (see PWM binding[0])
> +  - low_threshold_brightness: brightness threshold low level. (get linear
> +		 scales in brightness in low end of brightness levels)

The convention is to use dashes, not underscores, in device tree
property names, so this should be "low-threshold-brightness". I'd also
omit the comment in parentheses because the DT binding document
shouldn't specify any particular use-case. However I think it'd make
sense to add some information about the number space of the low
threshold value.

Maybe we should also rethink how the low threshold is handled in cases
where the brightness levels are used. I'm not sure it makes sense to
specify the low threshold as a value relative to the range given by the
levels. Perhaps it is more meaningful to specify it as relative to the
period/duty-cycle.

> =20
>  [0]: Documentation/devicetree/bindings/pwm/pwm.txt
> =20
> @@ -26,3 +28,22 @@ Example:
>  		brightness-levels =3D <0 4 8 16 32 64 128 255>;
>  		default-brightness-level =3D <6>;
>  	};
> +
> +Example for brightness_threshold_level:
> +
> +	backlight {
> +		compatible	=3D "pwm-backlight";
> +		pwms =3D <&pwm 0 50000>;
> +
> +		brightness-levels =3D <0 4 8 16 32 64 128 255>;
> +		default-brightness-level =3D <6>;
> +		low_threshold_brightness =3D <50>;
> +	};
> +};

I think you can just merge the low-threshold-brightness with the
previous example.

> +Note:
> +Low threshold support is required to have linear brightness scale from
> +0 to max. For some panels, backlight absent on low end of brightness
> +scale. So support for Low Threshold been required. So that the scale of
> +brightness changed from Low Threshold to Max in scales defined in
> +brightness-levels. In this example 20% maximum brightness scale should
> +be required to turn on panel backlight.

I think this kind of documentation doesn't belong in the device tree
binding. I'll work something like that into the proper documentation.

> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
> index 995f016..4965408 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -143,6 +143,11 @@ static int pwm_backlight_parse_dt(struct device *dev,
> =20
>  		data->dft_brightness =3D value;
>  		data->max_brightness--;
> +
> +		ret =3D of_property_read_u32(node, "low_threshold_brightness",
> +					   &value);
> +		if (!ret)
> +			data->lth_brightness =3D value;
>  	}

This obviously should also be low-threshold-brightness.

Thierry

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQFjB9AAoJEN0jrNd/PrOhaZoP/R+iBikJYEbKJpUtsPA64NSJ
Msao0ZA21IQTuHwYbGy9YOBJ56utA9QotTc9hMp3ZeoKJbsNgIEyE3qAdDrHBqe/
sLFQjobI5AsB/pMkJ8bvnBR6OJwItD485sD+dAc3muACmBpKlkxH3c4+BDOtW07D
NdAmQ4tt/7+0mMPeU6jWEczWBnq2NJ78K6YJxgsyD5tn+CkL/1PoUQM/NPOnsBl4
WLFhhPEMDOcModlMatDqWMj7oUR84do6yYJRtSv20kZ33Le7Gusls2F1NxpcwSfh
ruSScyr1hhxM/YESn94cX2ZMp78A72SgK+QCi7QD45nGeBcevEwCX9tE5PcEkvp6
Bg+b+fwlWJ/hvTeX1GukQ03JSrrkdZ8rFt4s2kNY/iPSJTgmKPeNT7po0jxPaQVm
T2uJ9C+boNOc+2vC4PI7Mq22CGe3vSpRNPyuboCAuJrgUJSqL1KidLalpK3BBr8H
A3tguaZl4tQ/p7aPBVilEcntsz5kYWJg2i0S9hs8fDZReyb3lhd2RXQgEO072nf1
clsxFgl31URSy/bPZP1OlQQuXIl8NUH42DG2kuLJdC/wMP7gP34nnGatijo0Do37
TaK4OUqpinUojS++kGUOjRNfSJQ1dPWWfLPVfEJOiuulV14RAtRMjNpqbiR7PsOc
1we2edxx/o3wXZR7HfMO
=InzF
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
