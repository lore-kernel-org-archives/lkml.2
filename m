Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0IEHx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 03:53:57 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56209 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0IEHx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 03:53:56 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Date: Sun, 5 Sep 2010 09:53:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33-tp42-01231-g11b897c; KDE/4.4.5; i686; ; )
Cc: Paolo Ornati <ornati@gmail.com>, "Ted Ts'o" <tytso@mit.edu>
References: <201008312153.45792.Martin@lichtvoll.de> <20100901204716.775e9cfd@gmail.com> (sfid-20100901_212311_933866_A0CD9FCC)
In-Reply-To: <20100901204716.775e9cfd@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart75513637.671KS0mUNc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009050953.52440.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart75513637.671KS0mUNc
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch 01 September 2010 schrieb Paolo Ornati:
> On Tue, 31 Aug 2010 21:53:43 +0200
>=20
> Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Obviously I am not interested in kernels prior 2.6.33. Should I just
> > do a "git bisect good" without trying the kernel or is there some
> > other remedy?
>=20
> No. Git is right in asking you to test that commit: you are ignoring
> branches and merges.
[...]
> So this this behaviour is normal :)

So as to the advice of Ted in the thread "stable? quality assurance?" I am=
=20
seeking some more help with bisecting this bug. I continued bisecting and=20
stumbled upon some problems:

Quite some kernels were unbootable with an ext4 and readahead related=20
backtrace[1]. These were all within an USB merge and after skipping about=20
five unbootable kernels I skipped the whole range of commits in it. I=20
wondered by git insisted taking me back to this range of commits, even in=20
the middle of two skips, instead of automatically re-adjusting the binary=20
search, so that range would not be hit again for a while. Cause then its=20
would have not been hit at all eventually. Anyway, I think this problem=20
got fixed prior to 2.6.34 so I am asking whether there is a patch, a commit=
=20
that fixed it in case I should stumble about such a unbootable kernel=20
again. I attached the backtrace screenshot to my bug comment[1]. Ted, I am=
=20
not booting from USB, but from the internal harddrive. I think these=20
backtraces are completely unrelated to that USB commits. I think the bug=20
has been introduced before that USB merge and fixed somewhen afterwards,=20
but from a quick glance I didn't find the commit that fixes it.

I am also seeking help with selecting more suitable commits to test: If=20
its a Radeon KMS related freeze and everything points at it, I think the=20
offending commit is in the first quarter of what git commit shows to me[2].=
=20
Thus I'd  like to select one commit before those drm/kms related commits=20
and one after it, before testing any other commits. But I have been fooled=
=20
by those branches and merges before and there is the range of skipped=20
commits in that USB merge, thus I'd like advice on which commits to=20
select. A current git bisect log I attached to [2]. I will continue=20
bisecting as usual for the time being, but I really appreciate some help,=20
cause its still above 1800 commits to test otherwise and I am quite=20
annoyed by seeing the same roughly 11 steps even if the absolute number of=
=20
commits got down by about somewhat:

Bisecting: 1861 revisions left to test after this (roughly 11 steps)

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D16376#c37
[2] https://bugzilla.kernel.org/show_bug.cgi?id=3D16376#c38

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart75513637.671KS0mUNc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyDTIYACgkQmRvqrKWZhMeuygCgsuviffbAtMoQwSNRJuaHWKIP
/NgAn0wyBXBswLsqhkjWkN6noxI6yMLN
=rrqj
-----END PGP SIGNATURE-----

--nextPart75513637.671KS0mUNc--
