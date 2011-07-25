Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab1GYF7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 01:59:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34185 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab1GYF7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 01:59:11 -0400
Date: Mon, 25 Jul 2011 15:58:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: linux-next: build failure after merge of the final tree
 (device-mapper tree related)
Message-Id: <20110725155854.e2a82f7e6864ea117d9131ab@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Jul_2011_15_58_54_+1000_zaz8=7/m8ZIqrq/4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jul_2011_15_58_54_+1000_zaz8=7/m8ZIqrq/4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/md/persistent-data/dm-space-map-disk.c:14:0:
include/asm-generic/bitops/le.h:52:19: error: conflicting types for 'test_b=
it_le'
arch/powerpc/include/asm/bitops.h:284:23: note: previous definition of 'tes=
t_bit_le' was here
include/asm-generic/bitops/le.h:57:20: error: redefinition of '__set_bit_le'
arch/powerpc/include/asm/bitops.h:291:20: note: previous definition of '__s=
et_bit_le' was here
include/asm-generic/bitops/le.h:62:20: error: redefinition of '__clear_bit_=
le'
arch/powerpc/include/asm/bitops.h:296:20: note: previous definition of '__c=
lear_bit_le' was here
include/asm-generic/bitops/le.h:67:19: error: redefinition of 'test_and_set=
_bit_le'
arch/powerpc/include/asm/bitops.h:301:19: note: previous definition of 'tes=
t_and_set_bit_le' was here
include/asm-generic/bitops/le.h:72:19: error: redefinition of 'test_and_cle=
ar_bit_le'
arch/powerpc/include/asm/bitops.h:306:19: note: previous definition of 'tes=
t_and_clear_bit_le' was here
include/asm-generic/bitops/le.h:77:19: error: redefinition of '__test_and_s=
et_bit_le'
arch/powerpc/include/asm/bitops.h:311:19: note: previous definition of '__t=
est_and_set_bit_le' was here
include/asm-generic/bitops/le.h:82:19: error: redefinition of '__test_and_c=
lear_bit_le'
arch/powerpc/include/asm/bitops.h:316:19: note: previous definition of '__t=
est_and_clear_bit_le' was here
In file included from drivers/md/persistent-data/dm-space-map-metadata.c:13=
:0:
include/asm-generic/bitops/le.h:52:19: error: conflicting types for 'test_b=
it_le'
arch/powerpc/include/asm/bitops.h:284:23: note: previous definition of 'tes=
t_bit_le' was here
include/asm-generic/bitops/le.h:57:20: error: redefinition of '__set_bit_le'
arch/powerpc/include/asm/bitops.h:291:20: note: previous definition of '__s=
et_bit_le' was here
include/asm-generic/bitops/le.h:62:20: error: redefinition of '__clear_bit_=
le'
arch/powerpc/include/asm/bitops.h:296:20: note: previous definition of '__c=
lear_bit_le' was here
include/asm-generic/bitops/le.h:67:19: error: redefinition of 'test_and_set=
_bit_le'
arch/powerpc/include/asm/bitops.h:301:19: note: previous definition of 'tes=
t_and_set_bit_le' was here
include/asm-generic/bitops/le.h:72:19: error: redefinition of 'test_and_cle=
ar_bit_le'
arch/powerpc/include/asm/bitops.h:306:19: note: previous definition of 'tes=
t_and_clear_bit_le' was here
include/asm-generic/bitops/le.h:77:19: error: redefinition of '__test_and_s=
et_bit_le'
arch/powerpc/include/asm/bitops.h:311:19: note: previous definition of '__t=
est_and_set_bit_le' was here
include/asm-generic/bitops/le.h:82:19: error: redefinition of '__test_and_c=
lear_bit_le'
arch/powerpc/include/asm/bitops.h:316:19: note: previous definition of '__t=
est_and_clear_bit_le' was here

Casued by commit 3222df7eca25 ("The persistent-data library offers a
re-usable framework for the storage").

I am not quite sure how you should fix this (maybe just include
linux/bitops.h?) so I have left this build error for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Jul_2011_15_58_54_+1000_zaz8=7/m8ZIqrq/4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLQYeAAoJEDMEi1NhKgbsz8IH/3N/nBsEUHvE1npEKj7zwEIG
jgEwZ4gmyTyXumDg1H5M07Z6JjSM35FMyACDHWCqMtxtXkW5l9g2e6IggUrqq3nB
87tGHn97CK7LGhnTXIMC+SWp4aGIDTbuSYIzsVOz2wpAx6hKyS0WSiAxo6eYqtlW
b1hewtS4AdnU9yk3DCQtjFPpCWUDf9xAevvFi0W/qbKt9MYZOYjqpKL+HVtPw08w
DOlyiEb8/RhuEPGK6vLlMD28kpbBywtQI/bHNjRuIomjHmI+qWQaHFAuleekliIk
6UHBbiCOCsRD6DXFdeIuIoBkFWA3+zO6/lQUkTrLC2zVS9gBpVOV0gd9NEpN6tA=
=G4x6
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jul_2011_15_58_54_+1000_zaz8=7/m8ZIqrq/4--
