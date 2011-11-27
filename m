Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1K0X4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 18:56:51 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40461 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1K0X4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 18:56:49 -0500
Date: Mon, 28 Nov 2011 10:56:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111128105633.8a8c06afce3cdccb1ce0d7b7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Nov_2011_10_56_33_+1100_dmuPrHgVlWjkoIHl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Nov_2011_10_56_33_+1100_dmuPrHgVlWjkoIHl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/plat-omap/include/plat/common.h between commit 4e65331c6bb4
("ARM: 7159/1: OMAP: Introduce local common.h files") from the  tree and
commit 13662dc5b177 ("ARM: OMAP: HWMOD: Unify DSS resets for OMAPs") from
the arm-soc tree.

I did the obvious fixup (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-omap/include/plat/common.h
index 346098f,3ff3e36..0000000
--- a/arch/arm/plat-omap/include/plat/common.h
+++ b/arch/arm/plat-omap/include/plat/common.h
@@@ -27,12 -27,97 +27,16 @@@
  #ifndef __ARCH_ARM_MACH_OMAP_COMMON_H
  #define __ARCH_ARM_MACH_OMAP_COMMON_H
 =20
 -#include <linux/delay.h>
 -
  #include <plat/i2c.h>
+ #include <plat/omap_hwmod.h>
 =20
 -struct sys_timer;
 -
 -extern void omap_map_common_io(void);
 -extern struct sys_timer omap1_timer;
 -extern struct sys_timer omap2_timer;
 -extern struct sys_timer omap3_timer;
 -extern struct sys_timer omap3_secure_timer;
 -extern struct sys_timer omap4_timer;
 -extern bool omap_32k_timer_init(void);
  extern int __init omap_init_clocksource_32k(void);
  extern unsigned long long notrace omap_32k_sched_clock(void);
 =20
  extern void omap_reserve(void);
+=20
 -void omap2420_init_early(void);
 -void omap2430_init_early(void);
 -void omap3430_init_early(void);
 -void omap35xx_init_early(void);
 -void omap3630_init_early(void);
 -void omap3_init_early(void);	/* Do not use this one */
 -void am35xx_init_early(void);
 -void ti816x_init_early(void);
 -void omap4430_init_early(void);
 -
+ extern int omap_dss_reset(struct omap_hwmod *);
+=20
  void omap_sram_init(void);
 =20
 -/*
 - * IO bases for various OMAP processors
 - * Except the tap base, rest all the io bases
 - * listed are physical addresses.
 - */
 -struct omap_globals {
 -	u32		class;		/* OMAP class to detect */
 -	void __iomem	*tap;		/* Control module ID code */
 -	void __iomem	*sdrc;           /* SDRAM Controller */
 -	void __iomem	*sms;            /* SDRAM Memory Scheduler */
 -	void __iomem	*ctrl;           /* System Control Module */
 -	void __iomem	*ctrl_pad;	/* PAD Control Module */
 -	void __iomem	*prm;            /* Power and Reset Management */
 -	void __iomem	*cm;             /* Clock Management */
 -	void __iomem	*cm2;
 -};
 -
 -void omap2_set_globals_242x(void);
 -void omap2_set_globals_243x(void);
 -void omap2_set_globals_3xxx(void);
 -void omap2_set_globals_443x(void);
 -void omap2_set_globals_ti816x(void);
 -
 -/* These get called from omap2_set_globals_xxxx(), do not call these */
 -void omap2_set_globals_tap(struct omap_globals *);
 -void omap2_set_globals_sdrc(struct omap_globals *);
 -void omap2_set_globals_control(struct omap_globals *);
 -void omap2_set_globals_prcm(struct omap_globals *);
 -
 -void omap242x_map_io(void);
 -void omap243x_map_io(void);
 -void omap3_map_io(void);
 -void omap4_map_io(void);
 -
 -
 -/**
 - * omap_test_timeout - busy-loop, testing a condition
 - * @cond: condition to test until it evaluates to true
 - * @timeout: maximum number of microseconds in the timeout
 - * @index: loop index (integer)
 - *
 - * Loop waiting for @cond to become true or until at least @timeout
 - * microseconds have passed.  To use, define some integer @index in the
 - * calling code.  After running, if @index =3D=3D @timeout, then the loop=
 has
 - * timed out.
 - */
 -#define omap_test_timeout(cond, timeout, index)			\
 -({								\
 -	for (index =3D 0; index < timeout; index++) {		\
 -		if (cond)					\
 -			break;					\
 -		udelay(1);					\
 -	}							\
 -})
 -
 -extern struct device *omap2_get_mpuss_device(void);
 -extern struct device *omap2_get_iva_device(void);
 -extern struct device *omap2_get_l3_device(void);
 -extern struct device *omap4_get_dsp_device(void);
 -
  #endif /* __ARCH_ARM_MACH_OMAP_COMMON_H */

--Signature=_Mon__28_Nov_2011_10_56_33_+1100_dmuPrHgVlWjkoIHl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO0s4xAAoJEECxmPOUX5FEZYQP/3KbPBlTHvi9kvcpz+tcLdXr
P8Qsv7+dyac6FssXeghnoSoOEjGskTXTap2Xa/JGCD5aVWbsi4ZInoMoGRB5PFP2
sg0mG0j3UNzvbJi7rCr992VgA64roqfOQGV7NDrlfCm9WPxJahqu7F9rI3cyM3+5
7ECBwW+JzqkoIg1Ks56BIwSQrmj/k9CCfamHIilivtkrZqwjjU3UuNugDOHBT8gA
th+HUyewcD3XgI7FJGtlfs7f9PP1pG31U6arOGi3mOF8xvGjdBFVjQjKVdIoCGCn
tC9MTZUa7TmMGy1Xh19s3klI7MbUpn/JmqCPMEU1AtmaiLKpwSYiiNQmig3ccMGz
pNZH10/OGCgGTmrIL8fuFsBcNt3g7uNXy4H7sRZCSzjbDP6ZL0juDHnljDx/DrD9
C1nH/GxHd3brrXXSiF2IYDJpCsBv9ZWRNvCi7mM3v3l3FtpuAoIPtc8+ggzu3Jed
3fX3inSQ+mzMIAqiK7QkHKoQYliW4izvZqg7Tbu4bmC1QtQCDhpPTCRM76pjvxcC
1C5R3qcMo1jxswBNb12/9aLSKjLbr55B+PDjqgwZA28Qq5zEJztBIQY0pfdnljXp
iLBrovyRA2MLg7G0m/b6kQY5GXamtD8FPkoTvHHEv71uhCqEAtqlv4Gb0ZrlxWyQ
SIySh9uyXC+isYXsYXK0
=uBjb
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Nov_2011_10_56_33_+1100_dmuPrHgVlWjkoIHl--
