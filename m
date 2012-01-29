Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2A2Xiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 18:38:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46349 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab2A2Xix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 18:38:53 -0500
Date: Mon, 30 Jan 2012 10:38:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20120130103841.041d276454d26b5adfae5a7a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__30_Jan_2012_10_38_41_+1100_t=eJkQPqdZBpL8QD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Jan_2012_10_38_41_+1100_t=eJkQPqdZBpL8QD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/mach-at91/at91cap9.c arch/arm/mach-at91/at91sam9g45.c between
commit 14f991a730f4 ("ARM: at91: Fix at91sam9g45 and at91cap9 reset")
from Linus' tree and commit c9dfafbaca0b ("ARM: mach-at91: move special
idle code out of line") from the arm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/at91cap9.c
index a42edc2,1d29a6c..0000000
--- a/arch/arm/mach-at91/at91cap9.c
+++ b/arch/arm/mach-at91/at91cap9.c
@@@ -313,6 -315,17 +314,12 @@@ static struct at91_gpio_bank at91cap9_g
  	}
  };
 =20
+ static void at91cap9_idle(void)
+ {
+ 	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
+ 	cpu_do_idle();
+ }
+=20
 -static void at91cap9_restart(char mode, const char *cmd)
 -{
 -	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RS=
TC_PERRST);
 -}
 -
  /* --------------------------------------------------------------------
   *  AT91CAP9 processor initialization
   * -------------------------------------------------------------------- */
@@@ -332,7 -344,8 +339,8 @@@ static void __init at91cap9_ioremap_reg
 =20
  static void __init at91cap9_initialize(void)
  {
+ 	arm_pm_idle =3D at91cap9_idle;
 -	arm_pm_restart =3D at91cap9_restart;
 +	arm_pm_restart =3D at91sam9g45_restart;
  	at91_extern_irq =3D (1 << AT91CAP9_ID_IRQ0) | (1 << AT91CAP9_ID_IRQ1);
 =20
  	/* Register GPIO subsystem */
diff --cc arch/arm/mach-at91/at91sam9g45.c
index 1cb6a96,0e80b39..0000000
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@@ -317,6 -318,17 +317,12 @@@ static struct at91_gpio_bank at91sam9g4
  	}
  };
 =20
+ static void at91sam9g45_idle(void)
+ {
+ 	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
+ 	cpu_do_idle();
+ }
+=20
 -static void at91sam9g45_restart(char mode, const char *cmd)
 -{
 -	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RS=
TC_PERRST);
 -}
 -
  /* --------------------------------------------------------------------
   *  AT91SAM9G45 processor initialization
   * -------------------------------------------------------------------- */

--Signature=_Mon__30_Jan_2012_10_38_41_+1100_t=eJkQPqdZBpL8QD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPJdiBAAoJEECxmPOUX5FEIggP/RMD1++5S9PAnxcXOYGCw98S
IHwAiaxwJXhzSBs7o7/vCF0OPW6c1q0HuTz6bELEp0JNbRn0QOWc/E/kXJMMF/rd
qfFFMbA+wiXBa00d1yuiz9rmgPgMFkXwMzwRoRtEGlwAL8G9uNhAZ4dy5oL4flM4
mwsSqlba/+yYDKm0pj4Ff84OnTT25TxRFhvLbRsTsGtPxt5XdpszRjMZ41fuPnSW
IvYbvbrbI/P0vthbdg8X00gBGbDFaAryY3ZW9sl9GIbLT/qtGWyuweJkqdZWeW2Y
I+SQo0VELxtX/Qd0q/K2XN4k3Oif+hUR7Z40F6VxUtXrBIEvzsT3rSKUcYcDZ461
knFjdDklo3MKE8Zy5qhlEM16V8oc0A51/EbmVEKK6iUstSnQEjgIhMtl9USPp8w1
0Z84NIGrpsWZbl7Aw+dNp47aVWKv3gZ1bXHdagdZpivyki+5PpkhL5iveEBem1fq
E1oGFcNvpEsspvsCHJXQY3P4Bc4916rAlg9AklReSiTeOAQ1CVFcF93WctVjnRRH
v7eZsxWv/GVn9IJKGs67tuakiBWKsuU9qQIfluWyygxks6dACWycD8S3XrmllyAw
VrVmc4eTzelYwkxrMpmBdBwjjQzwhT4dIx9AAHACO52qBnXpMAmAGdjHckfzyMYo
MEubgtKe6izhWegOm/sD
=EF9i
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Jan_2012_10_38_41_+1100_t=eJkQPqdZBpL8QD--
