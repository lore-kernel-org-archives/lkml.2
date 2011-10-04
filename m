Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1JDHVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:21:20 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:34523 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1JDHVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:21:18 -0400
Date: Tue, 4 Oct 2011 18:21:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20111004182111.d180e11f61c23740e6d6988f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Oct_2011_18_21_11_+1100_gnH6N.JOEFizi9dA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_18_21_11_+1100_gnH6N.JOEFizi9dA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/iio/adc/ad7746.c:345:8: error: 'S_IWUSR' undeclared here (n=
ot in a function)
drivers/staging/iio/adc/ad7746.c:436:8: error: 'S_IRUGO' undeclared here (n=
ot in a function)
drivers/staging/iio/adc/ad7746.c:681:19: error: 'THIS_MODULE' undeclared he=
re (not in a function)
drivers/staging/iio/adc/ad7746.c:778:1: warning: data definition has no typ=
e or storage class [enabled by default]
drivers/staging/iio/adc/ad7746.c:778:1: warning: type defaults to 'int' in =
declaration of 'MODULE_DEVICE_TABLE' [-Wimplicit-int]
drivers/staging/iio/adc/ad7746.c:778:1: warning: parameter names (without t=
ypes) in function declaration [enabled by default]
drivers/staging/iio/adc/ad7746.c:799:15: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/iio/adc/ad7746.c:800:20: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/iio/adc/ad7746.c:801:16: error: expected declaration specif=
iers or '...' before string constant

Caused by commit 83e416f458d5 ("staging: iio: adc: Replace, rewrite
ad7745 from scratch") from the staging tree interacting with the module.h
split.

I added the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Oct 2011 18:18:28 +1100
Subject: [PATCH] staging: iio: adc: add includes of module.h and stat.h

fixes these build problems:

drivers/staging/iio/adc/ad7746.c:345:8: error: 'S_IWUSR' undeclared here (n=
ot in a function)
drivers/staging/iio/adc/ad7746.c:436:8: error: 'S_IRUGO' undeclared here (n=
ot in a function)
drivers/staging/iio/adc/ad7746.c:681:19: error: 'THIS_MODULE' undeclared he=
re (not in a function)
drivers/staging/iio/adc/ad7746.c:778:1: warning: data definition has no typ=
e or storage class [enabled by default]
drivers/staging/iio/adc/ad7746.c:778:1: warning: type defaults to 'int' in =
declaration of 'MODULE_DEVICE_TABLE' [-Wimplicit-int]
drivers/staging/iio/adc/ad7746.c:778:1: warning: parameter names (without t=
ypes) in function declaration [enabled by default]
drivers/staging/iio/adc/ad7746.c:799:15: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/iio/adc/ad7746.c:800:20: error: expected declaration specif=
iers or '...' before string constant
drivers/staging/iio/adc/ad7746.c:801:16: error: expected declaration specif=
iers or '...' before string constant

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/iio/adc/ad7746.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7746.c b/drivers/staging/iio/adc/ad7=
746.c
index 0b251ad..3fe0c17 100644
--- a/drivers/staging/iio/adc/ad7746.c
+++ b/drivers/staging/iio/adc/ad7746.c
@@ -13,6 +13,8 @@
 #include <linux/sysfs.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/stat.h>
=20
 #include "../iio.h"
 #include "../sysfs.h"
--=20
1.7.6.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Oct_2011_18_21_11_+1100_gnH6N.JOEFizi9dA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOirPnAAoJEECxmPOUX5FEjJgQAIVY9R1j6D+PdkHyOv5Hrvb+
p8Atg2hdj+fBCPdb8CLUAntnHzqBkvNLtiA6+vjqw5xYPlW0DEwChMAS/xrnqmf7
i8TP814bWuMoFvynJvImsab+Gk+YQ1GgfOWKeizyWu52yPEoY6WxS8dYX+oScZJ7
hi46QipE/7vcMW/y0av7j8XFi/mkn4J9snJcHMtMGdwiV14xGGq1m00zkzNb+I8o
e9o2KZVxRPiXyOE3VRpjJDkAakV12ko8rCbvw1AdSSVisKmAvy+68P8ubCgUSMAX
1TJby3BPHC6xT30bHRJ17wHhsLPHUXqIqFDzOyyCBGbMouHeVN1NBWqIoaFPJ9GW
Tl5olPLU/LqREFjexpAHbhEHYkwlJ4FUeVw6dBbeTN07aA6+S0owhSDPnhjghS5I
SbhQba/fu2ZAnADVRfHj6L6Q8tRvCRcertnKpudWAxTu/MiR1ZQ6QsdWqXbCqkez
RLZ1wlMVLnw6Wj0zijtOdwGJHNJJ6zS35ZKdIqlJ3KVm2AIszv2PuBd1YcJvxb/l
kbrIPn0Bg8AgGfJjNEt9FCkvl26kr0Ig2V3x7tcfoWIiZxwA/SKDJwVRjbd7PPHO
w4KYr75fWjZ9teSFklNLHr3/OGJ22tq+ebTCDMikHxXwUnSIhk4G2o7RhgKElXCv
oYNMYm1X2DtIXjJ9EK33
=+AvV
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_18_21_11_+1100_gnH6N.JOEFizi9dA--
