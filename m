Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab1KAFT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 01:19:59 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:51713 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1KAFT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 01:19:58 -0400
Date: Tue, 1 Nov 2011 16:19:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Manna <kyle@kylemanna.com>, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the mfd tree with the arm-soc tree
Message-Id: <20111101161950.798537fc333958b0b7d72668@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_16_19_50_+1100_PY=vKR9tpze+JS/B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_16_19_50_+1100_PY=vKR9tpze+JS/B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
arch/arm/mach-omap2/board-omap3beagle.c between commit be7324605873
("ARM: OMAP2+: Remove custom init_irq for remaining boards") from the
arm-soc tree and commit 935bac2b14b0 ("arm: BeagleBoard: add support for
the twl4030-madc") from the mfd tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-omap3beagle.c
index 70261bc,0d68c8d..0000000
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@@ -444,6 -445,23 +445,11 @@@ static struct platform_device keys_gpi
  	},
  };
 =20
 -static void __init omap3_beagle_init_early(void)
 -{
 -	omap2_init_common_infrastructure();
 -	omap2_init_common_devices(mt46h32m32lf6_sdrc_params,
 -				  mt46h32m32lf6_sdrc_params);
 -}
 -
 -static void __init omap3_beagle_init_irq(void)
 -{
 -	omap3_init_irq();
 -}
 -
+ static struct platform_device madc_hwmon =3D {
+ 	.name	=3D "twl4030_madc_hwmon",
+ 	.id	=3D -1,
+ };
+=20
  static struct platform_device *omap3_beagle_devices[] __initdata =3D {
  	&leds_gpio,
  	&keys_gpio,

--Signature=_Tue__1_Nov_2011_16_19_50_+1100_PY=vKR9tpze+JS/B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr4F2AAoJEECxmPOUX5FEVAwQAKVfuD6DK9tAy56CQABwhj2T
z09JtjXts853G5JYlzgCGKo7SdsL/PjPzDGCK8nf7ZKzvUd6iYYqIyWykqmJa4XN
rWcTyL4KHDOO8dIMxO+UEkKYm8XhYzUJ1WMDUARmSQN7SxJfIyEz78XPMyO/JZrL
L18rh1BrHllYhQkkECLWdmmTOIhpBvs85aOvHgHK22AbZeSiVGM3dwEuty0n0C/5
iy+GuoU3ZLu9FGMfkbqqNeinRlLviahyrVDcxrhMu56Vmbys0LEXvEydDBJYasbA
4kgI93mHgQ548v2lRnci/ydYFicdk9UaK6yub/FzjYRMxxMaE6iwxrhvaprqaDHf
uPTV5LO26GswGj+j0NiEnvfHOr+VK+N2/2Dzv4ksrvPwgLQ89NXJY8a2vRzZK+UM
pgoOB2rdW98NsNhkpGE+WwRbTjoqQDOXJpSpYKYtoQ5P0IatUj0yiKusr84CO2rv
4+FexckBOARHp7FdInZrbttFavIvKT0hwN4oVJ/R6QSxhqpvRJbK2P8Wcv5Nwg45
EI1mhzhNabc8lQpMKlwEwKM5ek8i1o5UowC99vWl994cld4mGa68jKBHS7cy1cSw
ROOlcFx1SbJF+QDd6+0LRlBwdU9fbBjwqnZaMucVueOA9UBNxn0B3N1X9zgx5W2H
/QEkfKgav33AnFTwqG3Z
=HCtT
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_16_19_50_+1100_PY=vKR9tpze+JS/B--
