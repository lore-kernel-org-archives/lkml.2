Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0E0FRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:17:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36525 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab0E0FRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:17:04 -0400
Date: Thu, 27 May 2010 15:16:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: build failure after merge of the final tree (leds tree
 related)
Message-Id: <20100527151656.889b5977.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__27_May_2010_15_16_56_+1000_UNmjB7zpN0_cswM0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_May_2010_15_16_56_+1000_UNmjB7zpN0_cswM0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/leds/leds-net5501.c:20:23: error: asm/geode.h: No such file or dire=
ctory
drivers/leds/leds-net5501.c: In function 'soekris_init':
drivers/leds/leds-net5501.c:63: error: implicit declaration of function 'is=
_geode'

Caused by commit 14e40f644b020d473415342461b7c62e3bb5e312 ("leds: Add LED
driver for the Soekris net5501 board").  Presumably only tested on x86?

drivers/leds/leds-gpio.c: In function 'of_gpio_leds_probe':
drivers/leds/leds-gpio.c:253: error: 'struct gpio_led' has no member named =
'blinking'

Caused by commit 2146325df2c2640059a9e064890c30c6e259b458 ("leds:
leds-gpio: Change blink_set callback to be able to turn off blinking").

I have used the version of the leds tree from next-20100526 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_May_2010_15_16_56_+1000_UNmjB7zpN0_cswM0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv+AEgACgkQjjKRsyhoI8zjRQCeNDRmvpRfi8cMAx6TVN/womr3
M8UAn3IqQ4+/dt3DryYdWpAACFWdO8rY
=ZRQd
-----END PGP SIGNATURE-----

--Signature=_Thu__27_May_2010_15_16_56_+1000_UNmjB7zpN0_cswM0--
