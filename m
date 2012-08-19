Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2HSXrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 19:47:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46569 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616Ab2HSXrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 19:47:33 -0400
Message-ID: <1345420039.22400.80.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] perf: Fix include order for bison/flex-generated C files
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>
Date: Mon, 20 Aug 2012 00:47:19 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cbWNbsUU2CwhSzwN9bWy"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cbWNbsUU2CwhSzwN9bWy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

When we use a separate output directory, we add util/ to the include
path for the generated C files.  However, this is currently added to
the end of the path, behind /usr/include/slang and
/usr/include/gtk-2.0 if use of the respective libraries is enabled.
Thus the '#include "../perf.h"' in util/parse-events.l can actually
include /usr/include/perf.h if it exists.

Move '-Iutil/' ahead of all the other preprocessor options.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0eee64c..434175c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -756,10 +756,10 @@ $(OUTPUT)perf.o perf.spec \
 # over the general rule for .o
=20
 $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -w $<
+	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(ALL_CFLAGS) -w $<
=20
 $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=3D0 -DYYLTYPE_IS_T=
RIVIAL=3D0 -Iutil/ -w $<
+	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(ALL_CFLAGS) -DYYENABLE_NLS=3D0 -DYYLT=
YPE_IS_TRIVIAL=3D0 -w $<
=20
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<


--=-cbWNbsUU2CwhSzwN9bWy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDF7B+e/yOyVhhEJAQq6bA//fxC7Oynh0gjhQyPTJO/HQ9e0nrDdtRix
Bm/4YUv1aJpL0x+rWI++QW4WA9YCzVcrQwNIZUZ9Ie25j64XLu0t/MhCt7YG4ljn
hCXGZKUr8sIa+FHtRLuzN4QB7iyiSoWNRnYXp6pxFvCxL1MPADynNSDpDP1y/91v
gwxr+/GKa/6S9K27DToH0u81va1iU/7gRPQTf3BHlT01auvNyWqhsmXZE4yssHcC
f7nH83MtB64N6QHLSoFKnNnufmNC1Y5PMOG+kdmeWq8PiTzSnVHWnyTvpaO+ahtc
4WGzLoRk2/uoQqKOhQfVcLeu324r9GZ0+RDi5O8B1bbvF8zKZm+9I7ATKSb4fBtF
7t2bviZaHoPYkeb+difb+a3RoBmXwZXTgcuOZUOT030kIRK4uneQubEaJnqP6RcW
vP0iUavgkwMPsKX2dko+de2Ubw6k0PQnXH69xNrMZQgq+UAosyamPHvmNBHL1t0U
Y8F2Vvvn6mYmZieXsHqYdJe8L6XsqmwC340fWcdpau59S4hZpbVJPz/WhrWMjtw0
fzx2z7aWT7zfFxaDyQRJp1bsggPkyfP9r3HIulCobA2gOWm8n44HI+pP/oOGdi6h
leFuSPfWJI+yR2CtO2MX5AIU/zBzriVZCJlT37nfe/OIKxrVzhgJ6Qg65Znvz/1c
jodVOc89fXg=
=YTse
-----END PGP SIGNATURE-----

--=-cbWNbsUU2CwhSzwN9bWy--
