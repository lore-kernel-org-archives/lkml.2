Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab1LQEbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:31:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37609 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251Ab1LQEbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:31:12 -0500
Message-ID: <1324096266.2825.314.camel@deadeye>
Subject: [PATCH linux-firmware 4/4] keyspan_pda: Add makefile for building
 from source
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Dec 2011 04:31:06 +0000
In-Reply-To: <1324096119.2825.310.camel@deadeye>
References: <1324096119.2825.310.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UAk6/f9TM1haOHYUjX4S"
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UAk6/f9TM1haOHYUjX4S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The commands given in the source aren't quite right, and don't cover
use of ihex2fw.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE               |    2 ++
 keyspan_pda/Makefile |   12 ++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 keyspan_pda/Makefile

diff --git a/WHENCE b/WHENCE
index ef51ac1..3b9f5e2 100644
--- a/WHENCE
+++ b/WHENCE
@@ -173,6 +173,8 @@ Source: keyspan_pda/keyspan_pda.S
 File: keyspan_pda/xircom_pgs.fw
 Source: keyspan_pda/xircom_pgs.S
=20
+Source: keyspan_pda/Makefile
+
 Licence: GPLv2+
=20
 Compiled from original 8051 source into Intel HEX, used in our binary ihex=
 form.
diff --git a/keyspan_pda/Makefile b/keyspan_pda/Makefile
new file mode 100644
index 0000000..fc37ea4
--- /dev/null
+++ b/keyspan_pda/Makefile
@@ -0,0 +1,12 @@
+CC =3D gcc
+IHEX2FW =3D ihex2fw
+
+all: keyspan_pda.fw xircom_pgs.fw
+
+%.fw: %.S
+	$(CC) -x assembler-with-cpp -P -E -o $*.asm $<
+	as31 -l $*.asm
+	$(IHEX2FW) $*.hex $@
+
+clean:
+	rm -f *.asm *.fw *.hex *.lst *.obj
--=20
1.7.7.3



--=-UAk6/f9TM1haOHYUjX4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATuwbCue/yOyVhhEJAQpK5A/9FScptxERftq+DYn1FPvIlx+71et5KNMh
70/wv9qp6D7mcr2X8QEW3q1lLcntcsZsoeAVMTZ1piHHBFHC6bLl8K13mvFJSY6a
4f5he0ARo/K249b+NQqxPvdCFkXPoiPLmGsasiFOJAtLOTX7UY2YvnKvmPwdUSqk
Y3pmhOxtylJIwERHfoVVYJMeaXaQjm+sQF7Q3+xlTxr1Eoi2gt4AfMAffhqnHGNT
bO1eqhlWNlE+mNo9kCNIXoay/Sa98+5/OfoChtUaVFhi/aOkuFzvjGmPqy2gX9Bg
JT21K+Y0+NQvwngRP360gqWqVBrktpw2ysqUsA7GGsSNEWA0jPAN8eaF1TshYDwm
5shBTJWTRnsgb6rKjtDjFlaGAdknZBFsqBBH5W2pDjf/6rqXhGvypHh9couAAfPx
1Ek+9tyQZE+w453CGq0u8FNyGSEBkwYLyuM+ufUSE9RA1jYCIctGriUsnidDlggR
QFn034W96vPc8aPvQtYau0wM5o2e/zV2KimGUlXHFqI3xnoWk2U7XkuIcJnXgz1A
iR/Nkqhyr0wlonHYC6ZsPyrCwrJNwLNgtbP4+y61DhRHdk/RMTjc2RIssjOSCXW1
Evqsccd8JQoA0CXjsYNixrc/vLomlc17jm03GPL7cQEmikR1tPu+iz8yG5OXqLjK
viOY9rI5sok=
=j7xs
-----END PGP SIGNATURE-----

--=-UAk6/f9TM1haOHYUjX4S--
