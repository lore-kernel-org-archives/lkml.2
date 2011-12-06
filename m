Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1LFXxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 18:53:21 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46672 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab1LFXxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 18:53:16 -0500
Date: Wed, 7 Dec 2011 10:53:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Dong Aisheng <b29396@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111207105314.3afd16489c0304e2eae7a71d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Dec_2011_10_53_14_+1100_Oswxth_UJUjRU3.6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Dec_2011_10_53_14_+1100_Oswxth_UJUjRU3.6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-mxs/include/mach/common.h between commit d4e717535e94
("ARM: restart: mxs: use new restart hook") from the arm tree and commit
4e1b4ecaa231 ("ARM: mxs: add saif clkmux functions") from the arm-soc
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mxs/include/mach/common.h
index 1388485,3bbb94f..0000000
--- a/arch/arm/mach-mxs/include/mach/common.h
+++ b/arch/arm/mach-mxs/include/mach/common.h
@@@ -16,7 -16,7 +16,8 @@@ struct clk
  extern const u32 *mxs_get_ocotp(void);
  extern int mxs_reset_block(void __iomem *);
  extern void mxs_timer_init(struct clk *, int);
 +extern void mxs_restart(char, const char *);
+ extern int mxs_saif_clkmux_select(unsigned int clkmux);
 =20
  extern int mx23_register_gpios(void);
  extern int mx23_clocks_init(void);

--Signature=_Wed__7_Dec_2011_10_53_14_+1100_Oswxth_UJUjRU3.6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3qrqAAoJEECxmPOUX5FEgVoP/2UwMdbt2qH056j60QIId4i1
3dMxgCMxuiGUfbXHII8MozAi0iSX8cM7eKrJxkStEHGjyb8ZaSHRLi9Gw6iPZFIr
u6wiGAYKU/NPwnCOw3qqwp/sFAN/Y/RF8lQp0M6BYRxbA7Uic/0GuA4s9H/dIXx4
xuXR/jBa0T6QeEUwiCm6jl1P18Di9p7u6DfGl1h+oDP3aUj6j+x1JQt8SZGfCxhJ
G0qo4DpZLe8DiclMulISOCEI8RVeMH1RXoNt6JRcm15iXTt8iCTe0qzlptJMaFsX
28KLfX7yjb4Ho7kF2LgH+d5bk8F/XybJDT9RqDydaz/Z4swA8YohwZ95//NRAw4h
/FodgMA5kSny//pI/A5j/oLi0TcHBSUDPOnE/vU9hOZTDlEQ9ZBOMMs4DjsHlUT4
fOx3OxBuhw8zwPZZwzbShFvNiW2IU2e5XvGyPrcnuSLEaGonIebn/lA88WRR/HNo
k3BMBSUPi3NViCUrx1CdyI+4abcIMJyByJWQBYTtqkMz+HxYf5LDhSwsHWr9Hxxz
wwwhk8Tx/Zssl+yoO4jLxqCMctC+CGmH4I8fZ/RhgsyK6JGg8DZvbmgXvdab0miX
Es2qgbcQskN0hqTvUPqEJXQd+rFbZb0GLUmiGSW+du0XkVYu5NhK+MulhKycTs3i
y0fHOZOST0l3dxKBSNcU
=VBWY
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Dec_2011_10_53_14_+1100_Oswxth_UJUjRU3.6--
