Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964Ab0IENZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:25:19 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57486 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab0IENZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:25:17 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Paolo Ornati <ornati@gmail.com>
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Date: Sun, 5 Sep 2010 15:25:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33-tp42-03208-g2507c05; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>
References: <201008312153.45792.Martin@lichtvoll.de> <201009050953.52440.Martin@lichtvoll.de> <20100905142031.4b692ed5@gmail.com> (sfid-20100905_152124_025137_290D40F8)
In-Reply-To: <20100905142031.4b692ed5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1668349.dJTjO32ALO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009051525.13867.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1668349.dJTjO32ALO
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Sonntag 05 September 2010 schrieb Paolo Ornati:
> On Sun, 5 Sep 2010 09:53:41 +0200
>=20
> Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > I am also seeking help with selecting more suitable commits to test:
> > If its a Radeon KMS related freeze and everything points at it, I
> > think the offending commit is in the first quarter of what git
> > commit shows to me[2]. Thus I'd  like to select one commit before
> > those drm/kms related commits and one after it, before testing any
> > other commits.
>=20
> If you "know better" than git-bisect and want to test a particular
> commit, just do:
>=20
> 	git reset --hard commit_id

That part I understood from the manpage. But I seeked help to choose=20
exactly which commit.

Well I now go with

martin@shambhala:~/Computer/Shambhala/Kernel/2.6.33-2.6.34-
bisect/linux-2.6> git log | head     =20
commit a27341cd5fcb7cf2d2d4726e9f324009f7162c00
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Mar 2 08:36:46 2010 -0800

    Prioritize synchronous signals over 'normal' signals
   =20
    This makes sure that we pick the synchronous signals caused by a
    processor fault over any pending regular asynchronous signals sent to
    use by [t]kill().

When I interpret the graphical display of gitk correctly this one should=20
be directly before the whole lot of KMS/DRM/Radeon/Intel commits being=20
merged.

Now hopefully this one boots. And is good. Then I would have skipped a=20
whole lot of the revisions to test. But even when it just boots, but is=20
bad, I at least know that its not in these merges.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1668349.dJTjO32ALO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyDmi8ACgkQmRvqrKWZhMcVNQCfd7+JWKZKdqVfaVCs5wVFepY+
TZoAniDQKjse7ia49ahSkrN5QxkBix0o
=ypL5
-----END PGP SIGNATURE-----

--nextPart1668349.dJTjO32ALO--
