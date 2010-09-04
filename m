Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0IDQmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 12:42:24 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47610 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab0IDQmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 12:42:24 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
From: Martin Steigerwald <Martin@lichtvoll.de>
Date: Sat, 4 Sep 2010 18:42:19 +0200
Cc: Willy Tarreau <w@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2010521.kMYM9Ngh7n";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009041842.19968.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2010521.kMYM9Ngh7n
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Sorry, forgot Cc again.

Am Sonntag 11 Juli 2010 schrieb Willy Tarreau:
> Hi Martin,

Hi Willy, hi everyone else reading this,

> On Sun, Jul 11, 2010 at 04:51:42PM +0200, Martin Steigerwald wrote:
> > I hope that someone answers who actually can take some critique. From
> > the  current replies I perceive a lack of that ability.
>=20
> well, I'll try to do then :-)
>=20
> There were some threads in the past about kernel releases quality,
> where Linus explained why it could not be completely black or white.
>=20
> Among the things he explained, I remember that one of primary concern
> was the inability to slow down development. I mean, if he waits 2 more
> weeks for things to stabilize, then there will be two more weeks of
> crap^H^H^H^Hdevelopment merged in next merge window, so in fact this
> will just shift dates and not quality.

During bisecting [Bug 16376] random - possibly Radeon DRM KMS related=20
freezes, which goes very slowly due to having lots of unbootable kernels=20
with an ext4 / readahead related backtrace during boot, I had an idea:

I think main problem is that the current development process does not give=
=20
time for quality work and bug fixing. As I understand it currently its just=
=20
a constant development of new features with bug fixing and quality work=20
having to be done beneath that development:

=2D before 2.6.36 is released developers aim at developing new stuff for=20
2.6.37.

=2D after 2.6.36 is released developers aim at getting as much stuff into=20
2.6.37 and then after two weeks at developing new features for 2.6.38.

This process does not take bug fixing into account at all, cause after the=
=20
merge window has closing, developers hurry to get the stuff ready for the=20
next window.

In that model extending the freeze period after rc1 doesn't help at all,=20
cause as you say more "crap^H^H^H^Hdevelopment" gets collected for the=20
next kernel.

But is that a *given* that no one actually has any influence to? Is=20
collecting changes for next kernel like rain that either pours down or not=
=20
=2D usually pours down in this case like in August in Germany ;)? Who feeds=
=20
Linus with new stuff during the merge window? From what I understand of the=
=20
Linux development process its mainly the subsystem maintainers and Andrew=20
Morton.

What if those people stop collecting new stuff for Linus except bugfixes=20
about two or three weeks before the next kernel is relased? This would=20
give the subsystem trees and the mm tree some time to stabilize a bit, so=20
that Linus gets more quality stuff in the first time. And more importantly,=
=20
since developers know that subsystem maintainers and Andrew only collect=20
bugfixes 2-3 weeks before the release of a stable kernel, they can as well=
=20
spend some time on quality work.

Of course, developers can still decide: Well if 2.6.37 work is closed=20
already and continue developing for 2.6.38 even earlier, but I still think=
=20
this would help to slow things down a bit prior to the critical phase=20
before releasing a stable kernel. Cause when I know my subsystem=20
maintainer or Andrew won't be taking my stuff anyway, before the release=20
kernel is released, I can take a little time for other things.

The main idea here is to have a two-staged freeze process and to=20
distribute the "I am only taking bug fixes" work to more people than Linus.

=46or this to work properly, I think at the time of the release of the=20
stable kernel subsystem maintainers and Andrew should branch their trees.=20
=46or example when 2.6.36 is released:

=2D tree=20
  =3D> 2.6.36-stable-tree
  =3D> tree, where 2.6.37 stuff will be going in

Thus when subsystem maintainers take new stuff during the merge window, it=
=20
will be for the next kernel release already, not for the current one.=20
Except bugfix work. Whereas I think the criteria for bug fix work should no=
t=20
be that strict than for the stable patches Greg collects.

Thus it needs to be clear: No new stuff for next kernel already two weeks=20
prior to release the current stable kernel.

I think, this could help. Its a bit like the two-staged development=20
process of Debian, but with the freeze period for "unstable" being a fixed=
=20
time interval of about 2 weeks instead of RC=3D0 for stable ;). Its a bit o=
f=20
a formal shift of attention to the stable kernel about 2 weeks before its=20
release. Developers might find creative ways to circumvent it, or they=20
understand, that this process serves a purpose of improving kernel=20
quality.

When you think these two weeks cannot be squeezed into the three-monthly=20
development cycle, a four-monthly development cycle might do. But actually=
=20
I don't see why these two weeks could not be made to fit in there.

Installing and testing next kernel after yet another mail to this thread,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2010521.kMYM9Ngh7n
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyCdusACgkQmRvqrKWZhMcN2ACeOHcexnHFho6yL7gySrAx7AMY
5UwAoJ1IznybMIjAJ/rqAxtDqEoCrvBp
=na2u
-----END PGP SIGNATURE-----

--nextPart2010521.kMYM9Ngh7n--
