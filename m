Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab1LOGSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:18:03 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60268 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab1LOGSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:18:00 -0500
Date: Thu, 15 Dec 2011 17:17:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: build failure after merge of the regmap tree
Message-Id: <20111215171752.db0b6732fb591a91ef8c790a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Dec_2011_17_17_52_+1100_PmZ9jvrTmKtBG7xC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Dec_2011_17_17_52_+1100_PmZ9jvrTmKtBG7xC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the regmap tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/mfd/da9052-spi.c: In function 'da9052_spi_probe':
drivers/mfd/da9052-spi.c:42:2: error: 'da9052_regmap_config' undeclared (fi=
rst use in this function)

Caused by commit cfe04478fa1b ("MFD: DA9052/53 MFD core module add SPI
support v2").  Really, was this ever build tested?

da9052_regmap_config is defined in drivers/mfd/da9052-core.c but not
declared in any header file.

drivers/regulator/da9052-regulator.c: In function 'da9052_regulator_probe':
drivers/regulator/da9052-regulator.c:550:11: error: too few arguments to fu=
nction 'regulator_register'
include/linux/regulator/driver.h:215:23: note: declared here

Caused by commit 08bf1c0ae97f ("regulator: DA9052/53 Regulator support")
from the regulator tree interacting with commit 2c043bcbf287 ("regulator:
pass additional of_node to regulator_register()") also from the regulator
tree.  Again, building the above file depends on CONFIG_PMIC_DA9052 which
noone ever set before.

I have used the regmap tree from next-20111214 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Dec_2011_17_17_52_+1100_PmZ9jvrTmKtBG7xC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6ZEQAAoJEECxmPOUX5FEMAMP/3VUqilkWMwOt80cfvGjXOCi
TCwPDBATGLsDGMPX5RLPvEO1P1Hx3tvp4NzmB4GdiHUii0HCfz5FYvmddtEmn0xA
okVfrf5tpSfgedaxZ0bMrDtC/xJqODYLLIeK3EmUe910GpqjGAtK1KuZ1aaW1sLA
5O1VxSRAJe89mJBXI0WbfQ32XQqwYsob8h3FC6QaMiWPpUCom1vNdOpuwNNN9fVF
PUs++jSpWds1xw6nTCWnSaiiedG6iXJYlvLlKT33l/0AOnnk9/ZE5YkDua5mSUoE
HD2XI57yEvjJY6Xbx1WVc1BNO2gCXBoOWOcHk9KaCo4AsB09reMuqnDUM1nIGO/3
nC1DNEIkPMD/29Ddyj8ZiB3h7YJvgipaQzgCA5lTgu/+rW376QscxAh8X6Le8YYk
4vus/lO8+75IqkECLfIkBstU5BTVXdGLihHPls5ojCZS/rWbQ9DANTUwOCzpax0Y
k52EWiUnWu8g37EVtLFTyYqLWwkiYoSWFsmrKELaQWjeEg5Q4l/HIXcbC0y/1Vqr
cuy+Dfp/Gqu9HDxoD48JIFz7TFeS5rbTxV9xVsGVhcHwlotb7vSPefqWwqVzKQ0Y
ejVxoDPeOOu1F6P6qqDK42vuHhif6NfJU1OqaDEGyXNcyBt+wotoYDOvEs+InvC8
212J3d2euya1xSAQujQM
=JzM/
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Dec_2011_17_17_52_+1100_PmZ9jvrTmKtBG7xC--
