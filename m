Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0IIOS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:18:58 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37652 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0IIOSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:18:55 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Date: Thu, 9 Sep 2010 16:18:49 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-tp42-toi-3.2-rc1-vmembase-0-05032-g60140c1-dirty; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Paolo Ornati <ornati@gmail.com>
References: <201008312153.45792.Martin@lichtvoll.de> <201009050953.52440.Martin@lichtvoll.de> <20100907025110.GD6134@thunk.org> (sfid-20100908_171000_078066_F0824E6A)
In-Reply-To: <20100907025110.GD6134@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2368155.8tP3TTHNgB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009091618.51064.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2368155.8tP3TTHNgB
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Dienstag 07 September 2010 schrieb Ted Ts'o:
> On Sun, Sep 05, 2010 at 09:53:41AM +0200, Martin Steigerwald wrote:
> > Quite some kernels were unbootable with an ext4 and readahead related
> > backtrace[1].
>=20
> Unfortunately, you don't have a full backtrace in the picture which
> submitted as an attachment to the bugzilla.  It shows part of the
> backtrace which has an ext4 and readahead stack, yes.  But we didn't
> get to see the beginning of the stack trace with the IP and the reason
> for the oops.  If keyboard interrupts still work, you might try seing
> if you can scroll upwards and see more of the backtrace.  Or you might
> try configuring your console to use a higher resolution display so
> more lines can be displayed.  Or you might try getting a serial
> console.

Thanks for your detailled analysis. I missed posting an update to the=20
thread. I did not have to go back to those kernels again and bisected the=20
issue down to about 10 revisions, when Alex suggested my bug might be a=20
duplicate of

[Bug 28402] random radeon/kms/drm related freezes with kernel 2.6.34
https://bugs.freedesktop.org/show_bug.cgi?id=3D28402

So I tried some patches in there and the vmembase at zero patch seems to=20
do the trick. Although I am not sure, whether its a solution or a work-
around.

> I don't recognize the display, but the problem could just as easily be
> in the block layer or in the device driver for your hard drive.
> (i.e., the readahead stack calls ext4, which in turn will submit a
> read request to the block device layer which then submits the request
> to a device driver).

Yes, I am aware that it may not be a Ext4 problem at all. Thus I said Ext4=
=20
/ readahead related (!) backtrace (! not bug) cause that was all I could=20
see on the screen. How else should I have described that backtrace when I=20
can't speculate on what I can not see?

> But because you keep referring it to it as an ext4/readahead related
> backtrace, you may have disguised the symptom enough that people who
> might recognize it as, "Oh, yeah, there was this regression in the
> SATA layer", wouldn't recognize it as such from your description.
> That's why it's important to be careful how you describe issues; if
> you had said, I don't have a complete stack trace, and I don't have
> the IP and function where the fault occurred, that might have caused
> people to think a bit harder about what might be the problem, instead
> of thinking to themselves, "ah, well, the ext4 and readahead parts of
> the kernel aren't my problem, so I'll ignore this report".

I thought thats what the provided backtrace is for. And I think that any=20
developer can see that it isn't complete.

I will include a note that the backtrace is incomplete next time=20
nevertheless.

It would be good to have a backtrace viewer and saver that still works in=20
those conditions ;-). And when it just writes it somewhere on the swap=20
partition were a tool can grab it after booting again. But when the kernel=
=20
is completely messed up, exactly that can be very dangerous.

> > I am also seeking help with selecting more suitable commits to test:
> > If its a Radeon KMS related freeze and everything points at it, I
> > think the offending commit is in the first quarter of what git
> > commit shows to me[2].
>=20
> You do know that you can restrict a git bisect to commits that modify
> a particular part of the tree, right?  e.g.,
>=20
> git bisect start 2.6.34 2.6.33 -- drivers/gpu/drm/radeon

Yes, I have seen that in the git manpage, but since I wasn't absolutely=20
sure, that the freeze is radeon kms/drm related I skipped that step. From=20
what I learned I should have looked at git bisect visualize earlier and=20
selected from commits prior and after that drm kms related merges. That=20
would have spared me quite some time when my suspicion was right, like it=20
turned out to be, and wouldn't have taken many more turn arounds when it=20
was wrong.

Next time I know this.

Thanks for your help, I appreciate it.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2368155.8tP3TTHNgB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyI7MoACgkQmRvqrKWZhMdoAgCgjbfnSf0yGbzSvRXMwyC+y9lq
npwAnAhu1anomgTBJ5BFmQP61532VuVO
=A3oJ
-----END PGP SIGNATURE-----

--nextPart2368155.8tP3TTHNgB--
