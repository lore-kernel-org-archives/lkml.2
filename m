Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2KEAq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 19:46:56 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33791 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2KEAqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 19:46:53 -0500
Date: Mon, 5 Nov 2012 11:46:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Devendra Naga <develkernel412222@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Durgadoss R <durgadoss.r@intel.com>
Subject: linux-next: manual merge of the thermal tree with Linus' tree
Message-Id: <20121105114644.fe54cba816860bf12f1de9cf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Nov_2012_11_46_44_+1100_ohL2doonBlVZerjq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Nov_2012_11_46_44_+1100_ohL2doonBlVZerjq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Zhang,

Today's linux-next merge of the thermal tree got a conflict in
drivers/thermal/rcar_thermal.c between commit 608f62b996c6 ("thermal:
solve compilation errors in rcar_thermal") from Linus' tree and commit
ebbf0f11e7b4 ("Thermal: Pass zone parameters as argument to
tzd_register") from the thermal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/thermal/rcar_thermal.c
index f7a1b57,b13fe5d..0000000
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@@ -210,8 -210,8 +210,8 @@@ static int rcar_thermal_probe(struct pl
  		goto error_free_priv;
  	}
 =20
 -	zone =3D thermal_zone_device_register("rcar_thermal", 0, priv,
 +	zone =3D thermal_zone_device_register("rcar_thermal", 0, 0, priv,
- 					    &rcar_thermal_zone_ops, 0, 0);
+ 				    &rcar_thermal_zone_ops, NULL, 0, 0);
  	if (IS_ERR(zone)) {
  		dev_err(&pdev->dev, "thermal zone device is NULL\n");
  		ret =3D PTR_ERR(zone);

--Signature=_Mon__5_Nov_2012_11_46_44_+1100_ohL2doonBlVZerjq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQlwx0AAoJEECxmPOUX5FEfWUP/RDJG5d4OkyFQCGUka4p6Lp+
i78sDe4CTkOxfMHdaUu/esPRoasbEWFIQaLxBeZIyG5hi5QeJIDl1CQXCa9H4PLv
9IpRqF/X9OYff/SYGLS9RvTaKA70p03EaUrUSa2ItRlRizbKZ5mPLnPz/zfzDLHt
R9nRtDVFCrQ70cAq2akR/AGK62iXhI2M/TyarQEK7jMsuXV8rPfvgWaAov9pzsvT
7Fuc+8S1KKHer10g1fkB8aL3WsZjH68fJFJhKWw/tZyMp481qlMr9P+Uvd+dkfXZ
xojOwRRai7+kXPVRXq37CaWNgFlD+Bqjc8fBjX/iBl6mNaE/0idSp+wJf0PgJwTp
fFUEi6gJr3mfYdkLh8T/hmk3IsPc4S6F0Py+JLTEqiE2Bgrahxcn2W5tVZ4ygFbh
RykcccpyLjQdUaCMm3QIVlbPQBpFckv5uyCIpYp2G9KiAxz0nJAoS19CsC0VTWDX
O6OkG3LEDrm2ksJVvJASLHOiFiGC8WeLkt/tJ3uni/8YObrjdlZmYJ4YOm2WxZrD
ozDh/AyEpnwyKvorG+bdnyYkZ6H8j2UNdaL64gR55vfdXTixK9EIiDJzrFp7OMpZ
zkgjgnYPOSlWBry1iTfxnvKcZSThm0Q74gsNcW1TlMXp0JU6Dr7E9O/m2I/ROZlg
CZtPbzLvGNiGtUxnmyoU
=3FiQ
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Nov_2012_11_46_44_+1100_ohL2doonBlVZerjq--
