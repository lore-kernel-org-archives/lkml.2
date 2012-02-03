Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2BCCo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 21:44:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57478 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab2BCCoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 21:44:24 -0500
Date: Fri, 3 Feb 2012 13:44:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: linux-next: manual merge of the gpio tree with the regulator tree
Message-Id: <20120203134415.624d07b379876f1e5f0c644a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__3_Feb_2012_13_44_15_+1100_qYIGKrX+JIxynNVt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Feb_2012_13_44_15_+1100_qYIGKrX+JIxynNVt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the gpio tree got a conflict in
include/linux/mfd/tps65910.h between commit 1e0c66f49762 ("regulator:
tps65910: Sleep control through external inputs") from the regulator tree
and commit 290705988073 ("gpio: tps65910: Add sleep control support")
from the gpio tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mfd/tps65910.h
index fa6c6bf,9071902..0000000
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@@ -786,7 -786,7 +793,8 @@@ struct tps65910_board=20
  	int irq_base;
  	int vmbch_threshold;
  	int vmbch2_threshold;
 +	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];
+ 	bool en_gpio_sleep[TPS6591X_MAX_NUM_GPIO];
  	struct regulator_init_data *tps65910_pmic_init_data[TPS65910_NUM_REGS];
  };
 =20

--Signature=_Fri__3_Feb_2012_13_44_15_+1100_qYIGKrX+JIxynNVt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPK0n/AAoJEECxmPOUX5FEd2sQAIDrOk/ZwcYwToJsFQmoz5ow
IPza6lG3cQwY3KFmfeDwGdAhTM3BYXdnk3p0Ui5FPIq8+UoBh3HNg08jTeYnWZSA
0773EyBam/G1AK3fDQ2L6fpPaJUXhDP9MvxRCfulEwUd5tffXIqmvoGKj2q6Z8at
SclD4sJbC0cdHBZx7bbr8DCtuKPVgCZpmru0mEmeM0rbXbBa99c83ODVG3PXRlw+
UlrWeGSrOv69u8UTrSHpl6MHILfZ684yFgm9SZS817TlGgpiGJmHTEBSDtbXvGTM
/I4GosdPo/khGSPDXgXjt0vJf9jPD3vjzhH/wPzb0N8bPBXhmszmXxXAAsWRX2YU
yueWlKyG8Wl5/KtIoP/2Dm8oKUJUClqQeUtrnYMJclM9US9RYDviztoxyLJMwFhI
02eANQQ8xcKVsdG3NQChqDaPnOgHdLOX1Zr+fctVoCwmXMIqI67nONsjziRgCsIP
RhDxG+gMke+mzzyUID6fyXIKVDxeZf53337cfSFOjYTM4JC3UHJQxzTPTTVVLGkf
T3Z0cOPwFf9y2mBucUqReQO499Cd0e7hmuBuMsJ0yTZlVNvT2AgAe1OzcGEN2LJK
uDCojPGtpIwR0MJLFIA3APV08dBUF2uOzt8bzZdanWig6YDPsVxu9GRGKE0F7Tur
renOlOQZpaiG+SRP+y7o
=3W1O
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Feb_2012_13_44_15_+1100_qYIGKrX+JIxynNVt--
