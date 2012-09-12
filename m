Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2ILFwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:52:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42506 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2ILFwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:52:40 -0400
Date: Wed, 12 Sep 2012 15:52:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: linux-next: manual merge of the staging tree with the thermal tree
Message-Id: <20120912155231.716530c364bb20bd43efec0d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Sep_2012_15_52_31_+1000_f3N/thIT8Oj_jdDb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Sep_2012_15_52_31_+1000_f3N/thIT8Oj_jdDb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/omap-thermal/omap-thermal-common.c between commit
76f726fb24bd ("Thermal: Remove tc1/tc2 in generic thermal layer") from
the thermal tree and commit 765a1939a364 ("staging: omap-thermal: fix
polling period settings") from the staging tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/omap-thermal/omap-thermal-common.c
index b4cd6cc,46ee0a9..0000000
--- a/drivers/staging/omap-thermal/omap-thermal-common.c
+++ b/drivers/staging/omap-thermal/omap-thermal-common.c
@@@ -248,7 -268,9 +270,8 @@@ int omap_thermal_expose_sensor(struct o
  	/* Create thermal zone */
  	data->omap_thermal =3D thermal_zone_device_register(domain,
  				OMAP_TRIP_NUMBER, 0, data, &omap_thermal_ops,
- 				0, FAST_TEMP_MONITORING_RATE);
 -				1, 2, /*TODO: remove this when FW allows */
+ 				FAST_TEMP_MONITORING_RATE,
+ 				FAST_TEMP_MONITORING_RATE);
  	if (IS_ERR_OR_NULL(data->omap_thermal)) {
  		dev_err(bg_ptr->dev, "thermal zone device is NULL\n");
  		return PTR_ERR(data->omap_thermal);

--Signature=_Wed__12_Sep_2012_15_52_31_+1000_f3N/thIT8Oj_jdDb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUCMfAAoJEECxmPOUX5FE1SUP/RrlYm39+7uJD5rdCdpMUHhG
PfMwbWeETJo889WP9r1XHt4DWUO5g0RaxFQ985O4TsPfxTZRe24dgF8zNHchXExQ
V82Pe//3jEM+R8VaY/BXb/ycczGnom1VyFBpgo4y1f5qg09kljnwrOFCMT7ozhYW
6XghhGkuET7vwo+/8G6bzVrKa4jlDC6k/VrfWeIPplIjRzEUxRrwJwB9Pg4xihsz
DFDXnhbNmYSMvYd7wHQw8NPYtz2LCa4Ca+A7k2uvtQOMTWEtCok86MHkjRAa8pGI
yQwFP4ISqwzoS5aBwoEhbdeBk80Gmk0jPA7dpisoV0NVc95dGC5bvCHIXO9i+nad
1IgWGpxki2O1NKUGwZPVd5vNNxMdEuzHf5FlDZyR7TpT44QVaxPUGrhzddd38cGZ
e/yDT8xwIUdlZX5tmze/1+KwAg6E+5cj/QORwBePcENmuttE7ST5jv+3aqq1wvVU
pKLKYXtez653/gkoHi9ZM3PvkWw2njz4naJupCOwadIvrB1zuU3Sog+t0sOL9Kxa
0GOPgPwReMqiZ2f0PWZ/OtXun16wk0EeGwjDYhTHZ7kerH6uN4zumIZqLDSU1wmH
5vKu9OL+MTC1Q9au7ekviniv9cBiboI4EMdooQBojBGIM+h9mfLKRVkbkqGvlNQ0
uGTHDKjp1zWLIjTA0sHa
=8JIB
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Sep_2012_15_52_31_+1000_f3N/thIT8Oj_jdDb--
