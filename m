Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2AYMmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:42:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60178 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab2AYMmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:42:53 -0500
Date: Wed, 25 Jan 2012 12:42:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, jedu@slimlogic.co.uk, sameo@linux.intel.com,
        gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2] regulator: tps65910: Sleep control through external
 inputs
Message-ID: <20120125124250.GH3687@opensource.wolfsonmicro.com>
References: <1327489068-9460-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xzXx3ruJf7hsAzo"
Content-Disposition: inline
In-Reply-To: <1327489068-9460-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2xzXx3ruJf7hsAzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2012 at 04:27:48PM +0530, Laxman Dewangan wrote:

> @@ -450,6 +489,29 @@ static int tps65910_set_mode(struct regulator_dev *d=
ev, unsigned int mode)
>  	struct tps65910 *mfd =3D pmic->mfd;
>  	int reg, value, id =3D rdev_get_id(dev);
> =20
> +	/*
> +	 * If regulator is controlled through external control then
> +	 * mode can be identified by the input level of EN1/EN2/EN3.
> +	 * If it is HIGH then regulators is on, full power.
> +	 * If it is LOW then:
> +	 *       - the regulator is set off if its corresponding Control
> +	 *         bit =3D 0 in SLEEP_KEEP_XXX_ON.
> +	 *       - the regulator is set in low-power mode if its corresponding
> +	 *         control bit =3D 1 in SLEEP_KEEP_XXX_ON register.
> +	 */

This really isn't what the set_mode() API is for - especially the fact
that it supports turning the regulator off which really isn't what
set_mode() is supposed to do.  A generic driver using this API isn't
going to play too well.

> +	if (pmic->board_ext_control[id]) {
> +		u8 regoffs =3D (pmic->ext_sleep_control[id] >> 8) & 0xFF;
> +		u8 bit_pos =3D (1 << pmic->ext_sleep_control[id] & 0xFF);
> +		int ret =3D 0;
> +		if ((mode =3D=3D REGULATOR_MODE_IDLE) ||
> +			(mode =3D=3D REGULATOR_MODE_STANDBY))
> +			ret =3D tps65910_set_bits(mfd,
> +				TPS65910_SLEEP_KEEP_LDO_ON + regoffs, bit_pos);

As a coding style thing this should be a switch statement.

--2xzXx3ruJf7hsAzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPH/iqAAoJEBus8iNuMP3dkVgP/05tApbzaRactC2fxFBGzg2a
q9iQ74Gn/OXJuNQ/6pu8aqP3MaxAoh7VRCzeE/f0gegVAVPvfSvoZlCsJ6qWlaeB
H6Qc1RSASPu7niVnk/uyzHh7+bqJkFxaIPMCeZwU+MCDO/uifuR+FZO213L/5G+8
fOwXmsfG5juZdC5/0wWNp5GCY5IXxuNtT07xVLkfw3BiJimUKzfBAnFZiyyyuwxa
k7inRbKIIyasn55Aino+GCqrgG9v0odDvD2UzfG3ZF1E1ZAfXCUGytsUs9PTXCn9
1ijx2rqC5BCdtKDJg8y0uF2olKrF/k0FM+5OEYGEyDI4G+Wjf/t1M2rNfZnVSLa7
gUeeA35UocesQOaflVD5+308es8YFVR0XZBSh5po0BUQ1oadXhzJFZQ6zh+ZdtwW
Stz1KVUmm006EUSmHK0PQ0F3qIsuxie5PbPYh1UjUXW5f7X7TOYlK4Al+J9Zit1e
ce2SN2+osTWNTq8LOaH66NhyAuA2P8YEFXC3vdEcfZsyiIs9t53pWq/WEezUdXQJ
YhFp8/i5PVB962xZ147J6SfTce1o3qng5yUzwC55b6v60jFhChxSn88ZdQDK+vwh
jyQqD77z2tIvBB8A6TChy1798ltfZt0aMbGIiOcYqVDh8YHYgU0PA1ZfbFipzVtb
v3aOU9MgluHTTB9ZLAuk
=WuQD
-----END PGP SIGNATURE-----

--2xzXx3ruJf7hsAzo--
