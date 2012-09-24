Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2IXO3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:29:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51495 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2IXO33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:29:29 -0400
Date: Tue, 25 Sep 2012 00:29:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20120925002920.318f3eb84f8727ab97b57c91@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_00_29_20_+1000_iQGE.1BTumZGcapw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_00_29_20_+1000_iQGE.1BTumZGcapw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/dgrp/dgrp_specproc.c: In function 'config_proc_write':
drivers/staging/dgrp/dgrp_specproc.c:465:2: error: implicit declaration of =
function 'vzalloc' [-Werror=3Dimplicit-function-declaration]
drivers/staging/dgrp/dgrp_specproc.c:465:13: warning: assignment makes poin=
ter from integer without a cast [enabled by default]
drivers/staging/dgrp/dgrp_specproc.c:491:2: error: implicit declaration of =
function 'vfree' [-Werror=3Dimplicit-function-declaration]

Caused by commit 0b52b7497271 ("staging: Add dgrp driver for Digi
Realport devices").

I have added this fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 25 Sep 2012 00:27:11 +1000
Subject: [PATCH] staging: dgrp: using vmalloc needs to include vmalloc.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/dgrp/dgrp_specproc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/dgrp/dgrp_specproc.c b/drivers/staging/dgrp/dg=
rp_specproc.c
index 259d23a..28f5c9a 100644
--- a/drivers/staging/dgrp/dgrp_specproc.c
+++ b/drivers/staging/dgrp/dgrp_specproc.c
@@ -39,6 +39,7 @@
 #include <linux/proc_fs.h>
 #include <linux/ctype.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
=20
 #include "dgrp_common.h"
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_00_29_20_+1000_iQGE.1BTumZGcapw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYG5AAAoJEECxmPOUX5FEq4MP/iwOWTZ7OQUD3rjmpdJHZhr5
bBruLuOtvtnLp1nFxp3TIZxL7c64tt0u2BcaLyO0cTwFGxckFSI6vDmclWpIrBjN
3ghxYHkIS5ckp1LHUcswDUFu3djQU8dmY8UnhJulKeIVo31FujC0o60n99+Tbrol
1FaKiYpEAeeFctCMYR+cfahDiO1L8tgf7i1r//mM1skrAX9gYlha3RwnPl/W8UoF
w35qVi29Lp8/5DgY8/Xfm7Ln9XtetU1AN2QVCiJCLbLKJ7+SGq2xt24w1AEiZhyN
E59Vsd6qRG0cqlRRMgLqweE/jPjXB2kXBLOQSCk41bL2iXM61ajDymntU6yr8RYr
eKb8sQedXzRy4hGBBhn1RT4+l0KcZlWNdlOamZ6ZMh3dlza3CmSxLzFI6SI0mDvU
mXLhLl6xdT2AokPYfOz70iRNTSuLtgnp8n6DzgPATKum0Pow5lJNB1Q1kM4FdUgP
CX7RJ7JYOti1bWTCd9DNAbR67aQa/6j3zZn5dA5rPJ6dPkaMIO1nflHjIoIekXp1
+T0Fljw1TwHP6GRqlh81WVbCZPC/a3boupE2dUx5gRWhV7JCpl6KjSkdjfaR0WMS
veBTaiylGxqOh46YG7FAWTRxitPH/ku7rSwA7udbxdsb75V36KYSJNCJGAG/F3Jo
OOD+coG2YDzrxrBDoGsA
=A43N
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_00_29_20_+1000_iQGE.1BTumZGcapw--
