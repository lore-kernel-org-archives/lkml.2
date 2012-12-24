Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2LXCKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 21:10:35 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53987 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2LXCKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 21:10:34 -0500
Date: Mon, 24 Dec 2012 13:10:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: linux-next: manual merge of the akpm tree with the
 driver-core.current tree
Message-Id: <20121224131023.e0433db6868d6234c7a8c195@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Dec_2012_13_10_23_+1100__nnl.Xej4.VjOp//"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Dec_2012_13_10_23_+1100__nnl.Xej4.VjOp//
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/rtc/rtc-tegra.c between commit 9889589ba308 ("Drivers: rtc:
remove __dev* attributes") from the driver-core.current tree and commit
"drivers/rtc/rtc-tegra.c: convert to DT driver" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/rtc/rtc-tegra.c
index 5ba2f75,fb62808..0000000
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@@ -303,7 -303,13 +303,13 @@@ static struct rtc_class_ops tegra_rtc_o
  	.alarm_irq_enable =3D tegra_rtc_alarm_irq_enable,
  };
 =20
+ static const struct of_device_id tegra_rtc_dt_match[] =3D {
+ 	{ .compatible =3D "nvidia,tegra20-rtc", },
+ 	{}
+ };
+ MODULE_DEVICE_TABLE(of, tegra_rtc_dt_match);
+=20
 -static int __devinit tegra_rtc_probe(struct platform_device *pdev)
 +static int tegra_rtc_probe(struct platform_device *pdev)
  {
  	struct tegra_rtc_info *info;
  	struct resource *res;

--Signature=_Mon__24_Dec_2012_13_10_23_+1100__nnl.Xej4.VjOp//
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ17mPAAoJEECxmPOUX5FEy4IP/1iBKElYZCl0BWOReA2Jiyp5
2PgEKjbgFSHN6YzQt1hPWe6gwJK1onIX9/bMO1A8aukjsoAfAa/3S9JIeGt6HXts
ycl0ugYpJGFG/RcogFYuPgiY/xKrwocJD7Bc8e5RdHOVT8+w+7zKpmy2L+3l3gpY
AmNC+JElCfOLXrBhhIP4KRlo7qBZq7n1TZ31pPdtdeYzE8Z7Mj+8Xpc3yc3q/sG+
xvxShww2fEdx/cjH+JB/ZuofF04UBhKf6hEevFdhZGtG9REd2Sxqgwl+XQMrkj5/
pnoPeiD0L+8qjYdGDQrevv6tTFPS52QkR1QOFPzjsIeaj5husdg2OhKWT9RWchnt
RqftI5+o2wVaUepHBJgtbEBgSb+HQFJ1g/jR9pkXMrFiTAfy5FesVIc0ZEwO/fnQ
a7BOCskcs1GIDMcE/IyCW9v1NWdX8Q27sR+zUeYvcdAvN4rP7l2/Xx+dMsMYO4fA
K9nY5DxuMiTYbPnfNciP2vGJ/Oion0da/sXd0EDkjwoD16GVyym2hshuRN2CKB1n
udM9yI6i6AUb+aCNHXtawqKchv8hHMrE8PprvC25nJFTBPZjBEQ1dSijjHoys6fc
m+qnsz5FlxPQ18ePXn0jpHIUlAkuhNRzWCEo+g1k0uQpOZpxDGdV2S1VMLmbATG8
m0Y9nMk+3/zNVGAYsfzH
=zAes
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Dec_2012_13_10_23_+1100__nnl.Xej4.VjOp//--
