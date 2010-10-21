Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab0JUMkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:40:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57491 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755496Ab0JUMkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:40:42 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX19UC7QJR1lU11Ga/oi3BsgKXdkK3aYksdLjxbpFFH
	zdfL+ZVjIpaKPi
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [resend][PATCHv2] staging: batman-adv: remove useless addr_to_string()
Date: Thu, 21 Oct 2010 14:41:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Marek Lindner <lindner_marek@yahoo.de>
References: <1287589664-25447-1-git-send-email-andy.shevchenko@gmail.com> <20101020221636.GA21132@sven-atom.lazhur.ath.cx> <20101020223958.GA17011@kroah.com>
In-Reply-To: <20101020223958.GA17011@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2310473.Nn2jE4RZYK";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201010211441.39483.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2310473.Nn2jE4RZYK
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Greg KH wrote:
> On Thu, Oct 21, 2010 at 12:16:37AM +0200, Sven Eckelmann wrote:
> > On Wed, Oct 20, 2010 at 01:57:49PM -0700, Greg KH wrote:
> > > On Wed, Oct 20, 2010 at 10:51:15PM +0200, Sven Eckelmann wrote:
> > > > On Wed, Oct 20, 2010 at 06:47:44PM +0300, Andy Shevchenko wrote:
> > > > > Since all *printf() methods in the kernel understand '%pM' modifi=
er
> > > > > the conversion to the string is useless beforehand.
> > > > >=20
> > > > > Additionally this patch decreases batman_if structure by 20 bytes.
> > > >=20
> > > > Thanks for your patch. I have problems with compiling due to other
> > > > patches in the queue. I will fix that and recommend it as patch for
> > > > 2.6.38.
> > >=20
> > > What do you mean by this?  It applies just fine to my tree, so why
> > > can't I take it now?
> >=20
> > If you want then do so, but the stuff in batman-adv's master must be
> > fixed so they have to apply the v3 version of the patch and not the v2
> > version Andy sent.
>=20
> That's one of the problems with having an out-of-tree tree.  Please
> don't do that at all anymore.

I don't see a difference in a in-tree tree and and out-of-tree tree when=20
applying patches somewhere else out of order. In both situations we have a=
=20
merge conflict (not that the scm says "omg, i cannot merge it" but that the=
=20
thing doesn't compile after the merge). Not that it would care much that th=
ere=20
is a merge conflict - it only has to be resolved one way or the other. And =
I=20
don't force the submitter to do it (I couldn't do it anyway), but try to he=
lp=20
to resolve it for the actual maintainer.

I always thought that even when the source is in the kernel (or in staging)=
=20
that there are still a maintainer responsible for it. That this person has =
to=20
go through the patches and look if they do whatever they claim to do and th=
at=20
this isn't against what the original implementation had to do or should do.

In case of batman-adv those maintainers are called by the names Marek Lindn=
er=20
and Simon Wunderlich. None of those names sound like GregKH or random guy (=
aka=20
me). I know that you are the staging maintainer and you have more to say, b=
ut=20
wouldn't it be more healthy that the guys who know more details about it ca=
n=20
take a look at the non critical stuff?

And the only reason I proposed (not forced, only recommended) that will be=
=20
send later for inclusion in 2.6.38 was that you told us that the day a new=
=20
kernel (2.6.36) gets released is too late to get new stuff (other than fixe=
s)=20
in your tree for 2.6.37.

> I'll go apply this patch to mine, and you can handle any merge issues if
> you continue to wish to keep an external tree (hint, I STRONGLY
> recommend that you do not, for these reasons and many others.)

The development of batman-adv is mainly done by people which need it=20
externally - so out of kernel. That means if we are not allowed anymore to=
=20
have some kind of external tree that we can use, it must be done the other =
way=20
around aka compat-wireless like and without the ability to test experimenta=
l=20
stuff with the community unless by sending it to you and reverting it befor=
e a=20
new linux release is made. Otherwise we would only have a external tree whi=
ch=20
is in another form (quilt, loose patches, ...) and would be nothing differe=
nt=20
than what we have currently.

The current way is not to say that we come first, but to keep things=20
organized. Take for example Andy's patch - it was in my own opinion to late=
=20
for 2.6.37 and it was nothing real critical (but nevertheless quite helpful=
).=20
So queuing it up with the stuff for 2.6.38 seemed to be a good idea. In tha=
t=20
time also the affected other code parts could be fixed by the actual author=
=20
and everything flows back to you as a complete package.

And in my own opinion the external tree was quite helpful to see incorrect=
=20
merge resolutions...

Everything above is my own opinion and does not strictly reflect the positi=
ons=20
and policies of the batman-adv project or the actual maintainers.

thanks,
	Sven

--nextPart2310473.Nn2jE4RZYK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJMwDUCAAoJEF2HCgfBJntGa9gQAI+S+mSpjCuD5NoHsDAGQ+x7
kL/38+DXNMvHMJHoV7c1sfuBh1ikY6rDpY49d6NLhaQIkwTJ4bcyHZ4YB45PF4AP
9cAPhLoqkfX9c7nDhbVvpAYuQ3aQlGVJUtBBEuQgyzmBBp746GdudbOvWwWYfF9G
krprhlvPGdB1A6qP65fIGaOuu9udPBTF5BrGcwIUTHV4fz505Icz+l4B1GzXvYoy
idk0ngyuXRJIQm2bz5Mk6oYinQRH6b0IMYh/EScSLZN3qhBqTv9iN/GKC4bXaYJ+
IbE118bINGKbq0ucyRKco56iwZAV+jwYMqpuq7b40QR4gPc9woyLN+nA2D8Z9SEK
pC2E4m0OQHYNTTorG1BCIwmiciU/NgEqo0xlUV1acmzNG2N6wV9ExTNi50TYs5EY
6fZIgwE61dTLKclNmn8FFgn5CIn9Xi9UvMDM14OUStvk+f0PzWJn17J43LE1zNrg
C+VG3GHGaVoz+OBnKMuZKU64UgP7BQksg22s/B4wy5i6rqDBrIy7nWspKHvKOhYE
QaJdMq3ggOwy6grZSZZoD/ohbUrIrXUVRInTgnQ9C5v7dUJCaFRYAOx4rCVY4ejG
w9W4/eXxPyU3kINuxkhSwGxhVn3+RoVrawoOI7hnBKlWzC7PuLVW4+i+a6lKj0i6
1obYlBPevx5WwPAYCByQ
=yYhK
-----END PGP SIGNATURE-----

--nextPart2310473.Nn2jE4RZYK--
