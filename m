Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2FSEya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 00:54:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41111 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2FSEy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 00:54:27 -0400
Date: Tue, 19 Jun 2012 14:54:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Durgadoss R <durgadoss.r@intel.com>, Jenny TC <jenny.tc@intel.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: linux-next: build failure after merge of the final tree (acpi and
 battery trees related)
Message-Id: <20120619145425.6f825e142856ca808927ca45@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Jun_2012_14_54_25_+1000_uKXMIkiAs78EqsgQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jun_2012_14_54_25_+1000_uKXMIkiAs78EqsgQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig, i386 defconfig) failed like this:

drivers/power/power_supply_core.c:204:6: error: too few arguments to functi=
on 'thermal_zone_device_register'

Caused by commit a9e7402dd2e4 ("ACPI-Thermal: Make Thermal trip points
writeable") from the acpi tree interacting with commit 3be330bf8860
("power_supply: Register battery as a thermal zone") from the battery
tree.

I have added the following patch and will carry it as a merge fix to the
battery tree:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 19 Jun 2012 14:46:17 +1000
Subject: [PATCH] ACPI-Thermal: fix for an API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/power/power_supply_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply=
_core.c
index ff990d2..85689fb 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -201,7 +201,7 @@ static int psy_register_thermal(struct power_supply *ps=
y)
 	for (i =3D 0; i < psy->num_properties; i++) {
 		if (psy->properties[i] =3D=3D POWER_SUPPLY_PROP_TEMP) {
 			psy->tzd =3D thermal_zone_device_register(psy->name, 0,
-					psy, &psy_tzd_ops, 0, 0, 0, 0);
+					0, psy, &psy_tzd_ops, 0, 0, 0, 0);
 			if (IS_ERR(psy->tzd))
 				return PTR_ERR(psy->tzd);
 			break;
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Jun_2012_14_54_25_+1000_uKXMIkiAs78EqsgQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4AYBAAoJEECxmPOUX5FEz7wP/ixoAupADj94t/MQ1rryYJdU
/PgE3jKzz9xR2+Jce7gD4f9+kQAEHF3mFKMCJLpP1xP7PHFFnAc1QPppdaUkkikO
27nDzrT72vvL9wZL+9dWS97SaZ9VmprbTNQKt8PWXf8Qd896a/VqNqQYAwDmtjpn
wqJhz9YcTUJgy8E84+rhKOzL6XmnbfnJjMyScLmaiAY+yuLx+V/FG+q0jeVATfp0
NYRUc1l52W+FbN3h4lhjPhzdbYo33HGFsXm7spmaDy1oERODa1xJ2fYgV8W1FKjH
mv9wDpYxNsfTnXUyhVVZB+aXA0xDU5cnLroRXNrA7oFzgbEQsvVWnSU6JDxU5phi
sW9ZKQPwelfCpP7F5PFLOpkQ/EQTecLhuw11e/ZjanWJU4Bn5VMolwUaVYXOPJNC
FDdgw/sDbhAO+IFKZXHaQ6MMqijpnC6iydEQP2pJKXL+UnyR8JFZtiZoazq8XVyG
O3Wz/8yJuIsBexOoPVDxw6i8QBjw67xzLNoSOWTj+ysIiQSmpMRprbFC+IxZW9jJ
ZVCIdoOk4VaG3MbeYVOnsyRjtyycqyLBthf5hd3kk5jYQtg3q6uki3XA0ei2Ku25
tk1QLEkVwFf9mY+QoBqpb2vpj9jn1LVxLfUFome8cf1O9aKCTbbl9D7OgrkEVA+U
IhoIyJLJu9KTFD9OV52N
=MGZo
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jun_2012_14_54_25_+1000_uKXMIkiAs78EqsgQ--
