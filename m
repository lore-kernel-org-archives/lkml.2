Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2HPFQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:16:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36364 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2HPFQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:16:17 -0400
Date: Thu, 16 Aug 2012 15:16:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: build failure after merge of the final tree (regulator
 tree related)
Message-Id: <20120816151605.b0a9932005b541956288ce96@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Aug_2012_15_16_05_+1000_Hll.proEM1UdR2//"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Aug_2012_15_16_05_+1000_Hll.proEM1UdR2//
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/regulator/twl-regulator.c: In function 'twlreg_probe':
drivers/regulator/twl-regulator.c:1229:3: error: implicit declaration of fu=
nction 'kfree' [-Werror=3Dimplicit-function-declaration]

Caused by commit 537fbe92d723 ("regulator: twl: make twl_info tables
const") from the regulator tree.

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 16 Aug 2012 15:11:22 +1000
Subject: [PATCH] regulator: using kfree() requires including slab.h

Fixes this build error:

drivers/regulator/twl-regulator.c: In function 'twlreg_probe':
drivers/regulator/twl-regulator.c:1229:3: error: implicit declaration of fu=
nction 'kfree' [-Werror=3Dimplicit-function-declaration]

Also added string.h for kmemdup().

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/regulator/twl-regulator.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regu=
lator.c
index a836522..564acae 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -10,6 +10,8 @@
  */
=20
 #include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Aug_2012_15_16_05_+1000_Hll.proEM1UdR2//
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLIIVAAoJEECxmPOUX5FEkDUP/0Hqut54Leul3xtmVqEeY43j
ITwVeT7Tqix9zYkMHykLSijnO/s7wksGe2qiO4nkpgop7p8dzaZmoJAN5RPCKu2d
8wM5XLAmEFbNjz0e4U1n2YGzAa1q8nGreZagg5fldrQ8gD19Y/qr4YSk7I1eJEPV
5AYmt2C1syuCEzPBfGv4M4H7VEy0CUVY2buvDg5KOMxGcvkQgDkkVQSZ/fOcRonS
UsvKXw64wfSrgG6QS8TGOVgqtrqHuum4fHdiuKLa3fYpgrEoKvEwzdII0yy6UBN1
FsGnB3rZ1CGH8oFTL13DVU3cAJZUjuZ+W0HrtTG87Avue+cZoF5p6y/OT/HXnCCg
4F2x5dep5v5bSUXlQuYghHDKhmXleE5mhrewyvEciqJJoo5Tm3mkJKypIRrsa/oq
ADAjT8FQ0eiYpQPB8oAwkQHQ4jZujxmg0AJ5iq/aanVStoiiEn7dl8/vZihmr+ni
iEPQ1PMpbekgvjJ4jznfQ2JOJCtlMxwEkk0Qlmc4bSWMgfaXQ6znvx+nRFxIc/Dx
D4v7H65gKDFIcV/1HezDN0zQ1FIbdMK0LCarRPemsiBg4lawQVNZAZC7vdH7mIs3
AIaZqdgnaaPuvvXnlGRU9qUO6WlrIe4bJyFlLGAiyn1ElSPBfs50TGfnMjZr7i1Z
nJXF6HD+TzxpwEr/bves
=bxas
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Aug_2012_15_16_05_+1000_Hll.proEM1UdR2//--
