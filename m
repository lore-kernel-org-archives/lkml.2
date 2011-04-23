Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1DWRnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 13:43:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59803 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805Ab1DWRnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 13:43:04 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-PFyylESL2kTOmTCiUDZW"
Date: Sat, 23 Apr 2011 18:42:56 +0100
Message-ID: <1303580576.4815.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] kconfig: Avoid buffer underrun in choice input
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PFyylESL2kTOmTCiUDZW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

commit 40aee729b350672c2550640622416a855e27938f ('kconfig: fix default
value for choice input') fixed some cases where kconfig would select
the wrong option from a choice with a single valid option and thus
enter an infinite loop.

However, this broke the test for user input of the form 'N?', because
when kconfig selects the single valid option the input is zero-length
and the test will read the byte before the input buffer.  If this
happens to contain '?' (as it will in a mips build on Debian unstable
today) then kconfig again enters an infinite loop.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@kernel.org [2.6.17+]
---
Roman has failed to respond to this after 5 weeks and one reminder, so
please take it directly.

Ben.

 scripts/kconfig/conf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 659326c..006ad81 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -332,7 +332,7 @@ static int conf_choice(struct menu *menu)
 		}
 		if (!child)
 			continue;
-		if (line[strlen(line) - 1] =3D=3D '?') {
+		if (line[0] && line[strlen(line) - 1] =3D=3D '?') {
 			print_help(child);
 			continue;
 		}
--=20
1.7.4.1




--=-PFyylESL2kTOmTCiUDZW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATbMPoOe/yOyVhhEJAQrIvQ//bGdWG9l8DHhEK+NnEYx/g5fz1MVmWdmI
rMmRoJPSIww0ANnAW/GpKVAnbGRWfqIfTdVOiLhERts2UVEyhjXZFJl1eyc1aXlh
9SkyMyXBJPUSFNUiiCoKCoFHBEah6SO6tjPCwezTVxTylS/LuyCOdPwwnXaDOYcn
1Iwn3VaUQlhfOJG3Y4+xlDqgAXu6DYTcAwhpZmRkPpIdy/QOjNcKYi5wOwsIY5VZ
BSdEdWein6u0M9ocyr7aEM0CDG2heNN4Y72KjYRYEHS7sPX3Qd0mH+sfjRTQ22dP
cw98jVKje61ZwPXrIkA5PCnkYppzb7IC3EEmWuZ9IM/5CL9jSk/SlAb1FTCc0HUu
f9qQXUZVJ+BaRxUgWHWsV6b+M6y6bPwQEWooV/sD12UscPlZGABymtuX/3g8Hz0+
j2MPVmjnVQtaNcNj3eBbkOm+W0W6il+eNriBA1eXe8eScik8h+TxIvTBth72vuY2
Hplzu2o7+ziIczvHmbwkKyCnzdrRbAXta5iBLPhS2ZUib+fwVpjEX+u0EM+ALNrq
wH3ppy5tBVk5j9sbPnHjeTA1tMPdUPoaZZIYVmLjTW6YOCBVacaDG+P13rexkvMd
3HvLqDF8ONFxBlbLms1acrXauNRkhaLNWpbY/wn8ObnyYrlrU2MX43mL/9xzwGqw
I2zd2y9csHQ=
=lBc1
-----END PGP SIGNATURE-----

--=-PFyylESL2kTOmTCiUDZW--
