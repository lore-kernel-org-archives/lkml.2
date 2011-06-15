Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1FOCMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 22:12:16 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:46664 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1FOCMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 22:12:13 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 22:12:13 EDT
From: Eric Anholt <eric@anholt.net>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
In-Reply-To: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
References: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 14 Jun 2011 19:06:30 -0700
Message-ID: <877h8nc0gp.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Jun 2011 00:51:47 +0800, Daniel J Blueman <daniel.blueman@gmail.=
com> wrote:
> On 14 June 2011 13:23, Eric Anholt <eric@anholt.net> wrote:
> > On Tue, 14 Jun 2011 12:18:36 +0800, Daniel J Blueman <daniel.blueman@gm=
ail.com> wrote:
> >> Hi Eric,
> >>
> >> The frequent ~1.5s pauses I hit with SNB hardware in the gnome3 UI (eg
> >> whenever you hit the top-left of the screen to show all windows) are
> >> nicely addressed by your recent wake patch [1] (ported to -rc3). Thus
> >> I see no 'missed IRQ' kernel messages.
> >>
> >> As this addresses a significant usability regression, are you happy to
> >> add it to the 3.0-rc queue? I think it has very good value in -stable
> >> also (assuming correctness). What do you think?
> >
> > This one had significant performance impacts, and later hacks in this
> > series worked around the problem to approximately the same level of
> > success with less impact, and we don't actually have a justification of
> > why any of them work.  We were still hoping to come up with some clue,
> > and haven't yet.
>=20
> True; that is quite heavy handed delay looping.
>=20
> It's a pity the usual Intel font didn't make it to the programmer's
> reference manuals. Anyway, unmasking the blitter user interrupt in the ha=
rdware
> status mask register addresses the root cause. Out of reset it's FFFFFFFF=
h,
> so we don't need to read it here.
>=20
> It would be good to get this into -rc4. -stable probably needs some addit=
ional
> tweaks.
>=20
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

So you're saying that our interrupts at the top-level IMR are triggered
by the write to the status page of the lower-level ring?  That's
surprising to me.  Or do you think that this write is just happening to
trigger serialization so the interrupt comes after the DWORD write of
the seqno by the ring?  (hw folks just recently indicated that our
particular code is not expected to serialize the interrupt after the
seqno store, unless we had an MI_FLUSH_DWORD in between)

This patch has now passed 7000 iterations of the testcase that had a
~.5% failure rate before.

Tested-by: Eric Anholt <eric@anholt.net>

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk34E6YACgkQHUdvYGzw6vd4cgCeOnuRHx/8bAoYOJbtFchfQX1d
+CkAn1VrM3CLjjQfrV3RQy+9pmXzB31/
=qp2k
-----END PGP SIGNATURE-----
--=-=-=--
