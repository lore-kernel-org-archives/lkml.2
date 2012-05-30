Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab2E3MOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:14:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53735 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124Ab2E3MOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:14:51 -0400
Date: Wed, 30 May 2012 13:14:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, alsa-devel@alsa-project.org,
        lars@metafoo.de, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH v5] sound/soc/lapis: add platform driver for
 ML7213
Message-ID: <20120530121449.GI9947@opensource.wolfsonmicro.com>
References: <CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com>
 <20120326154009.GA17506@sirena.org.uk>
 <CANKRQnhn=ALR0ucv5gnvwnxwxBQX4ajm9Jo5qC0fL-EFjDdoZg@mail.gmail.com>
 <20120523093857.GC4085@opensource.wolfsonmicro.com>
 <CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com>
 <20120524100742.GH5361@opensource.wolfsonmicro.com>
 <CANKRQnj_LdGQPYPV7d5NNZBx8oM5aAGHu4qZidiiS6C4eNtNJQ@mail.gmail.com>
 <1337941231.1580.19.camel@vkoul-udesk3>
 <20120527221956.GB25019@opensource.wolfsonmicro.com>
 <CANKRQnhwkhGUHi6WQhw-sRJuKari3SLcipCJXVp27OZ29=Vxkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CNK/L7dwKXQ4Ub8J"
Content-Disposition: inline
In-Reply-To: <CANKRQnhwkhGUHi6WQhw-sRJuKari3SLcipCJXVp27OZ29=Vxkw@mail.gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CNK/L7dwKXQ4Ub8J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 30, 2012 at 07:50:28PM +0900, Tomoya MORINAGA wrote:
> On Mon, May 28, 2012 at 7:19 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:

> > Nobody has written the code, this is the problem! =A0If the code is not
> > there, you should try to write it. =A0If there is some great problem
> > writing the code then you should t

> The latter of the above seems dropped...

=2E..tell us.

> >> First you should not be writing your own dma driver, it *needs* to use
> >> dmaenegine. We already have bunch of driver supported, so there may be=
 a

> > He's already done that, their current code is all open coded dmaengine
> > stuff.

> I don't understand why you say so ?
> I don't use any own dma driver, right ? I use only dmaengine's.
> If there is own, let me show.

Please re-read what I wrote.

> > The existing code is far from nothing, there is a fairly substantial
> > dmaengine library there already which should share a big chunk of code
> > with any cyclic support. =A0If you were saying "this is too hard for
> > $REASON" that'd be one thing but that's not what you're saying here.

> If our ASoC supports cyclic dma mode, we must modify both pch_dma
> driver and our ASoC driver.

No, all current mainline drivers using the library use cyclic DMA.

> I don't want to do this.
> Because I can't understand the merit. In plain words, to me, this
> looks insignificant things.

The purpose of this change is to factor code out of individual drivers
into generic code rather than having lots of people writing exactly the
same code.  Code duplication at this level is pointless and makes more
work for everyone who will have to maintain the code going forward.

Having looked at Russell's out of tree code I'm even more convinced that
the amount of new code needed for non-cyclic DMA should be pretty
trivial.

> > It's possible that there is actually some substantial difficult but
> > my first instinct would be that it should be relatively straightforward.

> Let me clarify your saying again.
> Which do you want ?
>   1) pch_dma must support cyclic dma mode and our ASoC driver must use
> the cyclic dma function.
>   2) Non-cyclic dma engine should be added to alsa-dmaengine by myself.

Either of these options are fine.

>   3) Other

This would be someone else doing one of the above things.

--CNK/L7dwKXQ4Ub8J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxg8xAAoJEBus8iNuMP3dmkoP/24tPcKTBkKqNGNzLWv5ebyH
SMVn6xDAL+YB0Ld0P6f5L16W5HFi46SgIlCprZvIf7+WVgsgUE1FG8VFfZ7lxbin
uAKWHSaXfJp2Se+yX1u1ySgEUX0YfuKzKn3uZxVOm/Zmx+G3X8HwYljdKInG09/B
Yjbl72ady3dxgaEi9HOf3iIXbqSELjHYnThGN0vBkz6olFAL9Vgc4hwgXOzC5A7P
dnq3I7MkpI33NfGw4OBiqAV+21uXtYkqvUciV3iLuFJ7gBGGWZuMNNACgK8vMzzP
IuvQHTMdUa5HzhyBPVIhZCBewoGAvgyg/6dKF6WTGI2iRdYhT4SzcAlhZNqqU9hA
xPcrQpuyqucPQeF29Ebhl0MPW/V9L9uSpTrclqBIzyuOIVL7fIU+pB2UzpxMQ7VS
RgwiybCz2+b7pN3Si4dsTyPCfsh2W2EjKBIdWQ5zQlC7YaZQeDGT2uF/co56M5OB
FoooWLaDQAJoFJDu/myiCZk0G9PLiwK33eM9xKE+CXFmp2albwjuk/4VYjNxqpy5
VkgmikWnu+998GW25ss3/KpCIaiCgcyLY8aVQMCP4RDmdMJ6NemfapE2kL861Nh1
fi/QFQJdGaG9dyQLzzhnBpv05ygGT+qObDXRrShTxw6cKM6wlt6oc6cVDBZ0dFlE
xNqAxVixJDi7g1jNZYXQ
=SB2k
-----END PGP SIGNATURE-----

--CNK/L7dwKXQ4Ub8J--
