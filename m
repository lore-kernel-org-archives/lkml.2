Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1CZWxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 18:53:18 -0400
Received: from wnohang.net ([178.79.154.173]:58297 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab1CZWxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 18:53:17 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Mar 2011 18:53:16 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 4FA70249FB
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 1383F24905
Date: Sun, 27 Mar 2011 04:14:08 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Use the environment variable PYTHON if defined
Message-ID: <20110326224408.GA1336@Xye>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
X-Operating-System: Arch linux x86_64 2.6.38-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On systems with python{2,3} installed, perf build can break which can be fi=
xed by
exporting PYTHON to the right value. Added support for PYTHON in the Makefi=
le.
---
  tools/perf/Makefile |    8 ++++++--
  1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7141c42..d998221 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -149,6 +149,9 @@ endif
  #
  # Define NO_PERL if you do not want Perl scripts or libraries at all.
  #
+# Define PYTHON to point to python binary if it is not
+# /usr/bin/python, it will be used/called as $PYTHON-config.
+#
  # Define INTERNAL_QSORT to use Git's implementation of qsort(), which
  # is a simplified version of the merge sort used in glibc. This is
  # recommended if Git triggers O(n^2) behavior in your platform's qsort().
@@ -629,10 +632,11 @@ endif
  ifdef NO_LIBPYTHON
  	BASIC_CFLAGS +=3D -DNO_LIBPYTHON
  else
-       PYTHON_EMBED_LDOPTS =3D $(shell python-config --ldflags 2>/dev/null)
+       PYTHON ?=3D /usr/bin/python
+       PYTHON_EMBED_LDOPTS =3D $(shell $(PYTHON)-config --ldflags 2>/dev/n=
ull)
         PYTHON_EMBED_LDFLAGS =3D $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
         PYTHON_EMBED_LIBADD =3D $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
-	PYTHON_EMBED_CCOPTS =3D `python-config --cflags 2>/dev/null`
+	PYTHON_EMBED_CCOPTS =3D ` $(PYTHON)-config --cflags 2>/dev/null`
  	FLAGS_PYTHON_EMBED=3D$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
  	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
  		BASIC_CFLAGS +=3D -DNO_LIBPYTHON
--=20
1.7.4.1

--------------------------
Raghavendra Prabhu
GPG ID:D72BE977


--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNjmw4AAoJEKYW3KHXK+l3RhkH/jcAQjMWZNq92tnq9ZbERqjV
suxnVD0bYRuSLz0PIlG3DKBDSzGvjsKa0HeqWPYLwMgE6/h5J5GRKHDfU8AdUZpz
3/vaIpb/xnjGxyW0F28DT9KXafSFrcw35XrEOum+4qiqT+IobHgToxqpFB+m9P2+
GlB1UtLd1lrzZH6UA3fwOg+kve3d1AkqOmckq/RZPzijqnN1DQnFaiXz6A8RSbN6
TD+dKE1AJnNfT9bHSO3ruqimpqJ77cRjSTkrxAD0+LQQ7YNrH59dgXUWH1LpzGJ6
t86BT46/lFkO+W85m9yQnvPUyrfGtSQQUPHcVIclRBU/5hQ5Nb2oX89pkr9bU7M=
=HCOg
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
