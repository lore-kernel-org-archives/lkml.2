Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab0KTCwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:52:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51679 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756329Ab0KTCwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:52:45 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        David Brownell <david-b@pacbell.net>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <20101119214412.633136072@clark.site>
References: <20101119214412.633136072@clark.site>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CnguxU8QFW5mSnm1kb/s"
Date: Sat, 20 Nov 2010 02:52:37 +0000
Message-ID: <1290221557.3818.117.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [39/45] OHCI: work around for nVidia shutdown
 problem
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CnguxU8QFW5mSnm1kb/s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-19 at 13:43 -0800, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Alan Stern <stern@rowland.harvard.edu>
>=20
> commit 3df7169e73fc1d71a39cffeacc969f6840cdf52b upstream.
>=20
> This patch (as1417) fixes a problem affecting some (or all) nVidia
> chipsets.  When the computer is shut down, the OHCI controllers
> continue to power the USB buses and evidently they drive a Reset
> signal out all their ports.  This prevents attached devices from going
> to low power.  Mouse LEDs stay on, for example, which is disconcerting
> for users and a drain on laptop batteries.
>=20
> The fix involves leaving each OHCI controller in the OPERATIONAL state
> during system shutdown rather than putting it in the RESET state.
> Although this nominally means the controller is running, in fact it's
> not doing very much since all the schedules are all disabled.  However
> there is ongoing DMA to the Host Controller Communications Area, so
> the patch also disables the bus-master capability of all PCI USB
> controllers after the shutdown routine runs.
[...]

This last bit seems like a major change in behaviour, and this commit
has only just gone into the 2.6.37 cycle.  How thoroughly has this been
tested on other OHCI controllers?  Wouldn't it make more sense to use
the same quirk condition?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-CnguxU8QFW5mSnm1kb/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATOc38Oe/yOyVhhEJAQK8fRAAoYC7MN3+zuaMTSEJxMAD266R6dTGGUoy
lRaus2lDX4OvCOgP8M+2z7w9LUafALNFetxIZScSgVw4SviM/atIP+wQdkwF/YgA
VWIOsB0UX8nwLrU8h4tzNYGEWQeN8mHAfN9iY6K4suTTbO2z5i4cgcBT/3c1iI/M
2OQSf4TEUja5bPQoBprLx/d4LsnndPcnZPwkXxfyPiIl4BLyWx8yzZlcT5nFTrUV
8p4MUdcXRoUv8WAqYOJPmvljxeivyN6lWTeWaoUguDXY6WJ0JHUblxfnpv9or3Rm
kZDQwZEr1Zjpr6nRjUnccUsFvzEP51CcAifiRyzoH6BzSkgR7kBZ3A4hZRBAkD56
N2RyLs1ODwT0AiaB7Y0rySKsuwWH8WALHN4v5iRNrMRuc64mVNrtQ0cqCRH+jkyR
Ud4Ugif0g2pQ68ximobAPt/sUZOn5GZobIqy5lGVakf1Xg8Gu7nnP3fX9E9TOHUX
gW0wkQhaStWwaT88bH6J2rSKnuJpsVMyI0MOeFBQG6JVZmSl/l0UfqvK+08qfo8x
FeR9UjBoFxr1z63J0LgR2lV03b3QAIRrgwT3oNvAi2mRQYONCzQbYa7Gmtkcm6Kc
Xutjnh2IPSOaWkUhqSfoKW1aYnCZQaNMCBQtS4iSSLjjImXDtoBesD2no2aLbv+t
SiTOm2czkbk=
=UNMZ
-----END PGP SIGNATURE-----

--=-CnguxU8QFW5mSnm1kb/s--
