Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1KRBEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 20:04:39 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54971 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab1KRBEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 20:04:37 -0500
Date: Fri, 18 Nov 2011 12:04:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Sylwester Nawrocki <snjw23@gmail.com>
Subject: linux-next: manual merge of the v4l-dvb tree with the  tree
Message-Id: <20111118120429.14bbc7667cbf09a5d211a1c5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_Nov_2011_12_04_29_+1100_i4P7fgO1CO=1hGWX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Nov_2011_12_04_29_+1100_i4P7fgO1CO=1hGWX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/staging/media/as102/as102_drv.h between commit d29387e8de8b
("media/staging: fix allyesconfig build error") from Linus' tree and
commit 82aae98df488 ("[media] staging: as102: Remove leftovers of the SPI
bus driver") from the v4l-dvb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/media/as102/as102_drv.h
index fd33f5a,0ecef9e..0000000
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@@ -37,8 -27,9 +27,10 @@@
  #define DRIVER_FULL_NAME "Abilis Systems as10x usb driver"
  #define DRIVER_NAME "as10x_usb"
 =20
 -extern int debug;
 +extern int as102_debug;
 +#define debug	as102_debug
+ extern struct usb_driver as102_usb_driver;
+ extern int elna_enable;
 =20
  #define dprintk(debug, args...) \
  	do { if (debug) {	\

--Signature=_Fri__18_Nov_2011_12_04_29_+1100_i4P7fgO1CO=1hGWX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOxa8dAAoJEECxmPOUX5FE2dMP/1/hxKd4Cnux7znrmfihpeUM
5+gfoDyvxWtbmVCc4OGnLEcMYPgJjigtsCctwfyzRDsVhl+Bcs7Dc3sWP0HRb7/R
yHl+oNKSuqN8xrQYy0uvUjdausFDEYCWZ28zNdHI2fCsSdbEbQrrIigPPM4mju9a
doGLHLkHjR1zqFRE968rxabZszzD6atMrmQRn4i/K7YxJsOArnEYx66LQ5BLhuBy
1hrIixQLZvZ7H3QVdgH9d+T0QraaAU0n2RNLqK6EVLlgMJFu+KJXZZLB7KMaXQMP
7k/3Hk9xDOgmdBMs1ImO6K8g8w5eit5osDISVwaeYPBjGYMaxQ2MXu5a3qm4cwMN
dU7RFCsQ9wanjqYcLuajug9FnKyZQvsxhPrJMFiFOicOGVKZ0nppUoPN9ArcV8Ec
FYSr0WAWYUNA3gYQlAZVxirQiRJ5YSN4MlNyWqPatTholEcJyrYcrvJiQXDV8dfR
vu4o+5w5hpjPF8PJe5H4W6+71jgidvlpOirUsJ0mug1z1YfosqOoJbE8wCV4ZDzt
dtAaox2Aeuf24sjUUOmeUzpDmhHEUCCRx2LTDxaTeHYTdDcqMY50szccOhaLgTWK
4AFN/IOr+dNl71OduSvQlBxISTyGMoAR9gw57zSTKKfKzBYCukQNrY9ORZanOq+u
xn41m6S1aktm0BvY6YkL
=V00n
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Nov_2011_12_04_29_+1100_i4P7fgO1CO=1hGWX--
