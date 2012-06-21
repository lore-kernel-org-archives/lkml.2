Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab2FUD1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 23:27:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54331 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab2FUD1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 23:27:48 -0400
Date: Thu, 21 Jun 2012 13:27:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kim, Milo" <Milo.Kim@ti.com>, Axel Lin <axel.lin@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: linux-next: build failure after merge of the regulator tree
Message-Id: <20120621132738.6e797593acc58b3e30902f69@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Jun_2012_13_27_38_+1000_9m8H2sm01+eiWE7e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jun_2012_13_27_38_+1000_9m8H2sm01+eiWE7e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (x86_64
allmodconfig) failed like this:

lp872x.c:(.text+0xb0699): undefined reference to `devm_regmap_init_i2c'
drivers/built-in.o: In function `lp872x_driver_init':
lp872x.c:(.init.text+0x81ac): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `lp872x_driver_exit':
lp872x.c:(.exit.text+0x37e): undefined reference to `i2c_del_driver'

CONFIG_I2C=3Dm in this build.

Caused by commit 809d310c7e69 ("regulator: lp872x: Don't allow modular
build") but that was done to fix a different build problem.

I have used the regulator tree from next-20120619 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Jun_2012_13_27_38_+1000_9m8H2sm01+eiWE7e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4pSqAAoJEECxmPOUX5FExVYQAJM02PtIoUYfUuyZ/bwgKr09
E5R1smEOvu8kbwuukuGOQtOnyTfgV/bPP4cWFSVAlajtkBHIy3UEaZHVxKQyT0Zh
pEJ6ajMXejT1Wd96Dyn1XEwImsumE/NGSy1pstwpGFsk/abCRcjMxbYjmTJysRZp
WC617ea1SUGdbtN2/dXnUIKzmPw9lrsaICae9V8lLrFG1V7FypKXPQLZENEKGVt5
GmtuN22XA7m89tvHn00/GXwJDgFGY83jUpiSf+/ExoHW9OZ99gV7S28z0X1JezZ9
GQZ/WL3asDxxdiE369IOcMR7Y+E3iHLSe11DeOEEPQLlCur2ncBpLkdirQHd4tXv
OPYviJFCL9IPxUpR7DANf3Z25qIq8n2IJF8vvvRjkNO/R+skET9iuArt5RCF47D0
bontpycorWgUkz9scMxxomighkm0ktPC5CSGPIXn+9otiUK4IA3rCs97wx1TOlAW
gl9rBpXf+IlHyKvecFCFkZ/zXTnrG5efd5yT17pCSqH5ZuipTa4sGyMoJZWh6Ddo
R7vYbYGCMF5Umc5+9wlnK72dzM4aaNFoLqbAoyLjoa0Jub/xQBm2O/r5JJlKaTNo
BoF/qpWGQpaWRECS/XYQD13c+2IMEjKKEyjfm1zm82lg0UkeKWGxByaQOQyZvW2v
8Zzu8Rc8rcvMpDARVolx
=j3O/
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jun_2012_13_27_38_+1000_9m8H2sm01+eiWE7e--
