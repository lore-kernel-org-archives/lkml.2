Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2KEJWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:22:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab2KEJWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:22:32 -0500
Date: Mon, 5 Nov 2012 10:22:19 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "David S. Miller" <davm@davemloft.net>
Cc: sparclinux@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: SPARC and OF_GPIO
Message-ID: <20121105092218.GC5847@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:hoq0Vv7QgW7V5slr1X8Dm9aWFfPLKFsZkUwQ5F4iGQA
 c3SDX/4uW2TLfonDKI0PYpxJU6v63QMX4Ar7LSQNmGUTxKC8AW
 Ag9RDbvLL+h0SdFcVLcg1a4/cgYpfoe+VrYVbMyqbi6Z12FwCE
 xud5nA1yxEiBRbBH1lUvkxfTgJ4JsBDx9mg3KKTGJkNkb/h3FM
 Q/KC5zbdG/JyyKOWTUqCLd5ji3DOjLvjiKgRIiyvJfYdVjWygf
 JBpISCg1sbk3NsQgV+3K21jjzIGsKZZFksXnFAF32khWB87DuZ
 5EkrM+ZkKkNbBKMF377/ykeo+nQZaqyKcvO5GFX3lxPHP+XF8l
 cKjWLpzcxRy77tQpyHOuvrKjfdt+b3y3vjIGzfMhKtTT4/bRxm
 Qv8cFIqhGfeGlv07opHtsNhqmyevnGD9pU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi David,

There have been a number of reports that Linux kernel builds fail on
SPARC because it doesn't support OF_GPIO, which provides the of_node
field of the struct gpio_chip.

One of the drivers I wrote (gpio-adnp) accesses this unconditionally but
only depends on OF and not OF_GPIO, so it fails to build on SPARC. A
similar problem happens with the gpio-fan driver, which defines the OF
match table only if OF_GPIO is selected, but uses it even if only OF but
not OF_GPIO is selected.

While it is clearly the drivers which are at fault here it still raises
the question as to why SPARC still conflicts with OF_GPIO. Over two
years ago, commit 5ab5fc7 made most of the OF symbols available to all
platforms except SPARC. The commit message explicitly states that this
should probably be re-evaluated.

Are you aware of any reasons why this conflict would still be necessary?
This is not only the case for OF_GPIO but likely also for OF_SPI,
OF_I2C, OF_IRQ and OF_ADDRESS. Shouldn't those all work even on SPARC
nowadays?

Thierry

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQl4VKAAoJEN0jrNd/PrOhSwMQAK5hcpHzexhkfrD2MKvh4Sy6
Bz2wtVn8LpjBczKmYD9cAK7jz674I8Tl9OfpaJ4U8cZcpYAbZJSj0mTx11Uef8yO
MSsdS5yLP6Wfy1CFNV5C+sArcXkhuyhnce9gpMKIZRoZOQF77sueb+8OQcNFNwIW
wxR6lnH+Jj+v4j/9KLRsw45I4WmwJVLuqlWUyfAFbEQwHx0nOekcXVTzz/jUbnFu
mH0y58RcyrGCzHa9w3EaZrZO178pH2y/yAkNbCcLkSb7urRigcA3dO2Y4jq6OGqU
v/WFgcDftPzETOpYTBy8FxXWDadIfbJwNgfptayenD6XJMasbsUtYcduxVOiF9WJ
cvcelarHSFsTxzE9rrNv85R9KlF0WtiKC8Fgb7UIgfFxFhfiB28EK7h+HgUTO+Pw
GpNQWiaWrVtTAZBjX2CUBPGlGbHfS6frvE8fvUVoeib9t5r47H18cEbGZm2hLcIH
T7VigvvX8nqutsXjB2jU2kMWWRsriIQdTqzlfC8szBq6fiQ9iKdy/VrH5u9RkHtz
VOvyKGQHoIdixrw9ZCefNyErDE6J3IYJnRuMcJd1Jb2D6MVcb7Z+/7wDMIVBelIT
tsl8qRyGUASM0M4BSAeizoHV86DrLFSIt3bVRbgFxLCi5OHz7dI6wMrfIKugkSJs
nK2mXtBf/s5HQoH9A1jJ
=CyMA
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
