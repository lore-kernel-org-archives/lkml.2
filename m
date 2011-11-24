Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1KXBQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 20:16:32 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46838 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1KXBQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 20:16:31 -0500
Date: Thu, 24 Nov 2011 12:16:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Iles <jamie@jamieiles.com>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the at91 tree with the arm-soc tree
Message-Id: <20111124121611.fe102955910da2b603032d07@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Nov_2011_12_16_11_+1100_9yVWVubjIwtoMC/c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Nov_2011_12_16_11_+1100_9yVWVubjIwtoMC/c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the at91 tree got conflicts in
arch/arm/mach-at91/board-cap9adk.c, arch/arm/mach-at91/board-cpu9krea.c,
arch/arm/mach-at91/board-cpuat91.c,
arch/arm/mach-at91/board-snapper9260.c and
arch/arm/mach-at91/include/mach/board.h between commit 84e0cdb0a262
("macb: unify at91 and avr32 platform data") from the arm-soc tree and
commit 1509f4847dd1 ("at91/boards: use -EINVAL for invalid gpio") from
the at91 tree.

I fixed them up (see below) and can carry the fix as necessary.

However, it looks to me that struct macb_platform_data (in
include/linux/platform_data/macb.h) will need its phy_irq_pin members
changed to int as well (which may have other consequences).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/board-cap9adk.c
index af5520c,abadf5d..0000000
--- a/arch/arm/mach-at91/board-cap9adk.c
+++ b/arch/arm/mach-at91/board-cap9adk.c
@@@ -153,7 -154,8 +154,8 @@@ static struct at91_mmc_data __initdata=20
  /*
   * MACB Ethernet device
   */
 -static struct at91_eth_data __initdata cap9adk_macb_data =3D {
 +static struct macb_platform_data __initdata cap9adk_macb_data =3D {
+ 	.phy_irq_pin	=3D -EINVAL,
  	.is_rmii	=3D 1,
  };
 =20
diff --cc arch/arm/mach-at91/board-cpu9krea.c
index 04d2b9b,d583805..0000000
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@@ -99,7 -100,8 +100,8 @@@ static struct at91_udc_data __initdata=20
  /*
   * MACB Ethernet device
   */
 -static struct at91_eth_data __initdata cpu9krea_macb_data =3D {
 +static struct macb_platform_data __initdata cpu9krea_macb_data =3D {
+ 	.phy_irq_pin	=3D -EINVAL,
  	.is_rmii	=3D 1,
  };
 =20
diff --cc arch/arm/mach-at91/board-cpuat91.c
index 7a4c82e,e1991d6..0000000
--- a/arch/arm/mach-at91/board-cpuat91.c
+++ b/arch/arm/mach-at91/board-cpuat91.c
@@@ -82,7 -82,8 +82,8 @@@ static void __init cpuat91_init_early(v
  	at91_set_serial_console(0);
  }
 =20
 -static struct at91_eth_data __initdata cpuat91_eth_data =3D {
 +static struct macb_platform_data __initdata cpuat91_eth_data =3D {
+ 	.phy_irq_pin	=3D -EINVAL,
  	.is_rmii	=3D 1,
  };
 =20
diff --cc arch/arm/mach-at91/board-snapper9260.c
index fbec934,752fd05..0000000
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@@ -63,9 -64,11 +64,11 @@@ static struct at91_udc_data __initdata=20
  	.vbus_pin		=3D SNAPPER9260_IO_EXP_GPIO(5),
  	.vbus_active_low	=3D 1,
  	.vbus_polled		=3D 1,
+ 	.pullup_pin		=3D -EINVAL,
  };
 =20
 -static struct at91_eth_data snapper9260_macb_data =3D {
 +static struct macb_platform_data snapper9260_macb_data =3D {
+ 	.phy_irq_pin	=3D -EINVAL,
  	.is_rmii	=3D 1,
  };
 =20

--Signature=_Thu__24_Nov_2011_12_16_11_+1100_9yVWVubjIwtoMC/c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzZrbAAoJEECxmPOUX5FE1o8P/2siHmtPSjKQ/NQUWam/6qpC
fo/I9h/8v76DYOaI+Y/omiSi/BJVT+8FWM7d/VoebAfqXQIzdaFIOq6BpgPXkygs
eoyzY3eooZWMRWNCA/Zg7yAgdWsz42+853QO6rM/pXm4i4+yu46vVG5AXuyXtPva
5+u9txcBNUSF+2NM8XJcD4GdWW907NfAaejlq29ENKd3PFRaQdmy51AfAm8hRpQj
r8ZMhWJIhr83WAA5b5ooqq41zNxkE2hnDsl4RY2wF7x/v+e4CHYt87eO9l2dxR3X
Ek/LWEPI0hQheu02Gbqlv8h4rsk5O3yQkxMqP7R6KyZYLmpj/Ub0tLN16hI19s2n
pLQExSuvAwu3AX96pmuC9Tg8phqYP21Fz8uCt78K7EmvdM/udDqF0H1NMaAkVyP8
RnqY9Cict0ZYox8um0IqwW5JTeK8ReK26XT8VgUGZ8rERg5//7bT2lPrZSytUhz8
1ZdJfXP7UhymdcWIgoRSRPOYNcw3S3w+LSyrSyQ9Mlv/D01Zs90VoY4YEu0tMiFe
zB3729EkDwaFp73B/fIvOz0HmIGFZvG0uEBu42Dl4lZPsP6l7QsXOyUImXZajH4J
U79uCk0/aMIxvD691eRjrok/sA0+isAGrz70BQKeITK+/zL+d2nuxyadJso7ESq4
HXx6uA9Ukd3gVW5A4pj4
=HpHl
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Nov_2011_12_16_11_+1100_9yVWVubjIwtoMC/c--
