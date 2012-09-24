Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2IXJji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:39:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50176 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2IXJjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:39:36 -0400
Date: Mon, 24 Sep 2012 19:39:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the l2-mtd tree
Message-Id: <20120924193934.76d4feafb689b265ff49c5c3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_39_34_+1000_6VP3KgoIH7FFPfCw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_39_34_+1000_6VP3KgoIH7FFPfCw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mtd/nand/orion_nand.c between commit 11a3910e730e ("mtd:
orion_nand: remove <mach/hardware.h> include") from the l2-mtd tree and
commit c02cecb92ed4 ("ARM: orion: move platform_data definitions") from
the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/nand/orion_nand.c
index 9ee436d,131b58a..0000000
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@@ -21,7 -21,8 +21,7 @@@
  #include <linux/err.h>
  #include <asm/io.h>
  #include <asm/sizes.h>
- #include <plat/orion_nand.h>
 -#include <mach/hardware.h>
+ #include <linux/platform_data/mtd-orion_nand.h>
 =20
  static void orion_nand_cmd_ctrl(struct mtd_info *mtd, int cmd, unsigned i=
nt ctrl)
  {

--Signature=_Mon__24_Sep_2012_19_39_34_+1000_6VP3KgoIH7FFPfCw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYCpWAAoJEECxmPOUX5FEODsP/03ZmAZkoFLeRHEQXnD1dmT4
8aPDHq5qPVdZpW5cWSRfysizaq6nI5lx/S7kGyJTTDQxGn0T2tn+nV2DWjeO7Xyk
sgEah+sZWdSsX6IHX/noJ1Jbzx98HXC7zFgYphgcJ5qEZGX1d4J+jQ6czxhLbwWh
FzkzRDBmHwD5ytAlNxVjLnxtTL3yE9rTydGHYMBLUFDyuOSfkgF8RgS+sbhNZVUX
ZxxrUlVAmPXh5Fwn2EVnEnH8yz9FChVtEJCRWbogOobEK1S3kDwlHonmxBcVgj8Y
rdH2mwWNNmTdENhUHq1yT6Ua9B/JGF91+3V+Lg3Iy7npgwatdvWY3Fcl9GFlkQv2
XsNXvTwywiBHrE9vua+RzGy4+H3ulkVCDZU50+j+GilCS5LWnWIXJsrxGv+76T6r
GCgGGWGyEWxemMdcoCcU7oQlKSafiGBT676i6ZexQzq8ObYNbvoDyHSx198MtRH2
88GQS47cuJlm3vGN6IDdad91wFoKpX98Lxw0JlNRj0Wsa1clqQ6EMLS6KIR0xlVX
xxurL294lbVVg1eKZPTQxN2pnSog4Mwbv9eA1eb7Tn9NmSWEzSoRKn+LY2JYqoBs
HrPwTpQ1kUWJrKhtOEbjYnNQuuMvlCntg4lgej4QGwvYSOAPOT9ldHQA9uy/UlRg
IpaUz9BZ952p8vekSIq9
=fd1w
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_39_34_+1000_6VP3KgoIH7FFPfCw--
