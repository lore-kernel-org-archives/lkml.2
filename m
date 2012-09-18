Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab2IRDTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:19:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45938 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab2IRDTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:19:11 -0400
Date: Tue, 18 Sep 2012 13:19:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dong Aisheng <dong.aisheng@linaro.org>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20120918131904.ded0551cb03d079dc08cecbb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Sep_2012_13_19_04_+1000_+h0.2NNegDREBO3S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Sep_2012_13_19_04_+1000_+h0.2NNegDREBO3S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/regulator/anatop-regulator.c between commit 3e2a928472da
("regulator: anatop: Fix wrong mask used in anatop_get_voltage_sel") from
Linus' tree and commit baa64151aecc ("regulator: anatop-regulator:
Convert to use syscon to access anatop register") from the mfd tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/regulator/anatop-regulator.c
index ce0fe72,596535d..0000000
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@@ -61,18 -64,17 +64,18 @@@ static int anatop_regmap_set_voltage_se
  	return 0;
  }
 =20
- static int anatop_get_voltage_sel(struct regulator_dev *reg)
+ static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
  {
  	struct anatop_regulator *anatop_reg =3D rdev_get_drvdata(reg);
 -	u32 val;
 +	u32 val, mask;
 =20
  	if (!anatop_reg->control_reg)
  		return -ENOTSUPP;
 =20
- 	val =3D anatop_read_reg(anatop_reg->mfd, anatop_reg->control_reg);
+ 	regmap_read(anatop_reg->anatop, anatop_reg->control_reg, &val);
 -	val =3D (val & ((1 << anatop_reg->vol_bit_width) - 1)) >>
 +	mask =3D ((1 << anatop_reg->vol_bit_width) - 1) <<
  		anatop_reg->vol_bit_shift;
 +	val =3D (val & mask) >> anatop_reg->vol_bit_shift;
 =20
  	return val - anatop_reg->min_bit_val;
  }

--Signature=_Tue__18_Sep_2012_13_19_04_+1000_+h0.2NNegDREBO3S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQV+goAAoJEECxmPOUX5FElowP/Rrv6s/Di9YmqxVjPPA1Q6ej
L2AYPnAW3GXwBOilhpJ0spliTMh1WLcciIA6kF6IXmVnv3RTKS96rDpvWuJn1+nq
bEl0UlndOo4ZAIS3pUjdlECBAXLKJWzL0jZcGxl8Do/K8RW1kq2XhMtBOZ/EK3Mv
6A6mkr3+3ZGYLsy6P7IoLOPC/ulkwP8t8Kgp7ckzloMUtLgdQUALZOYy1OHJn82M
Zve663oYkKLBRWHEBGRNboRZQ7a7+RtSV9Z0IriZvRZyETW8FW74iYG+14nTHFZO
gJ+OXjt7UZlMK8WnKArbUnmkPh9ChYLgLo13FRNWZEdkwnKZhJDMmQEpx5I+8udt
4cCqZCSt0VEHbzkIwwq2EcEf5stLCDLqa3RcenLCd6SufjOJTOLDflRcnZ1f27Mx
74o7juvAwkxir+LrXAjxaCdW857OZtLqCUvQSMqm451daL3YFrbyi6Ymi1f4uEYP
N2G/vhUOE89Qe4DHZOl+bYtzXCq5BmMoLn6rG15gXgOgfpVqSXtx8/ZGFbIdgtnl
SSnhegZ26Qgp2nHSbC9jBcnsALm2C4o/1+36dP/d+7wWL+k/1MLJ2LYmp9/cOO4q
iDFwQGP31aZ+bNryKtnU3sb0yjBt6HmQ9+8P2ClFSqzwknpHHnq9CrQaQ7IzSMyx
OQqG5y/OvEDmqD/W0ozU
=FtrC
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Sep_2012_13_19_04_+1000_+h0.2NNegDREBO3S--
