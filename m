Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0KYTjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 14:39:45 -0500
Received: from home.keithp.com ([63.227.221.253]:33700 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab0KYTjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 14:39:44 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2010 14:39:44 EST
From: Keith Packard <keithp@keithp.com>
To: Nick Bowler <nbowler@elliptictech.com>, Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: i915: display doesn't get on back after returning from standby in 2.6.27-rc*
In-Reply-To: <20101125161058.GA5831@elliptictech.com>
References: <20101123123234.GA3791@tiehlicka.suse.cz> <20101125155828.GC9754@tiehlicka.suse.cz> <20101125161058.GA5831@elliptictech.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Thu, 25 Nov 2010 11:31:04 -0800
Message-ID: <yunr5e9qjyf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Nov 2010 11:10:58 -0500, Nick Bowler <nbowler@elliptictech.com> =
wrote:
> On 2010-11-25 16:58 +0100, Michal Hocko wrote:
> > [Let's add Rafael for regression tracking]
> >=20
> > On Tue 23-11-10 13:32:34, Michal Hocko wrote:
> > > Hi,
> > > since early 2.6.37 (I haven't bisected when exactly) my screen doesn't
> > > get on after it got into standby mode. I have to either change to a
> > > text console and back (if it gets to standby by the screen saver) or
> > > close the lid on my laptop if I try:
> > > xset dpms force standby
> [...]
> > > Is this a known issue?
>=20
> I suspect that all of the following are the same issue:
>=20
>   https://bugzilla.kernel.org/show_bug.cgi?id=3D23122
>   https://bugzilla.kernel.org/show_bug.cgi?id=3D23472
>   https://bugs.freedesktop.org/show_bug.cgi?id=3D31803

I've provided a couple of fixes that might be relevant here -- neither
kernel nor user mode were setting the tracked DPMS state of the outputs
to ON when doing mode setting, which caused all kinds of comedy. These
should fix 23472 and 31803. I'm not entirely sure what's up with 23122,
but it's possible that it's the same issue.

The user mode DPMS tracking fix is in xf86-video-intel master, the
kernel DPMS tracking fix was sent to Chris last week.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM7rl4Qp8BWwlsTdMRAqynAJ4zeaowLccJANKqm/Y3MlHUCqB4AwCgrp20
gAu0YEYDRUwDhtlEDUC60yc=
=CYWG
-----END PGP SIGNATURE-----
--=-=-=--
