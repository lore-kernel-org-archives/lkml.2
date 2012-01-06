Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946Ab2AFBDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:03:50 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43963 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964847Ab2AFBDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:03:47 -0500
Date: Fri, 6 Jan 2012 12:03:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hui Wang <jason77.wang@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120106120345.8157a839b1c924315d728eea@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_12_03_45_+1100_z.VV1Iz1g2zunkO7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_12_03_45_+1100_z.VV1Iz1g2zunkO7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-imx/mm-imx5.c between commit 9bdd46257ab3 ("ARM: plat-mxc:
hook special idle handlers to arm_pm_idle") from the arm tree and commit
010dc8af8f28 ("ARM: mx5: use generic irq chip pm interface for pm
functions on") from the arm-soc tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mm-imx5.c
index 65139a6,bc17dfe..0000000
--- a/arch/arm/mach-imx/mm-imx5.c
+++ b/arch/arm/mach-imx/mm-imx5.c
@@@ -21,9 -22,27 +22,24 @@@
  #include <mach/devices-common.h>
  #include <mach/iomux-v3.h>
 =20
+ static struct clk *gpc_dvfs_clk;
+=20
  static void imx5_idle(void)
  {
 -	if (!need_resched()) {
 -		/* gpc clock is needed for SRPG */
 -		if (gpc_dvfs_clk =3D=3D NULL) {
 -			gpc_dvfs_clk =3D clk_get(NULL, "gpc_dvfs");
 -			if (IS_ERR(gpc_dvfs_clk))
 -				goto err0;
 -		}
 -		clk_enable(gpc_dvfs_clk);
 -		mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
 -		if (tzic_enable_wake())
 -			goto err1;
 -		cpu_do_idle();
 -err1:
 -		clk_disable(gpc_dvfs_clk);
++	/* gpc clock is needed for SRPG */
++	if (gpc_dvfs_clk =3D=3D NULL) {
++		gpc_dvfs_clk =3D clk_get(NULL, "gpc_dvfs");
++		if (IS_ERR(gpc_dvfs_clk))
++			goto err0;
+ 	}
++	clk_enable(gpc_dvfs_clk);
 +	mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
++	if (tzic_enable_wake())
++		goto err1;
++	cpu_do_idle();
++err1:
++	clk_disable(gpc_dvfs_clk);
+ err0:
 -	local_irq_enable();
  }
 =20
  /*

--Signature=_Fri__6_Jan_2012_12_03_45_+1100_z.VV1Iz1g2zunkO7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBkhxAAoJEECxmPOUX5FEhzUP/13Z6r1SkJdlKHG3H4j8nHUy
K5nWY9YbY8mAqo1B2dN/sC0LJa2nGwFaSOOHT4vDMbWxjHJfJ3j6xG3N5m3G3o1O
2UbqxFsM77vWsKE5nYU9sOo6J7U6st3XLHxLt1jg3eI375tyQoMEGCkAPOHpB52l
Gz9trKJHboX7LAeipXTDaQLULM8U8q0NghU9XSptKnMrh7L2MGGO3J7H4aWvuX2o
2orM1+1EX5vtupT4+1ZGdJU2yUsaUAy3wLA4VSfL3fQDUpzXb7t+XLfoKjYZRG71
SjJqcFyw5cOIvgk6rpwcE+1fJ5WlXkl4Pq0JHxwRhshshzqBFmw4M/njE7EzmVPN
Lz5NRy2HjQ2v6mBvaSbjUd44QIOVg6Fe/BYT2GPkfjMnLQGC32LeF7HeNwwD1e3Z
4F8prGNg4qY+VQwEuhi60OU8AD9Bv+lAgivF2rmlPZanvnGwXW5ltpmwr2Sj21FK
NyGReYjmIN1s1VlQKzXqR+VKfRP2xwbrkxREFbQrifpgk6DYclDZa62g9/PBw/ZG
s5tU4jHgUc95fqmQnUU3zX/ze3ojuZNTmcjggHZLUbk+lpGoNA5eppPnhp+LG2JM
eIfxYHnVGE3ooxZYs3TF/0aHN2puPVZG6cZdaKufPw20TlJRw6f4N8ZWFP2m/jUL
VuU0kH4fWQYHwEnbOlin
=NSZh
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_12_03_45_+1100_z.VV1Iz1g2zunkO7--
