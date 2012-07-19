Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab2GSF2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 01:28:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48117 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2GSF2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 01:28:34 -0400
Date: Thu, 19 Jul 2012 15:28:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Alessandro Rubini <rubini@gnudd.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: manual merge of the arm-soc tree with the i2c-embedded
 tree
Message-Id: <20120719152812.21ae228fd32fcc4a8ae651c1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Jul_2012_15_28_12_+1000_m8nIk.IfRhW5ijfQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Jul_2012_15_28_12_+1000_m8nIk.IfRhW5ijfQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/i2c/busses/i2c-nomadik.c between commit 235602146ec9
("i2c-nomadik: turn the platform driver to an amba driver") from the
i2c-embedded tree and commit 98582d9562b4 ("ARM: ux500: Remove unused i2c
platform_data initialisation code") from the arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/i2c/busses/i2c-nomadik.c
index e6b93f3,a92440d..0000000
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@@ -969,12 -965,12 +969,11 @@@ static int nmk_i2c_probe(struct amba_de
  	adap->owner	=3D THIS_MODULE;
  	adap->class	=3D I2C_CLASS_HWMON | I2C_CLASS_SPD;
  	adap->algo	=3D &nmk_i2c_algo;
- 	adap->timeout	=3D pdata->timeout ? msecs_to_jiffies(pdata->timeout) :
- 		msecs_to_jiffies(20000);
+ 	adap->timeout	=3D msecs_to_jiffies(pdata->timeout);
 +	adap->nr =3D atomic_read(&adapter_id);
  	snprintf(adap->name, sizeof(adap->name),
 -		 "Nomadik I2C%d at %lx", pdev->id, (unsigned long)res->start);
 -
 -	/* fetch the controller id */
 -	adap->nr	=3D pdev->id;
 +		 "Nomadik I2C%d at %pR", adap->nr, &adev->res);
 +	atomic_inc(&adapter_id);
 =20
  	/* fetch the controller configuration from machine */
  	dev->cfg.clk_freq =3D pdata->clk_freq;

--Signature=_Thu__19_Jul_2012_15_28_12_+1000_m8nIk.IfRhW5ijfQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJQB5rsAAoJEECxmPOUX5FEdisP9jP5L0iHfTXZrsgcx//ZkuYd
q8rRn5v5cAO6laUTuS2qPqruNaXnq2vEdDLKCIBxdGTIjqsNqwNf31ewM8N3jF24
tzV6w1aW/+zhi6A+aFJMJ22VQwn3oe3Ty9db2+8rN/yZeuPSv17Q+hugBwch+ae3
eSYrPfmEfcXdQ0DN6so5it8haoaoJGBf6bRDzhk1dgW5xOaz00C3ZRvyFKu2vHiv
R/kX6kUYEiyo7lQq+TLfpZ+I27XIo2eO/tl9il6K7vuZwyueeP+3qXblQZcLTUFz
5Q4Yd6+W7jN7enoAZJJPauTkq3EGeP1whOUV9kUhPH/bx9hxA9iBtrn0WkNBA8Ll
JVc0GtKkcKTBoeBdkuxHZxoEZOxdSjzf2ucpgV9aMY8nPP4XQx6CHHWwZekXRSLr
06WQhnNye5e5ollgdf4LMMYK1SL5E58M7Ulv48L8QDHZwAyj5I58jVr9MiCpzq00
2Fsql1mTv2AmpiX4rZFiihrxNrvL0lkiO8d+IUez2BjBueB9PkLZyYx3A6RNbKVy
VJxL9jja2ISreOEe9wA34cUR1v13drn+ZHBw0IdG9GPOkdKpAn+3ovzq3os3E2ts
kqt0msPcd3y9uELWY4VZiRjs1LGiDcOUZ5tNdMW0KXXumezs7/DGg36+Mfl8c3Lg
k+EY34zwNa5SmEYPuvo=
=Ynq+
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Jul_2012_15_28_12_+1000_m8nIk.IfRhW5ijfQ--
