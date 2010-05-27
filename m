Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab0E0EOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:14:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57011 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0E0EOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:14:00 -0400
Date: Thu, 27 May 2010 06:13:58 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Robert Emanuele <rob@emanuele.us>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: Controlling Driver Load Order
Message-ID: <20100527041358.GA14070@pengutronix.de>
References: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com> <AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com> <20100526235246.GA31068@pengutronix.de> <AANLkTikj8yGSK5Ovud_k8f6jWloojqDJmQ_H6pD_IFgM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <AANLkTikj8yGSK5Ovud_k8f6jWloojqDJmQ_H6pD_IFgM@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 26, 2010 at 06:39:13PM -0700, Robert Emanuele wrote:

> Still the framebuffer device would initialize first and it would lack
> having the i2c chips it needs ready.  That is the order I'm trying to
> straighten out.

Understood. Our pointers were probably not precise enough, sorry. Please try
this patch and give a Tested-by-tag if it solves your problems.

=46rom: Wolfram Sang <w.sang@pengutronix.de>
Date: Thu, 27 May 2010 06:03:48 +0200
Subject: [PATCH] i2c-at91: use subsys_initcall() for early initialization

I2C needs to be available early, so other subsystems can access it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Robert Emanuele <rob@emanuele.us>
Cc: Ben Dooks <ben-linux@fluff.org>
---

 drivers/i2c/busses/i2c-at91.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 305c075..bea5794 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -313,13 +313,12 @@ static int __init at91_i2c_init(void)
 {
 	return platform_driver_register(&at91_i2c_driver);
 }
+subsys_initcall(at91_i2c_init);
=20
 static void __exit at91_i2c_exit(void)
 {
 	platform_driver_unregister(&at91_i2c_driver);
 }
-
-module_init(at91_i2c_init);
 module_exit(at91_i2c_exit);
=20
 MODULE_AUTHOR("Rick Bronson");


--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkv98YYACgkQD27XaX1/VRsvlwCffUOH2qAsWbaG2EmIf1Cl2H+I
8P4AoInnCS69XCfq6wIFku1hUgeT8hlG
=vGcD
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
