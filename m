Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2DTOnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:43:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34400 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756948Ab2DTOnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:43:00 -0400
Date: Fri, 20 Apr 2012 15:42:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
Message-ID: <20120420144256.GA6828@opensource.wolfsonmicro.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
 <20120419124204.GE3046@opensource.wolfsonmicro.com>
 <CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
 <20120419162905.GA3084@opensource.wolfsonmicro.com>
 <CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
 <20120420114602.GB3259@opensource.wolfsonmicro.com>
 <CAJe_ZhdKv_7fTj9ZhJE0JzmuhxEZn-JmSbHu615YMXoWZUei9A@mail.gmail.com>
 <20120420130134.GA5957@opensource.wolfsonmicro.com>
 <CAJe_ZhdKtK8YKo1qc8g18XrdnrQRZw2aFSkW8x3koELU10EsHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <CAJe_ZhdKtK8YKo1qc8g18XrdnrQRZw2aFSkW8x3koELU10EsHw@mail.gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 20, 2012 at 07:18:15PM +0530, Jassi Brar wrote:
> On 20 April 2012 18:31, Mark Brown <broonie@opensource.wolfsonmicro.com> =
wrote:

> > No. =A0You're failing to understand what dummy regulators are for.

> I think I do understand what dummy regulators are for and also that
> they are meant to go away some time in future.

No, they're here to stay - people will always be bringing up new boards
after all - but they're not supposed to be used on platforms.

> > =A0To repeat yet again you're not supposed to actually use dummy regula=
tors,
> > you're supposed to fully specify the regulators on your platform.

> I use dummy regulators for what they are meant for - until every platform
> completely define supplies for every consumer.
> We are not there yet, yet one 'ideal' consumer suffers because of that.

> If you ask me to go away and disable dummy and update all consumers
> and their platforms, then I say why not remove the concept of dummy
> altogether which only delays full compliance to the regulator api ?

The only reason dummy regulators are there is to provide a get out of
jail card to help keep systems booting when there's a problem with their
regulator setup.  Managing the introduction of regulator support to new
drivers is relatively hard, I don't see us getting it right first time
every time, so it's unlikely we'll ever be able to get rid of these
crutches.  It keeps people happy so even though the regulator setup is
generally trivial to fix when an issue crops up it's less hassle to have
the option.

In any case, as I've said it's not the fact that you've got a dummy
supply that's an issue for most of the cases you mention - it's the fact
that the supply is always on. =20

Even in the case where a supply might genuinely be missing (which are
very unusual, it's more effort in silicon to cope with missing supplies)
you're still stuck with guessing if the supply is missing because of
missing regulator setup or if the supply really is not physically
present.  If you really want to try to bodge in something for thingns
like this in the consumer probably a good solution is to do something
like have the driver check that it can get a sensible voltage back
though I'd be interested to see a driver that can usefully use it and a
system which did so.  Your example seemed pretty theoretical and it'd be
more usual to tie to a supply so I'd really like to look at some
concrete systems that do this.

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkXXkAAoJEBus8iNuMP3dWmsQAIgDK+Em0FyeiTwvnvdEdvul
x0Kwf9QMVJ1dhxIFpfPHAlXL2jlpv2/0cRJRfmuYDxr0FfzAsNC4BuPRNY7o+/EO
7AbuJesWPMDKtcyP8MVI17onz3vqZeH1KBYbJMjeF+GbMQ+5U01l6bHd6ei6GprC
N1xFG7ZLssFj/MKAzfIkXiOevHsEK74xyqBIptkqhOff8iWP/XsUsIKtePxGE7Gv
WUrDpJ8D64z4hfP9TSIyNgVhVRlj5vxDMtNYkr6fT002NA8uZNKUYlubvvXTNYd2
VRQhrijvkL+Teva02SC///rPhAt6rGYJoUgs1CASgelK3V/A2EJo0FgnpEhSuKRM
/tYWEoMTHzebdbelkjsOF2+FH/G79NEyDwNf7Zloh5nmkyIhKzXZVvbQBepU4/IK
qAcCL1LhKls7guW/+LLvHdfoH0/QDNnZLylnnjVwyo7W0SX4EhLibXhuXiSjP5b3
CW1/+GFNEujqdZhH2DX4e0PYlCVUbx5vwf4/94KyIw4kJjnHK7AqcxchckUAv3Ak
ojueH13xQ+pBC0LJOSqORfb0JDuGvvAyt0cQMsWrr2k0EQDtiSigamvjlIugL4xR
Hk7vsJ28Ayu6MbyPLnZsbQhVXmqTi6TbNgj66GQ2cbx9cTE9JhecROlzGcNu7cO2
i1X5F9cRdxaG/hrmVE1T
=/IHO
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
