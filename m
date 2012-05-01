Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2EAXaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:30:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462Ab2EAXaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:30:18 -0400
Date: Wed, 2 May 2012 09:29:56 +1000
From: NeilBrown <neilb@suse.de>
To: John Stultz <johnstul@us.ibm.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "Bergmann, Arnd" <arnd@arndb.de>
Subject: Re: omap-usb-host.c compile error
Message-ID: <20120502092956.3277750a@notabene.brown>
In-Reply-To: <4FA056A1.1040209@us.ibm.com>
References: <4FA056A1.1040209@us.ibm.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UuE7T6PPXmFN.zm+HizExtU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UuE7T6PPXmFN.zm+HizExtU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 01 May 2012 14:33:21 -0700 John Stultz <johnstul@us.ibm.com> wrote:

>=20
> I've been seeing the following compile issue for a few -rcs now:
> drivers/mfd/omap-usb-host.c: In function 'omap_usbhs_init':
> drivers/mfd/omap-usb-host.c:524: error: implicit declaration of function=
=20
> 'cpu_is_omap3430'
> drivers/mfd/omap-usb-host.c:524: error: implicit declaration of function=
=20
> 'omap_rev'
> drivers/mfd/omap-usb-host.c:524: error: 'OMAP3430_REV_ES2_1' undeclared=20
> (first use in this function)
> drivers/mfd/omap-usb-host.c:524: error: (Each undeclared identifier is=20
> reported only once
> drivers/mfd/omap-usb-host.c:524: error: for each function it appears in.)
>=20
> Reverting 1fcb57d0f6e1150003d222051aaaf4bc4a9ccc94 seems to resolve it.
>=20
> This still isn't fixed in Linus' HEAD. Any plans here?
>=20
> thanks
> -john

Following fixes it for me.

NeilBrown

Author: NeilBrown <neilb@suse.de>
Date:   Wed Apr 25 10:52:05 2012 +1000

    omap-usb-host: add include plat/cpu.h
   =20
    Need this for a version comparison.
   =20
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index c8aae66..7da9496 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -26,6 +26,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
 #include <plat/usb.h>
+#include <plat/cpu.h>
 #include <linux/pm_runtime.h>
=20
 #define USBHS_DRIVER_NAME      "usbhs_omap"


--Sig_/UuE7T6PPXmFN.zm+HizExtU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6Bx9Dnsnt1WYoG5AQJYahAAki+3XhzPMFzLmo8vPY9V7cDo02AoYoQQ
ZLXja4Srwu66ZAvJ3PD6UBlD+ZXm3TrhFX2yOKsUCC9XSpvdQH33flQ6m0eenPcc
H9B9FUvvNBbux6XxRK1XhVRgCIZl8sB5T+aYPQCqa9MHFY0vPjbrGWUss08JADiC
TW53iaGRYZjbH1vER1jVEvNKQOKoNA2tz1EfNrw3rJ6/UKvHhpknBdPsHDqnKk4b
p0B6+VcNBBez52qCLNirbWDgRE6X62lZJZTrbpnwV7x3ft+AKVHHwh72vywaJBGX
rzao2wTOMt66lJDohSl3zNJgFhK72SMMvEcCvtzwcZFXFNFJHISFSd5eUVJ3HInN
nXccWfYm5AhKDPrZG6WUMEUJhodV0tBflR/wiUTTKYOAaTyd9D815pUTCEqQB6m2
mNXNL/1i7pT1QSWguRg0aysb1snATsj8ch8lOISicxu7IP4s75rqVJqsHD2E8ZJL
BD1Mu0Bva5Gkia7zmb8KFyg+EQAYPHLbaj0G2z9uLqU6IYutPbmqQvaqNjik4e1g
KEs5anK1iF7KeBtYrpQ5xlnTUeghtMT/pc0kGrSkaQNs6at6wlifZIX8UYcONa7P
jIErCpcMguHjphKqA/v0N7sgkIwmqNw5tLF/56gs1O6qyvfy7u6pEPagas1P8joQ
6p19PlvvfWI=
=evaN
-----END PGP SIGNATURE-----

--Sig_/UuE7T6PPXmFN.zm+HizExtU--
