Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab0E0Pf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:35:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52235 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab0E0Pfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:35:55 -0400
Date: Fri, 28 May 2010 01:35:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree (leds
 tree related)
Message-Id: <20100528013549.9c17f6e4.sfr@canb.auug.org.au>
In-Reply-To: <1274965644.24079.1427.camel@rex>
References: <20100527151656.889b5977.sfr@canb.auug.org.au>
	<1274960190.1931.429.camel@pasglop>
	<1274965644.24079.1427.camel@rex>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_May_2010_01_35_49_+1000_bDQs/+J+I.acJ8gF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_May_2010_01_35_49_+1000_bDQs/+J+I.acJ8gF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Thu, 27 May 2010 14:07:24 +0100 Richard Purdie <rpurdie@rpsys.net> wrote:
>
> On Thu, 2010-05-27 at 21:36 +1000, Benjamin Herrenschmidt wrote:
> > On Thu, 2010-05-27 at 15:16 +1000, Stephen Rothwell wrote:
> > >=20
> > > drivers/leds/leds-net5501.c:20:23: error: asm/geode.h: No such file o=
r directory
> > > drivers/leds/leds-net5501.c: In function 'soekris_init':
> > > drivers/leds/leds-net5501.c:63: error: implicit declaration of functi=
on 'is_geode'
> >=20
> > Looks like something is missing an ifdef CONFIG_X86 :-)
>=20
> Right, that driver/board is x86 only. I've pushed a fix.
>=20
> > > Caused by commit 14e40f644b020d473415342461b7c62e3bb5e312 ("leds: Add=
 LED
> > > driver for the Soekris net5501 board").  Presumably only tested on x8=
6?
> > >=20
> > > drivers/leds/leds-gpio.c: In function 'of_gpio_leds_probe':
> > > drivers/leds/leds-gpio.c:253: error: 'struct gpio_led' has no member =
named 'blinking'
> > >=20
> > > Caused by commit 2146325df2c2640059a9e064890c30c6e259b458 ("leds:
> > > leds-gpio: Change blink_set callback to be able to turn off blinking"=
).
>=20
> This error looks like its from Ben's patch, probably when openfirmware
> is enabled. I've queued a fix for this too:
>=20
> http://git.o-hand.com/cgit.cgi/linux-rpurdie-leds/commit/?id=3Da4b4433c51=
1cf4361bb0afabba69e16632002d32

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_May_2010_01_35_49_+1000_bDQs/+J+I.acJ8gF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv+kVUACgkQjjKRsyhoI8yjIACeNJIEQrup6F1uoLvJXj+Edk57
tH4AoIKIUfDlNhRIdORFHMQUpnyeqEC8
=vYRc
-----END PGP SIGNATURE-----

--Signature=_Fri__28_May_2010_01_35_49_+1000_bDQs/+J+I.acJ8gF--
