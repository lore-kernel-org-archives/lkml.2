Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2ADEHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 23:07:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:47823 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab2ADEHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 23:07:09 -0500
Date: Wed, 4 Jan 2012 15:06:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
Subject: linux-next: manual merge of the net-next tree with the arm-soc tree
Message-Id: <20120104150658.aafd5ae8ebce944e897f1079@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Jan_2012_15_06_58_+1100_EE_gJhZvLnF10E3h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Jan_2012_15_06_58_+1100_EE_gJhZvLnF10E3h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/ethernet/freescale/fec.c between commit 0ebafefcaa7a ("net:
fec: add clk_prepare/clk_unprepare") from the arm-soc tree and commit
e163cc97f9ac ("net/fec: fix the .remove code") from the net-next tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/freescale/fec.c
index 112af9b,b0b0445..0000000
--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@@ -1638,13 -1657,18 +1657,18 @@@ fec_drv_remove(struct platform_device *
  	struct net_device *ndev =3D platform_get_drvdata(pdev);
  	struct fec_enet_private *fep =3D netdev_priv(ndev);
  	struct resource *r;
+ 	int i;
 =20
- 	fec_stop(ndev);
+ 	unregister_netdev(ndev);
  	fec_enet_mii_remove(fep);
+ 	for (i =3D 0; i < FEC_IRQ_NUM; i++) {
+ 		int irq =3D platform_get_irq(pdev, i);
+ 		if (irq > 0)
+ 			free_irq(irq, ndev);
+ 	}
 -	clk_disable(fep->clk);
 +	clk_disable_unprepare(fep->clk);
  	clk_put(fep->clk);
  	iounmap(fep->hwp);
- 	unregister_netdev(ndev);
  	free_netdev(ndev);
 =20
  	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);

--Signature=_Wed__4_Jan_2012_15_06_58_+1100_EE_gJhZvLnF10E3h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPA9BiAAoJEECxmPOUX5FEPDsP/14/DwT4uwfSLdGOt99ZWL1A
ETiUykRTREyEI5fdHXf1l8iigmGFErmv25+jFiyBHiZU6eu3okpX2VL8ysPSqRel
SQKS1vO1iuV+5boBGxHMekB12C+pDZj/1cPuAPa5CVtZVQyBR47sujqshm8f+wXG
u4HOlFuy+Ct/eqz75e50kBeHBITd8Sp63Av2Vr7/77U5iVAxSzY7q2kwoMtppB/p
cZcdS7oAvf9JmvtIJ5gRgFV5hX6cHoSU1BGqgbrItmn29PDnraESALsSckjBcaQQ
+V+L0jOpcMSImgCWU6ZguXFClI2WsRWg/k3z/iUeHfWoM4V2bIaBD3UlIJCs8Ch3
3djbAHE4sUd8mEO4gceOaY+N43Wda9xLXDhckuVaVnAZC7lC+jcx9n2Fjv+DkMuF
4Tz6dmxV+65UiHSgbas6GQ1nXdkKtSiN8oAOBisZlmb2Wkc8VJlk+Uo6wqXsNv0I
ewIMuKXoRTiNAbAWmUDcgeMahauHnv6YkOy3sNzAfY80fe027hIhcq3zdh+ExbxM
bjv96ARb31Hg4jvkxhvrM1BXcDLKSM4OGYtjjun8DWWtrcGu0t2B9mg39zZZJPAu
Rcad111rJ501o/DvkSm9/l//kdPKeb88gBijw+fjE/9IQ8GhYaYLsdb1x9fT4DKc
YIq3IwTcGYDBfNa85dzz
=oSr8
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Jan_2012_15_06_58_+1100_EE_gJhZvLnF10E3h--
