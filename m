Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab2GCOn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:43:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46967 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933090Ab2GCOn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:43:28 -0400
Date: Tue, 3 Jul 2012 15:43:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120703144325.GR29030@opensource.wolfsonmicro.com>
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
 <4FF2EEA1.6080204@linaro.org>
 <20120703132447.GN29030@opensource.wolfsonmicro.com>
 <201207031401.36262.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U5J2I87mWnf1KeOw"
Content-Disposition: inline
In-Reply-To: <201207031401.36262.arnd@arndb.de>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U5J2I87mWnf1KeOw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 03, 2012 at 02:01:35PM +0000, Arnd Bergmann wrote:
> On Tuesday 03 July 2012, Mark Brown wrote:

> > I'm really unconvinced that instnatiating the MFD cells from device tree
> > is in general a good idea.

> In general it's not, e.g. it makes no sense when the MFD is just
> a bunch of registers that are mapped to various distinct Linux
> devices. The two mfd devices on ux500 (prcmu and ab8500) are really
> buses by themselves that happen to be implemented using the MFD
> framework on Linux.

This is true for pretty much all MFDs except the pure MMIO ones.

> I don't see how we would get around representing the buses in
> the device tree because we have to refer to nodes under them
> from off-chip devices. Simplified we have something like

We can always refer to the parent device itself; there's two separate
things going on here which we can resolve separately.  One is
instantiating the children and the other is referencing the various
configuration that's needed which we don't need to do by mapping MFD
cells directly onto device tree nodes.  The MFD children can always look
at the DT bindings of their parents.

> Most of the stuff on the board is connected to the ab8500 regulators and
> gpio pins, which are also used as interrupts. In order to hook up
> the external devices in the device tree, we need to have something that
> we can point to as their interrupt-parent or the phandle in the gpio
> description.

Right, but there's no reason we have to instantiate a dedicated node for
each of these things and we should think carefully about what we're
doing.  One of the problems I've seen with people doing this stuff is
that the split we do for some of the cells in Linux is often not really
a good generic representation of the hardware (and some of them are actually
churning right now) so encoding it in the device tree isn't so helpful.
You also seem to get stuff where the MFD cells are all full of hard
coding for their parent so there's no way you could reuse them and again
we don't gain anything.

There will be some places where representing things directly in the DT
makes sense but we should think carefully before we go and do it.

--U5J2I87mWnf1KeOw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8wS4AAoJEBus8iNuMP3d5PQP/2CDug7pOqnZsQJOzPaHemYI
Rp3xbElwZ0z1c1qPygqMpOYRTN6wmh83tAOlrmx7k+Zdvm6oZ9ilfDA1srulGRCY
pMnyjVG7HFQ9U9dr5n+CxUtr/irXX7z42blTNgN/sXX6lvIoGnlan2pdZSb/9ZPt
rpERZBgUlWG0WaOAmwQSFTohiK159jTVZEnaktxEqDPawcq0GIvRKQZyTFwRY3zF
c+xFnocudH6yokjzh4O+o/U8HEOJCB27Z+N/4ltVsDVmQ+/I4bywYHmOYyjOcGGD
zq1YHK6n3EA8NN96QNyGdilbTwYlhQgEJi28/uwU2W0JKL4GNYfs+ur59+ytLO78
NbNpmfBiPPE4ko8eZ3Ga853WQoPBfLgBASs4tRCn5Yqsfl5pydfOM4E6pHpWLRxF
8WtfKrH+iCPUzOeg/B2G1W17VpgvgzCK1Ywy2xiNM4/hkkf4fAK1dVi4gkLc9pm8
WibpLr+DH/rEdpu4926UF+EdSNo3TmYgKxPHXT/rWn0WfOov8S/UPI9wLoo9gUg8
V/1L6lxLLqUJ/8Hvb/R9xnAIuqaCrLLuCByHV5ZMcn0oARhzzP/2SAnaZHh2wzK+
FbWfsoWIUtFhq74IpIEvqMNc8psBJzA4FoA344dahqEIrSnsMeTGPWtNyU6o/pFr
s2bdIgNKi/HoY+Od6o9R
=TH6T
-----END PGP SIGNATURE-----

--U5J2I87mWnf1KeOw--
