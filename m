Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2K2ESJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:18:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41252 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab2K2ESH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:18:07 -0500
Date: Thu, 29 Nov 2012 15:18:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the driver-core tree with the mfd tree
Message-Id: <20121129151804.a133338f9738b25d3ccf2e6f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_18_04_+1100_2m.VOuEfK2j09xlC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_18_04_+1100_2m.VOuEfK2j09xlC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/power/da9052-battery.c between commit 4b5edf7887c6 ("power:
da9052-battery: Convert to the new da9052 interrupt functions") from the
mfd tree and commit c8afa6406e60 ("power: remove use of __devinit") from
the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/power/da9052-battery.c
index 3972dc0,bb0df89..0000000
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@@ -578,16 -576,7 +578,16 @@@ static char *da9052_bat_irqs[] =3D=20
  	"CHG END",
  };
 =20
 +static int da9052_bat_irq_bits[] =3D {
 +	DA9052_IRQ_TBAT,
 +	DA9052_IRQ_DCIN,
 +	DA9052_IRQ_DCINREM,
 +	DA9052_IRQ_VBUS,
 +	DA9052_IRQ_VBUSREM,
 +	DA9052_IRQ_CHGEND,
 +};
 +
- static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
+ static s32 da9052_bat_probe(struct platform_device *pdev)
  {
  	struct da9052_pdata *pdata;
  	struct da9052_battery *bat;
@@@ -638,14 -630,16 +638,14 @@@ err
  	kfree(bat);
  	return ret;
  }
- static int __devexit da9052_bat_remove(struct platform_device *pdev)
+ static int da9052_bat_remove(struct platform_device *pdev)
  {
  	int i;
 -	int irq;
  	struct da9052_battery *bat =3D platform_get_drvdata(pdev);
 =20
 -	for (i =3D 0; i < ARRAY_SIZE(da9052_bat_irqs); i++) {
 -		irq =3D platform_get_irq_byname(pdev, da9052_bat_irqs[i]);
 -		free_irq(bat->da9052->irq_base + irq, bat);
 -	}
 +	for (i =3D 0; i < ARRAY_SIZE(da9052_bat_irqs); i++)
 +		da9052_free_irq(bat->da9052, da9052_bat_irq_bits[i], bat);
 +
  	power_supply_unregister(&bat->psy);
  	kfree(bat);
 =20

--Signature=_Thu__29_Nov_2012_15_18_04_+1100_2m.VOuEfK2j09xlC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtuH8AAoJEECxmPOUX5FEOaIQAJw3TCNnBDuxlU91KKJESpjN
SU+CTDOu4kkwXLl3Xke+ALkQ2Q6IOLny8UF+CCdOQbNml4e1YhAC1Q1eW9TqAh0U
c0lwqqqu7JkQNXUGjtHbNKugUY0OFqwdnPBgyLbQdXdzY4SlCqTi8A3YQrL5jLIJ
0xwh0eP4pGbiTmD2Aaf9r51LpwVQmP7dtHNLqZ8WRFyGsFrRGVHq1bGs0oDgGmr6
AfLrPqdETuXsrPoPvknWKcWgkhyzkFdGqen9c6sUFoxQoMRh/Tu2xt2VmMtUGgQk
pLGyhRFU+fFypqjQLZI4OpEh71FoQ9tl3rEfAA8BhRNBQBf+nL1zaIxxw/44Cf4p
4vK8RAvJc+5iaQeGyGe7k9iBsUyKrk6YhRWNBt4c03mVYaWYarys6W5GEgEra7sX
PYsRcaozC5v8CGBSI0LfSeRoLx7MCCZ5Uh4DPore4VdbJYRcJqsguRadSDEku3lP
2CsEPfb7nX4nWg85+tg3yScaCjnCdASerc10Mg5K/dTttz/2NiQzEjE5tma5ng9B
S/GRigghAJF20kiZx37/EDdQqGpysAKrMDSU2gBHGU6n1E6k2mlZWjaGx0nigO/q
OZylOrF/ULwo1NZGTKT3YtZJPlE8lQRGqdFvdNu/UfNIKETN2V5k/0BVlNIVuIWO
NR3wcdHB6fS1eofXCP0N
=B/CF
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_18_04_+1100_2m.VOuEfK2j09xlC--
