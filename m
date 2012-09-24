Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2IXJWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:22:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35588 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2IXJWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:22:00 -0400
Date: Mon, 24 Sep 2012 19:21:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the arm-soc tree with the pm tree
Message-Id: <20120924192154.2aab0ae61dea89722bbcb974@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_21_54_+1000_BAgH.XzQ86oRxx7a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_21_54_+1000_BAgH.XzQ86oRxx7a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/include/mach/common.h between commit 35f2b0bd5911
("ARM: shmobile: Move definition of shmobile_init_late() to header") from
the pm tree and commit a62580e58065 ("ARM: SoC: convert shmobile SMP to
SMP operations") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/include/mach/common.h
index eb89293,f80f9c5..0000000
--- a/arch/arm/mach-shmobile/include/mach/common.h
+++ b/arch/arm/mach-shmobile/include/mach/common.h
@@@ -81,13 -73,10 +75,8 @@@ extern void r8a7779_pinmux_init(void)
  extern void r8a7779_pm_init(void);
  extern void r8a7740_meram_workaround(void);
 =20
- extern unsigned int r8a7779_get_core_count(void);
- extern int r8a7779_platform_cpu_kill(unsigned int cpu);
- extern void r8a7779_secondary_init(unsigned int cpu);
- extern int r8a7779_boot_secondary(unsigned int cpu);
- extern void r8a7779_smp_prepare_cpus(void);
  extern void r8a7779_register_twd(void);
 =20
 -extern void shmobile_init_late(void);
 -
  #ifdef CONFIG_SUSPEND
  int shmobile_suspend_init(void);
  #else
@@@ -100,10 -89,15 +89,21 @@@ int shmobile_cpuidle_init(void)
  static inline int shmobile_cpuidle_init(void) { return 0; }
  #endif
 =20
 +static inline void shmobile_init_late(void)
 +{
 +	shmobile_suspend_init();
 +	shmobile_cpuidle_init();
 +}
 +
+ extern void shmobile_cpu_die(unsigned int cpu);
+ extern int shmobile_cpu_disable(unsigned int cpu);
+=20
+ #ifdef CONFIG_HOTPLUG_CPU
+ extern int shmobile_cpu_is_dead(unsigned int cpu);
+ #else
+ static inline int shmobile_cpu_is_dead(unsigned int cpu) { return 1; }
+ #endif
+=20
+ extern void shmobile_smp_init_cpus(unsigned int ncores);
+=20
  #endif /* __ARCH_MACH_COMMON_H */

--Signature=_Mon__24_Sep_2012_19_21_54_+1000_BAgH.XzQ86oRxx7a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYCYyAAoJEECxmPOUX5FEhE0P/1iWAp0BaglaFgeQXENY3ibp
OofRrvDPAVo3SCyXThUEzWjTPqyoWuTKn3DThvF23ZtX+9B7thDogubMOhwacHI9
EzfqnY3cddPgAPYYuFf5+C5kXbWZpyY2OVkjbCyhQQK81UCs1K6lUP/h7Lct0t66
mm8Fy+5koGFMmxeWVvQFDF5s7hC3Clhy5qIKWl2oezzx1BRemRUzTWAZ0BJmzzU4
4EjNYsMSZt23RpLM4HDmet4lt88Otqg5pTbNcBqMMFd3894jVs7J1NQwcb70JCfP
msauJDAXtieQuFh54gRnW6l78nVogmPWi/vWyB0ksTxpoPwNZX9dd7lt9HrXl49Q
otGZgqNWeV63iUwLWGeF61zgGH3X7ZQljqUCvqE7Z7D1rzj19wnA5stQOxxetZz7
94Dg/epByllktejuXGbm2Qz/bx4YaAY40gAmfnLB5k65q6ij6aEYXftBQxZ6Rw46
3D0t3ruVVCfG/MZ5JiXagpDFS/Rilas/zSKXC7l6Azoy+E/SANALQ4GaIHkUTmIJ
BVHZDFXPxljQqPQFIeJgAcREPAQiOD+d0UiPD9G93qiKbFXShm3biYdvoIvTN4XD
wsS43t9la0gMGk1/eGxqC//GYwthM6F+04IoMjJwhkwf2aO1MwkTd29VosJuOwun
m+DlUjd7rdYRK98Hvows
=rh6B
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_21_54_+1000_BAgH.XzQ86oRxx7a--
