Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0CTXG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 19:06:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60355 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab0CTXG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 19:06:58 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1269126097.18314.111.camel@localhost>
References: <1269126097.18314.111.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-U5d2svT9Jpx0ll/FdImU"
Date: Sat, 20 Mar 2010 23:06:50 +0000
Message-ID: <1269126410.18314.116.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 3/4] panic: Add taint flag TAINT_FIRMWARE_WORKAROUND ('I')
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U5d2svT9Jpx0ll/FdImU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This taint flag will initially be used when warning about invalid ACPI
DMAR tables.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/kernel.h |    1 +
 kernel/panic.c         |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index eaf7221..ab8072b 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -344,6 +344,7 @@ extern enum system_states {
 #define TAINT_OVERRIDDEN_ACPI_TABLE	8
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
+#define TAINT_FIRMWARE_WORKAROUND	11
=20
 extern void dump_stack(void) __cold;
=20
diff --git a/kernel/panic.c b/kernel/panic.c
index 8b821bc..e9fa224 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -178,6 +178,7 @@ static const struct tnt tnts[] =3D {
 	{ TAINT_OVERRIDDEN_ACPI_TABLE,	'A', ' ' },
 	{ TAINT_WARN,			'W', ' ' },
 	{ TAINT_CRAP,			'C', ' ' },
+	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
 };
=20
 /**
@@ -194,6 +195,7 @@ static const struct tnt tnts[] =3D {
  *  'A' - ACPI table overridden.
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
+ *  'I' - Firmware workaround was required.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
--=20
1.7.0




--=-U5d2svT9Jpx0ll/FdImU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6VVCee/yOyVhhEJAQKBfQ//XHHApIzk/Zxk5RqIQfg25xY/Q81yuYpy
I3Lcxi8q0+MsBtDw8pV0857MH/3MZFMVbY+ZF+boeh4VBq4NH/gIE1lzefPigsj+
SnXQZsiBeIojRDH1GzvTKeVJMUmDtxGSmhNpUxvwcfr6qyMxq2pv/JwZilS+0LiZ
w/EMLQfImjI+rq8GCD6wv0FH4qSHjrfU7nLB0HGSP8yurpw7SCNn9n27GexoMtG/
EFa9XxBl7pdOkuvTb42K10jEgwCpmJyNt/VQTWXS6w9cw7ECoL3X+QDoLa9VUdAL
ZXPB7E+U64fzmgAVRbFVHIyj91cdb7orfj+nglvkcqZBMfFsXXCIVF+AXc2YgWmq
AggQ2YTe3L73hKepl6r2+hnwHtF1oXnPp8sxYiS3YkmRthaX8JxwiDqjANJZT0At
X4EP86JzIlS8fEAlTSQW04OP7ZddiDr3TVQ8oJ1OmSHxY/RUZAbUbNnQ5xFobhcC
Zb9VUZyyAdzj8grkEquuEfr3GA59jicWR6cwYroXLI8lelGLaLU/sO3eBAFfbYrz
C8xvll8Oo3QY+ZBOJrVoV0VyKWAEhCj17DgT3vPxJOhFcQFNS4fqSt7KLdCpWLln
2O8K65cYRE36PoWGG3NrsCyBT7g1J5ic4HMLWkYBEwHEn90lKINfzsxxs9vWJIUD
X8Al0eS/aYo=
=vRux
-----END PGP SIGNATURE-----

--=-U5d2svT9Jpx0ll/FdImU--
