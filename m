Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab0GBU5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 16:57:40 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:48458 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0GBU5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 16:57:39 -0400
From: Eric Anholt <eric@anholt.net>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [resend] intel_agp: Don't oops with zero stolen memory
In-Reply-To: <201007022159.21848.linux@rainbow-software.org>
References: <201006161013.53612.linux@rainbow-software.org> <87aaqa2560.fsf@pollan.anholt.net> <201007022159.21848.linux@rainbow-software.org>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Fri, 02 Jul 2010 13:57:36 -0700
Message-ID: <87zky9iou7.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Jul 2010 21:59:20 +0200, Ondrej Zary <linux@rainbow-software.org>=
 wrote:
> On Friday 02 July 2010 00:44:39 Eric Anholt wrote:
> > On Wed, 16 Jun 2010 10:13:52 +0200, Ondrej Zary <linux@rainbow-software=
.org>=20
> wrote:
> > > When "onboard video memory" is set do "disabled" in BIOS on Asus
> > > P4P800-VM board (i865G), kernel oopses with memory corruption:
> > > https://bugs.freedesktop.org/show_bug.cgi?id=3D28430
> > >
> > > Fix that by cleanly aborting the initialization.
> > >
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >
> > I haven't seen a system with that option before. Is the integrated
> > graphics still supposed to work at that point, or is it "graphics is
> > disabled."?  What do other OSes do here?
>=20
> Testing it right now with Windows XP. Integrated graphics works as second=
ary=20
> only when the "onboard video memory" is set to "disabled"! If anything ot=
her=20
> is set (e.g. 1MB or 32MB), the driver does not load (code 10).

OK, I was thinking in that case that we should fix the AGP driver's math
so that it correctly set up a chip with no stolen memory allocation.  On
the other hand, I don't think we know what the correct math is, so maybe
we should just go ahead with disabling AGP in that case.


--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwuUsAACgkQHUdvYGzw6vcjYwCgizlGyo6qon/ZMlA5dY92E5jE
mbcAoJSyjxDe+6ibjLo6F5aaeGaUcOaQ
=95P2
-----END PGP SIGNATURE-----
--=-=-=--
