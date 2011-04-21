Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab1DUD3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 23:29:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40062 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476Ab1DUD3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 23:29:31 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110420050617.GA16756@suse.de>
References: <20110419204117.979118654@clark.kroah.org>
	 <1303263653.3464.65.camel@localhost> <20110420020128.GA27631@suse.de>
	 <1303265862.3464.77.camel@localhost> <20110420031105.GA11945@suse.de>
	 <1303274910.3464.95.camel@localhost>  <20110420050617.GA16756@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-+KwQAiSfXz6XVLHh/jol"
Date: Thu, 21 Apr 2011 04:29:15 +0100
Message-ID: <1303356555.3464.128.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+KwQAiSfXz6XVLHh/jol
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-04-19 at 22:06 -0700, Greg KH wrote:
> On Wed, Apr 20, 2011 at 05:48:30AM +0100, Ben Hutchings wrote:
> > On Tue, 2011-04-19 at 20:11 -0700, Greg KH wrote:
> > > On Wed, Apr 20, 2011 at 03:17:42AM +0100, Ben Hutchings wrote:
> > > > On Tue, 2011-04-19 at 19:01 -0700, Greg KH wrote:
> > > > > On Wed, Apr 20, 2011 at 02:40:53AM +0100, Ben Hutchings wrote:
> > > > > > On Tue, 2011-04-19 at 13:30 -0700, Greg KH wrote:
> > > > > > > 2.6.32-longterm review patch.  If anyone has any objections, =
please let us know.
> > > > > > >=20
> > > > > > > ------------------
> > > > > > >=20
> > > > > > > From: Hans Rosenfeld <hans.rosenfeld@amd.com>
> > > > > > >=20
> > > > > > > commit 9d8888c2a214aece2494a49e699a097c2ba9498b upstream.
> > > > > > >=20
> > > > > > > Remove check_c1e_idle() and use the new AMD errata checking f=
ramework
> > > > > > > instead.
> > > > > >=20
> > > > > > Clean-up patches are generally not candidates for longterm upda=
tes.
> > > > >=20
> > > > > This was added because a follow-on patch required it.
> > > >=20
> > > > Ah yes, 'x86, AMD: Set ARAT feature on AMD processors' is using the=
 same
> > > > condition.
> > > >=20
> > > > Of course, that could have been backported by referring to the func=
tion
> > > > that this removes, rather than pulling in a load of other changes w=
ith
> > > > consequent risk of regressions.
> > >=20
> > > I prefer to take original patches for stable, it makes it easier in t=
he
> > > end.
> >=20
> > It makes what easier, when?  What I see here is a bug fix that is much
> > larger than necessary, with a consequent risk of regression that seems
> > way out of proportion to the benefit.  (What actually *is* the benefit
> > of these AMD changes?)  And we have had several serious regressions in
> > the 2.6.32.y series recently, so I really don't think we are getting th=
e
> > trade-off right.
>=20
> We got a few new quirks added for AMD hardware platforms that fix
> problems.

Maybe, but I still haven't seen anyone explain what those problems are!

> It took 3 patches to get there, yes, but now, as time goes
> on, adding new ones is even easier as the .32 code matches the .39 code
> in this area due to these patches being added.
>=20
> Now if you find problems in these, great, let me know and I will work to
> resolve them.
>=20
> As for regressions, what are you referring to?

These are the regressions I'm aware of in the last few updates:

2.6.32.36: 'x86: Cleanup highmap after brk is concluded' broke
hibernation on x86-64 and some x86-32 machines (reverted in .37)
2.6.32.36: 'signal: Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from
spoofing the signal code' broke glibc aio (fixed in .37)
2.6.32.34: powerpc kdump/kexec changes didn't compile on UP or 32-bit
(fixed in .37)
2.6.32.30: 'x86 quirk: Fix polarity for IRQ0 pin2 override on SB800
systems' broke the revision check for other quirks (fixed in .34)
2.6.32.29: 'USB: Prevent buggy hubs from crashing the USB stack' broke
MUSB on BeagleBoards (still unfixed?)
=20
Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-+KwQAiSfXz6XVLHh/jol
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATa+ki+e/yOyVhhEJAQoy7g/8CCxvlQ5ZUuc4rtDSio41eHypr1E1Geqm
mT2j6Z4tAVRFnCvy/vIAF5goYgvcxqu902Ub6KGIGJiZ06IDzG8259k/jJrE+eii
gaUgFCT7+sRNjrnyjuDeo0Qxn8uM/VEr13vnISLzSpAScZFYY8Q2/v6uObA5l9Ub
YZ8A3q5FuxK6m3v5S1Jiicd/brFei7v7ibpNeI95r/Js+n+ZuPbx/mNPzWGpNNG/
fDEEhvm5F47Us49X/mtv9k4JbQ0Wj71W9ewqOF7k/374zUTOaiBD8pECDJtQn1ZG
XrLJAvgDS+C0cKTn+ajwX7v349JCVsMmL8oEjilJU5OoFOcab3hCVh34hVoRsAIZ
p6O9v8B1Q8CMvgE+fjZhkQPfZPbpOTWkismaN6ZeJHDuhWSSWChPEuhM4wXLf/AL
Xuw1srEM+HV86emjbtuMy9BXHmbGnMN3UJWsYcjCFJa1bevuSxV+r1lR0Pv0lX1i
D+3Hg/IcVOUTz9pf8qc3Ger7HYdEkjYPgNHluJAhQeIWwU1aCZcMyztFqlM0MlYn
3mkeBpLeKTP+YHFbllp4v9HqesrZoYXa3PcwqhO1rvJiRp03wy7C9uNwgsVPsNd+
C4YIdUI2yqigjXNnTNWxBz2S6pSLkr95HGhjebSAqB+kyThN+qpcPJPfhqFuhpf7
WdYpdJOhBf8=
=AGYg
-----END PGP SIGNATURE-----

--=-+KwQAiSfXz6XVLHh/jol--
