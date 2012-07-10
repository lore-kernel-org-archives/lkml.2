Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2GJNgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:36:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:40127 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab2GJNgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:36:35 -0400
Content-Type: multipart/mixed; boundary="===============1773372090=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="166246513"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] of: mtd: nuke useless const qualifier
Thread-Topic: [PATCH] of: mtd: nuke useless const qualifier
Thread-Index: AQHNXqDrYmVK+RLu10GvjAMZ2Mm3Jw==
Date: Tue, 10 Jul 2012 13:35:50 +0000
Message-ID: <1341927604.2963.101.camel@sauron>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.155]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1773372090==
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-IMs9levBL7e40jhrkXP+"

--=-IMs9levBL7e40jhrkXP+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch does the following:
 -const int of_get_nand_ecc_mode(struct device_node *np)
 +int of_get_nand_ecc_mode(struct device_node *np)

because:
1. it is probably just a typo?
2. it causes warnings like this when people assing the returned
   value to an 'int' variable:
   include/linux/of_mtd.h:14:18: warning: type qualifiers ignored on functi=
on return type [-Wignored-qualifiers]

Remove also the unnecessary "extern" qualifier to be consistent with other
declarations in this file.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/of/of_mtd.c    |    2 +-
 include/linux/of_mtd.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_mtd.c b/drivers/of/of_mtd.c
index e7cad62..a27ec94 100644
--- a/drivers/of/of_mtd.c
+++ b/drivers/of/of_mtd.c
@@ -32,7 +32,7 @@ static const char *nand_ecc_modes[] =3D {
  * The function gets ecc mode string from property 'nand-ecc-mode',
  * and return its index in nand_ecc_modes table, or errno in error case.
  */
-const int of_get_nand_ecc_mode(struct device_node *np)
+int of_get_nand_ecc_mode(struct device_node *np)
 {
 	const char *pm;
 	int err, i;
diff --git a/include/linux/of_mtd.h b/include/linux/of_mtd.h
index bae1b60..ed7f267 100644
--- a/include/linux/of_mtd.h
+++ b/include/linux/of_mtd.h
@@ -11,7 +11,7 @@
=20
 #ifdef CONFIG_OF_MTD
 #include <linux/of.h>
-extern const int of_get_nand_ecc_mode(struct device_node *np);
+int of_get_nand_ecc_mode(struct device_node *np);
 int of_get_nand_bus_width(struct device_node *np);
 bool of_get_nand_on_flash_bbt(struct device_node *np);
 #endif
--=20
1.7.10


--=-IMs9levBL7e40jhrkXP+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/DC0AAoJECmIfjd9wqK0EGYQAITTFLOyU8Kk/qCSi3DMoOOV
55njfuucO4UHZVCZi9GMM+YD9OOhTsrKiqU5sFHG1HCotrYsr1+ep1/ReG7ssXXl
QLO/ycSlkbUfRqTOWj0fWv1t6QIldyBWN5U3h4Ox7cMtljNZd5UVAUP2I/Ujee11
6FwODkSj5YO9S5AJSlfJuC7r5g+SUTKVnZVQ8AgULEqj3o9zSuXAKqvrNTpAHhaF
Rg7s/1ee2f8DdiXuVCM8HnCdXSH3dHALruUYmD5ycJ04zV6NTFgEH30uFimZ6riX
a6OYVR6evZol9hgjjun5iYk4pcOOXxxvk09IO89g10ooH/ZZZWZM81xanQhv/gRF
HbRVVeNN/evOs5ke5MvV3WWwsvYSDHznxXVmBPIV+rMVuyLW3IkXtguim2KvMXWO
hmCQyQO+8cCjKFLqvsRtQDJ8R2XnIVP0wmoN+BngtIy2PRh4GDDFusc6zTtFfZSf
h3eXgFMkOfClma4GOTvpYA4mAxH7HBUOyYwPUVan1bKUabXjtdLg/gmy9Wu/8gSB
hb/m19cCmt/CLgQKYs/M0euULq/1YIo9h4oBDiP08hK/aKzetikWlQkr8HLU4aNH
HY+ic44llQ+Edc1VbZOiC0aMUcO3xEeHbXkmoK2CaMla8mkNB79K3AcR0nxrxo+I
4FnKB1YlWweooMoPK5jq
=NvLS
-----END PGP SIGNATURE-----

--=-IMs9levBL7e40jhrkXP+--
--===============1773372090==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki =

Business Identity Code: 0357606 - 4 =

Domiciled in Helsinki =


This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============1773372090==--
