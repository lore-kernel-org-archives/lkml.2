Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab2IUDP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 23:15:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46193 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2IUDP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 23:15:57 -0400
Date: Fri, 21 Sep 2012 13:15:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jett.Zhou" <jtzhou@marvell.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the battery tree with the mfd tree
Message-Id: <20120921131546.032757ac5bc270ed280282ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Sep_2012_13_15_46_+1000_Dppj5gDQF1KmFtON"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Sep_2012_13_15_46_+1000_Dppj5gDQF1KmFtON
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

Today's linux-next merge of the battery tree got a conflict in
include/linux/mfd/88pm860x.h between commit a70abacb06b8 ("mfd: 88pm860x:
Use REG resource in regulator") from the mfd tree and commit a830d28b48bf
("power_supply: Enable battery-charger for 88pm860x") from the battery
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mfd/88pm860x.h
index d515e5c,b7c5a3c..0000000
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@@ -359,22 -460,8 +440,23 @@@ struct pm860x_platform_data=20
  	struct pm860x_rtc_pdata		*rtc;
  	struct pm860x_touch_pdata	*touch;
  	struct pm860x_power_pdata	*power;
+ 	struct charger_desc		*chg_desc;
 -	struct regulator_init_data	*regulator;
 +	struct regulator_init_data	*buck1;
 +	struct regulator_init_data	*buck2;
 +	struct regulator_init_data	*buck3;
 +	struct regulator_init_data	*ldo1;
 +	struct regulator_init_data	*ldo2;
 +	struct regulator_init_data	*ldo3;
 +	struct regulator_init_data	*ldo4;
 +	struct regulator_init_data	*ldo5;
 +	struct regulator_init_data	*ldo6;
 +	struct regulator_init_data	*ldo7;
 +	struct regulator_init_data	*ldo8;
 +	struct regulator_init_data	*ldo9;
 +	struct regulator_init_data	*ldo10;
 +	struct regulator_init_data	*ldo12;
 +	struct regulator_init_data	*ldo_vibrator;
 +	struct regulator_init_data	*ldo14;
 =20
  	unsigned short	companion_addr;	/* I2C address of companion chip */
  	int		i2c_port;	/* Controlled by GI2C or PI2C */

--Signature=_Fri__21_Sep_2012_13_15_46_+1000_Dppj5gDQF1KmFtON
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQW9viAAoJEECxmPOUX5FEPnoP/A+Xa+uzXEjjOQksWHFtUF5R
AP2Cfq4CKIzblDWedcBzkawhpYDPTUipC8RwkTn0ZzLePXr868TOLdZ5TC/ueCUH
/Y1LD3Gn/R/LIxCHxOJ1Zl7KONiKYaGFuG1dlOIQbjpBX+ps/A3ZEzY2WHUvAo3t
L5xUJikbmEtamq6WwMw73YZSwiWrswPqi+FNRnO/Y+DkN36dtp8r3C0XpLKPFhX8
HLKDViChFJDmd4YG1wnQ/pAyV9ofZxhug/iGuf9bXshVaZilrViA0xoQF9nSZTp2
eVzYQBUZA66Yd57nylRr62ZFHTIXAU0OnSXXuDvwGT3CKv2SXoCs9lz/J85KkQhw
etvMIW/rzWAuwUwYgNrB++4wWKP7Y7tGeuvlP9E/TMnE+xmU5NGNCeitKN8ailVK
Jb4dLDiwkt+OSmDgKsB9KGJInutnEGdXQAGEbgBnLj2zOwdKQcf1LxYEHsG42cNK
l1/Briv46iqHzoD384DnMgN4DnBGD3OOG6rYRTl6FVdkVicW1YfYUsmFozbvOL9N
eMAqSqg4Ma5Nh7glXZENXBzEf2IJlN7kDxKrPjxbAVAGIpV6muoHaHZiP5eWaHlW
zev1qA2X8SZdciVmXpm9UcdY+DCDhxPi0weMizpsYei4I5GeOmfdL4Ynlof8FpwF
MFZOyEACWTpRp2IWqB1b
=sriF
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Sep_2012_13_15_46_+1000_Dppj5gDQF1KmFtON--
