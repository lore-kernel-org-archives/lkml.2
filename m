Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0E1AMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:12:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38529 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab0E1AMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:12:06 -0400
Date: Fri, 28 May 2010 10:11:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree (leds
 tree related)
Message-Id: <20100528101157.aff693f4.sfr@canb.auug.org.au>
In-Reply-To: <20100528013549.9c17f6e4.sfr@canb.auug.org.au>
References: <20100527151656.889b5977.sfr@canb.auug.org.au>
	<1274960190.1931.429.camel@pasglop>
	<1274965644.24079.1427.camel@rex>
	<20100528013549.9c17f6e4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_May_2010_10_11_57_+1000_DRU.9I=QVd1dE=u9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_May_2010_10_11_57_+1000_DRU.9I=QVd1dE=u9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Fri, 28 May 2010 01:35:49 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 27 May 2010 14:07:24 +0100 Richard Purdie <rpurdie@rpsys.net> wro=
te:
> >
> > On Thu, 2010-05-27 at 21:36 +1000, Benjamin Herrenschmidt wrote:
> > > On Thu, 2010-05-27 at 15:16 +1000, Stephen Rothwell wrote:
> > > >=20
> > > > drivers/leds/leds-net5501.c:20:23: error: asm/geode.h: No such file=
 or directory
> > > > drivers/leds/leds-net5501.c: In function 'soekris_init':
> > > > drivers/leds/leds-net5501.c:63: error: implicit declaration of func=
tion 'is_geode'
> > >=20
> > > Looks like something is missing an ifdef CONFIG_X86 :-)
> >=20
> > Right, that driver/board is x86 only. I've pushed a fix.
> >=20
> > > > Caused by commit 14e40f644b020d473415342461b7c62e3bb5e312 ("leds: A=
dd LED
> > > > driver for the Soekris net5501 board").  Presumably only tested on =
x86?
> > > >=20
> > > > drivers/leds/leds-gpio.c: In function 'of_gpio_leds_probe':
> > > > drivers/leds/leds-gpio.c:253: error: 'struct gpio_led' has no membe=
r named 'blinking'
> > > >=20
> > > > Caused by commit 2146325df2c2640059a9e064890c30c6e259b458 ("leds:
> > > > leds-gpio: Change blink_set callback to be able to turn off blinkin=
g").
> >=20
> > This error looks like its from Ben's patch, probably when openfirmware
> > is enabled. I've queued a fix for this too:
> >=20
> > http://git.o-hand.com/cgit.cgi/linux-rpurdie-leds/commit/?id=3Da4b4433c=
511cf4361bb0afabba69e16632002d32
>=20
> Great, thanks.

Except, of course, Linus has merged the broken tree without the fixes :-(

Oh, well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_May_2010_10_11_57_+1000_DRU.9I=QVd1dE=u9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv/Ck0ACgkQjjKRsyhoI8xsVACgkmjaK/3shBd59NDcMQYcMlTb
qREAniVTEVXyP51txfKoBfbyfZWxl9Ww
=+7j+
-----END PGP SIGNATURE-----

--Signature=_Fri__28_May_2010_10_11_57_+1000_DRU.9I=QVd1dE=u9--
