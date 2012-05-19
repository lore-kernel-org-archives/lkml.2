Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2ESUvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 16:51:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48746 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173Ab2ESUvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 16:51:00 -0400
Date: Sat, 19 May 2012 21:50:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
Message-ID: <20120519205055.GA16590@opensource.wolfsonmicro.com>
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com>
 <20120519164134.GT4039@opensource.wolfsonmicro.com>
 <4FB7D4D8.2050501@nvidia.com>
 <4FB7D676.9000609@nvidia.com>
 <20120519174052.GX4039@opensource.wolfsonmicro.com>
 <4FB7DEB0.3040001@nvidia.com>
 <20120519182658.GB4039@opensource.wolfsonmicro.com>
 <4FB7EE84.7090704@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <4FB7EE84.7090704@nvidia.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 20, 2012 at 12:33:32AM +0530, Laxman Dewangan wrote:

> My board dts file is
>       pmu: tps65910@d2 {
>                 compatible =3D "ti,tps65910";
>                 reg =3D <0xd2>;
>                 interrupt-parent =3D <&intc>;
>                 interrupts =3D < 0 118 0x04 >;
>=20
>                 #gpio-cells =3D <2>;
>                 gpio-controller;
>=20
>                 #interrupt-cells =3D <2>;
>                 interrupt-controller;
>=20
>                 regulators {
>                         vdd1_reg: vdd1 {
>                                 regulator-min-microvolt =3D < 600000>;
>                                 regulator-max-microvolt =3D <1500000>;
>                                 regulator-always-on;
>                                 regulator-boot-on;
>                                 ti,regulator-ext-sleep-control =3D <0>;
>                         };
>                         vdd2_reg: vdd2 {
>                                 regulator-min-microvolt =3D < 600000>;
>                                 regulator-max-microvolt =3D <1500000>;
>                                 regulator-always-on;
>                                 regulator-boot-on;
>                                 ti,regulator-ext-sleep-control =3D <4>;
>                         };
>             };
>     };

Supplies aren't specified for any of the regulators here...

> So currently, when regulator_register gets called in
> tps65910-regulator.c, it sets the
> config.dev =3D tps65910->dev;
> config.of_node as
>                 config.of_node =3D
> of_find_node_by_name(tps65910->dev->of_node,
>                                                         info->name);
> So here config.of_node always shows NULL as the in
> tps65910->dev->of_node does not have name same as info->name ie.
> regulator name like vdd1, vdd2.

Of course, this is just like any other supply - since you've not
specified a mapping for it of course the framework isn't able to look it
up.

> >If there is a change needed in the core you need to explain what you
> >believe that change will do.

> I though this is straight but seems it is becoming more complex now.
> I will describe all this details if we agree to change require.

I still don't see any change needed here, from the above it simply looks
like the supplies aren't set up.

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuAepAAoJEBus8iNuMP3dnBcP/39r6cTCAiOVY5urcGJG5/gP
e9ZmJtxOXXBKmSQwg/1MM8aQCJQClB4hsTSJWr9ZJnQDicN0JNDQQllz0ToHqjYT
Gox+IckutALRsZYp8ZBBa7UGtBAfOdfsDcZxn3tuCB3X1qGhUJp0P7oayzy5VSMz
ZySLpHJ4r6ZCfgSJNRQ5bpxHs2ShAKMRXqctvLqRaTfL2EFVaNelOD4FkgGacRID
84c0Ilkf6FRbXRlcHogCeiYibHEXMLhSREx+qlqwCPnZRawIzug+iG1inb8tYe2B
4M3MN9YxcUwIDxAz5jF5xrcMSep2u6H/rxyqv5xHxIVc0XYCQBui5adP2C1T4yWk
Nl03li+cDFVvNaF6Bv+iGjsKo54NNLpzTghJUnGOJuYaDtnRRn+s7yn4nfHDnxmx
bUbzn21py/xqePRcX559aoOEkRKWv6TA8d25zJtrsr0wr11VtgRDaOPhxgppxMWE
o99pgbNwTNyh3zNEcUV0I/ZFurOPxiGzYpV0bfyOmIU35jfv2POEiyL3VONSE1ET
278l1BdBJUSbIulvwIbig41hXPz+Ij5BTrvJN3j5CE4919M402MsRFxVqFZJ6fJM
SdoFK22tLQNw5BtOawbsxTUoqBDyZuBdJRW4cWGRUrB1qAUuoCowTa/wmTAC9pis
zCiz0Rp3XP7BPK89kywR
=lLhK
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
