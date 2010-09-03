Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0ICBsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:48:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49602 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab0ICBr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:47:59 -0400
Date: Fri, 3 Sep 2010 11:47:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: build failure after merge of the final tree (net tree
 related)
Message-Id: <20100903114750.3d8994b7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Sep_2010_11_47_50_+1000_0n8nWaz3mj88hjRQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Sep_2010_11_47_50_+1000_0n8nWaz3mj88hjRQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, next-20100830 and later builds (s390
allmodconfig) failed like this:

drivers/net/stmmac/stmmac_main.c: In function 'stmmac_adjust_link':
drivers/net/stmmac/stmmac_main.c:217: error: implicit declaration of functi=
on 'readl'
drivers/net/stmmac/stmmac_main.c:270: error: implicit declaration of functi=
on 'writel'
drivers/net/stmmac/stmmac_main.c: In function 'stmmac_dvr_probe':
drivers/net/stmmac/stmmac_main.c:1676: error: implicit declaration of funct=
ion 'ioremap'
drivers/net/stmmac/stmmac_main.c:1676: warning: assignment makes pointer fr=
om integer without a cast
drivers/net/stmmac/stmmac_main.c:1744: warning: cast from pointer to intege=
r of different size
drivers/net/stmmac/stmmac_main.c:1760: error: implicit declaration of funct=
ion 'iounmap'

Exposed by commit ac75791aa943c7953521cb4fa7728bf51f9abd2d ("stmmac:
remove dead option in the driver's Kconfig")  That allowed the driver to
be built on a lot more platforms that previously.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Sep_2010_11_47_50_+1000_0n8nWaz3mj88hjRQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMgFPGAAoJEDMEi1NhKgbsQHMH/jk/JpQC41NE2lWG3UH1fq4r
LF2l9zEKijpYNPK5vvNsyNgmkD6QHhq8R+2ukmqKzf3xA5OghdBgcmLvd1+SlB4f
mb8bjmfXNTLV5n8I1o5vKirRdbvRUFdidEZa0KyrMj9ggWj4fuLaC1kRzBsi2pwq
6dsoXOV4JMqrtC4nDJP9CvkXkkyYCAPne3E73t+0EmQs1pqVT6K+VsXnmoBJpKny
N1oZJSALVKhK5NbFTPzoF1q8H3pa1sRs43jPI5B//Oz9Xdc5XCUKBLPA+f1Jy5jm
Vtwmj5Bxj5VkMlZJHHWcLNrv5zos1JuILEDoieMqt7NChq5buSL9WyhVBYTO+bo=
=Mqn7
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Sep_2010_11_47_50_+1000_0n8nWaz3mj88hjRQ--
