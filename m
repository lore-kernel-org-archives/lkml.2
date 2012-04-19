Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab2DSFAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 01:00:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54601 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab2DSFAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 01:00:00 -0400
Date: Thu, 19 Apr 2012 14:59:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: linux-next: manual merge of the tty tree with the tty.current tree
Message-Id: <20120419145951.4e1652ae5b1b80686892495d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Apr_2012_14_59_51_+1000_RZf47=l6OrTEEbuN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Apr_2012_14_59_51_+1000_RZf47=l6OrTEEbuN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/pch_uart.c between commit af6d17cdc8c8 ("pch_uart: Fix
dma channel unallocated issue") from the tty.current tree and commit
44db113212d8 ("pch_uart: Delete unused structure member") from the tty
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/pch_uart.c
index c2816f4,a5e6343..0000000
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@@ -1447,11 -1455,8 +1455,10 @@@ static int pch_uart_verify_port(struct=20
  			__func__);
  		return -EOPNOTSUPP;
  #endif
- 		priv->use_dma_flag =3D 1;
 -		priv->use_dma =3D 1;
  		dev_info(priv->port.dev, "PCH UART : Use DMA Mode\n");
 +		if (!priv->use_dma)
 +			pch_request_dma(port);
 +		priv->use_dma =3D 1;
  	}
 =20
  	return 0;

--Signature=_Thu__19_Apr_2012_14_59_51_+1000_RZf47=l6OrTEEbuN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPj5vHAAoJEECxmPOUX5FEfusP+QHz/ozpQCXsjG1vSiavwMsq
5NTb3hTdLMZV6kEpxri3cW36XZz0SHLfCMorcO+j4AOWF6+8bNn22aHXLq7WBcWT
QCp/DtCpmr5loTWSjnlEHWATTZ5MtEIRyeVYXdk3bdzlamrnPjq/N+RBxmSH2h2v
ASJ6UXCO1oCikXBPV0zcHWZUrN63kLG+E4c9fBY/Ed9LzDxPiom40V8uGpRIilDE
cNw7uv3TB262dmj2Wn7oLwzHJL+e+L3HMhKfIVzPtOH3M4qLu57atn2mCIq7Bnhh
DoJCzm8vp3kyVrY3zGfPEAP9EYiPrsLAKZWcYzRAntTTL8nwdtNl9zrbPpCM0VRC
+NZ0nam272BDYlGAc8Lo13QGm8sl/zy3DbJ+e7e+R++QffY73zlQCZ5RGkp7hKS0
GKoMrHs1kh5DutD2bXKR3pn+IHlr2/f1dUwP66iN33xUWJ7bIcNAeT1p/I8U6tzV
J+HxIMhAugrKwbRRBW+QUSV/y94VNEp//VAgozsr8QXZ3GKupC7qBfMUi8TryTG7
KktOUCIa7DIDnny0Hf/q20abb7jhdtaydadOmGdF6A4B69uz6r6FDreRvjmPRZB2
nU27R+pxac4pxBWcZsd/L20go8Bw5wqlPiZEjAitEqrigrfDTNyHnSObAuf0DAck
VXSz2TewN3mmXdeU1F6X
=Xn9p
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Apr_2012_14_59_51_+1000_RZf47=l6OrTEEbuN--
