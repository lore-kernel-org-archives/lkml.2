Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2KZK4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:56:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53509 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2KZK4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:56:10 -0500
Date: Mon, 26 Nov 2012 21:56:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lokesh Vutla <lokeshvutla@ti.com>, Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20121126215600.236b2e44ffea1abbea26898b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_21_56_00_+1100_q=Ep.QAitCunStOl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_21_56_00_+1100_q=Ep.QAitCunStOl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/plat-omap/common.c between commit b022e17b1c7e ("OMAP: common.c:
remove init call to vram") from the omap_dss2 tree and commit
f583f0f2c720 ("ARM: OMAP2+: Move omap_reserve() locally to mach-omap2")
from the arm-soc tree.

I fixed it up (by deleting the file and adding the following patch) and
can carry the fix as necessary (no action is required).

=46rom 523f2987a07f97c946c63e0be4558b8332b46e8f Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 26 Nov 2012 21:51:20 +1100
Subject: [PATCH] OMAP: common.c: remove init call to vram fixup

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mach-omap2/common.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-omap2/common.c b/arch/arm/mach-omap2/common.c
index 5c2fd48..2dabb9e 100644
--- a/arch/arm/mach-omap2/common.c
+++ b/arch/arm/mach-omap2/common.c
@@ -16,8 +16,6 @@
 #include <linux/init.h>
 #include <linux/platform_data/dsp-omap.h>
=20
-#include <plat/vram.h>
-
 #include "common.h"
 #include "omap-secure.h"
=20
@@ -32,7 +30,6 @@ int __weak omap_secure_ram_reserve_memblock(void)
=20
 void __init omap_reserve(void)
 {
-	omap_vram_reserve_sdram_memblock();
 	omap_dsp_reserve_sdram_memblock();
 	omap_secure_ram_reserve_memblock();
 	omap_barrier_reserve_memblock();
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__26_Nov_2012_21_56_00_+1100_q=Ep.QAitCunStOl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs0rAAAoJEECxmPOUX5FES2kP/isGKXOcaDo1t8dPoff2IxPr
s80thxUjCa9DzOREDx89CIb2Nw1h6ed4HsMx6KYbIx0700Qs0K5S/8zzqeQKfKr4
SGBDh1r0OWiBvfZdsRmrELKBwAFMUOSr5O8R0rTGKbR+4ZqFWR5+VOXiZ6NPMlmQ
5jg1iVnc/Noj3Bart3Kz1SGTD3s51Zgjeo1556mpiDMvxX2tayWRy2+qD3HYwaAT
YlMZx+6z6jTP74YVYDgaOg1PldpC1MfMQX4IdlSy5O7huDukTrHIricmQpyja7lL
ixFRylqOgX6G0shfFJ3F5SquLThSfEtaiWCbR2JlFiVvTOlvAEkprx5R8wMxViBs
+F8W5wQcAdd0j1yKR2UinCIVtVb5KyQc3owTax5clCFhwF4i748ENL0vi7TFOVWK
AW+AoNlasUqLeOy8uiQ3oSGtciNVYOsfws8ZxN21bqQ2aI5u0FhB/8Dn7oZr6qzf
ukT2320XBqEMs10fqW7hV8iGXZ6Jd/niw3d8axN/FwOsnf4TJ/spx6HHpLFkAi45
fTP4vrug8ZcmdnZlyUZ+wi2r2En6sHb/xtOGZIC3iflenqno9R1P1Q93NB/slQG2
YEeMWaLb0QHMZK9qWPNuKvqgfmad0GqBIC8XUm2Zhr+iqB7kkfMHMhhP1gCQBdMA
ijiowMntDR1dZ+s/CyJd
=yIQ2
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_21_56_00_+1100_q=Ep.QAitCunStOl--
