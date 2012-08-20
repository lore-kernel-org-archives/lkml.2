Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2HTRwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:52:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45208 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab2HTRv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:51:58 -0400
Date: Mon, 20 Aug 2012 18:51:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120820175155.GH26991@opensource.wolfsonmicro.com>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
 <201208140942.54773.arnd@arndb.de>
 <CACRpkdYbOBEPNbCdfi+=gupdqS8_7t7MpOgXs7VCVTs8Y3j_mQ@mail.gmail.com>
 <20120820083640.GH8450@gmail.com>
 <20120820121055.GA26991@opensource.wolfsonmicro.com>
 <20120820125531.GA20242@gmail.com>
 <20120820162923.GF26991@opensource.wolfsonmicro.com>
 <20120820164949.GB22749@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="boAH8PqvUi1v1f55"
Content-Disposition: inline
In-Reply-To: <20120820164949.GB22749@gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--boAH8PqvUi1v1f55
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 20, 2012 at 05:49:50PM +0100, Lee Jones wrote:
> On Mon, Aug 20, 2012 at 05:29:23PM +0100, Mark Brown wrote:

> > All of the regmap devices could use this.

> Only if they have linear domains and don't support DT.

Neither of those restrictions really apply...

> If they don't have linear domains there's no point, if they support DT
> then they can use it as it is.

All this stuff just works for any IRQ domain type, there's no
requirement for a particular one.  It's not urgently exciting for legacy
domains but it's not harmful either and pushes all the handling of this
stuff out of the MFD core and into the irqdomain code which is
definitely an abstraction win.

As far as DT goes supporting DT isn't enough, the current code will only
work on systems that actively use DT and do so using a particular style
of binding.  Since the majority of Linux architectures don't support DT
at all and it's not universally deployed on those that do this means
that generic drivers can't rely on it, and even drivers that use DT
might not be using the binding pattern which the framework code now
uses.

Indeed now that I think about the above isn't this going to be actively
harmful for generic drivers if they use this pattern for their bindings?
On DT systems the framework will unconditionally do the mapping but on
others no mapping will be done.  The function drivers don't know if the
mapping has been performed or not.

Unless I'm missing something here we need to fix this before the merge
window...

> To stop being DT dependent we'd need to remove all hand-rolled stuff=20
> that these drivers are currently using, or else they will be attempting
> to convert and already converted VIRQ value.=20

Well, yes - using framework code would be the goal here...

--boAH8PqvUi1v1f55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMnklAAoJEFJkBDiqVpZ4L0wQAJjIgsl8s/mI5sm7+vcOCOJS
u5eeRhRbSRV9yk3bclMZ5zgXb1tbHlPCF73JbvMBljaVFXTgMTJyqXn7uP64lRvz
0lu5TFF+aJGBYsI5BrtRixTRvClPOo1eyKa4ic/p1wWJ1QFyhjh+5cYDIMMMWSRj
Huwiuh+J7xAHiPit1DXVj9zMDTmEVWJILAoIIuXZP6ye0a/DIdVN6/pcRUSPZE+7
4S5a3CQ+q4SAGvyicHUF6sx31P9rSpTh5fNTlSUK/OTwYdSS40Bb1k8Hv3VGA2wz
GdY1cig1Yrv8Y8LClS5bkR3Ob6kF/en62VoushcntET6jH8N4IEjTYbJ1sKtiO1l
+JuAmKt3o7k2q/uboWwK5UJF2TswPgeZb/qorN2CD4YNosN4vvTvLfd8jjT0/8MK
caPFYGnvaMP7W/2Jt7z6xj6ryMrKVphYeRxkD6Sfpua+1gVgSZlhx4hurd0JvZuc
yOkrKD+QxbNE7HKtcpFlD9EccOT4GkIXbol/+IN+VxJu1/rueaqAmKDIWbAPS/+r
O036fTQC67a/+zCwO4SU6AXOaffN8Ab0x77SFCa92qEnv7VY+fi0E9e7EoQLyk03
ld7AmS+qV8q7b0rrMtAug48B0GpSDyvJFhsr7x63l2M7Zk65vMDnHP/IooXxwnXT
GHbuY92H0kI4zw1EQoxl
=fUWB
-----END PGP SIGNATURE-----

--boAH8PqvUi1v1f55--
