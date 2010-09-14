Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0INDn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 23:43:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50665 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab0INDn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 23:43:27 -0400
Date: Tue, 14 Sep 2010 13:43:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: linux-next: build failure after merge of the final tree (mfd tree
 related)
Message-Id: <20100914134321.5eee798a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Sep_2010_13_43_21_+1000_sqzy2DRlrV4ktv2u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Sep_2010_13_43_21_+1000_sqzy2DRlrV4ktv2u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/built-in.o: In function `__crc_pwm_free':
(*ABS*+0x24ba6d1e): multiple definition of `__crc_pwm_free'
drivers/mfd/built-in.o: In function `.pwm_free':
(.text+0x1ab3c): multiple definition of `.pwm_free'
drivers/misc/built-in.o:(.text+0x2620c): first defined here
drivers/mfd/built-in.o: In function `__crc_pwm_request':
(*ABS*+0xc1f4ec93): multiple definition of `__crc_pwm_request'
drivers/mfd/built-in.o: In function `__crc_pwm_enable':
(*ABS*+0x9d09808d): multiple definition of `__crc_pwm_enable'
drivers/mfd/built-in.o: In function `.pwm_enable':
(.text+0x1abc8): multiple definition of `.pwm_enable'
drivers/misc/built-in.o:(.text+0x26278): first defined here
drivers/mfd/built-in.o: In function `.pwm_request':
(.text+0x1a774): multiple definition of `.pwm_request'
drivers/misc/built-in.o:(.text+0x2604c): first defined here
drivers/mfd/built-in.o: In function `pwm_config':
(.opd+0x1ce0): multiple definition of `pwm_config'
drivers/misc/built-in.o:(.opd+0x3000): first defined here
drivers/mfd/built-in.o: In function `pwm_free':
(.opd+0x1d28): multiple definition of `pwm_free'
drivers/misc/built-in.o:(.opd+0x2fd0): first defined here
drivers/mfd/built-in.o: In function `pwm_request':
(.opd+0x1cf8): multiple definition of `pwm_request'
drivers/misc/built-in.o:(.opd+0x2f58): first defined here
drivers/mfd/built-in.o: In function `__crc_pwm_disable':
(*ABS*+0xb0493b18): multiple definition of `__crc_pwm_disable'
drivers/mfd/built-in.o: In function `.pwm_disable':
(.text+0x1aa24): multiple definition of `.pwm_disable'
drivers/misc/built-in.o:(.text+0x2613c): first defined here
drivers/mfd/built-in.o: In function `pwm_enable':
(.opd+0x1d40): multiple definition of `pwm_enable'
drivers/misc/built-in.o:(.opd+0x2fe8): first defined here
drivers/mfd/built-in.o: In function `.pwm_config':
(.text+0x1a648): multiple definition of `.pwm_config'
drivers/misc/built-in.o:(.text+0x26358): first defined here
drivers/mfd/built-in.o: In function `pwm_disable':
(.opd+0x1d10): multiple definition of `pwm_disable'
drivers/misc/built-in.o:(.opd+0x2fb8): first defined here
drivers/mfd/built-in.o: In function `__crc_pwm_config':
(*ABS*+0xc23f5b9): multiple definition of `__crc_pwm_config'

Caused by commit 03f582a93ecca6e9584b622570022abf08ed03ec ("misc: Add
ab8500 pwm driver").  I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Sep_2010_13_43_21_+1000_sqzy2DRlrV4ktv2u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMju9ZAAoJEDMEi1NhKgbsE7cIAJMOWJzwzVO+9YUb4YJ/W9Y1
gfYxCGw+xrd2J82bEl1LPl8P2+jzJEnU4MqOK58sWXnpJOdzju1Qpa19VngbVdDi
r+NK1ERNHTWoa6ccnZVCfg9lGiMl8d39wo9X0uSgqSAU86kOFje5dd7li3ITrPZp
A1rLQCD8/99RE7IW9TqPr8q2bz5sPzTbKzspuJ1to4xxQqLINN91nEi8lNJfMUtF
PpmEd18zy9zRwlHtouUdKUQYz/H0N7PyOAk+FMnnPUY9gGjRkdFp4sSbYfBVGt9L
gdMzip86D6khSG0pZqkDlEU7wyNGitv4kgtEcMgKG4KQBZGvRzpAUk7HaCo3nHY=
=8gn8
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Sep_2010_13_43_21_+1000_sqzy2DRlrV4ktv2u--
