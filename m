Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0IEH7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 03:59:39 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51492 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0IEH7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 03:59:38 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: stable? quality assurance?
Date: Sun, 5 Sep 2010 09:59:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33-tp42-01231-g11b897c; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201007110918.42120.Martin@lichtvoll.de> <201009042111.41695.Martin@lichtvoll.de> <20100904232351.GG4887@thunk.org> (sfid-20100905_090302_580506_760B8409)
In-Reply-To: <20100904232351.GG4887@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2607247.MNsNa9RBBV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009050959.34673.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2607247.MNsNa9RBBV
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Sonntag 05 September 2010 schrieb Ted Ts'o:
> On Sat, Sep 04, 2010 at 09:11:34PM +0200, Martin Steigerwald wrote:
> > Stop! I think we are misunderstanding.
> >=20
> > Its a bug I stumpled across the bisecting process. Neither 2.6.33 or
> > 2.6.34 are affected, but some kernels in between. As such I didn't
> > think its worth reporting the bug.
> >=20
> > I made a photo of part of the backtrace tough, so if you want I open
> > a bug report about it nonetheless. But I really think it has been
> > fixed during the 2.6.33 to 2.6.34 development cycle.
>=20
> FYI, it's fair game to send a note to LKML with the backtrace, saying,
> I'm getting this wierd stack trace while trying to do a bisect; it
> looks like it's fixed in 2.6.34, does it look familiar?  If so,
> someone might be able to point you at the commit that fixes the bug,
> and then you can apply that patch by hand while doing the bisect at
> each step (and then unapply it before doing the next bisect
> iteration).

Thanks. As to your advice I am seeking help again with bisecting this bug.=
=20
See the thread "help with git bisecting a bug 16376: random - possibly=20
Radeon DRM KMS related - freezes". I put you on Cc for the Ext4 /=20
readahead related backtrace.
=20
> > For now I just skipped affected kernels in the bisection process in
> > the hope that none is the first last good or first bad one regarding
> > the freeze bug. Since for now it has all been kernels of a usb merge
> > that showed this issue, I don't think the freeze bug is in there.
>=20
> Are you actually booting off of a USB device?  Even if you are, it
> seems... strange... that a series of USB patches would cause an
> ext4/readahead kernel OOPS.  Can you disable using USB devices, which
> would hopefully prevent the problem from showing up?

Nope. I think the bug is completely unrelated to the commits from the USB=20
merge. I think that the USB commits just had the bad luck having been=20
merged between the other bug was introduced and fixed.

> Note by the way, that you don't have to try compiling at the points
> chosen by "git bisect".  If you run into problems, you can try going
> to the head of the USB patches, and if that works, report that
> particular commit as "good" or "bad".

Yes, thats what the git reset --hard example should do. But I wondered on=20
how to do it exactly. I saw "git reset --hard HEAD~3" in the manpage to go=
=20
three commits back and only later found out that I could give a commit id=20
to "git reset". Is just going to the head of that USB merge and testing=20
that better than skipping the complete range? Anyway I really think that=20
none of the commits in there caused or fixed that bug.

> > So I just wanted to show that I am seriously working on tracking down
> > that likely radeon kms related freeze bug and that its
> > time-consuming for me due to having lots of unbootable kernels.
>=20
> Have you reported this bug to the maintainer?  Is he helping you out?
> Have you looked at the various Radeon-related commits between 2.6.34
> and 2.6.33?  I imagine there probably aren't that many of them.  You
> might try testing commits just before and after the Radeon-related
> commits, which might speed up the git bisect significantly.

Yes, of course. I also posted my previous git bisect results already. I=20
wanted to add a comment with the current results yesterday, but bugzilla=20
had to many MySQL connection for an extended period of time. Now I did=20
with more specifically asking for help[1]

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D16376#c38

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2607247.MNsNa9RBBV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyDTeYACgkQmRvqrKWZhMepFQCfQ2DKbaIlsJbQwLx8Qf5+bu6Q
I9sAnA770sjZ7Za1qXJCXI46M4n7WUIm
=iNaS
-----END PGP SIGNATURE-----

--nextPart2607247.MNsNa9RBBV--
