Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab1KVBTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:19:19 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40587 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab1KVBTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:19:17 -0500
Date: Tue, 22 Nov 2011 12:19:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the at91 tree with the arm tree
Message-Id: <20111122121900.f0946f93526d7f10e7cbfeb5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_12_19_00_+1100_FciYZLPthIwXT6wg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_12_19_00_+1100_FciYZLPthIwXT6wg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the at91 tree got conflicts in
arch/arm/mach-at91/at91cap9.c, arch/arm/mach-at91/at91sam9260.c,
arch/arm/mach-at91/at91sam9261.c, arch/arm/mach-at91/at91sam9263.c,
arch/arm/mach-at91/at91sam9g45.c and arch/arm/mach-at91/at91sam9rl.c
between commit b91dfe91bb61 ("ARM: restart: at91: use new restart hook")
from the arm tree and commit 92996c285e17 ("ARM: at91: make shutdown
controler soc independent") from the at91 tree.

Just context changes.  I fixed it up (see below) and can carry the fixes
as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/at91cap9.c
index 2937339,81a9f38..0000000
--- a/arch/arm/mach-at91/at91cap9.c
+++ b/arch/arm/mach-at91/at91cap9.c
@@@ -333,10 -326,16 +326,16 @@@ static void __init at91cap9_map_io(void
  	at91_init_sram(0, AT91CAP9_SRAM_BASE, AT91CAP9_SRAM_SIZE);
  }
 =20
+ static void __init at91cap9_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91CAP9_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91CAP9_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91CAP9_BASE_SMC);
+ }
+=20
  static void __init at91cap9_initialize(void)
  {
 -	at91_arch_reset =3D at91cap9_reset;
 +	arm_pm_restart =3D at91cap9_restart;
- 	pm_power_off =3D at91cap9_poweroff;
  	at91_extern_irq =3D (1 << AT91CAP9_ID_IRQ0) | (1 << AT91CAP9_ID_IRQ1);
 =20
  	/* Register GPIO subsystem */
diff --cc arch/arm/mach-at91/at91sam9260.c
index ec9e23d,5e25cef..0000000
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@@ -325,10 -318,16 +318,16 @@@ static void __init at91sam9260_map_io(v
  	}
  }
 =20
+ static void __init at91sam9260_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91SAM9260_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91SAM9260_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91SAM9260_BASE_SMC);
+ }
+=20
  static void __init at91sam9260_initialize(void)
  {
 -	at91_arch_reset =3D at91sam9_alt_reset;
 +	arm_pm_restart =3D at91sam9_alt_restart;
- 	pm_power_off =3D at91sam9260_poweroff;
  	at91_extern_irq =3D (1 << AT91SAM9260_ID_IRQ0) | (1 << AT91SAM9260_ID_IR=
Q1)
  			| (1 << AT91SAM9260_ID_IRQ2);
 =20
diff --cc arch/arm/mach-at91/at91sam9261.c
index 19ac7c0,a0538c5..0000000
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@@ -285,10 -278,16 +278,16 @@@ static void __init at91sam9261_map_io(v
  		at91_init_sram(0, AT91SAM9261_SRAM_BASE, AT91SAM9261_SRAM_SIZE);
  }
 =20
+ static void __init at91sam9261_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91SAM9261_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91SAM9261_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91SAM9261_BASE_SMC);
+ }
+=20
  static void __init at91sam9261_initialize(void)
  {
 -	at91_arch_reset =3D at91sam9_alt_reset;
 +	arm_pm_restart =3D at91sam9_alt_restart;
- 	pm_power_off =3D at91sam9261_poweroff;
  	at91_extern_irq =3D (1 << AT91SAM9261_ID_IRQ0) | (1 << AT91SAM9261_ID_IR=
Q1)
  			| (1 << AT91SAM9261_ID_IRQ2);
 =20
diff --cc arch/arm/mach-at91/at91sam9263.c
index 50d0163,0d90b6a..0000000
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@@ -303,10 -296,17 +296,17 @@@ static void __init at91sam9263_map_io(v
  	at91_init_sram(1, AT91SAM9263_SRAM1_BASE, AT91SAM9263_SRAM1_SIZE);
  }
 =20
+ static void __init at91sam9263_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91SAM9263_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91SAM9263_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91SAM9263_BASE_SMC0);
+ 	at91sam9_ioremap_smc(1, AT91SAM9263_BASE_SMC1);
+ }
+=20
  static void __init at91sam9263_initialize(void)
  {
 -	at91_arch_reset =3D at91sam9_alt_reset;
 +	arm_pm_restart =3D at91sam9_alt_restart;
- 	pm_power_off =3D at91sam9263_poweroff;
  	at91_extern_irq =3D (1 << AT91SAM9263_ID_IRQ0) | (1 << AT91SAM9263_ID_IR=
Q1);
 =20
  	/* Register GPIO subsystem */
diff --cc arch/arm/mach-at91/at91sam9g45.c
index ff21f7a,72c3cce..0000000
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@@ -338,10 -331,16 +331,16 @@@ static void __init at91sam9g45_map_io(v
  	init_consistent_dma_size(SZ_4M);
  }
 =20
+ static void __init at91sam9g45_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91SAM9G45_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91SAM9G45_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91SAM9G45_BASE_SMC);
+ }
+=20
  static void __init at91sam9g45_initialize(void)
  {
 -	at91_arch_reset =3D at91sam9g45_reset;
 +	arm_pm_restart =3D at91sam9g45_restart;
- 	pm_power_off =3D at91sam9g45_poweroff;
  	at91_extern_irq =3D (1 << AT91SAM9G45_ID_IRQ0);
 =20
  	/* Register GPIO subsystem */
diff --cc arch/arm/mach-at91/at91sam9rl.c
index 61cbb46,96247f6..0000000
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@@ -290,10 -283,16 +283,16 @@@ static void __init at91sam9rl_map_io(vo
  	at91_init_sram(0, AT91SAM9RL_SRAM_BASE, sram_size);
  }
 =20
+ static void __init at91sam9rl_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91SAM9RL_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91SAM9RL_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91SAM9RL_BASE_SMC);
+ }
+=20
  static void __init at91sam9rl_initialize(void)
  {
 -	at91_arch_reset =3D at91sam9_alt_reset;
 +	arm_pm_restart =3D at91sam9_alt_restart;
- 	pm_power_off =3D at91sam9rl_poweroff;
  	at91_extern_irq =3D (1 << AT91SAM9RL_ID_IRQ0);
 =20
  	/* Register GPIO subsystem */

--Signature=_Tue__22_Nov_2011_12_19_00_+1100_FciYZLPthIwXT6wg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOyviEAAoJEECxmPOUX5FE/AsP/3oI7XNxUogbPKp1DjsUGVB8
3HPVN6zgWhCrayboldwudhc//FwOTWtkVEi09rXjMLCmSTbhIYMMm9ohNb6/Hu1j
BWeNux1pItSg77XAWKZNasrittpeny11FwidJx5bixdbcdfgBzTbCdTkzJsqjm1g
URcDhieFUNEpplYLCMZSuqUZTY9s0pX1tFXJokRgmEqIxUuoOInldhazjC/YM1Fr
piJYIQjk1C6cV7NQVrDdXrGiH5RciHTvjqFyHWul1BA51oCXXkbJUw4DSHRJz10E
XOc+fI+LzgqOJ3f29yHSyLMgYafgoZ/WkvtS/62A7Ah2Nt5o8ohcM/g5JbyCXlZA
A9RLorEBeP3IRaGzSOEDcfs6/riBmhCb+kaZ0TQFiBmIDHfpEKxizsMdFHEljayC
rTO+rFlcDm/oAwy6eSjEz8fiSUQyqBGcvm5/7L+SjEgSUy1BGzIltPKEbpCLhjQG
mJ65jFUpkuFOoUkUqHtWb4PRAd5EbB7tOYbJV/w70MhZxjkjwKyYBACgfeBNtUDv
QPkSW1fwQ2hr64pgucaTgU7gUz8KMdL+wmz51xITYB6qT0gVJPQqZh7U8Bfcbnit
P/+E+1V/PYYxawoaIDmBef1ldQ1WjPXshGsUAGR/NZ3FG6Bq3MjjR0dZQHSdbz8q
5sHR2vsY0voisWQofMj+
=hSgj
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_12_19_00_+1100_FciYZLPthIwXT6wg--
