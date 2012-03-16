Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2CPEWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 00:22:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47170 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2CPEWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 00:22:33 -0400
Date: Fri, 16 Mar 2012 15:16:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>, gregkh@linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] tty/hvc_vio: FW_FEATURE_ISERIES is no longer selectable
Message-Id: <20120316151654.7b2fedd2ecd2132a807630c6@canb.auug.org.au>
In-Reply-To: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
References: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_15_16_54_+1100_4.o4HPt+zKRTr90X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_15_16_54_+1100_4.o4HPt+zKRTr90X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

so remove the code that tests for it.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/tty/hvc/hvc_vio.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

Greg, it is probably easiest for this to go through the powerpc tree.

diff --git a/drivers/tty/hvc/hvc_vio.c b/drivers/tty/hvc/hvc_vio.c
index fc3c3ad..3a0d53d 100644
--- a/drivers/tty/hvc/hvc_vio.c
+++ b/drivers/tty/hvc/hvc_vio.c
@@ -46,7 +46,6 @@
 #include <asm/hvconsole.h>
 #include <asm/vio.h>
 #include <asm/prom.h>
-#include <asm/firmware.h>
 #include <asm/hvsi.h>
 #include <asm/udbg.h>
=20
@@ -322,9 +321,6 @@ static int __init hvc_vio_init(void)
 {
 	int rc;
=20
-	if (firmware_has_feature(FW_FEATURE_ISERIES))
-		return -EIO;
-
 	/* Register as a vio device to receive callbacks */
 	rc =3D vio_register_driver(&hvc_vio_driver);
=20
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Mar_2012_15_16_54_+1100_4.o4HPt+zKRTr90X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYr62AAoJEECxmPOUX5FEp0AP/Arf+mwzgjGeEt/u+lKJzLQl
QwrlGascKTmgcQbA1HbU2WSU7yFO5acgPXoKqX0tVNhnaWku4YIyEGwXpMg/fPL5
S0h2tWEXYqTV1X4+st3xQ/uJDRhI7B4UpjDLJBnF3lN6A5TlyYpRjCoXczp9mEQa
8M3+gQOBifaKqZjpeN3HISA+mIBXs8eUBvTy2/NPT1XHzxdpI4cBlzCrGlkkkjBa
25U5ZtUuTA0Gmloe3tFr21hyNctqYDQD5pMdSQVUu/z21usN0cl2iyku3e5P/Mba
hLovNL8qyG1Gb6EpKC6QqeyEccjlzphgE9D2YO8DdH9E7Gm62G6mccmMLITrGEja
gjvoE8AxEfXPkU21GdNB94y8oPF+KI775JaUvVivJ7C8UlLAaG4NYGmqIjmAIaao
CZGfi+FOysI4o5/alcg/IkSQRlPNhaxSHF0UTdly2lu6bqs8uq7DZigdnQR4qEbG
SLt1synzgXWtWyJUpo/dKeKQq6HOgJI0LKxAP0bedSsbHSv4yrl17O46Ut/cZPFm
MBkBP2r/dp7ldq4lLhlYUyOg8nqgn3JZ4yd1sTo73XLT4/HUQvJGbsljkBNFQbPl
EAgtKuIax3EHEhz5vdilSbgmymZo/KnaOqzELtDav37bFatk8ZpBlGcLBNw7KwMB
bYlCF/S0Nf0moPc58fqW
=daWI
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_15_16_54_+1100_4.o4HPt+zKRTr90X--
