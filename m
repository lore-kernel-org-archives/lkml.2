Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2GBSd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:33:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48645 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666Ab2GBSd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:33:27 -0400
Date: Mon, 2 Jul 2012 19:33:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alessandro Rubini <rubini@gnudd.com>,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux@arm.linux.org.uk, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Message-ID: <20120702183324.GA29030@opensource.wolfsonmicro.com>
References: <4FECB95D.7010200@zytor.com>
 <20120701104401.GA4352@mail.gnudd.com>
 <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com>
 <201207021658.27755.arnd@arndb.de>
 <20120702180518.GA25995@sirena.org.uk>
 <4FF1E37D.7050103@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <4FF1E37D.7050103@zytor.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 02, 2012 at 11:07:57AM -0700, H. Peter Anvin wrote:

> If there is a dependency there it should be registered, regardless if
> x86 enables the clock API.

Not really, what we *should* have is the clock API available (at least
for build purposes) everywhere.  The current situation where the API is
randomly available on some architectures makes it unusuable in generic
code which is nuts and wasting time and effort, you either need ifdefs
or Kconfig hoop jumping in all the users which isn't at all sane and
means if you're doing anything generic you still need a backup plan.

What should be happening with this is the same as happens with all the
other similar APIs - the API should stub itself out where it's not
provided and the default should be that all architectures use the
generic implementation.  The overwhelming majority of clock API usage is
just enabling the clock only while the device is running to save power
when it isn't which is totally amenable to stubbing out on platforms
that don't support that level of power management.

> Last I saw I saw a patch to that effect, asked what the benefit was, and
> got no answer.

Are you positive about that?  I don't recall you replying any of the
times I sent out the patch and my mail archive isn't contradicting me
either.

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8eklAAoJEBus8iNuMP3dw2EP/38nYqFWf+gkQtzpYMjOUQmj
tKFxCodmY7aXWKi087Hrsyzo/DA7h4tJSrCPlhBZiaWM0sX5/iziEsbV+tLWSEG+
FPDEaxXu8NdBlSQyFZqdwFlcRnU4dw9zSs3sFDXw+itS1xybjtfLhavit8KKqBNV
88JO8XWJbJVl8sH/Z84LukJ/jYMCDPQXNtKud1pHOvd1euW43sHw7OYeWWMaCNzZ
1tqyLUHd74XVyEBGGfqFqMT5uYOGwMLR+LK2OxSWZIOVObBf8qQ+6WGNSc0Pm99u
w/wrsFF6eYiNPsCPlgVQgFG06BtrDbFn7npbp1lAIG+8ehC+F0V/ICC+sc6eSCGG
gfMLpPI0pGwnpVu6nsaVhFrlHY2zITFU9X27eW0ZySOvGeJna4xCu9Ls+baEqg8d
UIMTXE7+sd8J0VZn7K+s/LKRnQgTOWgVBliZ1spVplKnzWsOwgtnhqD2J9E1kPBQ
ROdTnP+qwcfjDMiD6Nf/q0EEqOrJgjh9qBzOGWmIG7ExZpkYPoEIh2CTkNFKpjIz
fgFVJKnVcQdo8kdKtH+J8Vk6fgi7bfvGs+aOPCwG4qrRJDpjCQFYuMoGI5FDrFlM
Lbq7aO/mCYKvtjXTyIflWmtV9m9AZT0WlGCg50SNvt9pvSep/AHIxOlJkLo2WEIW
SPIlNTQZi8OVB0W0lFUm
=wn04
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
