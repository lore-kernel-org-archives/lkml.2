Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2HSOzC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 10:55:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42995 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab2HSOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 10:55:00 -0400
Message-ID: <1345388084.22400.3.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 32/37] drm/i915: correctly order the ring init sequence
From: Ben Hutchings <ben@decadent.org.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>
Date: Sun, 19 Aug 2012 15:54:44 +0100
In-Reply-To: <CAKMK7uGYgJvWs-BYoPUwNjcmM8xFYJZhpBpyetYzoj_4br5XwA@mail.gmail.com>
References: <20120817030243.807605523@decadent.org.uk>
	 <20120817030248.892667316@decadent.org.uk>
	 <20120817232956.GG4039@herton-Z68MA-D2H-B3>
	 <CAKMK7uGYgJvWs-BYoPUwNjcmM8xFYJZhpBpyetYzoj_4br5XwA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-u+YNtcxWpAyTv46zTmUk"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-u+YNtcxWpAyTv46zTmUk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-08-18 at 12:04 +0200, Daniel Vetter wrote:
> On Sat, Aug 18, 2012 at 1:29 AM, Herton Ronaldo Krzesinski
> <herton.krzesinski@canonical.com> wrote:
> > On Fri, Aug 17, 2012 at 04:03:15AM +0100, Ben Hutchings wrote:
> >> 3.2-stable review patch.  If anyone has any objections, please let me =
know.
> >>
> >> ------------------
> >>
> >> From: Daniel Vetter <daniel.vetter@ffwll.ch>
> >>
> >> commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 upstream.
> >>
> >> We may only start to set up the new register values after having
> >> confirmed that the ring is truely off. Otherwise the hw might lose the
> >> newly written register values. This is caught later on in the init
> >> sequence, when we check whether the register writes have stuck.
> >>
> >> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> >> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=3D50522
> >> Tested-by: Yang Guang <guang.a.yang@intel.com>
> >> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > [...]
> >
> > With this commit on 3.2, i915 fails to initialize on a G41 based machin=
e
> > I have here:
> >
> > [   36.894261] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
> > [   36.894265] i915 0000:00:02.0: setting latency timer to 64
> > [   36.933118] mtrr: type mismatch for d0000000,10000000 old: write-bac=
k new: write-combining
> > [   36.933121] [drm] MTRR allocation failed.  Graphics performance may =
suffer.
> > [   36.933467] i915 0000:00:02.0: irq 42 for MSI/MSI-X
> > [   36.933471] [drm] Supports vblank timestamp caching Rev 1 (10.10.201=
0).
> > [   36.933472] [drm] Driver supports precise vblank timestamp query.
> > [   36.933498] vgaarb: device changed decodes: PCI:0000:00:02.0,olddeco=
des=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
> > [   36.969669] [drm:init_ring_common] *ERROR* render ring initializatio=
n failed ctl 0001f001 head 00001074 tail 00000000 start 00001000
> > [   36.969763] vga_switcheroo: disabled
> > [   36.969765] [drm:i915_driver_load] *ERROR* failed to init modeset
> > [   36.987444] i915 0000:00:02.0: PCI INT A disabled
> > [   36.987453] i915: probe of 0000:00:02.0 failed with error -5
> >
> > Taking a look at it, I suspected of a timing issue, especially looking =
at
> > this commit, which isn't on 3.2:
> >
> > commit 18ef6f6c70a6cc36ee71e4a98a68901229
> > Author: Sean Paul <seanpaul@chromium.org>
> > Date:   Fri Mar 16 12:43:22 2012 -0400
> >
> >     drm/i915: Add wait_for in init_ring_common
> >
> > And picking it made the issue go away, so the extra delay helped and is=
 needed
> > with 0d8957c8a90bbb5d34fab9a304459448a5131e06 applied here.
>=20
> Good catch, I've forgotten to check whether all the recent ring_init
> patches have gone  through cc: stable. For the stable team, please
> pick up both patches:
>=20
> f01db988ef6f6c70a6cc36ee71e4a98a68901229 and
> 0d8957c8a90bbb5d34fab9a304459448a5131e06
>=20
> Note that all kernels that need f01db backported also need
> b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 (to fix a regression
> introduce by the former).

3.2.y already had the second and third of these, but not f01db98
'drm/i915: Add wait_for in init_ring_common'.  So I've added that.

I don't have commit 18ef6f6c70a6cc36ee71e4a98a68901229 here, but I
assume it's a cherry-picked version as it has the same subject line.

Ben.

> Yeah, the ring init sequence is a fickle beast :( but I'm pretty sure
> with these three patches, stable kernels should be up to date and have
> all the latest fixes.
>=20
> Yours, Daniel

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-u+YNtcxWpAyTv46zTmUk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDD+NOe/yOyVhhEJAQq52w//Yln6zuDZh02frr+BJHFYUwmxOi4YViQj
Y2tl3/HCFbRK0uYL+kI9BWkAOeosT5KzPyq3VZirgmIQy3b0S5NmjHfn+Iw/oiou
gCYRRKVOFNUwvve62BUNXzWdspboPjSXDlvjqmrqnJzVEtWnSU01WRoMoCRO5t6d
nggg9UXbKa7v70L30iG6GVlpwFNx6FeAi7+HPruX/dBFn2HMAqFQDFTPzHXIK5yz
kRGoixNoiV+eNMUdLylnH0qqvISf4UHPWbNlxmvbSnpBmkBdgPXQiSikQ7izh4qi
zo3inGv21tLXMA9deAJhMu9yM0U3CM6BTGqam/udKR++iK5WXujAsp5znE4HE/Y6
1SiQrDU0CMtItg5/beScA+D+dNOu5XB7oGYnGKzv7VTRLutOL5KQWQqMHUIyAipl
wU5Xpv/mS8afzgyfERVEVrqx+wGMCS/v/uBmFZyviV1FbJ2zTStUMmrAxqIWpUBv
Q58ZIzyFvtj5KfXjO/JqfpsohtAFEL3QfpsrJwXTCbGxZUhIMq4TkQXK59Q9MsQ2
adDzGwKESGYYjFEIvQV3FLowa1RMsZb39Iz89H2JdouYdhtarZ65UTvi0aeP88fJ
y5JwR1Mwof0ogLygTyWKlb+oCUm980DuZ2Fbx0gD/XUAZNbEy8HQ0VA6PZSzByQy
uX6+NeWQo1s=
=mOZa
-----END PGP SIGNATURE-----

--=-u+YNtcxWpAyTv46zTmUk--
