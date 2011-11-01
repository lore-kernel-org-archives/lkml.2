Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1KARuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:50:20 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39672 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab1KARuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:50:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] regulator: Provide dummy supply support
Date: Tue, 1 Nov 2011 13:50:14 -0400
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, Tony Lindgren <tony@atomide.com>,
        linux-sh@vger.kernel.org, linux-omap@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
References: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de> <20111028215931.GA30366@opensource.wolfsonmicro.com> <20111028224757.GG23421@pengutronix.de>
In-Reply-To: <20111028224757.GG23421@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1776660.LEMsXGfj8t";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111011350.17425.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1776660.LEMsXGfj8t
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday 28 October 2011 18:47:57 Sascha Hauer wrote:
> On Fri, Oct 28, 2011 at 11:59:31PM +0200, Mark Brown wrote:
> > On Fri, Oct 28, 2011 at 10:26:58PM +0200, Sascha Hauer wrote:
> > >  drivers/regulator/Makefile        |    2 +-
> > >  drivers/regulator/dummy-supply.c  |   88
> > >  +++++++++++++++++++++++++++++++++++++
> >=20
> > We already have a dummy regulator driver and a fixed voltage regulator
> > driver, we shouldn't be adding a third implementation of the same thing.
> > Just use the fixed voltage regulator for this.
>=20
> I explained in my mail why I think that the current implementation of
> the dummy regulator is not suitable for things apart from debugging.

your complaints seem to be specific to how the dummy regulator gets hooked =
in=20
and not in the specific regulator implementation.  so it seems like the rig=
ht=20
thing would be to split the kconfig knobs:

 config REGULATOR_DUMMY
=2D	bool "Provide a dummy regulator if regulator lookups fail"
+	bool "Provide a dummy regulator"
+config REGULATOR_DUMMY_FALLBACK
+	bool "Fallback to dummy regulator if lookup fails"
+	depends on REGULATOR_DUMMY

(and then obviously update the .c files accordingly)
=2Dmike

--nextPart1776660.LEMsXGfj8t
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOsDFZAAoJEEFjO5/oN/WBw/0QAOPNXxnKtpFmoL8PdBc8traj
EPqZvtb7CTVjOR12pTMzp0+1me8JPb05so6j9QX3saJdYcX4hKqmbhT2P7yfv/+2
SLVk0eEqk1NUPOBv040z6blvhzJEQSLAjcvavMSpOMkC9TsNZ7NuOoRIRTWBGL3Q
U4CElHYcprYS4RjX3eY+qcHLe4+w3HWEZAHctoT+W4b247l40qvhSKxjRhqerTYT
XdO6b+dEJnFBZgTR8tzIX6PURr2lomcPLIo38layhZ/ikF1yRE/Pq1Osp5gxMmbv
BSOAmmGmUqCPbAwZUpsWYfrtXGLPPEtQoGXsWZwZuXEhmoewXEUklC8bDucK9ecv
/UiZWehK+Ne5QqcfWZMYUtbd6PrNwjIZ1EL3rVpVgTkT4XRvLUwMtFI7Esv285vv
Supr/vZpAwMaC9qOXjethgeq+B26b6X9zXxXI9iwOTFVRBfBYHCCAdQejfrFQ3fy
AkfciebOigxUM/yfkEq33VWQMwIxlF9MVkkkQkOk/+4+2mY9c5xbftm9JFFGQpsz
Mz/xLOHhuzHs+0rVzfI3fxDDnmOjqNdchS9i31gzNrqffF5DHBaMqPP2XUVLRMtr
6kTCXTG1TOcVAXpPjpyYQatDWRHi/MS2tWBprOnrifOiGwnwDrLKO/I85G7pUL3M
6DtFDB9oaS/p6eqN87BS
=ndsl
-----END PGP SIGNATURE-----

--nextPart1776660.LEMsXGfj8t--
