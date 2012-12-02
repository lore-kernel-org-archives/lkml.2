Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2LBJem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 04:34:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab2LBJej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 04:34:39 -0500
Date: Sun, 2 Dec 2012 20:34:21 +1100
From: NeilBrown <neilb@suse.de>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Saranya Gopal <saranya.gopal@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] bq27x00_battery: fix bugs introduced with BQ27425 support
Message-ID: <20121202203421.1ad1f6dc@notabene.brown>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uIdDvXgRvAk+Qzb/IFzcPjn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uIdDvXgRvAk+Qzb/IFzcPjn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



commit a66f59ba2e994bf70274ef0513e24e0e7ae20c63
    bq27x00_battery: Add support for BQ27425 chip

introduced 2 bug.

1/ 'chip' was set to BQ27425 unconditionally - breaking support for
   other devices.
2/ BQ27425 does not support cycle count, how the code still tries to
   get the cycle count for BQ27425, and now does it twice for other chips.

Cc: Saranya Gopal <saranya.gopal@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_batter=
y.c
index e2659f1..51d4017 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -445,7 +445,6 @@ static void bq27x00_update(struct bq27x00_device_info *=
di)
 		cache.temperature =3D bq27x00_battery_read_temperature(di);
 		if (!is_bq27425)
 			cache.cycle_count =3D bq27x00_battery_read_cyct(di);
-		cache.cycle_count =3D bq27x00_battery_read_cyct(di);
 		cache.power_avg =3D
 			bq27x00_battery_read_pwr_avg(di, BQ27x00_POWER_AVG);
=20
@@ -697,7 +696,6 @@ static int bq27x00_powersupply_init(struct bq27x00_devi=
ce_info *di)
 	int ret;
=20
 	di->bat.type =3D POWER_SUPPLY_TYPE_BATTERY;
-	di->chip =3D BQ27425;
 	if (di->chip =3D=3D BQ27425) {
 		di->bat.properties =3D bq27425_battery_props;
 		di->bat.num_properties =3D ARRAY_SIZE(bq27425_battery_props);

--Sig_/uIdDvXgRvAk+Qzb/IFzcPjn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULsgnTnsnt1WYoG5AQJdJBAAjnFzx+os1r0aizrubYoc8U1IWcmTxGmP
hhF4z9iF2i2Npt27ig3HgqrKtxp1iBFquENjrZlRkkq+BWixBKYLt7ctWkfvKTmO
2UxFPvsktC+uA8ykQGnX0PRD5ZFtUuUy3RT7b0zzf5l5ZyT11lVgPnXUwc+zXNR1
bRJLPgzBsZIbtpBq90ERzbrpy7To7HE94irf4MKsUw4POvYG2b2omzDtaQhIrjLc
YI4M8TM4OK9/DIx7sDF8NWrF4LJc6a458EWgvbwkwFoPeAh+COFXw5MdARvAEGPv
aF9yVXpSGc5iIfFDZY5rOkpWu13wVE7ziEsesu3Ve8Tcj4AVhhE9U+cojTlUDsPf
M930cO205nNWJR/BQ9vWy6AAa8Oc+Bdwy4qRk2IW3voF7iIsAqtSuFURepgjjzbk
+ccZyORh5c7c6uANvmBV6tVxxWSVm+yop+/wsVJmA50P+0QpAFLQLgsQxvBilRfH
6Tc9McEZho8Ivc+HZtMuiRAca9HLY3fPvPnhHtAgWU/cfKb2S5br/6mfXXIg3PL/
ZdFNXjds7NheoYKmfc8X7NOn4BJqee/Hg5VBNX4VnYE/DpYojLP7S/w/h5ka07aC
ZiuXcwgjVRYYeoAlWkgfglBJ5pgaSshAtkgqVjlG81WAPm8ymDOwM6TVpRv6XKCi
X2S97On2XxA=
=mIRW
-----END PGP SIGNATURE-----

--Sig_/uIdDvXgRvAk+Qzb/IFzcPjn--
