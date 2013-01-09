Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab3AIMZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 07:25:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45745 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757506Ab3AIMZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 07:25:54 -0500
Date: Wed, 9 Jan 2013 12:25:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130109122550.GA20956@opensource.wolfsonmicro.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <1357555480-24022-6-git-send-email-mika.westerberg@linux.intel.com>
 <20130108110228.GM4544@opensource.wolfsonmicro.com>
 <20130108124153.GJ13897@intel.com>
 <20130108131008.GW4544@opensource.wolfsonmicro.com>
 <50EC90C3.2090604@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <50EC90C3.2090604@intel.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 08, 2013 at 10:33:55PM +0100, Rafael J. Wysocki wrote:
> On 1/8/2013 2:10 PM, Mark Brown wrote:
> >On Tue, Jan 08, 2013 at 02:41:53PM +0200, Mika Westerberg wrote:

> >>Do you mean enabling CONFIG_COMMON_CLK on x86?

> >Yes.

> Why so?  x86 doesn't have a notion of direct clock control, at least
> not on the ACPI systems.

So, a couple of things here.  One is that your SFI systems *do* have
user controllable clocks so they really should be using the clock API.

The other is that even if the CPU doesn't want to use clocks off-CPU
devices may wish to - for example, a PCI card using off the shelf
components or in this case a device on the SPI bus on the laptop which
requires a clock and wants to manage it at runtime if possible.  We
should be able to arrange things so that drivers can work with clocks
using the standard clock API.  I'm really hopinng that having the clock
API will eventually enable us to work with clocks in off-SoC devices but
right now the only option is open coding.

> >I'm sure it's not beyond the bounds of possibility that we could solve
> >this problem...

> No, it isn't.  Any suggestions?

Well, the most obvious solution would be to just hard code this
information in the kernel and set it up based on what you do know.  For
example if this is a SoC-internal clock then set it up based on knowing
the SoC (this seems to be basically what Mika is suggesting).

> >It is something that needs to be resolved for your smartphone SoCs for

> We're not talking about smartphones and even not about SoCs here, sorry.

> This is a laptop CPU that happens to have an SPI controller integrated.

These are still x86 systems so are part of why it seems like a good idea
to make the clock API available on x86.

> >this and for other things like platform data for external chips, what's
> >actually happening in practical systems here is that people are just
> >hacking the arch code as there's no mechanism for providing
> >configuration at present.

> I'm not sure what you're referring to, but here we have ACPI as a
> configuration mechanism.

> Which doesn't allow us to control clocks directly.

Right, and because the BIOS guys don't provide any mechanism for
handling this stuff using the BIOS information what people actually
deploying systems are doing is just hacking the arch code which gets us
the worst of both worlds - we have to put things into the BIOS but we
then have to put extra information into the kernel to actually make
things functional.

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7WG1AAoJELSic+t+oim9svcP/1nZVvFaomBKkz3LRmOuj9uW
uLOlCwQQQTYXALU/7vq4elC4s3DUn58oQDUgzFLWN++cKIa4u1dwBte8atLO9ODt
LUE85BlnCJd4gZvkeCUIxvfDxe3C90S7apUC/WgaZqG85iTRnBaRhrYG0LifpuIZ
rRZJcfqg61DHsbCRkjRVSYsS5dX3nZRtxXhvGR2XExW17Vol4GooYLgsS/UJJj3H
2rU0pxy1nwGoS+ZomET7ukdi2/qIcHieDzn/UPfpNuVEh7hz/Dxzi8o5yNSnDOlo
tcidDyg8dQA6qzwzh/+0eC6UsMTH61LNwQVarruWYLKypkkM0hPco1B7QDTvR5qe
XyUIOXNPx8411DVTwTaSQWtGQjEOHgRpoVsUt4fHXu/TEmkZxmnKdVH4b4K36JAj
gKOzkB7Vu+0ET0VnO48LVOh4GvG8ldh6kxwQ7R+WACQa9WIt3CU+lMaTyJxoYeyp
Z/G1nFyShgaoDrpBwU5tFUdwNXXKpd3yfZsJZXZKIR6Okl2dpE0VdQ2yqMy6DDUy
T4l6amWt1872e4Slx41E/sX7T6xtoeyUrGwqaW4wqnUvwvoRM6CqqabvZ5PpD3UT
Bx5lv/o5crToaILQWsfIHwOjILGyrMdvHSYfREPll1FVCn5TiOI/jGCedV4DfRcL
BBFscAVMc7huwxYeH0FE
=6Glt
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
