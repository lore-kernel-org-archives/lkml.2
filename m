Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1LTXJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:09:00 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34001 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1LTXI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:08:58 -0500
Date: Wed, 21 Dec 2011 10:08:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Magnus Damm <damm@opensource.se>,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20111221100848.19ff7107b4a8a63818d3c767@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Dec_2011_10_08_48_+1100_DGTtwkQ/ltuaXdo6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Dec_2011_10_08_48_+1100_DGTtwkQ/ltuaXdo6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/mach-shmobile/board-kota2.c between commit 1b6cec8a6910 ("ARM:
mach-shmobile: Kota2 PINT fix") from Linus' tree and commit a83d8e27d2f6
("ARM: shmobile: convert smp platforms to gic_handle_irq()") from the arm
tree.

Just context changes.  I fixed it up (see below) and can carry the change
as necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/board-kota2.c
index f44150b,1b4439d..0000000
--- a/arch/arm/mach-shmobile/board-kota2.c
+++ b/arch/arm/mach-shmobile/board-kota2.c
@@@ -549,9 -447,8 +549,9 @@@ struct sys_timer kota2_timer =3D=20
 =20
  MACHINE_START(KOTA2, "kota2")
  	.map_io		=3D kota2_map_io,
 -	.init_irq	=3D kota2_init_irq,
 +	.nr_irqs	=3D NR_IRQS_LEGACY,
 +	.init_irq	=3D sh73a0_init_irq,
- 	.handle_irq	=3D shmobile_handle_irq_gic,
+ 	.handle_irq	=3D gic_handle_irq,
  	.init_machine	=3D kota2_init,
  	.timer		=3D &kota2_timer,
  MACHINE_END

--Signature=_Wed__21_Dec_2011_10_08_48_+1100_DGTtwkQ/ltuaXdo6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8RWAAAoJEECxmPOUX5FEgzUP/REmLoTM9omPRf5I5fuksFjr
d7Leb37cFsl4KSHH4NBfEuQEzBcURUb0ZFXIefQfMcAJyE9R1ox8Bdsfc05CVH7V
jzrm0uKd0ZkO3gybyFxQjqJPSefE343KmJzn+PwvvFdG5TN/9SjiJYbLSSA3WhJU
R3rfmN+DHr7iqdp/D5f5teWgR+eaNJMXnWRSCs0pT88vRLQnNgeV6Aqo4JxBy090
zkePLLmNBRRsO/O/mJ7t3cINjPTfsfXfF6jOjT0lcV/kOU4ROlxHhbK+m7/zwy0B
LTRVaMwdeHfhA9eGWpz206czAgv8J0G+k/7d5hC8d1H6HjSJERP2bCQsgZETgTOt
1aGLjGmtF2aDeFlzwpg3mL4Af3oCESUbQodDAg32D0v0mwjRr/Xt7irlkBZWFogP
VMxaOtDv5+H9jOWTMuLG5xW+SpegNB7IT+BDHcFT0mw+Dw+DsLKLGvUZzPw5mTac
e4ZfTaxICLEuoupnKBXzYkEz4PDwoGjZs93sfkIy8dr8hSdn9x6n68QmydnWEq3q
bvX9ysg4Ftf3cGcS4g++SYIvr53JpldhaX0xTVyj8I/fU9F33UVi7RM4iSAB/WNu
gumloGX05+XuRiWJn76mmxk0M58LFx8kUFnepD2MYsZ1utAPpaIS8bGk/4Sf3eSQ
wPtPLB9RQKlj/zi7oKBR
=SIGj
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Dec_2011_10_08_48_+1100_DGTtwkQ/ltuaXdo6--
