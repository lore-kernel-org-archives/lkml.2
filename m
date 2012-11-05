Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2KEJx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:53:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2KEJx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:53:26 -0500
Date: Mon, 5 Nov 2012 10:53:15 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: SPARC and OF_GPIO
Message-ID: <20121105095315.GG5847@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuhbYIxU28t+Kd57"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:1pC+tkKd35wdMfUzq8S8IA3RcXMu7ci8J8Rge3hsMg8
 Oa0R1UDcPLWUgjuflIeT9GfstV/YTQ8Ayxu//p8lN+Iv1fEaIj
 MhV6piWJ2LP9G1HrbxfVSS3uxDoAEArcWUYgMpu8An1GuBwCVK
 dgKN7wo6ODDfiDY3Q+hRctH0GNpsAtZw4By2AtNDKXtcRQLd26
 Z9xaqJGnvGJ4/02qQ+gLDXoW4m0tQgKjSm8h+TArXr7OcmFFlo
 zoUGkD2B6y+Q0Q2ilBfQmQOOCwCbzjjM3L0J0Y/DO7YtCIq9Uu
 tYo4Rbh8TBlQeshwdMpDKWLgOJGiSGH+qxFgfx3IhgVWTPRGXz
 I0fib+7dqZdob7ltuULiGpWhQhhyLtFY+/BAOmoBJhI5pTqgNY
 sv4ViI1aUdQlKIPrwYTA9iBiQwRjdCOP8FZomtOohfe1z+K5SH
 33l3y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IuhbYIxU28t+Kd57
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[resending with David's correct email address]

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

--IuhbYIxU28t+Kd57
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQl4yLAAoJEN0jrNd/PrOhXygP/jGMHlQziQqKLTiAjztsBcJ+
35EAeHeU30ygMpJ9sVBuKbTkj3qPtkSyEYJ/W8QQxQAxvf9qJYcXEIZr5K9QtXnX
03ZpN7qFdeJJWyduC1SbT1X+xKuMnpbbGHMYCHyeR9SZG4SVRxneyTkkzP+8He5t
hfVqA0p1YbvplfYoDPHNdXYNWjZsiFQVKmoAcEz+SmuLCfm5A82mnhGhl+V0gANT
ALKJQeIPL0UwoUEsjQPKE2KWhRj1I2FRXdz2MUk4UJi+bzFgSvu1YNupMyG5RPO9
qrKM4FR88/iIm661QbQCHr92N2ifm03Yij/2U7rg8Ep9689NmmH46xk8u/OtIrXw
Y4dsp4HV0Pjt5fgNyHO5dAEq/rnXayezKSamyBXCdlgK04ALHqfm5iLUn31w/ftF
26A8b2NLiMNl4JcEZuwmQ6y/d0VNAhoTykRcfBiaPbO7yPbN3ddgyk+z88/mB+h9
i11nHnNKSYdL2Wx3GyuXcjzpu2aoUvFjo8jpH0GBQvG4VMWguNUctJ7RCU4C8Bp7
eKc5zHv2pzGwIJgQaN7dCNfSUtSAgIf1WJGdgTx22YIGWrKpoNKtw46pDvhaaAZB
GkFncassQ9rh359byZJEe8GXYu7Tkdyrh4dNJCbEcpcDn5fJJLeHQBmIG47RTDPq
kVtlIh6ds+YTlRw/Zm28
=Dxcz
-----END PGP SIGNATURE-----

--IuhbYIxU28t+Kd57--
