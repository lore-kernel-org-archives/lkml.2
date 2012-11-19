Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2KSMSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 07:18:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42118 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2KSMSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 07:18:33 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Date: Mon, 19 Nov 2012 13:18:29 +0100
Message-ID: <5320319.2WmO5VDT8j@pali>
User-Agent: KMail/4.9.2 (Linux/3.5.0-18-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121118231239.GC29066@lizard.sbx05977.paloaca.wayport.net>
References: <19040462.WFXWijAIDd@pali> <2562836.SjVVyiPAk1@pali> <20121118231239.GC29066@lizard.sbx05977.paloaca.wayport.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2703664.498KMTxjib"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2703664.498KMTxjib
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Sunday 18 November 2012 15:12:40 Anton Vorontsov wrote:
> On Wed, Oct 31, 2012 at 10:48:40AM +0100, Pali Roh=C3=A1r wrote:
> > Hello, I fixed style issues and added it to Makefile and
> > Kconfig.
> >=20
> > power_supply: Add Nokia RX-51 battery driver
> >=20
> > This driver exporting battery design capacity, temperature
> > and voltage for battery in Nokia RX-51. This driver is
> > needed for open source battery management on Nokia RX-51
> > (N900).
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Looks great, thank you! This is now in the battery git tree.
>=20
> p.s.
>=20
> fwiw, I added the N900 reference to the user-visible Kconfig
> text:
>=20
>  config BATTERY_RX51
> -=09tristate "Nokia RX-51 battery driver"
> +=09tristate "Nokia RX-51 (N900) battery driver"
>  =09depends on TWL4030_MADC
>  =09help
> -=09  Say Y here to enable support for battery information on
> Nokia RX-51. +=09  Say Y here to enable support for battery
> information on Nokia +=09  RX-51, also known as N900 tablet.

Ok. Here is missing patch which register this driver in Nokia N900 boar=
d code. Without it driver is not loaded.

>From 0b60efd06a71668439bcb761c6572dd7df91dc17 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Pali=3D20Roh=3DC3=3DA1r?=3D <pali.rohar@gmail.com>
Date: Mon, 19 Nov 2012 09:05:24 +0100
Subject: [PATCH 1/3] ARM: OMAP: rx51: Register platform device for
 rx51_battery driver
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/ma=
ch-omap2/board-rx51-peripherals.c
index 020e03c..fe1ac7e 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -271,11 +271,17 @@ static struct platform_device rx51_charger_device=
 =3D {
 =09},
 };
=20
+static struct platform_device rx51_battery_device =3D {
+=09.name=09=09=3D "rx51-battery",
+=09.id=09=09=3D -1,
+};
+
 static void __init rx51_charger_init(void)
 {
 =09WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
 =09=09GPIOF_OUT_INIT_HIGH, "isp1704_reset"));
=20
+=09platform_device_register(&rx51_battery_device);
 =09platform_device_register(&rx51_charger_device);
 }
=20
--=20
1.7.10.4

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
--nextPart2703664.498KMTxjib
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlCqI5YACgkQi/DJPQPkQ1Ia1wCfUDPisqLpTFaN3TSXDHex7gMj
KOUAnAyHrdeN6natTPDlW2fJGhFjMzry
=DoVF
-----END PGP SIGNATURE-----

--nextPart2703664.498KMTxjib--

