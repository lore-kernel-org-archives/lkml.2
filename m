Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3ACBgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:36:08 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51482 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab3ACBgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:36:06 -0500
Date: Thu, 3 Jan 2013 12:35:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        Julien Delacou <julien.delacou@stericsson.com>
Subject: linux-next: manual merge of the pinctrl tree with the
 driver-core.current tree
Message-Id: <20130103123557.7162f7108bb99dac57732e35@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Jan_2013_12_35_57_+1100_eraoyP4+t044dg56"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Jan_2013_12_35_57_+1100_eraoyP4+t044dg56
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
drivers/pinctrl/pinctrl-nomadik.c between commit c2c57b329c7b ("Drivers:
pinctrl: remove __dev* attributes") from the driver-core.current tree and
commit f7ae849b80de ("pinctrl/nomadik: adopt pinctrl sleep mode
management") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/pinctrl-nomadik.c
index c68ec40,8e4720f..0000000
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@@ -1846,7 -2111,29 +2111,29 @@@ static const struct of_device_id nmk_pi
  	{},
  };
 =20
+ static int nmk_pinctrl_suspend(struct platform_device *pdev, pm_message_t=
 state)
+ {
+ 	struct nmk_pinctrl *npct;
+=20
+ 	npct =3D platform_get_drvdata(pdev);
+ 	if (!npct)
+ 		return -EINVAL;
+=20
+ 	return pinctrl_force_sleep(npct->pctl);
+ }
+=20
+ static int nmk_pinctrl_resume(struct platform_device *pdev)
+ {
+ 	struct nmk_pinctrl *npct;
+=20
+ 	npct =3D platform_get_drvdata(pdev);
+ 	if (!npct)
+ 		return -EINVAL;
+=20
+ 	return pinctrl_force_default(npct->pctl);
+ }
+=20
 -static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 +static int nmk_pinctrl_probe(struct platform_device *pdev)
  {
  	const struct platform_device_id *platid =3D platform_get_device_id(pdev);
  	struct device_node *np =3D pdev->dev.of_node;

--Signature=_Thu__3_Jan_2013_12_35_57_+1100_eraoyP4+t044dg56
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ5OB9AAoJEECxmPOUX5FE6J8P/1TB04vse3M+1vKDmMGCvsVS
0UGyKvZiG7Rgn6uy5i3mYfWODzOCjHn1794Ko6rCDqINrBln2Q5ODNi8SeVV+ao5
XGjr8m/84crAfrSiD0G9Kp+s8R5YDSYxLFcmyFDrWfv+BhY02sce47gTEAO6U2Ec
MY4018oqBY7RUf4G/TAofcgwd6nHEn5DUq1gw/2y/+in2njCu56upaGOOfk5Fy3d
KF9So45QJ3nhio6npdW3TPRxnP/wg4QDpp+yUQelkBL6lW8n6tzn+hLOA1rV1SLE
Me87Ixw2hzVKWzhnyqIuaQoOIClVyg34P4yyh19VNqTA31J3UnwelTVOz9Z24skK
jVIoXM8pGEpUhkjszFk+a2xCeQaoKUV6dYExCDHfF9vfcofQY2zyjyiQxkqG+aga
Sh6QS5J84m9Uf2wJIiQqQYyf+O35dnZgs5Yh0f4v82MtyuPcfgrx9o2J2yWGc0nQ
ew8G2oXbN3XnXt5AOZBMol5ymED+0XxD+bzlSq4/tvsOdiSUlW3k5FBwzp3S0TGq
7v9atWLBLdBaJFhFt0rPTZ2hoymCRT3E0D1sI1/Dj1xAqFsUKuYg6UapCYh92oEU
rDIzDWXfmSvJFBXv1GkGwmtIoIXO7d8ruwGfexyE8fvOzGTGgiEmdFdLS8y7XHPX
NbG8NMeobsiqjyzxZgv8
=NX+j
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jan_2013_12_35_57_+1100_eraoyP4+t044dg56--
