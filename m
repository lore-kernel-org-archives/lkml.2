Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661Ab2CMD7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:59:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50412 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759616Ab2CMD7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:59:18 -0400
Date: Tue, 13 Mar 2012 14:59:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the mmc tree with the s5p tree
Message-Id: <20120313145907.8b549d741fef217899f971a4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_14_59_07_+1100_=YDyDqQ=3JW_C/uu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_14_59_07_+1100_=YDyDqQ=3JW_C/uu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the mmc tree got a conflict in
drivers/mmc/host/sdhci-s3c.c between commit c1c4b66dc010 ("mmc:
sdhci-s3c: add platform data for the second capability") from the s5p
tree and commit 1c352c37ee23 ("mmc: sdhci-s3c: Enable runtime power
management") from the mmc tree.

Just context changes (I think).  I fixed it up (see below) and can carry
the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/sdhci-s3c.c
index a2bfbe0,312aaf4..0000000
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@@ -714,9 -706,11 +703,14 @@@ static int __devinit sdhci_s3c_probe(st
  	if (pdata->host_caps)
  		host->mmc->caps |=3D pdata->host_caps;
 =20
 +	if (pdata->host_caps2)
 +		host->mmc->caps2 |=3D pdata->host_caps2;
 +
+ 	pm_runtime_enable(&pdev->dev);
+ 	pm_runtime_set_autosuspend_delay(&pdev->dev, 50);
+ 	pm_runtime_use_autosuspend(&pdev->dev);
+ 	pm_suspend_ignore_children(&pdev->dev, 1);
+=20
  	ret =3D sdhci_add_host(host);
  	if (ret) {
  		dev_err(dev, "sdhci_add_host() failed\n");

--Signature=_Tue__13_Mar_2012_14_59_07_+1100_=YDyDqQ=3JW_C/uu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXsYLAAoJEECxmPOUX5FEnKoQAIIZE63mo0oVNgF7SbgDJoON
R5QK8kcDP7KcTONQC2CCPlYL69ndyCk7WdYMxdhy9Oa8VXWADWoLL5GdbJ/+a0ui
Cmnne8a+cfin50WrITN3sqWxstJ+60Ynjx9iOBgPz7IqwtUtEhiuDoXKp/e5rXQm
lzH3hjunJaoVADeSp521ry7j0KbZE0XpfO2xFMhUIYA/ilfVoF2PtPjVWs5AmeBk
QCWv17nvV5/WabZiyP+279XsZ86cpiFfJh8hm56+gbLXTfckDwQzk3ww9H2ysy4H
/vApIuhE/OhU5/THtLCxrDYFkNJrKiH5vyuk5IrE513Umda6BYAoW6FXTTdqzhfB
1WzZFNKYiv85DuUah796n4AE43UoDPhDMG2e+N0OjdwjngkPWKs4uYOSYySTiO8k
RCmZAUYBRQ1lboWs/4PlHNgcRn3cOApjyvPpsFspe+SJnYbVxDpcp+4toxfBtbqR
9TPfAfEVtb6FHCwgPUJFHmzkb9LDhpn8v635Xir3bTbgArSdluqGosFvanVxhdA0
k9qu3QYf6ZpjdqkNV5LvWb6wG5lBM90DFbBMakDe+nh6vSzcscfiayoVK4C6Ii4/
+F0yGPn2+x9qbdACjIJeePl4F7h+emR20ah7UeyAGIAGo8z3tKrL7QDmDjMSeeGk
G+SviRmRvc4uYmIplN2c
=OzBI
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_14_59_07_+1100_=YDyDqQ=3JW_C/uu--
