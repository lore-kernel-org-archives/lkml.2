Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab1LOGFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:05:30 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60723 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1LOGF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:05:28 -0500
Date: Thu, 15 Dec 2011 17:05:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ashishj3 <ashish.jangam@kpitcummins.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Dajun Chen <dchen@diasemi.com>
Subject: linux-next: build failure after merge of the regmap tree
Message-Id: <20111215170517.0b7fc08487881743ca76c192@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Dec_2011_17_05_17_+1100_i7aWL71shuUxQkFB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Dec_2011_17_05_17_+1100_i7aWL71shuUxQkFB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the regmap tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpio/gpio-da9052.c:25:35: fatal error: linux/mfd/da9052/gpio.h: No =
such file or directory

So, it looks like this would never have built
(include/linux/mfd/da9052/gpio.h never existed) but noone ever enabled
CONFIG_PMIC_DA9052 before (which CONFIG_GPIO_DA9052 depends on).

drivers/gpio/gpio-da9052.c was added with commit 07bfc9152365 ("GPIO:
DA9052 GPIO module v3") in v3.1-rc1.

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 15 Dec 2011 16:59:59 +1100
Subject: [PATCH] gpio: disable broken driver

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 79199f4..e338013 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -70,7 +70,7 @@ config GPIO_GENERIC
=20
 config GPIO_DA9052
 	tristate "Dialog DA9052 GPIO"
-	depends on PMIC_DA9052
+	depends on PMIC_DA9052 && BROKEN
 	help
 	  Say yes here to enable the GPIO driver for the DA9052 chip.
=20
--=20
1.7.7.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Dec_2011_17_05_17_+1100_i7aWL71shuUxQkFB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6Y4dAAoJEECxmPOUX5FE+WMP/R7cdDhjhsQTCdWIte+n1Lei
VrA17DIOuUyslw55HDb84zcIB90txNrTTrEsv9MFMusV5eOg2012wgSyLgnmCUSs
ZvP0d0s4nTrgX8vZlnVYzKrqxD1S32tNJWVhSkc5gpOscZ5o9m4p6kuosPOohaOy
CswzaYGJB9cRzdh9CQo84mGI0DrXdhXBv4iyRSzaASE/diWl6GuKVgh/7Jk9lWQu
et7FY6F2XwvqySTNedVHvNCEVv9Xx4h1dwUDf5qvdhnBpxXHg9eqoftCU36golsi
w/GiwsI30ZqF62HkDAmFmjMZ1oKx2p7b1BPJrTSQhju8xT2ogK1Y7gPbv//zonkj
thpHm6WGtza/JibIo53W/ix8c8YIDFkfrb2jMkj4SW/mggerPUu8bfS+gUkrM7Kj
nl2C66AcVUjPx7bxcHBj71qgskRSylegC2nEFKCIDDq3p+rWUwGX59070zD8Bqvf
O1zAx7/9RAmX2TuDg6ugE75b8Sv8/K7aCCo9SYXNZgPcpccmSe/2KCNi8D7By8RF
KF9e4k0/zgHGhkCMCwf/vw3hJfoESrkaGzOmORE0f4lZiTWK51/uKEHBjpUtRWHd
/2EQhTcAhU0Ee758mDKwLeNbpvrKemvAw88nrEyVHrQyO1OfHligDRhTAU1vN8lT
w+yYEGonpu3bfmU6scfh
=anQ/
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Dec_2011_17_05_17_+1100_i7aWL71shuUxQkFB--
