Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2FDDDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 23:03:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34786 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab2FDDDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 23:03:11 -0400
Date: Mon, 4 Jun 2012 13:03:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Guenter Roeck <linux@roeck-us.net>,
        David Dajun Chen <dchen@diasemi.com>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the acpi tree with the hwmon-staging
 tree
Message-Id: <20120604130305.f8d3a3702d43f660a1db0f9e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Jun_2012_13_03_05_+1000_oDieulfTEYi4mpf0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jun_2012_13_03_05_+1000_oDieulfTEYi4mpf0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the acpi tree got a conflict in
drivers/hwmon/Kconfig between commit 418e7870dca9 ("hwmon: Driver for
DA9052/53 PMIC") from the hwmon-staging tree and commit f36beb016903
("hwmon: exynos4: move thermal sensor driver to driver/thermal
directory") from the acpi tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hwmon/Kconfig
index 4039353,2c7ef39..0000000
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@@ -314,26 -314,6 +314,16 @@@ config SENSORS_DS162
  	  This driver can also be built as a module.  If so, the module
  	  will be called ds1621.
 =20
 +config SENSORS_DA9052_ADC
 +	tristate "Dialog DA9052/DA9053 ADC"
 +	depends on PMIC_DA9052
 +	help
 +	  Say y here to support the ADC found on Dialog Semiconductor
 +	  DA9052-BC and DA9053-AA/Bx PMICs.
 +
 +	  This driver can also be built as module. If so, the module
 +	  will be called da9052-hwmon.
 +
- config SENSORS_EXYNOS4_TMU
- 	tristate "Temperature sensor on Samsung EXYNOS4"
- 	depends on ARCH_EXYNOS4
- 	help
- 	  If you say yes here you get support for TMU (Thermal Management
- 	  Unit) on SAMSUNG EXYNOS4 series of SoC.
-=20
- 	  This driver can also be built as a module. If so, the module
- 	  will be called exynos4-tmu.
-=20
  config SENSORS_I5K_AMB
  	tristate "FB-DIMM AMB temperature sensor on Intel 5000 series chipsets"
  	depends on PCI && EXPERIMENTAL

--Signature=_Mon__4_Jun_2012_13_03_05_+1000_oDieulfTEYi4mpf0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPzCVpAAoJEECxmPOUX5FEgg4QAJm523OaoylZmSlcGL59wYCw
0D44WgDcFiDFmdpI87G1/zeP7BfkwMcXlCl1QY2PTilNE79czchcHfxVHPzzGe3G
MDJf5LFufA7AI60yX07jNgupjFXV900bJhi+CF/m39x/Ql7BtW4MMCSWikn1Shnk
COL/8yHPb61xePd1NuFr6/DW4mkc3XLPmqc5L4NM253Yt6arOCJZEcR+NDNkeea9
nFqASgsfZVp9UOAQhYJDKrt5hpWTQNQuZXzIZS5LwZxfv1stw7jydcmLDeYp3iB9
ZqBEl0O1Yfg38XnHOXo4esjKxGoTRWByZDB8TMm0psriTe9C6c02VxmdkOFHHe2W
Z4nWRGx/+ZwLeGSovO4lGu5DOGVM5nDsKPqMGKJv1b74dQqz0Ze0wS4UFqzfdHbo
YkcbJ+m9frQbuZLd0a8U4fK1NCeMcLxuedn1aCc5V8IXD097ljUZwVaMI7vzZMBc
uBlDUcCeDBQ2Ss9B9nRW+H45dDVZU0FasvQbIK8Dn5OF19EormTBqCwzxRfUemav
lp4K/SPxQlq/XuYJHgfUu+R56JDsAYaMWvErVEao/rAgGb5KMCCYEDd6W27RUrVG
ZvlPN6iO9ZuZu/iWVHfIXkyilA6oLV7gBC8E2wmCh9ng+Tax9cw05ddBDxFNzSpT
bnnU/5T8UDPhS/zFgbD0
=QsxM
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jun_2012_13_03_05_+1000_oDieulfTEYi4mpf0--
