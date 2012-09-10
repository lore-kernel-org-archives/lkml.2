Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2IJHEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:04:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39596 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2IJHES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:04:18 -0400
Date: Mon, 10 Sep 2012 17:04:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Cotey <puff65537@bansheeslibrary.com>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20120910170409.59b71819008bc527130d3987@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Sep_2012_17_04_09_+1000_iL=TXtVvVyyqcbAN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Sep_2012_17_04_09_+1000_iL=TXtVvVyyqcbAN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/silicom/bypasslib/built-in.o: In function `.is_bypass':
(.text+0x3254): multiple definition of `.is_bypass'
drivers/staging/silicom/bpctl_mod.o:(.text+0x1d938): first defined here
drivers/staging/silicom/bypasslib/built-in.o: In function `is_bypass':
(.opd+0x480): multiple definition of `is_bypass'
drivers/staging/silicom/bpctl_mod.o:(.opd+0x15f0): first defined here

Caused by commit 7040e556c90a ("staging: add Silicom Bypass driver").

I added this patch to disable the driver:

=46rom 884437b30775214e9f34696adb2be2f24f1e6df7 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 10 Sep 2012 17:01:05 +1000
Subject: [PATCH] staging: disable Silicom Bypass driver

due to build breakage:

rivers/staging/silicom/bypasslib/built-in.o: In function `.is_bypass':
(.text+0x3254): multiple definition of `.is_bypass'
drivers/staging/silicom/bpctl_mod.o:(.text+0x1d938): first defined here
drivers/staging/silicom/bypasslib/built-in.o: In function `is_bypass':
(.opd+0x480): multiple definition of `is_bypass'
drivers/staging/silicom/bpctl_mod.o:(.opd+0x15f0): first defined here

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/silicom/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/silicom/Kconfig b/drivers/staging/silicom/Kcon=
fig
index 3493ee8..1914844 100644
--- a/drivers/staging/silicom/Kconfig
+++ b/drivers/staging/silicom/Kconfig
@@ -6,6 +6,7 @@ config NET_VENDOR_SILICOM
 	bool "Silicom devices"
 	default y
 	depends on (SSB_POSSIBLE && HAS_DMA) || PCI=20
+	depends on BROKEN
 	---help---
 	  If you have a network card (Ethernet) belonging to this class,
 	  say Y.
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Sep_2012_17_04_09_+1000_iL=TXtVvVyyqcbAN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQTZDpAAoJEECxmPOUX5FEnmMP/3kIXo88tEjIkCovBwT4mzvp
Hd4zLA7JLZXyRwkw+8ibzl+OT0Gm16AreWsmo9vdly7wt7sPWUG6SbvwYmr7bJL3
F8AQtYgZLplmYjd3LscRh9jIASa+qBqqWI6PKx/fKMFhJvo6cuX2XyhdlbAq4Zjl
T0cA6vx2A0QoqObJkZu18n6RAiknjAg6DEurcd/inhTiVZXVZEkuUZmA4MXoROzi
nac8ao6H3h0ApE1sxe5M9Sii2/42Tu6faM9i4kofMib6+yyQMLeK8kMzOhWLG/Ry
OkFBoQNwNgCBiEy/zrN0xHlsu3Eu/EBFktQZKxsHkNOtPl6d1/x3aQ/e2AVTpI1V
/ZcdhuryX3rapHuPVXGXVDRF4cbtnpu3kxzi1HiNrpHpTkKMc9HB9eytSx3f/BqO
PabmCWNwMJWajNvgnEoubpZnwuEm5yJGqiHiJuYR2fBCOdqkrfJEc2Z3+XzNZ8VL
zrpwTWc4YWklprPHm80noLbjgLLVfNv++Tvt5v83K3/MIyYkYGl1SGaXk+AyhCAq
le6VtiXtF/Lji+7Wh9eJ0ufIxEA8MGLc6U+ESRT49ZRThhIz92n2+CxWjcI7ZnQI
fJktAoFFjrj15KE2pBn8bmusCoFG2PQqnU9XW+oejLnYFDoFHapPAxQCtkrWxTKs
YXO/Nb6BfP57yq4lpsPb
=jNtO
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Sep_2012_17_04_09_+1000_iL=TXtVvVyyqcbAN--
