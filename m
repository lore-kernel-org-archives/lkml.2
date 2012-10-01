Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab2JAEY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 00:24:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58332 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2JAEX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 00:23:26 -0400
Date: Mon, 1 Oct 2012 13:58:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>
Subject: linux-next: manual merge of the mips tree with Linus' tree
Message-Id: <20121001135829.7da3ee1b81d2dae0c8c393e7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__1_Oct_2012_13_58_29_+1000_OoDkj51X.eALb33x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Oct_2012_13_58_29_+1000_OoDkj51X.eALb33x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

Today's linux-next merge of the mips tree got a conflict in
drivers/net/ethernet/octeon/octeon_mgmt.c between commit df555b665367
("netdev: octeon: fix return value check in octeon_mgmt_init_phy()") from
Linus' tree and commit eeae05aa2169 ("netdev: octeon_mgmt: Add support
for 1Gig ports") from the mips tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/octeon/octeon_mgmt.c
index a688a2d,5be431c..0000000
--- a/drivers/net/ethernet/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/octeon/octeon_mgmt.c
@@@ -722,10 -973,8 +973,8 @@@ static int octeon_mgmt_init_phy(struct=20
  				   octeon_mgmt_adjust_link, 0,
  				   PHY_INTERFACE_MODE_MII);
 =20
 -	if (p->phydev =3D=3D NULL)
 +	if (!p->phydev)
- 		return -1;
-=20
- 	phy_start_aneg(p->phydev);
+ 		return -ENODEV;
 =20
  	return 0;
  }

--Signature=_Mon__1_Oct_2012_13_58_29_+1000_OoDkj51X.eALb33x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQaRTlAAoJEECxmPOUX5FEbfEQAJVNrDtZ5be7nMP4s/13AYWl
3q+CW6OC4d5+M0okcnzXugG4RiHmiUxX/OscUHcsvlQ6+X1U3sewRt2gNqv7Xx3P
SLfKkfXRYLSZEuPb7xqfcGNFaJPdOUC2A7MFwLWW3ST4yRvnPyCqFcZvlGHf/k6J
2QpKEEE6mUmyUKuigl9/nTuvdWfXE9vZrOqq8tFLkPrzAQTmBj4AY3fFNaq5iDmn
nQ6h9QlJciBJA0Zums49UTjEswiN6sfTg64KsmAGvapVsIVWLTiAc8wJghRNhEyK
QEC+PHzzdrbrACTiDK7hXxgPVazxFDiouv+45MrxGbqV414gdGV3KpwRn6/ivQST
W8yANTipJdUPtCsvcAd5Ia9z38zX0UfRfOchpahIEhy0kBsrHpPalyUZV45Opw0I
54fzhRhQQPtmsMd7zzfCTN3VYrk6KWAhUm/iFZEajdqgxzjwmloxER43lFs/oDvk
Vw+YixOPNfEciB85XHII/MLTHpYkj/u45vfzi+5oeGFeqxIiXj+lCw2uGX1px0gv
PqMcVno46SFFuQkzyjrmx3XqhJGX75AfdrtHnDa7qLcZJQK/Zi8NGA+Zy+q8cavi
9hQE1Sq8QzGvkIDDD/7SSlluV1Tk8JgjN2ZobsT1Z3uXCWs04FaBqKeHgDtd/rIR
5sGTnMVyfMTsyckqOueL
=teAp
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Oct_2012_13_58_29_+1000_OoDkj51X.eALb33x--
