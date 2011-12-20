Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1LTVEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 16:04:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1LTVDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 16:03:54 -0500
Date: Wed, 21 Dec 2011 08:03:00 +1100
From: NeilBrown <neilb@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] leds-tca6507: allow driver to compile when GPIOLIB
 is not available.
Message-ID: <20111221080300.02cb8a45@notabene.brown>
In-Reply-To: <4EF0EF8B.1030904@xenotime.net>
References: <20111220054233.7043.3561.stgit@notabene.brown>
	<20111220054441.7043.48656.stgit@notabene.brown>
	<4EF0ED15.5030906@xenotime.net>
	<4EF0EF8B.1030904@xenotime.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=2lbGy.nUqYxHolJ/EMir+g"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=2lbGy.nUqYxHolJ/EMir+g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Dec 2011 12:26:51 -0800 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:

> On 12/20/2011 12:16 PM, Randy Dunlap wrote:
> > On 12/19/2011 09:44 PM, NeilBrown wrote:
> >> This driver can configure the outputs as GPIO line instead of LEDs.  B=
ut
> >> that only works if GPIOLIB is available.  So make that code conditional
> >> on the library's availability.
> >>
> >> Also remove the 'teardown' callback as it is never called and should
> >> never be needed.
> >>
> >> Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > Thanks.  This builds.
> >=20
> > Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>=20
> Neil,
> You might want to check this also:
>=20
> drivers/leds/leds-tca6507.c:358:17: warning: array subscript is above arr=
ay bounds
> drivers/leds/leds-tca6507.c:357:17: warning: array subscript is above arr=
ay bounds
>=20
>=20

Argh..

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index 75dc5e4..ce20ab7 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -349,7 +349,7 @@ static int led_prepare(struct tca6507_led *led)
 			return 0;
 		}
=20
-		for (i =3D MASTER; i >=3D BANK0; i++) {
+		for (i =3D MASTER; i >=3D BANK0; i--) {
 			int d;
 			if (tca->bank[i].level =3D=3D level ||
 			    tca->bank[i].level_use =3D=3D 0) {

That loop used to go up..

I might just go an re-review all the code.  And repeat the tests.

Thanks a lot.

NeilBrown

--Sig_/=2lbGy.nUqYxHolJ/EMir+g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvD4BDnsnt1WYoG5AQJ6KRAAs8UgCvVL6JzO7L39Y++j5WlE230KxC3X
yiHaEd25DpBJr3de00a86fgWVLMYwyQ1/GJVLqGsA5iF4U+ElqG8Ygd9TtM3GlWs
NWKpvAHofCzIGz66GI3hCy26eZNawjfhmyt0ycPv9W6YOCMBmIPz4C8lfCkm4wb+
Tgqs3On4heYQPGCB0Y8DWRIuTWSz9G8IQIwlseV1nhKyN89Pt7np6mz+/hm5S5Kn
gAJ7WhsFFt/P7Wz2mVN3Vp2cfFyipJ6w/DTiKQhhm5P3Dm9zhCB803hC8HBJ5sSU
WGCXH21UWXuBo+XnKGHa32cTtIOGnk+H59amExIdeT8hChSozLFoa3+6gMQZHptT
3c0mEUDzyxj/kwd5rqUMg8yVoUKlpo9yzV4PomUciwJUZ6K77a/hmAklJHoMaeup
gRqXcOqkFz7X0/ZU6GSVFqh24Ikw12y+E04fMJfBlBLGcYgXT+x5uh8igOg/xzNm
a/eOOERUVN+smCX3L5jxWjFKw9AXkM+ts4n2ZygCSgIISQF8IT5ZyAo4LXmNIjWC
XaRfAfiysnFky7acpxP/1UfVeJIfOL8LOnXOvOSQm1QJdFNBCGbWnpCD+Km4dnEM
yK8NfPyJ4SwDHMqBSYEEiDjhj3MJUqJRwPUDHKTAk/jGj7TZkXMl73kp4xxxOIE0
0jhYGpDRflE=
=zYSY
-----END PGP SIGNATURE-----

--Sig_/=2lbGy.nUqYxHolJ/EMir+g--
