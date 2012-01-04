Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2ADARB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:17:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34123 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036Ab2ADAQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:16:59 -0500
Message-ID: <1325636211.13595.270.camel@deadeye>
Subject: [PATCH linux-firmware] cis: Add makefile for building CIS files
 from text format
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 04 Jan 2012 00:16:51 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mH84HfJisAT+lcZoHKs3"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mH84HfJisAT+lcZoHKs3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Most of the CIS files come from the pcmcia-cs project and are built
from a text format using the pack_cis tool.

In pcmcia-cs 3.2.8, apparently the last release, pack_cis had some
bugs that are fatal when it is built with a current gcc and glibc.
Therefore I refer to my own repackaged version that runs successfully
and generates exactly the same binaries included here.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
I'll push this change out in a moment.

Ben.

 cis/Makefile |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 cis/Makefile

diff --git a/cis/Makefile b/cis/Makefile
new file mode 100644
index 0000000..0a222f1
--- /dev/null
+++ b/cis/Makefile
@@ -0,0 +1,14 @@
+# The pack_cis tool from cis-tools
+# <http://git.kernel.org/?p=3Dutils/cis-tools/cis-tools.git>.
+PACK_CIS =3D pack_cis
+
+CIS_SRC :=3D $(wildcard src/*.cis)
+CIS_BIN :=3D $(notdir $(CIS_SRC))
+
+all: $(CIS_BIN)
+
+%.cis: src/%.cis
+	$(PACK_CIS) -o $@ $<
+
+clean:
+	rm -f $(CIS_BIN)
--=20
1.7.7.3



--=-mH84HfJisAT+lcZoHKs3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATwOac+e/yOyVhhEJAQqYBhAAjcvjhcKWtC1jVO1SiH2POW9VcQLlF5N9
W5WedC6z3HG4oOkEndt9d9dlcnYqY9GCu9Rqrn1EwElv9QWv50ETbuyJSRpDhSTZ
/dgD0Mc77lqnmp03W/YY8kDw8aAmacJ+NRJnR8i5rnrxfr+LBEJlZfn4H8DMzVC3
pFSzsld+sqCXOOvFYruFG2R077+ItqKZ7B00HW3/TcFwamYIj70NldWrKnxklKEm
Il9XkpdQqlqO5j4gT2ioAk3CLRtoSDop8nXBFP2JlQFmp12eNBbfC7rJmXJgdoDL
wjG/K4iW/YU7PaODfdagvGaujivcJvWW27ti2uHp3ANqGTo192pXGERMNJtX+xAv
9pwu7/q8kRLmqvDlaLRqL8wKWXEH2ObcIVOvu+6C6TqjUP9QKveLnca4NdBms7Jg
8cypFii/NKbqFByhXf6BZNdC58cAYOmTTVFSkwzoUhwyFXCOrouyxiUGyOKPsZsB
F5UcRvqwj1mdoyD6wZn2PCbFb8Ds4JlKyEOhETzEOdnO2CRbTSUTralbeycV2OE/
F/cXKGB7vtWqy1HLHyEL4QoBv8uhUmhDwW+f6JeQipC+Ch8HPvAY5l4xbIstP+s2
V/ecpaq0t3A2e4TiF3TyBJKFVfSDFd0TFHEgOOvuJFZDWPMjqaoR1drtqprj6qHh
gA9Wt5mUTYs=
=ehGI
-----END PGP SIGNATURE-----

--=-mH84HfJisAT+lcZoHKs3--
